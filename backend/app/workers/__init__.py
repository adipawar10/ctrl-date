"""Background workers and task queue for Ctrl+Shift+Date."""

from app.workers.celery_app import celery_app

__all__ = ["celery_app"]
