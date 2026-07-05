"""Wrap all JSON API responses in { message, success, data }."""

from __future__ import annotations

import json
from typing import Any

from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import JSONResponse, Response


def envelope_success(data: Any, message: str = "") -> dict[str, Any]:
    return {"message": message, "success": True, "data": _as_data_object(data)}


def envelope_failure(message: str, data: Any = None) -> dict[str, Any]:
    return {"message": message, "success": False, "data": _as_data_object({})}


def _as_data_object(data: Any) -> dict[str, Any]:
    """Ensure envelope `data` is always a JSON object."""
    if isinstance(data, dict):
        return data
    if isinstance(data, list):
        return {"items": data}
    if data is None or isinstance(data, bool):
        return {}
    return {"value": data}


def wrap_payload(payload: Any, status_code: int) -> dict[str, Any]:
    if isinstance(payload, dict) and "success" in payload and "data" in payload:
        msg = str(payload.get("message") or "")
        success = payload.get("success") is True
        data = payload.get("data")
        if success and data is None:
            return envelope_failure(msg or "No data returned")
        if not success:
            return envelope_failure(msg or "Request failed")
        return {"message": msg, "success": True, "data": _as_data_object(data)}

    if status_code >= 400:
        return envelope_failure(_extract_error_message(payload))

    if isinstance(payload, dict) and "success" in payload and "message" in payload:
        msg = str(payload.get("message") or "")
        ok = payload.get("success") is True
        if ok:
            return envelope_success({}, msg)
        return envelope_failure(msg or "Request failed")

    return envelope_success(payload)


def _extract_error_message(payload: Any) -> str:
    if isinstance(payload, dict):
        detail = payload.get("detail")
        if isinstance(detail, str) and detail.strip():
            return detail
        if isinstance(detail, list) and detail:
            first = detail[0]
            if isinstance(first, dict):
                return str(first.get("msg") or first.get("message") or "Request failed")
            return str(first)
        for key in ("message", "error", "msg"):
            val = payload.get(key)
            if isinstance(val, str) and val.strip():
                return val
    if isinstance(payload, str) and payload.strip():
        return payload
    return "Request failed"


_SKIP_PREFIXES = ("/docs", "/redoc", "/openapi.json")


class EnvelopeMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        if request.method == "OPTIONS":
            return await call_next(request)

        response = await call_next(request)
        path = request.url.path
        if any(path.startswith(prefix) for prefix in _SKIP_PREFIXES):
            return response

        content_type = response.headers.get("content-type", "")
        if "application/json" not in content_type:
            return response

        body = b""
        async for chunk in response.body_iterator:
            body += chunk

        try:
            payload = json.loads(body) if body else None
        except json.JSONDecodeError:
            return Response(
                content=body,
                status_code=response.status_code,
                headers=dict(response.headers),
                media_type="application/json",
            )

        wrapped = wrap_payload(payload, response.status_code)
        headers = {
            key: value
            for key, value in response.headers.items()
            if key.lower() not in {"content-length", "content-type"}
        }
        return JSONResponse(content=wrapped, status_code=response.status_code, headers=headers)
