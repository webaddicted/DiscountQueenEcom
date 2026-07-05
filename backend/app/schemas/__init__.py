"""Pydantic schemas — camelCase for Flutter."""

from __future__ import annotations

from datetime import date, datetime
from decimal import Decimal
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field
from pydantic.alias_generators import to_camel


class CamelModel(BaseModel):
    model_config = ConfigDict(
        alias_generator=to_camel,
        populate_by_name=True,
        from_attributes=True,
        serialize_by_alias=True,
    )


# --- Catalog ---

class BannerOut(CamelModel):
    id: UUID
    title: str | None = None
    subtitle: str | None = None
    image: str = Field(validation_alias="image_url")
    action_type: str = "none"
    action_value: str | None = None
    sort_order: int = 0
    is_active: bool = True


class CategoryOut(CamelModel):
    id: UUID
    name: str
    image: str = Field(default="", validation_alias="image_url")
    icon: str = Field(default="", validation_alias="icon_name")
    product_count: int = 0
    sort_order: int = 0
    is_active: bool = True


class ProductOut(CamelModel):
    id: UUID
    name: str
    description: str = ""
    short_description: str = ""
    price: float
    mrp: float = 0
    discount_percent: int = 0
    images: list[str] = []
    thumbnail: str = ""
    category_id: UUID | None = None
    category_name: str = ""
    brand: str = ""
    rating: float = 0
    review_count: int = 0
    in_stock: bool = True
    stock_qty: int = 0
    sizes: list[str] = []
    colors: list[str] = []
    tags: list[str] = []
    specifications: dict[str, str] = {}
    is_featured: bool = False
    is_popular: bool = False
    is_new_arrival: bool = False
    created_at: str = ""


class ReviewOut(CamelModel):
    id: UUID
    user_id: UUID
    user_name: str = ""
    user_avatar: str = ""
    product_id: UUID
    rating: float
    comment: str = ""
    images: list[str] = []
    created_at: str = ""


# --- User ---

class ProfileOut(CamelModel):
    id: UUID
    name: str = ""
    email: str = ""
    phone: str = ""
    photo_url: str = ""
    gender: str = ""
    date_of_birth: str = ""
    is_admin: bool = False
    is_blocked: bool = False
    created_at: str = ""


class ProfileUpdateIn(CamelModel):
    name: str | None = None
    phone: str | None = None
    photo_url: str | None = None
    gender: str | None = None
    date_of_birth: str | None = None


class AddressOut(CamelModel):
    id: UUID
    name: str = ""
    phone: str = ""
    address_line_1: str = ""
    address_line_2: str = ""
    city: str = ""
    state: str = ""
    pincode: str = ""
    landmark: str = ""
    type: str = Field(default="home", validation_alias="address_type")
    is_default: bool = False


class AddressIn(CamelModel):
    name: str = ""
    phone: str = ""
    address_line_1: str
    address_line_2: str = ""
    city: str
    state: str
    pincode: str
    landmark: str = ""
    type: str = Field(default="home", serialization_alias="address_type")
    is_default: bool = False


# --- Cart ---

class CartItemOut(CamelModel):
    id: UUID
    product_id: UUID
    product_name: str = ""
    product_image: str = ""
    price: float
    mrp: float = 0
    quantity: int = 1
    selected_size: str = ""
    selected_color: str = ""


class CartOut(CamelModel):
    items: list[CartItemOut] = []
    coupon_code: str = ""
    coupon_discount: float = 0


class CartAddIn(CamelModel):
    product_id: UUID
    quantity: int = 1
    selected_size: str = ""
    selected_color: str = ""
    variant_id: UUID | None = None


class CartUpdateIn(CamelModel):
    quantity: int


class CouponApplyIn(CamelModel):
    code: str


# --- Orders ---

class OrderTrackingOut(CamelModel):
    title: str
    description: str = ""
    date_time: str = ""
    is_completed: bool = False
    is_current: bool = False


class OrderOut(CamelModel):
    id: UUID
    order_number: str = ""
    items: list[CartItemOut] = []
    subtotal: float = 0
    delivery_fee: float = 0
    discount: float = 0
    total: float = 0
    status: str = "pending"
    payment_method: str = ""
    payment_status: str = "pending"
    delivery_address: AddressOut | None = None
    created_at: str = ""
    updated_at: str = ""
    estimated_delivery: str = ""
    tracking_steps: list[OrderTrackingOut] = []
    user_id: UUID | None = None
    payment_ref: str = ""


class PlaceOrderIn(CamelModel):
    address_id: UUID
    payment_method: str = "cod"
    coupon_code: str | None = None
    notes: str | None = None


# --- Auth ---

class AuthLoginIn(CamelModel):
    email: str
    password: str


class AuthRegisterIn(CamelModel):
    name: str
    email: str
    password: str
    phone: str | None = None
    user_id: UUID | None = None


class MessageOut(CamelModel):
    message: str
    success: bool = True


# --- Admin ---

class DashboardOut(CamelModel):
    user_count: int = 0
    order_count: int = 0
    revenue_total: float = 0
    orders_today: int = 0
    product_count: int = 0


class ProductAdminIn(CamelModel):
    name: str
    description: str = ""
    short_description: str = ""
    price: float
    mrp: float = 0
    category_id: UUID | None = None
    stock_qty: int = 0
    thumbnail: str = ""
    images: list[str] = []
    sizes: list[str] = []
    colors: list[str] = []
    tags: list[str] = []
    is_featured: bool = False
    is_popular: bool = False
    is_new_arrival: bool = False


class CategoryAdminIn(CamelModel):
    name: str
    image: str = ""
    icon: str = ""
    sort_order: int = 0
    is_active: bool = True


class BannerAdminIn(CamelModel):
    title: str = ""
    subtitle: str = ""
    image: str
    action_type: str = "none"
    action_value: str = ""
    sort_order: int = 0
    is_active: bool = True


class CouponAdminIn(CamelModel):
    code: str
    discount_type: str = "percent"
    discount_percent: int = 0
    discount_amount: float = 0
    max_discount: float = 0
    min_order_amount: float = 0
    is_active: bool = True
    expires_at: datetime | None = None


class BroadcastAdminIn(CamelModel):
    title: str
    body: str


class UserFlagsIn(CamelModel):
    is_admin: bool = False
    is_blocked: bool = False
    block_reason: str | None = None


class OrderStatusIn(CamelModel):
    status: str


class ReviewIn(CamelModel):
    product_id: UUID
    rating: float
    comment: str = ""
    images: list[str] = []

