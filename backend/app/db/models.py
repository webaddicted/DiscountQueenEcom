"""SQLAlchemy ORM models for ecom_* tables."""

import uuid
from datetime import date, datetime
from decimal import Decimal
from typing import Dict, List, Optional

from sqlalchemy import Boolean, Date, DateTime, ForeignKey, Integer, Numeric, String, Text, func
from sqlalchemy.dialects.postgresql import ARRAY, JSONB, UUID
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship


class Base(DeclarativeBase):
    pass


class EcomUserProfile(Base):
    __tablename__ = "ecom_user_profiles"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), unique=True, nullable=False)
    name: Mapped[Optional[str]] = mapped_column(String(150))
    phone: Mapped[Optional[str]] = mapped_column(String(20))
    photo_url: Mapped[Optional[str]] = mapped_column(Text)
    gender: Mapped[Optional[str]] = mapped_column(String(20))
    date_of_birth: Mapped[Optional[date]] = mapped_column(Date)
    is_email_verified: Mapped[bool] = mapped_column(Boolean, default=False)
    is_mobile_verified: Mapped[bool] = mapped_column(Boolean, default=False)
    account_status: Mapped[str] = mapped_column(String(30), default="active")
    is_admin: Mapped[bool] = mapped_column(Boolean, default=False)
    is_blocked: Mapped[bool] = mapped_column(Boolean, default=False)
    block_reason: Mapped[Optional[str]] = mapped_column(Text)
    referral_code: Mapped[Optional[str]] = mapped_column(String(20))
    loyalty_points: Mapped[int] = mapped_column(Integer, default=0)
    membership_tier: Mapped[str] = mapped_column(String(30), default="free")
    total_orders_count: Mapped[int] = mapped_column(Integer, default=0)
    total_spent: Mapped[Decimal] = mapped_column(Numeric(14, 2), default=0)
    created_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), server_default=func.now())


class EcomCategory(Base):
    __tablename__ = "ecom_categories"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    slug: Mapped[str] = mapped_column(String(100), unique=True)
    name: Mapped[str] = mapped_column(String(150))
    image_url: Mapped[Optional[str]] = mapped_column(Text)
    icon_name: Mapped[Optional[str]] = mapped_column(String(50))
    sort_order: Mapped[int] = mapped_column(Integer, default=0)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    product_count: Mapped[int] = mapped_column(Integer, default=0)


class EcomBrand(Base):
    __tablename__ = "ecom_brands"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name: Mapped[str] = mapped_column(String(150), unique=True)
    logo_url: Mapped[Optional[str]] = mapped_column(Text)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)


class EcomProduct(Base):
    __tablename__ = "ecom_products"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    sku: Mapped[str] = mapped_column(String(50), unique=True)
    name: Mapped[str] = mapped_column(String(255))
    slug: Mapped[str] = mapped_column(String(255), unique=True)
    description: Mapped[Optional[str]] = mapped_column(Text)
    short_description: Mapped[Optional[str]] = mapped_column(String(500))
    category_id: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))
    brand_id: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))
    price: Mapped[Decimal] = mapped_column(Numeric(12, 2), default=0)
    mrp: Mapped[Decimal] = mapped_column(Numeric(12, 2), default=0)
    discount_percent: Mapped[int] = mapped_column(Integer, default=0)
    thumbnail_url: Mapped[Optional[str]] = mapped_column(Text)
    rating_avg: Mapped[Decimal] = mapped_column(Numeric(3, 2), default=0)
    review_count: Mapped[int] = mapped_column(Integer, default=0)
    stock_qty: Mapped[int] = mapped_column(Integer, default=0)
    sold_count: Mapped[int] = mapped_column(Integer, default=0)
    is_featured: Mapped[bool] = mapped_column(Boolean, default=False)
    is_popular: Mapped[bool] = mapped_column(Boolean, default=False)
    is_new_arrival: Mapped[bool] = mapped_column(Boolean, default=False)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    is_deleted: Mapped[bool] = mapped_column(Boolean, default=False)
    tags: Mapped[Optional[List[str]]] = mapped_column(ARRAY(Text))
    created_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), server_default=func.now())

    images: Mapped[List["EcomProductImage"]] = relationship(back_populates="product", lazy="selectin")
    variants: Mapped[List["EcomProductVariant"]] = relationship(back_populates="product", lazy="selectin")
    specs: Mapped[List["EcomProductSpec"]] = relationship(back_populates="product", lazy="selectin")


class EcomProductImage(Base):
    __tablename__ = "ecom_product_images"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    product_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("ecom_products.id"), nullable=False
    )
    image_url: Mapped[str] = mapped_column(Text)
    alt_text: Mapped[Optional[str]] = mapped_column(String(255))
    sort_order: Mapped[int] = mapped_column(Integer, default=0)
    is_primary: Mapped[bool] = mapped_column(Boolean, default=False)

    product: Mapped["EcomProduct"] = relationship(back_populates="images")


