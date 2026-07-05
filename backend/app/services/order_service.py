"""Order placement and tracking."""

from __future__ import annotations

from datetime import date, datetime, timedelta
from decimal import Decimal
from uuid import UUID

from sqlalchemy import select
from sqlalchemy.orm import Session, joinedload

from app.config import get_settings
from app.db.models import (
    EcomAddress,
    EcomCoupon,
    EcomOrder,
    EcomOrderDeliveryAddress,
    EcomOrderItem,
    EcomOrderTracking,
    EcomPayment,
    EcomProduct,
    EcomUserProfile,
)
from app.schemas import AddressOut, CartItemOut, OrderOut, OrderTrackingOut, PlaceOrderIn
from app.services.cart_service import CartService


class OrderService:
    def __init__(self, db: Session):
        self.db = db
        self.settings = get_settings()

    def _order_out(self, order: EcomOrder) -> OrderOut:
        items = [
            CartItemOut(
                id=oi.id,
                product_id=oi.product_id or UUID(int=0),
                product_name=oi.product_name,
                product_image=oi.product_image or "",
                price=float(oi.unit_price),
                mrp=float(oi.unit_mrp),
                quantity=oi.quantity,
                selected_size=oi.selected_size,
                selected_color=oi.selected_color,
            )
            for oi in order.items
        ]
        addr_out = None
        if order.delivery_address:
            da = order.delivery_address
            addr_out = AddressOut(
                id=da.id,
                name=da.name or "",
                phone=da.phone or "",
                address_line_1=da.address_line_1 or "",
                address_line_2=da.address_line_2 or "",
                city=da.city or "",
                state=da.state or "",
                pincode=da.pincode or "",
                landmark=da.landmark or "",
                type=da.address_type or "home",
            )
        tracking = [
            OrderTrackingOut(
                title=t.title,
                description=t.description or "",
                date_time=t.event_at.isoformat() if t.event_at else "",
                is_completed=t.is_completed,
                is_current=t.is_current,
            )
            for t in sorted(order.tracking, key=lambda x: x.sort_order)
        ]
        payment_ref = ""
        pay = self.db.scalar(select(EcomPayment).where(EcomPayment.order_id == order.id))
        if pay and pay.payment_ref:
            payment_ref = pay.payment_ref

        return OrderOut(
            id=order.id,
            order_number=order.order_number,
            items=items,
            subtotal=float(order.subtotal),
            delivery_fee=float(order.delivery_fee),
            discount=float(order.discount),
            total=float(order.total),
            status=order.status,
            payment_method=order.payment_method or "",
            payment_status=order.payment_status,
            delivery_address=addr_out,
            created_at=order.created_at.isoformat() if order.created_at else "",
            updated_at=order.updated_at.isoformat() if order.updated_at else "",
            estimated_delivery=order.estimated_delivery.isoformat() if order.estimated_delivery else "",
            tracking_steps=tracking,
            user_id=order.user_id,
            payment_ref=payment_ref,
        )

    def list_orders(self, user_id: UUID) -> list[OrderOut]:
        rows = self.db.scalars(
            select(EcomOrder)
            .where(EcomOrder.user_id == user_id)
            .options(
                joinedload(EcomOrder.items),
                joinedload(EcomOrder.tracking),
                joinedload(EcomOrder.delivery_address),
            )
            .order_by(EcomOrder.created_at.desc())
        ).unique().all()
        return [self._order_out(o) for o in rows]

    def order_detail(self, user_id: UUID, order_id: UUID) -> OrderOut | None:
        order = self.db.scalar(
            select(EcomOrder)
            .where(EcomOrder.id == order_id, EcomOrder.user_id == user_id)
            .options(
                joinedload(EcomOrder.items),
                joinedload(EcomOrder.tracking),
                joinedload(EcomOrder.delivery_address),
            )
        )
        if not order:
            return None
        return self._order_out(order)

    def place_order(self, user_id: UUID, data: PlaceOrderIn) -> OrderOut:
        cart_svc = CartService(self.db)
        cart = cart_svc.get_cart(user_id)
        if not cart.items:
            raise ValueError("Cart is empty")

        addr = self.db.scalar(
            select(EcomAddress).where(EcomAddress.id == data.address_id, EcomAddress.user_id == user_id)
        )
        if not addr:
            raise ValueError("Address not found")

        subtotal = Decimal(str(sum(i.price * i.quantity for i in cart.items)))
        discount = Decimal("0")
        coupon_code = data.coupon_code or cart.coupon_code
        if coupon_code:
            coupon = self.db.scalar(select(EcomCoupon).where(EcomCoupon.code == coupon_code))
            if coupon:
                if coupon.discount_type == "percent":
                    discount = min(
                        subtotal * Decimal(coupon.discount_percent) / 100,
                        Decimal(str(coupon.max_discount)),
                    )
                else:
                    discount = Decimal(str(coupon.discount_amount))

        delivery_fee = (
            Decimal("0")
            if subtotal >= Decimal(str(self.settings.free_delivery_threshold))
            else Decimal(str(self.settings.delivery_charge))
        )
        total = subtotal + delivery_fee - discount

        order_number = f"DQ-{int(datetime.utcnow().timestamp()) % 1000000:06d}"
        payment_status = "paid" if data.payment_method == "cod" else "pending"

        order = EcomOrder(
            order_number=order_number,
            user_id=user_id,
            status="confirmed" if data.payment_method == "cod" else "pending",
            subtotal=subtotal,
            delivery_fee=delivery_fee,
            discount=discount,
            total=total,
            coupon_code=coupon_code,
            payment_method=data.payment_method,
            payment_status=payment_status,
            estimated_delivery=date.today() + timedelta(days=3),
            notes=data.notes,
        )
        self.db.add(order)
        self.db.flush()

        for ci in cart.items:
            product = self.db.get(EcomProduct, ci.product_id)
            self.db.add(
                EcomOrderItem(
                    order_id=order.id,
                    product_id=ci.product_id,
                    product_name=ci.product_name,
                    product_image=ci.product_image,
                    selected_size=ci.selected_size,
                    selected_color=ci.selected_color,
                    unit_price=Decimal(str(ci.price)),
                    unit_mrp=Decimal(str(ci.mrp)),
                    quantity=ci.quantity,
                    line_total=Decimal(str(ci.price * ci.quantity)),
                )
            )
            if product:
                product.stock_qty = max(0, product.stock_qty - ci.quantity)
                product.sold_count = (product.sold_count or 0) + ci.quantity

        self.db.add(
            EcomOrderDeliveryAddress(
                order_id=order.id,
                source_address_id=addr.id,
                name=addr.name,
                phone=addr.phone,
                address_line_1=addr.address_line_1,
                address_line_2=addr.address_line_2,
                city=addr.city,
                state=addr.state,
                pincode=addr.pincode,
                landmark=addr.landmark,
                address_type=addr.address_type,
            )
        )
        now = datetime.utcnow()
        self.db.add(
            EcomOrderTracking(
                order_id=order.id,
                title="Order Placed",
                description="Your order has been placed successfully",
                event_at=now,
                is_completed=True,
                is_current=True,
                sort_order=1,
            )
        )
        if data.payment_method == "cod":
            self.db.add(
                EcomPayment(
                    order_id=order.id,
                    user_id=user_id,
                    gateway="cod",
                    amount=total,
                    status="success",
                    paid_at=now,
                )
            )

        profile = self.db.scalar(select(EcomUserProfile).where(EcomUserProfile.user_id == user_id))
        if profile:
            profile.total_orders_count += 1
            profile.total_spent += total

        cart_svc.clear_cart(user_id)
        self.db.commit()
        self.db.refresh(order)
        return self._order_out(
            self.db.scalar(
                select(EcomOrder)
                .where(EcomOrder.id == order.id)
                .options(
                    joinedload(EcomOrder.items),
                    joinedload(EcomOrder.tracking),
                    joinedload(EcomOrder.delivery_address),
                )
            )
        )

    def cancel_order(self, user_id: UUID, order_id: UUID) -> OrderOut:
        order = self.db.scalar(
            select(EcomOrder).where(EcomOrder.id == order_id, EcomOrder.user_id == user_id)
        )
        if not order:
            raise ValueError("Order not found")
        if order.status not in ("pending", "confirmed"):
            raise ValueError("Order cannot be cancelled")
        order.status = "cancelled"
        order.cancelled_at = datetime.utcnow()
        self.db.commit()
        return self.order_detail(user_id, order_id)  # type: ignore[return-value]
