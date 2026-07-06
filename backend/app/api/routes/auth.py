"""Auth — login, register, availability check, OTP verification."""

from __future__ import annotations

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.api.deps import get_db
from app.schemas import (
    AuthAvailabilityIn,
    AuthAvailabilityOut,
    AuthLoginIn,
    AuthRegisterIn,
    AuthResendOtpIn,
    AuthVerifyOtpIn,
    MessageOut,
    ProfileOut,
    RegisterPendingOut,
)
from app.services.auth_service import AuthService

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/check-availability", response_model=AuthAvailabilityOut)
def check_availability(data: AuthAvailabilityIn, db: Session = Depends(get_db)) -> AuthAvailabilityOut:
    return AuthService(db).check_availability(data)


@router.post("/login", response_model=ProfileOut)
def login(data: AuthLoginIn, db: Session = Depends(get_db)) -> ProfileOut:
    return AuthService(db).login(data)


@router.post("/register", response_model=RegisterPendingOut)
def register(data: AuthRegisterIn, db: Session = Depends(get_db)) -> RegisterPendingOut:
    return AuthService(db).register(data)


@router.post("/send-otp", response_model=MessageOut)
def send_otp(data: AuthResendOtpIn, db: Session = Depends(get_db)) -> MessageOut:
    return AuthService(db).send_otp(data.email)


@router.post("/verify-otp", response_model=MessageOut)
def verify_otp(data: AuthVerifyOtpIn, db: Session = Depends(get_db)) -> MessageOut:
    return AuthService(db).verify_otp(data)


@router.post("/logout", response_model=MessageOut)
def logout() -> MessageOut:
    return MessageOut(message="Logged out", success=True)