class EcomProductVariant(Base):
    __tablename__ = "ecom_product_variants"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    product_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("ecom_products.id"), nullable=False
    )
    size: Mapped[str] = mapped_column(String(30), default="")
    color: Mapped[str] = mapped_column(String(50), default="")
    stock_qty: Mapped[int] = mapped_column(Integer, default=0)
    price_override: Mapped[Optional[Decimal]] = mapped_column(Numeric(12, 2))
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)

    product: Mapped["EcomProduct"] = relationship(back_populates="variants")


class EcomProductSpec(Base):
    __tablename__ = "ecom_product_specifications"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    product_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("ecom_products.id"), nullable=False
    )
    spec_key: Mapped[str] = mapped_column(String(100))
    spec_value: Mapped[str] = mapped_column(Text)
    sort_order: Mapped[int] = mapped_column(Integer, default=0)

    product: Mapped["EcomProduct"] = relationship(back_populates="specs")


class EcomBanner(Base):
    __tablename__ = "ecom_banners"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title: Mapped[Optional[str]] = mapped_column(String(200))
    subtitle: Mapped[Optional[str]] = mapped_column(String(300))
    image_url: Mapped[str] = mapped_column(Text)
    action_type: Mapped[str] = mapped_column(String(30), default="none")
    action_value: Mapped[Optional[str]] = mapped_column(String(255))
    sort_order: Mapped[int] = mapped_column(Integer, default=0)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)


class EcomCoupon(Base):
    __tablename__ = "ecom_coupons"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    code: Mapped[str] = mapped_column(String(50), unique=True)
    discount_type: Mapped[str] = mapped_column(String(20), default="percent")
    discount_percent: Mapped[int] = mapped_column(Integer, default=0)
    discount_amount: Mapped[Decimal] = mapped_column(Numeric(12, 2), default=0)
    max_discount: Mapped[Decimal] = mapped_column(Numeric(12, 2), default=0)
    min_order_amount: Mapped[Decimal] = mapped_column(Numeric(12, 2), default=0)
    usage_limit: Mapped[Optional[int]] = mapped_column(Integer)
    per_user_limit: Mapped[int] = mapped_column(Integer, default=1)
    used_count: Mapped[int] = mapped_column(Integer, default=0)
    expires_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True))
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)


class EcomAddress(Base):
    __tablename__ = "ecom_addresses"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True))
    name: Mapped[Optional[str]] = mapped_column(String(150))
    phone: Mapped[Optional[str]] = mapped_column(String(20))
    address_line_1: Mapped[str] = mapped_column(Text)
    address_line_2: Mapped[Optional[str]] = mapped_column(Text)
    city: Mapped[str] = mapped_column(String(100))
    state: Mapped[str] = mapped_column(String(100))
    pincode: Mapped[str] = mapped_column(String(10))
    landmark: Mapped[Optional[str]] = mapped_column(String(200))
    address_type: Mapped[str] = mapped_column(String(20), default="home")
    is_default: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), server_default=func.now())


class EcomCartItem(Base):
    __tablename__ = "ecom_cart_items"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True))
    product_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("ecom_products.id"), nullable=False
    )
    variant_id: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))
    quantity: Mapped[int] = mapped_column(Integer, default=1)
    selected_size: Mapped[str] = mapped_column(String(30), default="")
    selected_color: Mapped[str] = mapped_column(String(50), default="")
    unit_price: Mapped[Decimal] = mapped_column(Numeric(12, 2), default=0)
    unit_mrp: Mapped[Decimal] = mapped_column(Numeric(12, 2), default=0)


class EcomWishlistItem(Base):
    __tablename__ = "ecom_wishlist_items"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True))
    product_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("ecom_products.id"), nullable=False
    )
    created_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), server_default=func.now())


class EcomOrder(Base):
    __tablename__ = "ecom_orders"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    order_number: Mapped[str] = mapped_column(String(30), unique=True)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True))
    status: Mapped[str] = mapped_column(String(30), default="pending")
    subtotal: Mapped[Decimal] = mapped_column(Numeric(12, 2), default=0)
    delivery_fee: Mapped[Decimal] = mapped_column(Numeric(12, 2), default=0)
    discount: Mapped[Decimal] = mapped_column(Numeric(12, 2), default=0)
    total: Mapped[Decimal] = mapped_column(Numeric(12, 2), default=0)
    coupon_code: Mapped[Optional[str]] = mapped_column(String(50))
    payment_method: Mapped[Optional[str]] = mapped_column(String(30))
    payment_status: Mapped[str] = mapped_column(String(30), default="pending")
    estimated_delivery: Mapped[Optional[date]] = mapped_column(Date)
    cancelled_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True))
    notes: Mapped[Optional[str]] = mapped_column(Text)
    created_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), server_default=func.now())

    items: Mapped[List["EcomOrderItem"]] = relationship(back_populates="order", lazy="selectin")
    tracking: Mapped[List["EcomOrderTracking"]] = relationship(back_populates="order", lazy="selectin")
    delivery_address: Mapped[Optional["EcomOrderDeliveryAddress"]] = relationship(
        back_populates="order", uselist=False, lazy="selectin"
    )


