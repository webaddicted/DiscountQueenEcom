"""Cart operations."""

from __future__ import annotations

from uuid import UUID

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_user_id
from app.schemas import CartAddIn, CartOut, CartUpdateIn, CouponApplyIn, MessageOut
from app.services.cart_service import CartService

router = APIRouter(tags=["cart"])


@router.get("/cart", response_model=CartOut)
def get_cart(user_id: UUID = Depends(get_user_id), db: Session = Depends(get_db)) -> CartOut:
    return CartService(db).get_cart(user_id)


@router.post("/cart/add", response_model=CartOut)
def add_to_cart(
    data: CartAddIn,
    user_id: UUID = Depends(get_user_id),
    db: Session = Depends(get_db),
) -> CartOut:
    return CartService(db).add_to_cart(user_id, data)


@router.post("/cart/update", response_model=CartOut)
def update_cart(
    data: CartUpdateIn,
    item_id: UUID,
    user_id: UUID = Depends(get_user_id),
    db: Session = Depends(get_db),
) -> CartOut:
    return CartService(db).update_cart(user_id, item_id, data.quantity)


@router.post("/cart/remove", response_model=CartOut)
def remove_from_cart(
    item_id: UUID,
    user_id: UUID = Depends(get_user_id),
    db: Session = Depends(get_db),
) -> CartOut:
    return CartService(db).remove_from_cart(user_id, item_id)


@router.post("/cart/clear", response_model=CartOut)
def clear_cart(user_id: UUID = Depends(get_user_id), db: Session = Depends(get_db)) -> CartOut:
    return CartService(db).clear_cart(user_id)


@router.post("/cart/coupon/apply", response_model=CartOut)
def apply_coupon(
    data: CouponApplyIn,
    user_id: UUID = Depends(get_user_id),
    db: Session = Depends(get_db),
) -> CartOut:
    return CartService(db).apply_coupon(user_id, data.code)


@router.post("/cart/coupon/remove", response_model=CartOut)
def remove_coupon(user_id: UUID = Depends(get_user_id), db: Session = Depends(get_db)) -> CartOut:
    return CartService(db).get_cart(user_id)
