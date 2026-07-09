"""Authentication — login, register, availability check, OTP."""

from __future__ import annotations

import logging
from datetime import datetime, timedelta, timezone
from uuid import UUID, uuid4

from fastapi import HTTPException
from sqlalchemy import func, select
from sqlalchemy.exc import ProgrammingError
from sqlalchemy.orm import Session

from app.config import get_settings
from app.db.models import EcomAuthAccount, EcomOtpVerification, EcomUserProfile
from app.schemas import (
    AuthAvailabilityIn,
    AuthAvailabilityOut,
    AuthLoginIn,
    AuthRegisterIn,
    AuthVerifyOtpIn,
    MessageOut,
    ProfileOut,
    RegisterPendingOut,
)
from app.services.password_service import hash_password, verify_password
from app.services.supabase_auth_service import SupabaseAuthService
from app.services.user_service import UserService

log = logging.getLogger(__name__)

_DEMO_USERS: dict[str, tuple[str, str, bool]] = {
    "aisha@example.com": ("10000001-0001-4001-8001-000000000001", "Pass@123", False),
    "admin@discountqueen.com": ("10000001-0001-4001-8001-000000000002", "Admin@123", True),
    "admin@kdebug.com": ("10000001-0001-4001-8001-000000000002", "Admin@123", True),
}


