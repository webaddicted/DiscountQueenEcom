"""User profile and addresses."""

from __future__ import annotations

from datetime import datetime, timezone
from uuid import UUID

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.db.models import EcomAddress, EcomAuthAccount, EcomUserProfile
from app.schemas import AddressIn, AddressOut, ProfileOut, ProfileUpdateIn
from app.services.supabase_auth_service import SupabaseAuthUser


class UserService:
    def __init__(self, db: Session):
        self.db = db

    def get_or_create_profile(self, user_id: UUID, email: str = "", name: str = "") -> EcomUserProfile:
        profile = self.db.scalar(select(EcomUserProfile).where(EcomUserProfile.user_id == user_id))
        if profile:
            return profile
        profile = EcomUserProfile(
            user_id=user_id,
            name=name or (email.split("@")[0] if email else ""),
            referral_code=f"REF{str(user_id)[:8].upper()}",
        )
        self.db.add(profile)
        self.db.commit()
        self.db.refresh(profile)
        return profile

    def sync_from_supabase_user(
        self,
        auth_user: SupabaseAuthUser,
        *,
        name: str = "",
        phone: str | None = None,
    ) -> EcomUserProfile:
        """Upsert ecom_user_profiles from Supabase auth user data."""
        metadata = auth_user.user_metadata or {}
        resolved_name = (
            name.strip()
            or str(metadata.get("name") or metadata.get("full_name") or "").strip()
            or (auth_user.email.split("@")[0] if auth_user.email else "")
        )
        resolved_phone = (phone or auth_user.phone or str(metadata.get("phone") or "")).strip() or None
        photo_url = str(metadata.get("avatar_url") or metadata.get("photo_url") or "").strip() or None
        gender = str(metadata.get("gender") or "").strip() or None

        profile = self.db.scalar(
            select(EcomUserProfile).where(EcomUserProfile.user_id == auth_user.id)
        )
        if profile is None:
            profile = EcomUserProfile(
                user_id=auth_user.id,
                name=resolved_name,
                phone=resolved_phone,
                photo_url=photo_url,
                gender=gender,
                referral_code=f"REF{str(auth_user.id)[:8].upper()}",
                is_email_verified=auth_user.email_confirmed_at is not None,
                last_login_at=datetime.now(timezone.utc),
            )
            self.db.add(profile)
        else:
            if resolved_name:
                profile.name = resolved_name
            if resolved_phone:
                profile.phone = resolved_phone
            if photo_url:
                profile.photo_url = photo_url
            if gender:
                profile.gender = gender
            if auth_user.email_confirmed_at:
                profile.is_email_verified = True
            profile.last_login_at = datetime.now(timezone.utc)

        self.db.commit()
        self.db.refresh(profile)
        return profile

    def profile_out(self, user_id: UUID, email: str = "", phone: str = "") -> ProfileOut:
        p = self.get_or_create_profile(user_id, email=email)
        if not email:
            account = self.db.scalar(
                select(EcomAuthAccount).where(EcomAuthAccount.user_id == user_id)
            )
            if account:
                email = account.email
                if not phone:
                    phone = account.phone or ""
        return ProfileOut(
            id=p.user_id,
            name=p.name or "",
            email=email,
            phone=phone or p.phone or "",
            photo_url=p.photo_url or "",
            gender=p.gender or "",
            date_of_birth=p.date_of_birth.isoformat() if p.date_of_birth else "",
            is_admin=p.is_admin,
            is_blocked=p.is_blocked,
            created_at=p.created_at.isoformat() if p.created_at else "",
        )

    def update_profile(self, user_id: UUID, data: ProfileUpdateIn) -> ProfileOut:
        p = self.get_or_create_profile(user_id)
        if data.name is not None:
            p.name = data.name
        if data.phone is not None:
            p.phone = data.phone
        if data.photo_url is not None:
            p.photo_url = data.photo_url
        if data.gender is not None:
            p.gender = data.gender
        if data.date_of_birth:
            from datetime import date

            p.date_of_birth = date.fromisoformat(data.date_of_birth[:10])
        self.db.commit()
        return self.profile_out(user_id)

    def register_profile(
        self,
        user_id: UUID,
        *,
        name: str,
        email: str,
        phone: str | None = None,
    ) -> ProfileOut:
        p = self.get_or_create_profile(user_id, email=email, name=name)
        if phone:
            p.phone = phone
        self.db.commit()
        self.db.refresh(p)
        return self.profile_out(user_id, email=email)

    def list_addresses(self, user_id: UUID) -> list[AddressOut]:
        rows = self.db.scalars(
            select(EcomAddress).where(EcomAddress.user_id == user_id).order_by(EcomAddress.is_default.desc())
        ).all()
        return [AddressOut.model_validate(r) for r in rows]

    def add_address(self, user_id: UUID, data: AddressIn) -> AddressOut:
        if data.is_default:
            for addr in self.db.scalars(select(EcomAddress).where(EcomAddress.user_id == user_id)):
                addr.is_default = False
        addr = EcomAddress(
            user_id=user_id,
            name=data.name,
            phone=data.phone,
            address_line_1=data.address_line_1,
            address_line_2=data.address_line_2,
            city=data.city,
            state=data.state,
            pincode=data.pincode,
            landmark=data.landmark,
            address_type=data.type,
            is_default=data.is_default,
        )
        self.db.add(addr)
        self.db.commit()
        self.db.refresh(addr)
        return AddressOut.model_validate(addr)

    def update_address(self, user_id: UUID, address_id: UUID, data: AddressIn) -> AddressOut:
        addr = self.db.scalar(
            select(EcomAddress).where(EcomAddress.id == address_id, EcomAddress.user_id == user_id)
        )
        if not addr:
            raise ValueError("Address not found")
        if data.is_default:
            for a in self.db.scalars(select(EcomAddress).where(EcomAddress.user_id == user_id)):
                a.is_default = False
        addr.name = data.name
        addr.phone = data.phone
        addr.address_line_1 = data.address_line_1
        addr.address_line_2 = data.address_line_2
        addr.city = data.city
        addr.state = data.state
        addr.pincode = data.pincode
        addr.landmark = data.landmark
        addr.address_type = data.type
        addr.is_default = data.is_default
        self.db.commit()
        return AddressOut.model_validate(addr)

    def delete_address(self, user_id: UUID, address_id: UUID) -> None:
        addr = self.db.scalar(
            select(EcomAddress).where(EcomAddress.id == address_id, EcomAddress.user_id == user_id)
        )
        if not addr:
            raise ValueError("Address not found")
        self.db.delete(addr)
        self.db.commit()
