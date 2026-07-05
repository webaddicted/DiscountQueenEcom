"""Admin dashboard and CRUD."""

from __future__ import annotations

import re
from datetime import date, datetime
from decimal import Decimal
from uuid import UUID, uuid4

from sqlalchemy import func, select
from sqlalchemy.orm import Session, joinedload

from app.db.models import (
    EcomBanner,
    EcomCategory,
    EcomCoupon,
    EcomNotificationBroadcast,
    EcomOrder,
    EcomProduct,
    EcomProductImage,
    EcomProductVariant,
    EcomReview,
    EcomUserNotification,
    EcomUserProfile,
)
from app.schemas import (
    BannerAdminIn,
    BannerOut,
    BroadcastAdminIn,
    CategoryAdminIn,
    CategoryOut,
    CouponAdminIn,
    DashboardOut,
    OrderOut,
    ProductAdminIn,
    ProductOut,
    ProfileOut,
    ReviewOut,
    UserFlagsIn,
)
from app.services.catalog_service import CatalogService
from app.services.order_service import OrderService


def _slugify(text: str) -> str:
    s = re.sub(r"[^a-z0-9]+", "-", text.lower()).strip("-")
    return s or f"item-{uuid4().hex[:8]}"


class AdminService:
    def __init__(self, db: Session):
        self.db = db
        self.catalog = CatalogService(db)
        self.orders = OrderService(db)

    def dashboard(self) -> DashboardOut:
        today = date.today()
        user_count = self.db.scalar(select(func.count()).select_from(EcomUserProfile)) or 0
        order_count = self.db.scalar(select(func.count()).select_from(EcomOrder)) or 0
        product_count = self.db.scalar(
            select(func.count()).select_from(EcomProduct).where(
                EcomProduct.is_active, EcomProduct.is_deleted.is_(False)
            )
        ) or 0
        revenue = self.db.scalar(
            select(func.coalesce(func.sum(EcomOrder.total), 0)).where(EcomOrder.status != "cancelled")
        ) or 0
        orders_today = self.db.scalar(
            select(func.count()).select_from(EcomOrder).where(func.date(EcomOrder.created_at) == today)
        ) or 0
        return DashboardOut(
            user_count=int(user_count),
            order_count=int(order_count),
            revenue_total=float(revenue),
            orders_today=int(orders_today),
            product_count=int(product_count),
        )

    def list_users(self) -> list[ProfileOut]:
        rows = self.db.scalars(select(EcomUserProfile).order_by(EcomUserProfile.created_at.desc())).all()
        return [
            ProfileOut(
                id=r.user_id,
                name=r.name or "",
                email="",
                phone=r.phone or "",
                photo_url=r.photo_url or "",
                gender=r.gender or "",
                date_of_birth=r.date_of_birth.isoformat() if r.date_of_birth else "",
                is_admin=r.is_admin,
                is_blocked=r.is_blocked,
                created_at=r.created_at.isoformat() if r.created_at else "",
            )
            for r in rows
        ]

    def update_user_flags(self, user_id: UUID, data: UserFlagsIn) -> ProfileOut:
        profile = self.db.scalar(select(EcomUserProfile).where(EcomUserProfile.user_id == user_id))
        if not profile:
            raise ValueError("User not found")
        profile.is_admin = data.is_admin
        profile.is_blocked = data.is_blocked
        profile.block_reason = data.block_reason
        self.db.commit()
        return ProfileOut(
            id=profile.user_id,
            name=profile.name or "",
            email="",
            phone=profile.phone or "",
            photo_url=profile.photo_url or "",
            is_admin=profile.is_admin,
            is_blocked=profile.is_blocked,
            created_at=profile.created_at.isoformat() if profile.created_at else "",
        )

    def list_products(self) -> list[ProductOut]:
        rows = self.db.scalars(
            select(EcomProduct)
            .where(EcomProduct.is_deleted.is_(False))
            .options(
                joinedload(EcomProduct.images),
                joinedload(EcomProduct.variants),
                joinedload(EcomProduct.specs),
            )
            .order_by(EcomProduct.created_at.desc())
        ).unique().all()
        return [self.catalog._to_product_out(p) for p in rows]

    def save_product(self, data: ProductAdminIn, product_id: UUID | None = None) -> ProductOut:
        if product_id:
            product = self.db.get(EcomProduct, product_id)
            if not product:
                raise ValueError("Product not found")
        else:
            sku = f"SKU-{uuid4().hex[:8].upper()}"
            product = EcomProduct(sku=sku, slug=_slugify(data.name), name=data.name)
            self.db.add(product)

        product.name = data.name
        product.description = data.description
        product.short_description = data.short_description
        product.price = Decimal(str(data.price))
        product.mrp = Decimal(str(data.mrp))
        product.category_id = data.category_id
        product.stock_qty = data.stock_qty
        product.thumbnail_url = data.thumbnail
        product.tags = data.tags
        product.is_featured = data.is_featured
        product.is_popular = data.is_popular
        product.is_new_arrival = data.is_new_arrival
        product.is_active = True
        if product.mrp > 0:
            product.discount_percent = int(round((1 - float(product.price) / float(product.mrp)) * 100))

        self.db.flush()

        if data.images:
            for img in list(product.images):
                self.db.delete(img)
            for i, url in enumerate(data.images):
                self.db.add(
                    EcomProductImage(
                        product_id=product.id,
                        image_url=url,
                        sort_order=i,
                        is_primary=i == 0,
                    )
                )

        if data.sizes or data.colors:
            for v in list(product.variants):
                self.db.delete(v)
            sizes = data.sizes or [""]
            colors = data.colors or [""]
            for size in sizes:
                for color in colors:
                    self.db.add(
                        EcomProductVariant(
                            product_id=product.id,
                            size=size,
                            color=color,
                            stock_qty=data.stock_qty,
                        )
                    )

        self.db.commit()
        self.db.refresh(product)
        return self.catalog._to_product_out(product)

    def delete_product(self, product_id: UUID) -> None:
        product = self.db.get(EcomProduct, product_id)
        if not product:
            raise ValueError("Product not found")
        product.is_deleted = True
        product.is_active = False
        self.db.commit()

    def list_categories(self) -> list[CategoryOut]:
        rows = self.db.scalars(select(EcomCategory).order_by(EcomCategory.sort_order)).all()
        return [CategoryOut.model_validate(r) for r in rows]

    def save_category(self, data: CategoryAdminIn, category_id: UUID | None = None) -> CategoryOut:
        if category_id:
            cat = self.db.get(EcomCategory, category_id)
            if not cat:
                raise ValueError("Category not found")
        else:
            cat = EcomCategory(slug=_slugify(data.name), name=data.name)
            self.db.add(cat)
        cat.name = data.name
        cat.image_url = data.image
        cat.icon_name = data.icon
        cat.sort_order = data.sort_order
        cat.is_active = data.is_active
        self.db.commit()
        self.db.refresh(cat)
        return CategoryOut.model_validate(cat)

    def delete_category(self, category_id: UUID) -> None:
        cat = self.db.get(EcomCategory, category_id)
        if not cat:
            raise ValueError("Category not found")
        cat.is_active = False
        self.db.commit()

    def list_banners(self) -> list[BannerOut]:
        rows = self.db.scalars(select(EcomBanner).order_by(EcomBanner.sort_order)).all()
        return [BannerOut.model_validate(r) for r in rows]

    def save_banner(self, data: BannerAdminIn, banner_id: UUID | None = None) -> BannerOut:
        if banner_id:
            banner = self.db.get(EcomBanner, banner_id)
            if not banner:
                raise ValueError("Banner not found")
        else:
            banner = EcomBanner(image_url=data.image)
            self.db.add(banner)
        banner.title = data.title
        banner.subtitle = data.subtitle
        banner.image_url = data.image
        banner.action_type = data.action_type
        banner.action_value = data.action_value
        banner.sort_order = data.sort_order
        banner.is_active = data.is_active
        self.db.commit()
        self.db.refresh(banner)
        return BannerOut.model_validate(banner)

    def delete_banner(self, banner_id: UUID) -> None:
        banner = self.db.get(EcomBanner, banner_id)
        if not banner:
            raise ValueError("Banner not found")
        banner.is_active = False
        self.db.commit()

    def list_coupons(self) -> list[CouponAdminIn]:
        rows = self.db.scalars(select(EcomCoupon).order_by(EcomCoupon.code)).all()
        return [
            CouponAdminIn(
                code=c.code,
                discount_type=c.discount_type,
                discount_percent=c.discount_percent,
                discount_amount=float(c.discount_amount),
                max_discount=float(c.max_discount),
                min_order_amount=float(c.min_order_amount),
                is_active=c.is_active,
                expires_at=c.expires_at,
            )
            for c in rows
        ]

    def save_coupon(self, data: CouponAdminIn) -> CouponAdminIn:
        coupon = self.db.scalar(select(EcomCoupon).where(EcomCoupon.code == data.code))
        if not coupon:
            coupon = EcomCoupon(code=data.code)
            self.db.add(coupon)
        coupon.discount_type = data.discount_type
        coupon.discount_percent = data.discount_percent
        coupon.discount_amount = Decimal(str(data.discount_amount))
        coupon.max_discount = Decimal(str(data.max_discount))
        coupon.min_order_amount = Decimal(str(data.min_order_amount))
        coupon.is_active = data.is_active
        coupon.expires_at = data.expires_at
        self.db.commit()
        return data

    def list_orders(self) -> list[OrderOut]:
        rows = self.db.scalars(
            select(EcomOrder)
            .options(
                joinedload(EcomOrder.items),
                joinedload(EcomOrder.tracking),
                joinedload(EcomOrder.delivery_address),
            )
            .order_by(EcomOrder.created_at.desc())
        ).unique().all()
        return [self.orders._order_out(o) for o in rows]

    def update_order_status(self, order_id: UUID, status: str) -> OrderOut:
        order = self.db.get(EcomOrder, order_id)
        if not order:
            raise ValueError("Order not found")
        order.status = status
        if status == "cancelled":
            order.cancelled_at = datetime.utcnow()
        self.db.commit()
        return self.orders._order_out(
            self.db.scalar(
                select(EcomOrder)
                .where(EcomOrder.id == order_id)
                .options(
                    joinedload(EcomOrder.items),
                    joinedload(EcomOrder.tracking),
                    joinedload(EcomOrder.delivery_address),
                )
            )
        )

    def list_reviews(self) -> list[ReviewOut]:
        rows = self.db.scalars(select(EcomReview).order_by(EcomReview.created_at.desc())).all()
        out: list[ReviewOut] = []
        for r in rows:
            profile = self.db.scalar(select(EcomUserProfile).where(EcomUserProfile.user_id == r.user_id))
            out.append(
                ReviewOut(
                    id=r.id,
                    user_id=r.user_id,
                    user_name=profile.name if profile else "",
                    user_avatar=profile.photo_url if profile and profile.photo_url else "",
                    product_id=r.product_id,
                    rating=float(r.rating),
                    comment=r.comment or "",
                    images=list(r.images or []),
                    created_at=r.created_at.isoformat() if r.created_at else "",
                )
            )
        return out

    def moderate_review(self, review_id: UUID, visible: bool) -> None:
        review = self.db.get(EcomReview, review_id)
        if not review:
            raise ValueError("Review not found")
        review.is_visible = visible
        review.moderation_status = "approved" if visible else "rejected"
        self.db.commit()

    def send_broadcast(self, admin_id: UUID, data: BroadcastAdminIn) -> None:
        broadcast = EcomNotificationBroadcast(
            title=data.title,
            body=data.body,
            created_by=admin_id,
            is_sent=True,
            sent_at=datetime.utcnow(),
        )
        self.db.add(broadcast)
        users = self.db.scalars(select(EcomUserProfile.user_id)).all()
        for uid in users:
            self.db.add(
                EcomUserNotification(
                    user_id=uid,
                    title=data.title,
                    body=data.body,
                    notification_type="broadcast",
                )
            )
        self.db.commit()
