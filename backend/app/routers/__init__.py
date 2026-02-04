"""API Routers."""

from app.routers import (
    auth,
    events,
    calendar_import,
    sharing,
    friends,
    inbox,
    reflections,
    ai_suggestions,
    sync,
)

__all__ = [
    "auth",
    "events",
    "calendar_import",
    "sharing",
    "friends",
    "inbox",
    "reflections",
    "ai_suggestions",
    "sync",
]
