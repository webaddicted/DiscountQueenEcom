"""Tests for Discount Queen API."""

from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def _data(response) -> object:
    body = response.json()
    assert "success" in body
    assert "message" in body
    assert "data" in body
    return body["data"]


def test_health_root() -> None:
    response = client.get("/health")
    assert response.status_code == 200
    body = response.json()
    assert body["success"] is True
    data = body["data"]
    assert data["status"] == "UP"
    assert data["service"] == "discount-queen-backend"


def test_health_api_v1() -> None:
    response = client.get("/api/v1/health")
    assert response.status_code == 200
    assert response.json()["success"] is True
    assert _data(response)["status"] == "UP"


def test_auth_login_user_not_found() -> None:
    response = client.post(
        "/api/v1/auth/login",
        json={"email": "unknown-user@example.com", "password": "secret"},
    )
    assert response.status_code == 401
    body = response.json()
    assert body["success"] is False
    assert body["data"] == {}
    assert body["message"]


def test_envelope_failure_on_missing_user_header() -> None:
    response = client.get("/api/v1/cart")
    assert response.status_code == 401
    body = response.json()
    assert body["success"] is False
    assert body["data"] == {}
    assert body["message"]
