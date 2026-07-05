"""Tests for Discount Queen API."""

from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_health_root() -> None:
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "UP"
    assert data["service"] == "discount-queen-backend"


def test_health_api_v1() -> None:
    response = client.get("/api/v1/health")
    assert response.status_code == 200
    assert response.json()["status"] == "UP"


def test_auth_login_stub() -> None:
    response = client.post(
        "/api/v1/auth/login",
        json={"email": "test@example.com", "password": "secret"},
    )
    assert response.status_code == 200
    assert response.json()["success"] is True
