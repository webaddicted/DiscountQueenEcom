"""Catalog API tests — require DATABASE_URL or SUPABASE_DB_PASSWORD."""

import os

import pytest
from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)

requires_db = pytest.mark.skipif(
    not os.getenv("DATABASE_URL") and not os.getenv("SUPABASE_DB_PASSWORD"),
    reason="Database credentials not configured",
)


@requires_db
def test_list_banners() -> None:
    response = client.get("/api/v1/banners")
    assert response.status_code == 200
    assert isinstance(response.json(), list)


@requires_db
def test_list_categories() -> None:
    response = client.get("/api/v1/categories")
    assert response.status_code == 200
    assert isinstance(response.json(), list)
