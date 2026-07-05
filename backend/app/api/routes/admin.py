"""Admin API — requires is_admin profile."""

from __future__ import annotations

from uuid import UUID

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.api.deps import get_db, require_admin
from app.schemas import (
    BannerAdminIn,
    BannerOut,
    BroadcastAdminIn,
    CategoryAdminIn,
    CategoryOut,
    CouponAdminIn,
    DashboardOut,
    MessageOut,
    OrderOut,
    OrderStatusIn,
    ProductAdminIn,
    ProductOut,
    ProfileOut,
    ReviewOut,
    UserFlagsIn,
)
from app.services.admin_service import AdminService

router = APIRouter(prefix="/admin", tags=["admin"])


@router.get("/dashboard", response_model=DashboardOut)
def dashboard(
    _: UUID = Depends(require_admin),
    db: Session = Depends(get_db),
) -> DashboardOut:
    return AdminService(db).dashboard()


@router.get("/users", response_model=list[ProfileOut])
def list_users(_: UUID = Depends(require_admin), db: Session = Depends(get_db)) -> list[ProfileOut]:
    return AdminService(db).list_users()


@router.post("/users/{user_id}/flags", response_model=ProfileOut)
def update_user_flags(
    user_id: UUID,
    data: UserFlagsIn,
    _: UUID = Depends(require_admin),
    db: Session = Depends(get_db),
) -> ProfileOut:
    return AdminService(db).update_user_flags(user_id, data)


@router.get("/products", response_model=list[ProductOut])
def list_products(_: UUID = Depends(require_admin), db: Session = Depends(get_db)) -> list[ProductOut]:
    return AdminService(db).list_products()


@router.post("/products", response_model=ProductOut)
def create_product(
    data: ProductAdminIn,
    _: UUID = Depends(require_admin),
    db: Session = Depends(get_db),
) -> ProductOut:
    return AdminService(db).save_product(data)


@router.put("/products/{product_id}", response_model=ProductOut)
def update_product(
    product_id: UUID,
    data: ProductAdminIn,
    _: UUID = Depends(require_admin),
    db: Session = Depends(get_db),
) -> ProductOut:
    return AdminService(db).save_product(data, product_id=product_id)


@router.delete("/products/{product_id}", response_model=MessageOut)
def delete_product(
    product_id: UUID,
    _: UUID = Depends(require_admin),
    db: Session = Depends(get_db),
) -> MessageOut:
    AdminService(db).delete_product(product_id)
    return MessageOut(message="Product deleted", success=True)


@router.get("/categories", response_model=list[CategoryOut])
def list_categories(_: UUID = Depends(require_admin), db: Session = Depends(get_db)) -> list[CategoryOut]:
    return AdminService(db).list_categories()


@router.post("/categories", response_model=CategoryOut)
def create_category(
    data: CategoryAdminIn,
    _: UUID = Depends(require_admin),
    db: Session = Depends(get_db),
) -> CategoryOut:
    return AdminService(db).save_category(data)


@router.put("/categories/{category_id}", response_model=CategoryOut)
def update_category(
    category_id: UUID,
    data: CategoryAdminIn,
    _: UUID = Depends(require_admin),
    db: Session = Depends(get_db),
) -> CategoryOut:
    return AdminService(db).save_category(data, category_id=category_id)


@router.delete("/categories/{category_id}", response_model=MessageOut)
def delete_category(
    category_id: UUID,
    _: UUID = Depends(require_admin),
    db: Session = Depends(get_db),
) -> MessageOut:
    AdminService(db).delete_category(category_id)
    return MessageOut(message="Category deleted", success=True)


@router.get("/banners", response_model=list[BannerOut])
def list_banners(_: UUID = Depends(require_admin), db: Session = Depends(get_db)) -> list[BannerOut]:
    return AdminService(db).list_banners()


@router.post("/banners", response_model=BannerOut)
def create_banner(
    data: BannerAdminIn,
    _: UUID = Depends(require_admin),
    db: Session = Depends(get_db),
) -> BannerOut:
    return AdminService(db).save_banner(data)


@router.put("/banners/{banner_id}", response_model=BannerOut)
def update_banner(
    banner_id: UUID,
    data: BannerAdminIn,
    _: UUID = Depends(require_admin),
    db: Session = Depends(get_db),
) -> BannerOut:
    return AdminService(db).save_banner(data, banner_id=banner_id)


@router.delete("/banners/{banner_id}", response_model=MessageOut)
def delete_banner(
    banner_id: UUID,
    _: UUID = Depends(require_admin),
    db: Session = Depends(get_db),
) -> MessageOut:
    AdminService(db).delete_banner(banner_id)
    return MessageOut(message="Banner deleted", success=True)


@router.get("/coupons", response_model=list[CouponAdminIn])
def list_coupons(_: UUID = Depends(require_admin), db: Session = Depends(get_db)) -> list[CouponAdminIn]:
    return AdminService(db).list_coupons()


@router.post("/coupons", response_model=CouponAdminIn)
def save_coupon(
    data: CouponAdminIn,
    _: UUID = Depends(require_admin),
    db: Session = Depends(get_db),
) -> CouponAdminIn:
    return AdminService(db).save_coupon(data)


@router.get("/orders", response_model=list[OrderOut])
def list_orders(_: UUID = Depends(require_admin), db: Session = Depends(get_db)) -> list[OrderOut]:
    return AdminService(db).list_orders()


@router.post("/orders/{order_id}/status", response_model=OrderOut)
def update_order_status(
    order_id: UUID,
    data: OrderStatusIn,
    _: UUID = Depends(require_admin),
    db: Session = Depends(get_db),
) -> OrderOut:
    return AdminService(db).update_order_status(order_id, data.status)


@router.get("/reviews", response_model=list[ReviewOut])
def list_reviews(_: UUID = Depends(require_admin), db: Session = Depends(get_db)) -> list[ReviewOut]:
    return AdminService(db).list_reviews()


@router.post("/reviews/{review_id}/moderate", response_model=MessageOut)
def moderate_review(
    review_id: UUID,
    visible: bool = True,
    _: UUID = Depends(require_admin),
    db: Session = Depends(get_db),
) -> MessageOut:
    AdminService(db).moderate_review(review_id, visible)
    return MessageOut(message="Review updated", success=True)


@router.post("/notifications/broadcast", response_model=MessageOut)
def broadcast(
    data: BroadcastAdminIn,
    admin_id: UUID = Depends(require_admin),
    db: Session = Depends(get_db),
) -> MessageOut:
    AdminService(db).send_broadcast(admin_id, data)
    return MessageOut(message="Broadcast sent", success=True)
