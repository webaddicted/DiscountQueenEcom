"""Payment webhooks — Razorpay stub."""

from __future__ import annotations

from fastapi import APIRouter, Request

router = APIRouter(prefix="/webhooks", tags=["webhooks"])


@router.post("/razorpay")
async def razorpay_webhook(request: Request) -> dict[str, str]:
    _ = await request.body()
    return {"status": "received"}
