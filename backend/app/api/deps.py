"""FastAPI dependencies."""

from __future__ import annotations

from uuid import UUID

from fastapi import Depends, Header, HTTPException
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.services.supabase_auth_service import SupabaseAuthService
from app.services.user_service import UserService

__all__ = ["get_db", "get_user_id", "get_optional_user_id", "require_admin"]


def _extract_bearer_token(authorization: str | None) -> str | None:
    if not authorization:
        return None
    parts = authorization.strip().split(" ", 1)
    if len(parts) != 2 or parts[0].lower() != "bearer":
        return None
    token = parts[1].strip()
    return token or None


def get_user_id(
    authorization: str | None = Header(default=None),
    x_user_id: str | None = Header(default=None, alias="X-User-Id"),
) -> UUID:
    """Resolve user id from Supabase JWT (preferred) or X-User-Id (dev fallback)."""
    token = _extract_bearer_token(authorization)
    if token:
        return SupabaseAuthService().verify_token_get_user_id(token)

    if x_user_id:
        try:
            return UUID(x_user_id)
        except ValueError as exc:
            raise HTTPException(status_code=401, detail="Invalid user id") from exc

    raise HTTPException(status_code=401, detail="Missing authentication token")


def get_optional_user_id(
    authorization: str | None = Header(default=None),
    x_user_id: str | None = Header(default=None, alias="X-User-Id"),
) -> UUID | None:
    token = _extract_bearer_token(authorization)
    if token:
        try:
            return SupabaseAuthService().verify_token_get_user_id(token)
        except HTTPException:
            return None

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
