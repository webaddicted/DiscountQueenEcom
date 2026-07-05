"""Cart and wishlist."""

from __future__ import annotations

from decimal import Decimal
from uuid import UUID

from sqlalchemy import delete, select
from sqlalchemy.orm import Session

from app.config import get_settings
from app.db.models import EcomCartItem, EcomCoupon, EcomProduct, EcomWishlistItem
from app.schemas import CartAddIn, CartItemOut, CartOut, ProductOut
from app.services.catalog_service import CatalogService


class CartService:
    def __init__(self, db: Session):
        self.db = db
        self.settings = get_settings()

    def _cart_items(self, user_id: UUID) -> list[EcomCartItem]:
        return list(self.db.scalars(select(EcomCartItem).where(EcomCartItem.user_id == user_id)))

    def get_cart(self, user_id: UUID) -> CartOut:
        items = self._cart_items(user_id)
        out_items: list[CartItemOut] = []
        for ci in items:
            product = self.db.get(EcomProduct, ci.product_id)
            out_items.append(
                CartItemOut(
                    id=ci.id,
                    product_id=ci.product_id,
                    product_name=product.name if product else "",
                    product_image=product.thumbnail_url if product else "",
                    price=float(ci.unit_price),
                    mrp=float(ci.unit_mrp),
                    quantity=ci.quantity,
                    selected_size=ci.selected_size,
                    selected_color=ci.selected_color,
                )
            )
        return CartOut(items=out_items)

    def add_to_cart(self, user_id: UUID, data: CartAddIn) -> CartOut:
        product = self.db.get(EcomProduct, data.product_id)
        if not product or not product.is_active:
            raise ValueError("Product not found")
        price = Decimal(str(product.price))
        mrp = Decimal(str(product.mrp))
        existing = self.db.scalar(
            select(EcomCartItem).where(
                EcomCartItem.user_id == user_id,
                EcomCartItem.product_id == data.product_id,
                EcomCartItem.variant_id == data.variant_id,
            )
        )
        if existing:
            existing.quantity += data.quantity
            existing.selected_size = data.selected_size
            existing.selected_color = data.selected_color
        else:
            self.db.add(
                EcomCartItem(
                    user_id=user_id,
                    product_id=data.product_id,
                    variant_id=data.variant_id,
                    quantity=data.quantity,
                    selected_size=data.selected_size,
                    selected_color=data.selected_color,
                    unit_price=price,
                    unit_mrp=mrp,
                )
            )
        self.db.commit()
        return self.get_cart(user_id)

    def update_cart(self, user_id: UUID, item_id: UUID, quantity: int) -> CartOut:
        item = self.db.scalar(
            select(EcomCartItem).where(EcomCartItem.id == item_id, EcomCartItem.user_id == user_id)
        )
        if not item:
            raise ValueError("Cart item not found")
        if quantity <= 0:
            self.db.delete(item)
        else:
            item.quantity = quantity
        self.db.commit()
        return self.get_cart(user_id)

    def remove_from_cart(self, user_id: UUID, item_id: UUID) -> CartOut:
        self.db.execute(
            delete(EcomCartItem).where(EcomCartItem.id == item_id, EcomCartItem.user_id == user_id)
        )
        self.db.commit()
        return self.get_cart(user_id)

    def clear_cart(self, user_id: UUID) -> CartOut:
        self.db.execute(delete(EcomCartItem).where(EcomCartItem.user_id == user_id))
        self.db.commit()
        return CartOut()

    def apply_coupon(self, user_id: UUID, code: str) -> CartOut:
        cart = self.get_cart(user_id)
        coupon = self.db.scalar(select(EcomCoupon).where(EcomCoupon.code == code, EcomCoupon.is_active))
        if not coupon:
            raise ValueError("Invalid coupon")
        subtotal = sum(i.price * i.quantity for i in cart.items)
        if subtotal < float(coupon.min_order_amount):
            raise ValueError("Order amount too low for this coupon")
        if coupon.discount_type == "percent":
            discount = min(subtotal * coupon.discount_percent / 100, float(coupon.max_discount))
        else:
            discount = float(coupon.discount_amount)
        cart.coupon_code = code
        cart.coupon_discount = discount
        return cart

    def wishlist(self, user_id: UUID) -> list[ProductOut]:
        ids = self.db.scalars(
            select(EcomWishlistItem.product_id).where(EcomWishlistItem.user_id == user_id)
        ).all()
        catalog = CatalogService(self.db)
        out: list[ProductOut] = []
        for pid in ids:
            p = catalog.product_detail(pid)
            if p:
                out.append(p)
        return out

    def add_wishlist(self, user_id: UUID, product_id: UUID) -> list[ProductOut]:
        exists = self.db.scalar(
            select(EcomWishlistItem).where(
                EcomWishlistItem.user_id == user_id, EcomWishlistItem.product_id == product_id
            )
        )
        if not exists:
            self.db.add(EcomWishlistItem(user_id=user_id, product_id=product_id))
            self.db.commit()
        return self.wishlist(user_id)

    def remove_wishlist(self, user_id: UUID, product_id: UUID) -> list[ProductOut]:
        self.db.execute(
            delete(EcomWishlistItem).where(
                EcomWishlistItem.user_id == user_id, EcomWishlistItem.product_id == product_id
            )
        )
        self.db.commit()
        return self.wishlist(user_id)
