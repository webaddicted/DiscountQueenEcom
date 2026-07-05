"""Auth stubs — Supabase Auth on client; backend uses X-User-Id."""

from __future__ import annotations

from fastapi import APIRouter

from app.schemas import AuthLoginIn, AuthRegisterIn, MessageOut

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/login", response_model=MessageOut)
def login(_: AuthLoginIn) -> MessageOut:
    return MessageOut(
        message="Use Supabase Auth on client; pass user UUID via X-User-Id header",
        success=True,
    )


@router.post("/register", response_model=MessageOut)
def register(data: AuthRegisterIn) -> MessageOut:
    return MessageOut(
        message=f"Register {data.email} via Supabase Auth; then pass user UUID via X-User-Id",
        success=True,
    )


@router.post("/logout", response_model=MessageOut)
def logout() -> MessageOut:
    return MessageOut(message="Logged out", success=True)
