"""User profile and addresses."""

from __future__ import annotations

from uuid import UUID

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.db.models import EcomAddress, EcomUserProfile
from app.schemas import AddressIn, AddressOut, ProfileOut, ProfileUpdateIn


class UserService:
    def __init__(self, db: Session):
        self.db = db

    def get_or_create_profile(self, user_id: UUID, email: str = "", name: str = "") -> EcomUserProfile:
        profile = self.db.scalar(select(EcomUserProfile).where(EcomUserProfile.user_id == user_id))
        if profile:
            return profile
        profile = EcomUserProfile(
            user_id=user_id,
            name=name or email.split("@")[0],
            referral_code=f"REF{str(user_id)[:8].upper()}",
        )
        self.db.add(profile)
        self.db.commit()
        self.db.refresh(profile)
        return profile

    def profile_out(self, user_id: UUID, email: str = "") -> ProfileOut:
        p = self.get_or_create_profile(user_id, email=email)
        return ProfileOut(
            id=p.user_id,
            name=p.name or "",
            email=email,
            phone=p.phone or "",
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
