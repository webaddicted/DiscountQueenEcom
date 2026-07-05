"""FastAPI application entry point."""

from __future__ import annotations

import logging

from fastapi import APIRouter, FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.api.routes import admin, auth, cart, catalog, health, notifications, orders, reviews, user, webhooks, wishlist
from app.config import get_settings

logging.basicConfig(level=logging.INFO)
log = logging.getLogger(__name__)


def create_app() -> FastAPI:
    settings = get_settings()
    app = FastAPI(
        title="Discount Queen API",
        version="1.0.0",
        description="Queen Ecom backend — Supabase + FastAPI",
    )

    origins = settings.cors_origin_list
    app.add_middleware(
        CORSMiddleware,
        allow_origins=origins if "*" not in origins else ["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    @app.exception_handler(ValueError)
    async def value_error_handler(_: Request, exc: ValueError) -> JSONResponse:
        return JSONResponse(status_code=400, content={"error": str(exc)})

    api_v1 = APIRouter(prefix="/api/v1")
    api_v1.include_router(health.router)
    api_v1.include_router(auth.router)
    api_v1.include_router(catalog.router)
    api_v1.include_router(user.router)
    api_v1.include_router(cart.router)
    api_v1.include_router(wishlist.router)
    api_v1.include_router(orders.router)
    api_v1.include_router(reviews.router)
    api_v1.include_router(notifications.router)
    api_v1.include_router(admin.router)
    api_v1.include_router(webhooks.router)
    app.include_router(api_v1)
    app.include_router(health.router)
    return app


app = create_app()
