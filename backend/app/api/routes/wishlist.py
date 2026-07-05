"""Wishlist."""

from __future__ import annotations

from uuid import UUID

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_user_id
from app.schemas import ProductOut
from app.services.cart_service import CartService

router = APIRouter(tags=["wishlist"])


@router.get("/wishlist", response_model=list[ProductOut])
def get_wishlist(user_id: UUID = Depends(get_user_id), db: Session = Depends(get_db)) -> list[ProductOut]:
    return CartService(db).wishlist(user_id)


@router.post("/wishlist/add", response_model=list[ProductOut])
def add_wishlist(
    product_id: UUID,
    user_id: UUID = Depends(get_user_id),
    db: Session = Depends(get_db),
) -> list[ProductOut]:
    return CartService(db).add_wishlist(user_id, product_id)


@router.post("/wishlist/remove", response_model=list[ProductOut])
def remove_wishlist(
    product_id: UUID,
    user_id: UUID = Depends(get_user_id),
    db: Session = Depends(get_db),
) -> list[ProductOut]:
    return CartService(db).remove_wishlist(user_id, product_id)
