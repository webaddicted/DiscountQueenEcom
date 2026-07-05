"""Catalog queries — products, categories, banners."""

from __future__ import annotations

from decimal import Decimal
from uuid import UUID

from sqlalchemy import or_, select
from sqlalchemy.orm import Session, joinedload

from app.db.models import (
    EcomBanner,
    EcomBrand,
    EcomCategory,
    EcomProduct,
    EcomProductImage,
    EcomProductSpec,
    EcomProductVariant,
    EcomReview,
    EcomUserProfile,
)
from app.schemas import BannerOut, CategoryOut, ProductOut, ReviewOut


class CatalogService:
    def __init__(self, db: Session):
        self.db = db

    def banners(self) -> list[BannerOut]:
        rows = self.db.scalars(
            select(EcomBanner).where(EcomBanner.is_active).order_by(EcomBanner.sort_order)
        ).all()
        return [BannerOut.model_validate(r) for r in rows]

    def categories(self) -> list[CategoryOut]:
        rows = self.db.scalars(
            select(EcomCategory).where(EcomCategory.is_active).order_by(EcomCategory.sort_order)
        ).all()
        return [CategoryOut.model_validate(r) for r in rows]

    def _product_query(self):
        return (
            select(EcomProduct)
            .where(EcomProduct.is_active, EcomProduct.is_deleted.is_(False))
            .options(
                joinedload(EcomProduct.images),
                joinedload(EcomProduct.variants),
                joinedload(EcomProduct.specs),
            )
        )

    def _to_product_out(self, p: EcomProduct) -> ProductOut:
        cat_name = ""
        if p.category_id:
            cat = self.db.get(EcomCategory, p.category_id)
            cat_name = cat.name if cat else ""
        brand_name = ""
        if p.brand_id:
            brand = self.db.get(EcomBrand, p.brand_id)
            brand_name = brand.name if brand else ""

        images = [img.image_url for img in sorted(p.images, key=lambda x: x.sort_order)]
        thumbnail = p.thumbnail_url or (images[0] if images else "")
        sizes = sorted({v.size for v in p.variants if v.is_active and v.size})
        colors = sorted({v.color for v in p.variants if v.is_active and v.color})
        specs = {s.spec_key: s.spec_value for s in sorted(p.specs, key=lambda x: x.sort_order)}

        return ProductOut(
            id=p.id,
            name=p.name,
            description=p.description or "",
            short_description=p.short_description or "",
            price=float(p.price),
            mrp=float(p.mrp),
            discount_percent=p.discount_percent,
            images=images,
            thumbnail=thumbnail,
            category_id=p.category_id,
            category_name=cat_name,
            brand=brand_name,
            rating=float(p.rating_avg),
            review_count=p.review_count,
            in_stock=p.stock_qty > 0,
            stock_qty=p.stock_qty,
            sizes=sizes,
            colors=colors,
            tags=list(p.tags or []),
            specifications=specs,
            is_featured=p.is_featured,
            is_popular=p.is_popular,
            is_new_arrival=p.is_new_arrival,
            created_at=p.created_at.isoformat() if p.created_at else "",
        )

    def products(
        self,
        *,
        featured: bool | None = None,
        popular: bool | None = None,
        new_arrivals: bool | None = None,
        category_id: UUID | None = None,
        category_slug: str | None = None,
        q: str | None = None,
        limit: int = 50,
        offset: int = 0,
    ) -> list[ProductOut]:
        stmt = self._product_query()
        if featured:
            stmt = stmt.where(EcomProduct.is_featured.is_(True))
        if popular:
            stmt = stmt.where(EcomProduct.is_popular.is_(True))
        if new_arrivals:
            stmt = stmt.where(EcomProduct.is_new_arrival.is_(True))
        if category_id:
            stmt = stmt.where(EcomProduct.category_id == category_id)
        if category_slug:
            cat = self.db.scalar(select(EcomCategory).where(EcomCategory.slug == category_slug))
            if cat:
                stmt = stmt.where(EcomProduct.category_id == cat.id)
        if q:
            like = f"%{q}%"
            stmt = stmt.where(or_(EcomProduct.name.ilike(like), EcomProduct.description.ilike(like)))
        stmt = stmt.order_by(EcomProduct.created_at.desc()).limit(limit).offset(offset)
        rows = self.db.scalars(stmt).unique().all()
        return [self._to_product_out(p) for p in rows]

    def product_detail(self, product_id: UUID) -> ProductOut | None:
        p = self.db.scalar(self._product_query().where(EcomProduct.id == product_id))
        if not p:
            return None
        return self._to_product_out(p)

    def reviews(self, product_id: UUID) -> list[ReviewOut]:
        rows = self.db.scalars(
            select(EcomReview)
            .where(
                EcomReview.product_id == product_id,
                EcomReview.is_visible.is_(True),
                EcomReview.moderation_status == "approved",
            )
            .order_by(EcomReview.created_at.desc())
        ).all()
        out: list[ReviewOut] = []
        for r in rows:
            profile = self.db.scalar(
                select(EcomUserProfile).where(EcomUserProfile.user_id == r.user_id)
            )
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

    def add_review(self, user_id: UUID, product_id: UUID, rating: float, comment: str, images: list[str]) -> ReviewOut:
        existing = self.db.scalar(
            select(EcomReview).where(EcomReview.product_id == product_id, EcomReview.user_id == user_id)
        )
        if existing:
            raise ValueError("You already reviewed this product")
        review = EcomReview(
            product_id=product_id,
            user_id=user_id,
            rating=Decimal(str(rating)),
            comment=comment,
            images=images,
        )
        self.db.add(review)
        self.db.commit()
        self.db.refresh(review)
        profile = self.db.scalar(select(EcomUserProfile).where(EcomUserProfile.user_id == user_id))
        return ReviewOut(
            id=review.id,
            user_id=user_id,
            user_name=profile.name if profile else "",
            user_avatar=profile.photo_url if profile and profile.photo_url else "",
            product_id=product_id,
            rating=float(review.rating),
            comment=review.comment or "",
            images=list(review.images or []),
            created_at=review.created_at.isoformat() if review.created_at else "",
        )
