"""Celery application configuration for background task processing."""

import os
from celery import Celery
from celery.schedules import crontab

# Load Redis URL from environment
REDIS_URL = os.environ.get("REDIS_URL", "redis://localhost:6379/0")

# Create Celery app
celery_app = Celery(
    "ctrl_shift_date",
    broker=REDIS_URL,
    backend=REDIS_URL,
    include=["app.workers.tasks"],
)

# Celery configuration
celery_app.conf.update(
    # Serialization
    task_serializer="json",
    accept_content=["json"],
    result_serializer="json",

    # Timezone
    timezone="UTC",
    enable_utc=True,

    # Task settings
    task_track_started=True,
    task_time_limit=300,  # 5 minutes max per task
    task_soft_time_limit=240,  # Soft limit at 4 minutes

    # Retry settings
    task_acks_late=True,  # Acknowledge after task completes
    task_reject_on_worker_lost=True,

    # Result backend settings
    result_expires=3600,  # Results expire after 1 hour
    result_extended=True,

    # Worker settings
    worker_prefetch_multiplier=1,  # One task at a time per worker
    worker_concurrency=4,  # Number of concurrent workers

    # Rate limiting
    task_annotations={
        "app.workers.tasks.send_push_notification": {
            "rate_limit": "100/m",  # Max 100 push notifications per minute
        },
        "app.workers.tasks.process_recurring_events": {
            "rate_limit": "10/m",  # Max 10 recurrence expansions per minute
        },
    },
)

# Beat schedule for periodic tasks
celery_app.conf.beat_schedule = {
    # Process upcoming reminders every minute
    "check-reminders-every-minute": {
        "task": "app.workers.tasks.check_upcoming_reminders",
        "schedule": 60.0,  # Every 60 seconds
    },

    # Expand recurring events for the next 7 days (run hourly)
    "expand-recurring-events-hourly": {
        "task": "app.workers.tasks.expand_recurring_events_batch",
        "schedule": crontab(minute=0),  # Every hour at minute 0
    },

    # Clean up old data (run daily at 3 AM UTC)
    "cleanup-old-data-daily": {
        "task": "app.workers.tasks.cleanup_old_data",
        "schedule": crontab(hour=3, minute=0),
    },

    # Calculate daily reflections/streaks (run daily at midnight UTC)
    "calculate-daily-reflections": {
        "task": "app.workers.tasks.calculate_daily_reflections",
        "schedule": crontab(hour=0, minute=5),  # 5 minutes after midnight
    },
}


# Optional: Configure task routes for different queues
celery_app.conf.task_routes = {
    "app.workers.tasks.send_push_notification": {"queue": "notifications"},
    "app.workers.tasks.send_reminder": {"queue": "notifications"},
    "app.workers.tasks.process_recurring_events": {"queue": "events"},
    "app.workers.tasks.expand_recurring_events_batch": {"queue": "events"},
    "app.workers.tasks.cleanup_old_data": {"queue": "maintenance"},
    "app.workers.tasks.calculate_daily_reflections": {"queue": "maintenance"},
}


if __name__ == "__main__":
    celery_app.start()
