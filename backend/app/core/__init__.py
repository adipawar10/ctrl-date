"""Core module for application configuration, database, and security."""

from app.core.config import settings, get_settings
from app.core.database import supabase, engine, AsyncSessionLocal, Base, get_db
from app.core.security import (
    AuthError,
    verify_token,
    get_current_user,
    get_optional_user,
)

__all__ = [
    # Config
    "settings",
    "get_settings",
    # Database
    "supabase",
    "engine",
    "AsyncSessionLocal",
    "Base",
    "get_db",
    # Security
    "AuthError",
    "verify_token",
    "get_current_user",
    "get_optional_user",
]
