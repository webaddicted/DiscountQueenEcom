"""Reviews."""

from __future__ import annotations

from uuid import UUID

from fastapi import APIRouter, Depends, Query
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_user_id
from app.db.models import EcomReview, EcomUserProfile
from app.schemas import ReviewIn, ReviewOut
from app.services.catalog_service import CatalogService

router = APIRouter(tags=["reviews"])


@router.get("/reviews", response_model=list[ReviewOut])
def list_reviews(
    product_id: UUID | None = Query(default=None),
    db: Session = Depends(get_db),
) -> list[ReviewOut]:
    if product_id:
        return CatalogService(db).reviews(product_id)
    rows = db.scalars(select(EcomReview).order_by(EcomReview.created_at.desc()).limit(50)).all()
    out: list[ReviewOut] = []
    for r in rows:
        profile = db.scalar(select(EcomUserProfile).where(EcomUserProfile.user_id == r.user_id))
        out.append(
            ReviewOut(
                id=r.id,
                user_id=r.user_id,
                user_name=profile.name if profile else "",
                user_avatar=profile.photo_url if profile and profile.photo_url else "",
                product_id=r.product_id,
                rating=float(r.rating),
                comment=r.comment or "",
                images=list(r.images or []),
                created_at=r.created_at.isoformat() if r.created_at else "",
            )
        )
    return out


@router.post("/reviews/add", response_model=ReviewOut)
def add_review(
    data: ReviewIn,
    user_id: UUID = Depends(get_user_id),
    db: Session = Depends(get_db),
) -> ReviewOut:
    return CatalogService(db).add_review(
        user_id, data.product_id, data.rating, data.comment, data.images
    )
