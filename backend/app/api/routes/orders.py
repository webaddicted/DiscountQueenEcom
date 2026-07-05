"""Orders."""

from __future__ import annotations

from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_user_id
from app.schemas import MessageOut, OrderOut, PlaceOrderIn
from app.services.order_service import OrderService

router = APIRouter(tags=["orders"])


@router.get("/orders", response_model=list[OrderOut])
def list_orders(user_id: UUID = Depends(get_user_id), db: Session = Depends(get_db)) -> list[OrderOut]:
    return OrderService(db).list_orders(user_id)


@router.get("/orders/{order_id}", response_model=OrderOut)
def order_detail(
    order_id: UUID,
    user_id: UUID = Depends(get_user_id),
    db: Session = Depends(get_db),
) -> OrderOut:
    order = OrderService(db).order_detail(user_id, order_id)
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    return order


@router.post("/orders/place", response_model=OrderOut)
def place_order(
    data: PlaceOrderIn,
    user_id: UUID = Depends(get_user_id),
    db: Session = Depends(get_db),
) -> OrderOut:
    return OrderService(db).place_order(user_id, data)


@router.post("/orders/cancel", response_model=OrderOut)
def cancel_order(
    order_id: UUID,
    user_id: UUID = Depends(get_user_id),
    db: Session = Depends(get_db),
) -> OrderOut:
    return OrderService(db).cancel_order(user_id, order_id)


@router.get("/orders/track/{order_id}", response_model=OrderOut)
def track_order(
    order_id: UUID,
    user_id: UUID = Depends(get_user_id),
    db: Session = Depends(get_db),
) -> OrderOut:
    order = OrderService(db).order_detail(user_id, order_id)
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    return order
