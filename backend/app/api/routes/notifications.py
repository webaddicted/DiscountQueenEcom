"""User notifications."""

from __future__ import annotations

from uuid import UUID

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_user_id
from app.db.models import EcomUserNotification
from app.schemas import MessageOut
from pydantic import BaseModel, ConfigDict
from pydantic.alias_generators import to_camel

router = APIRouter(tags=["notifications"])


class NotificationOut(BaseModel):
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True, serialize_by_alias=True)

    id: UUID
    title: str
    body: str = ""
    notification_type: str = "system"
    is_read: bool = False
    created_at: str = ""


@router.get("/notifications", response_model=list[NotificationOut])
def list_notifications(
    user_id: UUID = Depends(get_user_id),
    db: Session = Depends(get_db),
) -> list[NotificationOut]:
    rows = db.scalars(
        select(EcomUserNotification)
        .where(EcomUserNotification.user_id == user_id)
        .order_by(EcomUserNotification.created_at.desc())
    ).all()
    return [
        NotificationOut(
            id=r.id,
            title=r.title,
            body=r.body or "",
            notification_type=r.notification_type,
            is_read=r.is_read,
            created_at=r.created_at.isoformat() if r.created_at else "",
        )
        for r in rows
    ]


@router.post("/notifications/read", response_model=MessageOut)
def mark_read(
    notification_id: UUID,
    user_id: UUID = Depends(get_user_id),
    db: Session = Depends(get_db),
) -> MessageOut:
    row = db.scalar(
        select(EcomUserNotification).where(
            EcomUserNotification.id == notification_id,
            EcomUserNotification.user_id == user_id,
        )
    )
    if row:
        row.is_read = True
        db.commit()
    return MessageOut(message="Marked read", success=True)