class EcomOrderItem(Base):
    __tablename__ = "ecom_order_items"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    order_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("ecom_orders.id"), nullable=False
    )
    product_id: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))
    product_name: Mapped[str] = mapped_column(String(255))
    product_image: Mapped[Optional[str]] = mapped_column(Text)
    selected_size: Mapped[str] = mapped_column(String(30), default="")
    selected_color: Mapped[str] = mapped_column(String(50), default="")
    unit_price: Mapped[Decimal] = mapped_column(Numeric(12, 2), default=0)
    unit_mrp: Mapped[Decimal] = mapped_column(Numeric(12, 2), default=0)
    quantity: Mapped[int] = mapped_column(Integer, default=1)
    line_total: Mapped[Decimal] = mapped_column(Numeric(12, 2), default=0)

    order: Mapped["EcomOrder"] = relationship(back_populates="items")


class EcomOrderDeliveryAddress(Base):
    __tablename__ = "ecom_order_delivery_addresses"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    order_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("ecom_orders.id"), unique=True, nullable=False
    )
    name: Mapped[Optional[str]] = mapped_column(String(150))
    phone: Mapped[Optional[str]] = mapped_column(String(20))
    address_line_1: Mapped[Optional[str]] = mapped_column(Text)
    address_line_2: Mapped[Optional[str]] = mapped_column(Text)
    city: Mapped[Optional[str]] = mapped_column(String(100))
    state: Mapped[Optional[str]] = mapped_column(String(100))
    pincode: Mapped[Optional[str]] = mapped_column(String(10))
    landmark: Mapped[Optional[str]] = mapped_column(String(200))
    address_type: Mapped[Optional[str]] = mapped_column(String(20))

    order: Mapped["EcomOrder"] = relationship(back_populates="delivery_address")


class EcomOrderTracking(Base):
    __tablename__ = "ecom_order_tracking_steps"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    order_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("ecom_orders.id"), nullable=False
    )
    title: Mapped[str] = mapped_column(String(100))
    description: Mapped[Optional[str]] = mapped_column(Text)
    event_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True))
    is_completed: Mapped[bool] = mapped_column(Boolean, default=False)
    is_current: Mapped[bool] = mapped_column(Boolean, default=False)
    sort_order: Mapped[int] = mapped_column(Integer, default=0)

    order: Mapped["EcomOrder"] = relationship(back_populates="tracking")


class EcomPayment(Base):
    __tablename__ = "ecom_payments"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    order_id: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True))
    payment_ref: Mapped[Optional[str]] = mapped_column(String(100))
    gateway: Mapped[str] = mapped_column(String(30), default="cod")
    amount: Mapped[Decimal] = mapped_column(Numeric(12, 2), default=0)
    currency: Mapped[str] = mapped_column(String(3), default="INR")
    status: Mapped[str] = mapped_column(String(30), default="pending")
    gateway_response: Mapped[Optional[Dict]] = mapped_column(JSONB)
    paid_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True))
    created_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), server_default=func.now())


class EcomReview(Base):
    __tablename__ = "ecom_reviews"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    product_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("ecom_products.id"), nullable=False
    )
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True))
    rating: Mapped[Decimal] = mapped_column(Numeric(2, 1))
    comment: Mapped[Optional[str]] = mapped_column(Text)
    images: Mapped[Optional[List[str]]] = mapped_column(ARRAY(Text))
    is_visible: Mapped[bool] = mapped_column(Boolean, default=True)
    moderation_status: Mapped[str] = mapped_column(String(30), default="approved")
    created_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), server_default=func.now())


class EcomUserNotification(Base):
    __tablename__ = "ecom_user_notifications"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True))
    title: Mapped[str] = mapped_column(String(200))
    body: Mapped[Optional[str]] = mapped_column(Text)
    notification_type: Mapped[str] = mapped_column(String(40), default="system")
    action_type: Mapped[Optional[str]] = mapped_column(String(30))
    action_value: Mapped[Optional[str]] = mapped_column(String(255))
    is_read: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), server_default=func.now())


class EcomNotificationBroadcast(Base):
    __tablename__ = "ecom_notification_broadcasts"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title: Mapped[str] = mapped_column(String(200))
    body: Mapped[str] = mapped_column(Text)
    is_sent: Mapped[bool] = mapped_column(Boolean, default=False)
    sent_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True))
    created_by: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))
    created_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), server_default=func.now())


class EcomAppSetting(Base):
    __tablename__ = "ecom_app_settings"

    key: Mapped[str] = mapped_column(String(100), primary_key=True)
    value: Mapped[Dict] = mapped_column(JSONB, default={})
    updated_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), server_default=func.now())


class EcomFaq(Base):
    __tablename__ = "ecom_faqs"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    question: Mapped[str] = mapped_column(Text)
    answer: Mapped[str] = mapped_column(Text)
    category: Mapped[str] = mapped_column(String(50), default="general")
    sort_order: Mapped[int] = mapped_column(Integer, default=0)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
