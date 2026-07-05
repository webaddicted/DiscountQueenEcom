"""FastAPI dependencies."""

from __future__ import annotations

from uuid import UUID

from fastapi import Depends, Header, HTTPException
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.services.user_service import UserService

__all__ = ["get_db", "get_user_id", "get_optional_user_id", "require_admin"]


def get_user_id(x_user_id: str | None = Header(default=None, alias="X-User-Id")) -> UUID:
    """Dev auth: Flutter passes Supabase user UUID via X-User-Id header."""
    if not x_user_id:
        raise HTTPException(status_code=401, detail="Missing X-User-Id header")
    try:
        return UUID(x_user_id)
    except ValueError as exc:
        raise HTTPException(status_code=401, detail="Invalid user id") from exc


def get_optional_user_id(x_user_id: str | None = Header(default=None, alias="X-User-Id")) -> UUID | None:
    if not x_user_id:
        return None
    try:
        return UUID(x_user_id)
    except ValueError:
        return None


def require_admin(
    user_id: UUID = Depends(get_user_id),
    db: Session = Depends(get_db),
) -> UUID:
    profile = UserService(db).get_or_create_profile(user_id)
    if not profile.is_admin:
        raise HTTPException(status_code=403, detail="Admin access required")
    return user_id
