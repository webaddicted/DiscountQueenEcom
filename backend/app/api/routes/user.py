"""User profile and addresses."""

from __future__ import annotations

from uuid import UUID

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_user_id
from app.schemas import AddressIn, AddressOut, MessageOut, ProfileOut, ProfileUpdateIn
from app.services.user_service import UserService

router = APIRouter(tags=["user"])


@router.get("/user/profile", response_model=ProfileOut)
def get_profile(user_id: UUID = Depends(get_user_id), db: Session = Depends(get_db)) -> ProfileOut:
    return UserService(db).profile_out(user_id)


@router.post("/user/update", response_model=ProfileOut)
def update_profile(
    data: ProfileUpdateIn,
    user_id: UUID = Depends(get_user_id),
    db: Session = Depends(get_db),
) -> ProfileOut:
    return UserService(db).update_profile(user_id, data)


@router.post("/user/delete", response_model=MessageOut)
def delete_account(user_id: UUID = Depends(get_user_id), db: Session = Depends(get_db)) -> MessageOut:
    profile = UserService(db).get_or_create_profile(user_id)
    profile.account_status = "deleted"
    db.commit()
    return MessageOut(message="Account marked deleted", success=True)


@router.get("/addresses", response_model=list[AddressOut])
def list_addresses(user_id: UUID = Depends(get_user_id), db: Session = Depends(get_db)) -> list[AddressOut]:
    return UserService(db).list_addresses(user_id)


@router.post("/addresses/add", response_model=AddressOut)
def add_address(
    data: AddressIn,
    user_id: UUID = Depends(get_user_id),
    db: Session = Depends(get_db),
) -> AddressOut:
    return UserService(db).add_address(user_id, data)


@router.post("/addresses/update", response_model=AddressOut)
def update_address(
    data: AddressIn,
    address_id: UUID,
    user_id: UUID = Depends(get_user_id),
    db: Session = Depends(get_db),
) -> AddressOut:
    return UserService(db).update_address(user_id, address_id, data)


@router.post("/addresses/delete", response_model=MessageOut)
def delete_address(
    address_id: UUID,
    user_id: UUID = Depends(get_user_id),
    db: Session = Depends(get_db),
) -> MessageOut:
    UserService(db).delete_address(user_id, address_id)
    return MessageOut(message="Address deleted", success=True)
