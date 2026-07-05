"""Auth — dev register creates profile; login stub for Supabase client auth."""

from __future__ import annotations

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.api.deps import get_db
from app.schemas import AuthLoginIn, AuthRegisterIn, MessageOut, ProfileOut
from app.services.auth_service import resolve_register_user_id
from app.services.user_service import UserService

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/login", response_model=MessageOut)
def login(_: AuthLoginIn) -> MessageOut:
    return MessageOut(
        message="Use Supabase Auth on client; pass user UUID via X-User-Id header",
        success=True,
    )


@router.post("/register", response_model=ProfileOut)
def register(data: AuthRegisterIn, db: Session = Depends(get_db)) -> ProfileOut:
    user_id = resolve_register_user_id(data.email, data.user_id)
    return UserService(db).register_profile(
        user_id,
        name=data.name,
        email=data.email.strip(),
        phone=data.phone,
    )


@router.post("/logout", response_model=MessageOut)
def logout() -> MessageOut:
    return MessageOut(message="Logged out", success=True)
