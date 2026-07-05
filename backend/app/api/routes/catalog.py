"""Catalog — banners, categories, products."""

from __future__ import annotations

from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session

from app.api.deps import get_db
from app.schemas import BannerOut, CategoryOut, ProductOut, ReviewOut
from app.services.catalog_service import CatalogService

router = APIRouter(tags=["catalog"])


@router.get("/banners", response_model=list[BannerOut])
def list_banners(db: Session = Depends(get_db)) -> list[BannerOut]:
    return CatalogService(db).banners()


@router.get("/categories", response_model=list[CategoryOut])
def list_categories(db: Session = Depends(get_db)) -> list[CategoryOut]:
    return CatalogService(db).categories()


@router.get("/products", response_model=list[ProductOut])
def list_products(
    category_id: UUID | None = None,
    category: str | None = None,
    limit: int = Query(default=50, le=100),
    offset: int = Query(default=0, ge=0),
    db: Session = Depends(get_db),
) -> list[ProductOut]:
    return CatalogService(db).products(
        category_id=category_id,
        category_slug=category,
        limit=limit,
        offset=offset,
    )


@router.get("/products/featured", response_model=list[ProductOut])
def featured_products(db: Session = Depends(get_db)) -> list[ProductOut]:
    return CatalogService(db).products(featured=True)


@router.get("/products/popular", response_model=list[ProductOut])
def popular_products(db: Session = Depends(get_db)) -> list[ProductOut]:
    return CatalogService(db).products(popular=True)


@router.get("/products/new-arrivals", response_model=list[ProductOut])
def new_arrivals(db: Session = Depends(get_db)) -> list[ProductOut]:
    return CatalogService(db).products(new_arrivals=True)


@router.get("/products/search", response_model=list[ProductOut])
def search_products(q: str = Query(min_length=1), db: Session = Depends(get_db)) -> list[ProductOut]:
    return CatalogService(db).products(q=q)


@router.get("/products/reviews/{product_id}", response_model=list[ReviewOut])
def product_reviews(product_id: UUID, db: Session = Depends(get_db)) -> list[ReviewOut]:
    return CatalogService(db).reviews(product_id)


@router.get("/products/{product_id}", response_model=ProductOut)
def product_detail(product_id: UUID, db: Session = Depends(get_db)) -> ProductOut:
    product = CatalogService(db).product_detail(product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return product

