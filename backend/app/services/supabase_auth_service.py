"""Supabase Auth — sign-in, sign-up, JWT verification."""

from __future__ import annotations

import logging
from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Any
from uuid import UUID

import httpx
import jwt
from fastapi import HTTPException

from app.config import get_settings

log = logging.getLogger(__name__)


@dataclass(frozen=True)
class SupabaseAuthUser:
    id: UUID
    email: str
    phone: str
    email_confirmed_at: datetime | None
    user_metadata: dict[str, Any]


@dataclass(frozen=True)
class SupabaseAuthSession:
    access_token: str
    refresh_token: str
    user: SupabaseAuthUser


class SupabaseAuthService:
    def __init__(self) -> None:
        self._settings = get_settings()

    @property
    def is_configured(self) -> bool:
        return bool(self._settings.supabase_url and self._settings.supabase_anon_key)

    def sign_in_with_password(self, email: str, password: str) -> SupabaseAuthSession:
        if not self.is_configured:
            raise HTTPException(status_code=503, detail="Supabase auth is not configured.")

        payload = {"email": email.strip().lower(), "password": password}
        data = self._post_auth("/token?grant_type=password", payload)
        self._raise_auth_error(data, default_message="Invalid email or password.")
        return self._session_from_payload(data)

    def sign_up(
        self,
        email: str,
        password: str,
        *,
        name: str = "",
        phone: str | None = None,
    ) -> SupabaseAuthSession:
        if not self.is_configured:
            raise HTTPException(status_code=503, detail="Supabase auth is not configured.")

        metadata: dict[str, Any] = {}
        if name.strip():
            metadata["name"] = name.strip()
        if phone and phone.strip():
            metadata["phone"] = phone.strip()

        payload: dict[str, Any] = {
            "email": email.strip().lower(),
            "password": password,
        }
        if metadata:
            payload["data"] = metadata

        data = self._post_auth("/signup", payload)
        self._raise_auth_error(data, default_message="Registration failed.")
        return self._session_from_payload(data)

    def verify_token_get_user_id(self, token: str) -> UUID:
        claims = self._decode_token(token)
        sub = claims.get("sub")
        if not sub:
            raise HTTPException(status_code=401, detail="Invalid auth token.")
        try:
            return UUID(str(sub))
        except ValueError as exc:
            raise HTTPException(status_code=401, detail="Invalid auth token.") from exc

    def get_user_from_token(self, token: str) -> SupabaseAuthUser:
        claims = self._decode_token(token)
        user_id = claims.get("sub")
        if not user_id:
            raise HTTPException(status_code=401, detail="Invalid auth token.")

        metadata = claims.get("user_metadata") or {}
        if not isinstance(metadata, dict):
            metadata = {}

        email_confirmed_at = None
        if claims.get("email_confirmed_at"):
            try:
                email_confirmed_at = datetime.fromisoformat(
                    str(claims["email_confirmed_at"]).replace("Z", "+00:00")
                )
            except ValueError:
                email_confirmed_at = None

        return SupabaseAuthUser(
            id=UUID(str(user_id)),
            email=str(claims.get("email") or ""),
            phone=str(claims.get("phone") or metadata.get("phone") or ""),
            email_confirmed_at=email_confirmed_at,
            user_metadata=metadata,
        )

    def _decode_token(self, token: str) -> dict[str, Any]:
        secret = self._settings.supabase_jwt_secret
        if not secret:
            raise HTTPException(status_code=503, detail="Supabase JWT secret is not configured.")

        try:
            return jwt.decode(
                token,
                secret,
                algorithms=["HS256"],
                audience="authenticated",
                options={"verify_aud": True},
            )
        except jwt.ExpiredSignatureError as exc:
            raise HTTPException(status_code=401, detail="Session expired. Please login again.") from exc
        except jwt.InvalidTokenError as exc:
            raise HTTPException(status_code=401, detail="Invalid auth token.") from exc

    def _raise_auth_error(self, data: dict[str, Any], *, default_message: str) -> None:
        message = (
            data.get("error_description")
            or data.get("msg")
            or data.get("message")
            or (str(data.get("error")) if data.get("error") else None)
        )
        error_code = str(data.get("error_code") or data.get("code") or "").lower()

        if not message and not error_code:
            return

        message = message or default_message
        status = 401
        if "already" in message.lower() or error_code in {"user_already_exists", "email_exists"}:
            status = 409
        elif error_code in {"validation_failed", "weak_password"}:
            status = 400

        raise HTTPException(status_code=status, detail=message)

    def _post_auth(self, path: str, payload: dict[str, Any]) -> dict[str, Any]:
        url = f"{self._settings.supabase_url.rstrip('/')}/auth/v1{path}"
        headers = {
            "apikey": self._settings.supabase_anon_key,
            "Content-Type": "application/json",
        }
        try:
            with httpx.Client(timeout=20.0) as client:
                response = client.post(url, json=payload, headers=headers)
        except httpx.HTTPError as exc:
            log.exception("Supabase auth request failed")
            raise HTTPException(status_code=502, detail="Authentication service unavailable.") from exc

        try:
            return response.json()
        except ValueError as exc:
            raise HTTPException(status_code=502, detail="Invalid auth service response.") from exc

    def _session_from_payload(self, data: dict[str, Any]) -> SupabaseAuthSession:
        access_token = str(data.get("access_token") or "")
        refresh_token = str(data.get("refresh_token") or "")
        user_raw = data.get("user") or {}

        if not access_token or not user_raw.get("id"):
            raise HTTPException(status_code=502, detail="Authentication response incomplete.")

        metadata = user_raw.get("user_metadata") or {}
        if not isinstance(metadata, dict):
            metadata = {}

        email_confirmed_at = None
        confirmed_raw = user_raw.get("email_confirmed_at")
        if confirmed_raw:
            try:
                email_confirmed_at = datetime.fromisoformat(str(confirmed_raw).replace("Z", "+00:00"))
            except ValueError:
                email_confirmed_at = None

        user = SupabaseAuthUser(
            id=UUID(str(user_raw["id"])),
            email=str(user_raw.get("email") or ""),
            phone=str(user_raw.get("phone") or metadata.get("phone") or ""),
            email_confirmed_at=email_confirmed_at,
            user_metadata=metadata,
        )
        return SupabaseAuthSession(
            access_token=access_token,
            refresh_token=refresh_token,
            user=user,
        )