class AuthService:
    def __init__(self, db: Session):
        self.db = db
        self._users = UserService(db)
        self._supabase = SupabaseAuthService()

    def check_availability(self, data: AuthAvailabilityIn) -> AuthAvailabilityOut:
        email = data.email.strip().lower()
        phone = (data.phone or "").strip() or None

        email_taken = self._email_exists(email)
        phone_taken = bool(phone and self._phone_exists(phone))

        return AuthAvailabilityOut(
            email_available=not email_taken,
            phone_available=not phone_taken,
        )

    def login(self, data: AuthLoginIn) -> ProfileOut:
        email = data.email.strip().lower()

        if self._supabase.is_configured:
            return self._login_with_supabase(email, data.password)

        return self._login_with_local_accounts(email, data.password)

    def register(self, data: AuthRegisterIn) -> RegisterPendingOut:
        email = data.email.strip().lower()
        phone = (data.phone or "").strip() or None

        if self._supabase.is_configured:
            session = self._supabase.sign_up(
                email,
                data.password,
                name=data.name.strip(),
                phone=phone,
            )
            profile = self._users.sync_from_supabase_user(
                session.user,
                name=data.name.strip(),
                phone=phone,
            )
            self._upsert_local_account(
                user_id=session.user.id,
                email=email,
                phone=phone,
                password=data.password,
                is_verified=session.user.email_confirmed_at is not None,
            )
            if profile.is_blocked:
                raise HTTPException(status_code=403, detail="Your account has been blocked.")

            if session.user.email_confirmed_at is None:
                return RegisterPendingOut(
                    email=email,
                    message="OTP generated. Please verify to continue.",
                )

            return RegisterPendingOut(
                email=email,
                message="Registration successful. Please login.",
            )

        if self._email_exists(email):
            raise HTTPException(status_code=409, detail="User already exists with this email.")

        if phone and self._phone_exists(phone):
            raise HTTPException(status_code=409, detail="This phone number is already registered.")

        return self._register_local(data, email=email, phone=phone)

    def send_otp(self, email: str) -> MessageOut:
        normalized = email.strip().lower()
        account = self._get_account_by_email(normalized)
        if account is None:
            raise HTTPException(status_code=404, detail="User not found.")
        if account.is_verified:
            raise HTTPException(status_code=400, detail="Email is already verified. Please login.")

        self._create_and_send_otp(normalized)
        return MessageOut(message="OTP generated.", success=True)

    def verify_otp(self, data: AuthVerifyOtpIn) -> MessageOut:
        email = data.email.strip().lower()
        otp = data.otp.strip()

        row = self.db.scalar(
            select(EcomOtpVerification)
            .where(
                func.lower(EcomOtpVerification.email) == email,
                EcomOtpVerification.is_used.is_(False),
            )
            .order_by(EcomOtpVerification.created_at.desc())
        )
        if row is None:
            raise HTTPException(status_code=400, detail="OTP not found. Please request a new one.")

        if row.expires_at < datetime.now(timezone.utc):
            raise HTTPException(status_code=400, detail="OTP has expired. Please request a new one.")

        if row.otp_code != otp:
            raise HTTPException(status_code=400, detail="Invalid OTP. Please try again.")

        account = self._get_account_by_email(email)
        if account is None:
            raise HTTPException(status_code=404, detail="User not found.")

        row.is_used = True
        account.is_verified = True

        profile = self.db.scalar(
            select(EcomUserProfile).where(EcomUserProfile.user_id == account.user_id)
        )
        if profile:
            profile.is_email_verified = True

        self.db.commit()
        return MessageOut(message="Email verified successfully. Please login.", success=True)

    def _login_with_supabase(self, email: str, password: str) -> ProfileOut:
        try:
            session = self._supabase.sign_in_with_password(email, password)
        except HTTPException as exc:
            if exc.status_code == 401:
                return self._login_with_local_accounts(email, password)
            raise

        profile = self._users.sync_from_supabase_user(session.user)
        if profile.is_blocked:
            raise HTTPException(status_code=403, detail="Your account has been blocked.")

        out = self._users.profile_out(
            session.user.id,
            email=session.user.email or email,
            phone=session.user.phone or profile.phone or "",
        )
        return out.model_copy(
            update={
                "access_token": session.access_token,
                "refresh_token": session.refresh_token,
            }
        )

    def _login_with_local_accounts(self, email: str, password: str) -> ProfileOut:
        account = self._get_account_by_email(email)

        if account is None:
            self._ensure_demo_user(email)
            account = self._get_account_by_email(email)

        if account is None:
            raise HTTPException(status_code=401, detail="User not found. Please register first.")

        if not verify_password(password, account.password_hash):
            raise HTTPException(status_code=401, detail="Invalid email or password.")

        if not account.is_verified:
            raise HTTPException(status_code=403, detail="Please verify your email with OTP before logging in.")

        profile = self.db.scalar(
            select(EcomUserProfile).where(EcomUserProfile.user_id == account.user_id)
        )
        if profile and profile.is_blocked:
            raise HTTPException(status_code=403, detail="Your account has been blocked.")

        return self._users.profile_out(account.user_id, email=account.email, phone=account.phone or "")

    def _register_local(
        self,
        data: AuthRegisterIn,
        *,
        email: str,
        phone: str | None,
    ) -> RegisterPendingOut:
        user_id = uuid4()
        account = EcomAuthAccount(
            user_id=user_id,
            email=email,
            phone=phone,
            password_hash=hash_password(data.password),
            is_verified=False,
        )
        self.db.add(account)

        profile = EcomUserProfile(
            user_id=user_id,
            name=data.name.strip(),
            phone=phone,
            referral_code=f"REF{str(user_id)[:8].upper()}",
            is_email_verified=False,
        )
        self.db.add(profile)
        self.db.commit()

        self._create_and_send_otp(email)

        return RegisterPendingOut(email=email, message="OTP generated. Please verify to continue.")

    def _upsert_local_account(
        self,
        *,
        user_id: UUID,
        email: str,
        phone: str | None,
        password: str,
        is_verified: bool,
    ) -> None:
        account = self._get_account_by_email(email)
        if account is None:
            account = EcomAuthAccount(
                user_id=user_id,
                email=email,
                phone=phone,
                password_hash=hash_password(password),
                is_verified=is_verified,
            )
            self.db.add(account)
        else:
            account.user_id = user_id
            account.phone = phone
            account.password_hash = hash_password(password)
            account.is_verified = is_verified
        self.db.commit()

    def _create_and_send_otp(self, email: str) -> None:
        otp = get_settings().dev_otp
        row = EcomOtpVerification(
            email=email,
            otp_code=otp,
            expires_at=datetime.now(timezone.utc)
            + timedelta(minutes=get_settings().otp_expiry_minutes),
        )
        self.db.add(row)
        self.db.commit()
        log.info("[OTP] email=%s otp=%s", email, otp)

    def _get_account_by_email(self, email: str) -> EcomAuthAccount | None:
        try:
            return self.db.scalar(
                select(EcomAuthAccount).where(
                    func.lower(EcomAuthAccount.email) == email.strip().lower()
                )
            )
        except ProgrammingError:
            self.db.rollback()
            log.warning("ecom_auth_accounts table unavailable; skipping local auth lookup")
            return None

    def _email_exists(self, email: str) -> bool:
        return self._get_account_by_email(email) is not None

    def _phone_exists(self, phone: str) -> bool:
        try:
            return self.db.scalar(
                select(EcomAuthAccount.id).where(EcomAuthAccount.phone == phone.strip())
            ) is not None
        except ProgrammingError:
            self.db.rollback()
            return False

    def _ensure_demo_user(self, email: str) -> None:
        demo = _DEMO_USERS.get(email.strip().lower())
        if demo is None:
            return
        user_id = UUID(demo[0])
        password = demo[1]
        is_admin = demo[2]

        if self._get_account_by_email(email) is not None:
            return

        account = EcomAuthAccount(
            user_id=user_id,
            email=email.strip().lower(),
            password_hash=hash_password(password),
            is_verified=True,
        )
        self.db.add(account)

        profile = self.db.scalar(select(EcomUserProfile).where(EcomUserProfile.user_id == user_id))
        if profile is None:
            profile = EcomUserProfile(
                user_id=user_id,
                name=email.split("@")[0].capitalize(),
                is_admin=is_admin,
                is_email_verified=True,
                referral_code=f"REF{str(user_id)[:8].upper()}",
            )
            self.db.add(profile)
        else:
            profile.is_admin = is_admin
            profile.is_email_verified = True

        self.db.commit()
