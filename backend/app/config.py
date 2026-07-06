"""Runtime configuration."""

from __future__ import annotations

from functools import lru_cache
from urllib.parse import quote_plus, urlparse, urlunparse

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


def jdbc_to_sqlalchemy_url(jdbc_url: str, user: str, password: str) -> str:
    url = jdbc_url.strip()
    if url.startswith("jdbc:"):
        url = url[5:]
    parsed = urlparse(url)
    netloc = parsed.hostname or ""
    if parsed.port:
        netloc = f"{netloc}:{parsed.port}"
    if user:
        creds = quote_plus(user)
        if password:
            creds = f"{creds}:{quote_plus(password)}"
        netloc = f"{creds}@{netloc}"
    path = parsed.path or "/postgres"
    query = parsed.query.replace("prepareThreshold=0", "").strip("&")
    return urlunparse(("postgresql+psycopg2", netloc, path, "", query, "")).rstrip("?")


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    port: int = Field(default=8082, alias="PORT")
    database_url: str | None = Field(default=None, alias="DATABASE_URL")
    supabase_db_url: str = Field(
        default="jdbc:postgresql://localhost:5432/postgres?sslmode=require",
        alias="SUPABASE_DB_URL",
    )
    supabase_db_user: str = Field(default="postgres", alias="SUPABASE_DB_USER")
    supabase_db_password: str = Field(default="", alias="SUPABASE_DB_PASSWORD")
    cors_origins: str = Field(default="*", alias="CORS_ORIGINS")
    free_delivery_threshold: float = Field(default=499.0, alias="FREE_DELIVERY_THRESHOLD")
    delivery_charge: float = Field(default=49.0, alias="DELIVERY_CHARGE")
    razorpay_key_id: str = Field(default="", alias="RAZORPAY_KEY_ID")
    razorpay_key_secret: str = Field(default="", alias="RAZORPAY_KEY_SECRET")
    dev_otp: str = Field(default="12345", alias="DEV_OTP")
    otp_expiry_minutes: int = Field(default=5, alias="OTP_EXPIRY_MINUTES")

    @property
    def sqlalchemy_url(self) -> str:
        if self.database_url:
            url = self.database_url
            if url.startswith("postgresql://") and "+psycopg2" not in url:
                url = url.replace("postgresql://", "postgresql+psycopg2://", 1)
            return url
        return jdbc_to_sqlalchemy_url(
            self.supabase_db_url, self.supabase_db_user, self.supabase_db_password
        )

    @property
    def cors_origin_list(self) -> list[str]:
        return [o.strip() for o in self.cors_origins.split(",") if o.strip()]


@lru_cache
def get_settings() -> Settings:
    return Settings()
