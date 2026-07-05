"""FastAPI application entry point."""

from __future__ import annotations

import logging

from fastapi import APIRouter, FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from sqlalchemy.exc import SQLAlchemyError

from app.api.routes import admin, auth, cart, catalog, health, notifications, orders, reviews, user, webhooks, wishlist
from app.config import get_settings
from app.middleware.envelope import envelope_failure

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
    use_wildcard = "*" in origins

    from app.middleware.envelope import EnvelopeMiddleware

    app.add_middleware(EnvelopeMiddleware)

    if use_wildcard:
        # Flutter web runs on random localhost ports — regex avoids credentials+* conflict.
        app.add_middleware(
            CORSMiddleware,
            allow_origin_regex=r"https?://(localhost|127\.0\.0\.1)(:\d+)?",
            allow_credentials=True,
            allow_methods=["*"],
            allow_headers=["*"],
            expose_headers=["*"],
        )
    else:
        app.add_middleware(
            CORSMiddleware,
            allow_origins=origins,
            allow_credentials=True,
            allow_methods=["*"],
            allow_headers=["*"],
            expose_headers=["*"],
        )

    @app.exception_handler(SQLAlchemyError)
    async def database_exception_handler(_: Request, exc: SQLAlchemyError) -> JSONResponse:
        log.exception("Database error")
        return JSONResponse(status_code=500, content=envelope_failure("Database error. Please try again later"))

    @app.exception_handler(Exception)
    async def unhandled_exception_handler(request: Request, exc: Exception) -> JSONResponse:
        if isinstance(exc, HTTPException):
            raise exc
        log.exception("Unhandled error on %s", request.url.path)
        return JSONResponse(status_code=500, content=envelope_failure("Internal server error"))

    @app.exception_handler(ValueError)
    async def value_error_handler(_: Request, exc: ValueError) -> JSONResponse:
        return JSONResponse(status_code=400, content=envelope_failure(str(exc)))

    @app.exception_handler(HTTPException)
    async def http_exception_handler(_: Request, exc: HTTPException) -> JSONResponse:
        detail = exc.detail
        message = detail if isinstance(detail, str) else str(detail)
        return JSONResponse(status_code=exc.status_code, content=envelope_failure(message))

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
