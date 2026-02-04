"""Background tasks for Ctrl+Shift+Date application."""

import os
import json
import asyncio
from datetime import datetime, date, timedelta
from typing import Optional, List, Dict, Any
from uuid import uuid4

from celery import shared_task
from celery.utils.log import get_task_logger

from supabase import create_client, Client
from dateutil.rrule import rrule, DAILY, WEEKLY, MONTHLY, YEARLY

logger = get_task_logger(__name__)

# Initialize Supabase client for background tasks
SUPABASE_URL = os.environ.get("SUPABASE_URL", "")
SUPABASE_SERVICE_KEY = os.environ.get("SUPABASE_SERVICE_ROLE_KEY", "")


def get_supabase() -> Client:
    """Get Supabase client for background tasks."""
    return create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)


# =============================================================================
# Push Notification Tasks
# =============================================================================

@shared_task(
    bind=True,
    max_retries=3,
    default_retry_delay=60,
    autoretry_for=(Exception,),
)
def send_push_notification(
    self,
    user_id: str,
    title: str,
    body: str,
    data: Optional[Dict[str, Any]] = None,
    badge: Optional[int] = None,
) -> Dict[str, Any]:
    """
    Send push notification to a user's registered devices.

    Supports both APNS (iOS) and FCM (Android) push notifications.

    Args:
        user_id: The user's ID to send notification to
        title: Notification title
        body: Notification body text
        data: Optional payload data to include
        badge: Optional badge number (iOS only)

    Returns:
        Dictionary with success status and device delivery results
    """
    logger.info(f"Sending push notification to user {user_id}: {title}")

    supabase = get_supabase()

    # Fetch user's device tokens
    response = supabase.table("device_tokens").select(
        "id, token, platform, is_active"
    ).eq("user_id", user_id).eq("is_active", True).execute()

    device_tokens = response.data or []

    if not device_tokens:
        logger.info(f"No active device tokens for user {user_id}")
        return {"success": True, "devices_notified": 0, "message": "No active devices"}

    results = []

    for device in device_tokens:
        platform = device["platform"]
        token = device["token"]
        device_id = device["id"]

        try:
            if platform == "ios":
                result = _send_apns_notification(token, title, body, data, badge)
            elif platform == "android":
                result = _send_fcm_notification(token, title, body, data)
            else:
                logger.warning(f"Unknown platform {platform} for device {device_id}")
                continue

            results.append({
                "device_id": device_id,
                "platform": platform,
                "success": result.get("success", False),
                "error": result.get("error"),
            })

            # Mark device as inactive if token is invalid
            if result.get("invalid_token"):
                supabase.table("device_tokens").update({
                    "is_active": False,
                    "deactivated_at": datetime.utcnow().isoformat(),
                    "deactivation_reason": "invalid_token",
                }).eq("id", device_id).execute()

        except Exception as e:
            logger.error(f"Failed to send notification to device {device_id}: {e}")
            results.append({
                "device_id": device_id,
                "platform": platform,
                "success": False,
                "error": str(e),
            })

    success_count = sum(1 for r in results if r["success"])

    return {
        "success": success_count > 0,
        "devices_notified": success_count,
        "total_devices": len(device_tokens),
        "results": results,
    }


def _send_apns_notification(
    token: str,
    title: str,
    body: str,
    data: Optional[Dict[str, Any]] = None,
    badge: Optional[int] = None,
) -> Dict[str, Any]:
    """Send notification via Apple Push Notification Service."""
    try:
        from aioapns import APNs, NotificationRequest, PushType

        # Load APNS configuration
        apns_key_id = os.environ.get("APNS_KEY_ID", "")
        apns_team_id = os.environ.get("APNS_TEAM_ID", "")
        apns_bundle_id = os.environ.get("APNS_BUNDLE_ID", "")
        apns_key_path = os.environ.get("APNS_KEY_PATH", "")
        apns_use_sandbox = os.environ.get("APNS_USE_SANDBOX", "false").lower() == "true"

        if not all([apns_key_id, apns_team_id, apns_bundle_id, apns_key_path]):
            logger.warning("APNS not configured, skipping iOS notification")
            return {"success": False, "error": "APNS not configured"}

        # Create APNS client
        async def send_async():
            apns = APNs(
                key=apns_key_path,
                key_id=apns_key_id,
                team_id=apns_team_id,
                topic=apns_bundle_id,
                use_sandbox=apns_use_sandbox,
            )

            # Build notification payload
            payload = {
                "aps": {
                    "alert": {
                        "title": title,
                        "body": body,
                    },
                    "sound": "default",
                }
            }

            if badge is not None:
                payload["aps"]["badge"] = badge

            if data:
                payload.update(data)

            request = NotificationRequest(
                device_token=token,
                message=payload,
                push_type=PushType.ALERT,
            )

            response = await apns.send_notification(request)

            if response.is_successful:
                return {"success": True}
            else:
                is_invalid = response.description in [
                    "BadDeviceToken",
                    "Unregistered",
                    "DeviceTokenNotForTopic",
                ]
                return {
                    "success": False,
                    "error": response.description,
                    "invalid_token": is_invalid,
                }

        # Run async function
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
        try:
            return loop.run_until_complete(send_async())
        finally:
            loop.close()

    except ImportError:
        logger.error("aioapns not installed")
        return {"success": False, "error": "aioapns not installed"}
    except Exception as e:
        logger.error(f"APNS error: {e}")
        return {"success": False, "error": str(e)}


def _send_fcm_notification(
    token: str,
    title: str,
    body: str,
    data: Optional[Dict[str, Any]] = None,
) -> Dict[str, Any]:
    """Send notification via Firebase Cloud Messaging."""
    try:
        import firebase_admin
        from firebase_admin import credentials, messaging

        # Initialize Firebase if not already done
        fcm_credentials_path = os.environ.get("FCM_CREDENTIALS_PATH", "")

        if not fcm_credentials_path:
            logger.warning("FCM not configured, skipping Android notification")
            return {"success": False, "error": "FCM not configured"}

        if not firebase_admin._apps:
            cred = credentials.Certificate(fcm_credentials_path)
            firebase_admin.initialize_app(cred)

        # Build message
        notification = messaging.Notification(
            title=title,
            body=body,
        )

        android_config = messaging.AndroidConfig(
            priority="high",
            notification=messaging.AndroidNotification(
                sound="default",
                default_vibrate_timings=True,
            ),
        )

        message = messaging.Message(
            notification=notification,
            android=android_config,
            token=token,
            data={k: str(v) for k, v in (data or {}).items()},
        )

        # Send message
        response = messaging.send(message)
        logger.info(f"FCM message sent: {response}")

        return {"success": True, "message_id": response}

    except ImportError:
        logger.error("firebase-admin not installed")
        return {"success": False, "error": "firebase-admin not installed"}
    except messaging.UnregisteredError:
        return {"success": False, "error": "Token unregistered", "invalid_token": True}
    except messaging.InvalidArgumentError as e:
        return {"success": False, "error": str(e), "invalid_token": True}
    except Exception as e:
        logger.error(f"FCM error: {e}")
        return {"success": False, "error": str(e)}


# =============================================================================
# Recurring Events Tasks
# =============================================================================

FREQ_MAP = {
    "daily": DAILY,
    "weekly": WEEKLY,
    "monthly": MONTHLY,
    "yearly": YEARLY,
}


@shared_task(bind=True)
def process_recurring_events(
    self,
    event_id: str,
    range_start: str,
    range_end: str,
) -> Dict[str, Any]:
    """
    Expand a recurring event into individual instances within a date range.

    This creates "materialized" event instances for a recurring event
    to enable easier querying and status tracking per instance.

    Args:
        event_id: The parent recurring event ID
        range_start: Start date (ISO format)
        range_end: End date (ISO format)

    Returns:
        Dictionary with expansion results
    """
    logger.info(f"Processing recurring event {event_id} from {range_start} to {range_end}")

    supabase = get_supabase()

    # Fetch the event
    event_response = supabase.table("events").select(
        "*, recurrence_rules(*)"
    ).eq("id", event_id).single().execute()

    if not event_response.data:
        logger.error(f"Event {event_id} not found")
        return {"success": False, "error": "Event not found"}

    event = event_response.data

    if not event.get("recurrence_rule_id"):
        logger.info(f"Event {event_id} is not recurring")
        return {"success": True, "message": "Event is not recurring", "instances_created": 0}

    # Parse dates
    range_start_dt = datetime.fromisoformat(range_start.replace("Z", "+00:00"))
    range_end_dt = datetime.fromisoformat(range_end.replace("Z", "+00:00"))

    # Get recurrence rule
    rule = event.get("recurrence_rules") or {}
    if not rule:
        rule_response = supabase.table("recurrence_rules").select("*").eq(
            "id", event["recurrence_rule_id"]
        ).single().execute()
        rule = rule_response.data or {}

    if not rule:
        logger.error(f"Recurrence rule not found for event {event_id}")
        return {"success": False, "error": "Recurrence rule not found"}

    # Parse event times
    base_start = datetime.fromisoformat(event["start_time"].replace("Z", "+00:00"))
    base_end = datetime.fromisoformat(event["end_time"].replace("Z", "+00:00"))
    duration = base_end - base_start

    # Build rrule
    rrule_kwargs = {
        "freq": FREQ_MAP.get(rule.get("frequency", "daily"), DAILY),
        "interval": rule.get("interval", 1),
        "dtstart": base_start,
    }

    if rule.get("until_date"):
        until = datetime.fromisoformat(rule["until_date"])
        if until.tzinfo is None:
            until = until.replace(tzinfo=base_start.tzinfo)
        rrule_kwargs["until"] = until

    if rule.get("count"):
        rrule_kwargs["count"] = rule["count"]

    if rule.get("by_weekday"):
        rrule_kwargs["byweekday"] = rule["by_weekday"]

    if rule.get("by_monthday"):
        rrule_kwargs["bymonthday"] = rule["by_monthday"]

    if rule.get("by_month"):
        rrule_kwargs["bymonth"] = rule["by_month"]

    if rule.get("by_setpos"):
        rrule_kwargs["bysetpos"] = rule["by_setpos"]

    # Generate occurrences
    try:
        rr = rrule(**rrule_kwargs)
        occurrences = list(rr.between(range_start_dt, range_end_dt, inc=True))
    except Exception as e:
        logger.error(f"Error expanding recurrence: {e}")
        return {"success": False, "error": str(e)}

    # Get excluded dates
    excluded = set()
    for exc_date in rule.get("excluded_dates") or []:
        if isinstance(exc_date, str):
            excluded.add(date.fromisoformat(exc_date))
        else:
            excluded.add(exc_date)

    occurrences = [o for o in occurrences if o.date() not in excluded]

    # Check existing instances
    existing_response = supabase.table("events").select(
        "recurrence_instance_date"
    ).eq("recurrence_parent_id", event_id).execute()

    existing_dates = {
        date.fromisoformat(e["recurrence_instance_date"])
        for e in (existing_response.data or [])
        if e.get("recurrence_instance_date")
    }

    # Create new instances
    instances_to_create = []

    for occurrence in occurrences:
        instance_date = occurrence.date()

        if instance_date in existing_dates:
            continue

        instance = {
            "id": str(uuid4()),
            "owner_id": event["owner_id"],
            "title": event["title"],
            "description": event.get("description"),
            "location": event.get("location"),
            "start_time": occurrence.isoformat(),
            "end_time": (occurrence + duration).isoformat(),
            "all_day": event.get("all_day", False),
            "timezone": event["timezone"],
            "is_locked": event.get("is_locked", False),
            "priority": event.get("priority", 2),
            "recurrence_parent_id": event_id,
            "recurrence_instance_date": instance_date.isoformat(),
            "status": "scheduled",
            "color": event.get("color"),
            "tags": event.get("tags", []),
        }
        instances_to_create.append(instance)

    # Batch insert
    if instances_to_create:
        batch_size = 100
        for i in range(0, len(instances_to_create), batch_size):
            batch = instances_to_create[i:i + batch_size]
            supabase.table("events").insert(batch).execute()

    logger.info(f"Created {len(instances_to_create)} instances for event {event_id}")

    return {
        "success": True,
        "event_id": event_id,
        "instances_created": len(instances_to_create),
        "total_occurrences": len(occurrences),
    }


@shared_task(bind=True)
def expand_recurring_events_batch(self) -> Dict[str, Any]:
    """
    Batch task to expand all recurring events for the next 7 days.

    Run periodically (e.g., hourly) to ensure recurring events are
    materialized ahead of time for efficient querying.
    """
    logger.info("Starting batch expansion of recurring events")

    supabase = get_supabase()

    # Calculate date range
    today = datetime.utcnow().date()
    range_start = datetime.combine(today, datetime.min.time())
    range_end = datetime.combine(today + timedelta(days=7), datetime.max.time())

    # Find all recurring events
    response = supabase.table("events").select(
        "id, recurrence_rule_id"
    ).not_.is_("recurrence_rule_id", "null").is_(
        "recurrence_parent_id", "null"
    ).is_("deleted_at", "null").execute()

    recurring_events = response.data or []

    results = []
    for event in recurring_events:
        try:
            result = process_recurring_events.delay(
                event["id"],
                range_start.isoformat(),
                range_end.isoformat(),
            )
            results.append({
                "event_id": event["id"],
                "task_id": result.id,
            })
        except Exception as e:
            logger.error(f"Failed to queue expansion for event {event['id']}: {e}")
            results.append({
                "event_id": event["id"],
                "error": str(e),
            })

    return {
        "success": True,
        "events_queued": len(results),
        "results": results,
    }


# =============================================================================
# Reminder Tasks
# =============================================================================

@shared_task(
    bind=True,
    max_retries=3,
    default_retry_delay=30,
)
def send_reminder(
    self,
    event_id: str,
    user_id: str,
    reminder_type: str = "notification",
) -> Dict[str, Any]:
    """
    Send a reminder for an upcoming event.

    Args:
        event_id: The event to remind about
        user_id: The user to notify
        reminder_type: Type of reminder (notification, email, sms)

    Returns:
        Dictionary with reminder delivery status
    """
    logger.info(f"Sending reminder for event {event_id} to user {user_id}")

    supabase = get_supabase()

    # Fetch event details
    event_response = supabase.table("events").select("*").eq(
        "id", event_id
    ).single().execute()

    if not event_response.data:
        logger.error(f"Event {event_id} not found")
        return {"success": False, "error": "Event not found"}

    event = event_response.data

    # Check if event is still scheduled
    if event.get("status") != "scheduled":
        logger.info(f"Event {event_id} is no longer scheduled, skipping reminder")
        return {"success": True, "message": "Event not scheduled, skipping"}

    # Check if event hasn't passed
    event_start = datetime.fromisoformat(event["start_time"].replace("Z", "+00:00"))
    if event_start < datetime.utcnow().replace(tzinfo=event_start.tzinfo):
        logger.info(f"Event {event_id} has passed, skipping reminder")
        return {"success": True, "message": "Event has passed, skipping"}

    # Build reminder message
    title = f"Upcoming: {event['title']}"
    time_until = event_start - datetime.utcnow().replace(tzinfo=event_start.tzinfo)
    minutes_until = int(time_until.total_seconds() / 60)

    if minutes_until < 60:
        time_str = f"{minutes_until} minutes"
    elif minutes_until < 1440:  # Less than a day
        hours = minutes_until // 60
        time_str = f"{hours} hour{'s' if hours > 1 else ''}"
    else:
        days = minutes_until // 1440
        time_str = f"{days} day{'s' if days > 1 else ''}"

    body = f"Starting in {time_str}"
    if event.get("location"):
        body += f" at {event['location']}"

    # Send based on reminder type
    if reminder_type == "notification":
        result = send_push_notification.delay(
            user_id=user_id,
            title=title,
            body=body,
            data={
                "type": "event_reminder",
                "event_id": event_id,
            },
        )
        return {
            "success": True,
            "reminder_type": "notification",
            "task_id": result.id,
        }

    # Future: support email and SMS reminders
    else:
        logger.warning(f"Unknown reminder type: {reminder_type}")
        return {"success": False, "error": f"Unknown reminder type: {reminder_type}"}


@shared_task(bind=True)
def check_upcoming_reminders(self) -> Dict[str, Any]:
    """
    Check for events that need reminders sent and queue them.

    This task runs every minute to find events starting within
    the user's configured reminder lead time.
    """
    logger.info("Checking for upcoming reminders")

    supabase = get_supabase()

    # Find events starting in the next hour with reminders enabled
    now = datetime.utcnow()
    window_end = now + timedelta(hours=1)

    # Fetch events
    events_response = supabase.table("events").select(
        "id, owner_id, title, start_time"
    ).eq("status", "scheduled").is_(
        "deleted_at", "null"
    ).gte(
        "start_time", now.isoformat()
    ).lte(
        "start_time", window_end.isoformat()
    ).execute()

    events = events_response.data or []

    if not events:
        return {"success": True, "reminders_queued": 0}

    # Get user preferences
    user_ids = list(set(e["owner_id"] for e in events))
    users_response = supabase.table("users").select(
        "id, preferences"
    ).in_("id", user_ids).execute()

    user_prefs = {
        u["id"]: u.get("preferences", {})
        for u in (users_response.data or [])
    }

    # Check which reminders have already been sent
    event_ids = [e["id"] for e in events]
    sent_response = supabase.table("sent_reminders").select(
        "event_id"
    ).in_("event_id", event_ids).execute()

    sent_reminders = {r["event_id"] for r in (sent_response.data or [])}

    reminders_queued = 0

    for event in events:
        event_id = event["id"]
        user_id = event["owner_id"]

        # Skip if already sent
        if event_id in sent_reminders:
            continue

        # Get user's lead time preference
        prefs = user_prefs.get(user_id, {})
        lead_time = prefs.get("notification_lead_time", 15)  # Default 15 minutes

        # Calculate reminder time
        event_start = datetime.fromisoformat(event["start_time"].replace("Z", "+00:00"))
        reminder_time = event_start - timedelta(minutes=lead_time)

        # Check if it's time to send
        if now >= reminder_time:
            # Queue the reminder
            send_reminder.delay(
                event_id=event_id,
                user_id=user_id,
                reminder_type="notification",
            )

            # Record that we sent this reminder
            supabase.table("sent_reminders").insert({
                "id": str(uuid4()),
                "event_id": event_id,
                "user_id": user_id,
                "sent_at": now.isoformat(),
            }).execute()

            reminders_queued += 1

    logger.info(f"Queued {reminders_queued} reminders")

    return {
        "success": True,
        "reminders_queued": reminders_queued,
        "events_checked": len(events),
    }


# =============================================================================
# Maintenance Tasks
# =============================================================================

@shared_task(bind=True)
def cleanup_old_data(self) -> Dict[str, Any]:
    """
    Clean up old data from the database.

    - Remove soft-deleted events older than 30 days
    - Remove old sent_reminders records
    - Remove old ai_suggestions records
    """
    logger.info("Starting data cleanup")

    supabase = get_supabase()

    now = datetime.utcnow()
    cutoff_30_days = (now - timedelta(days=30)).isoformat()
    cutoff_7_days = (now - timedelta(days=7)).isoformat()

    results = {}

    # Clean up soft-deleted events
    try:
        response = supabase.table("events").delete().lt(
            "deleted_at", cutoff_30_days
        ).execute()
        results["deleted_events"] = len(response.data or [])
    except Exception as e:
        logger.error(f"Failed to clean up deleted events: {e}")
        results["deleted_events_error"] = str(e)

    # Clean up old sent_reminders
    try:
        response = supabase.table("sent_reminders").delete().lt(
            "sent_at", cutoff_7_days
        ).execute()
        results["sent_reminders_cleaned"] = len(response.data or [])
    except Exception as e:
        logger.error(f"Failed to clean up sent reminders: {e}")
        results["sent_reminders_error"] = str(e)

    # Clean up old AI suggestions
    try:
        response = supabase.table("ai_suggestions").delete().lt(
            "created_at", cutoff_30_days
        ).execute()
        results["ai_suggestions_cleaned"] = len(response.data or [])
    except Exception as e:
        logger.error(f"Failed to clean up AI suggestions: {e}")
        results["ai_suggestions_error"] = str(e)

    logger.info(f"Cleanup completed: {results}")

    return {"success": True, "results": results}


@shared_task(bind=True)
def calculate_daily_reflections(self) -> Dict[str, Any]:
    """
    Calculate daily reflection stats and update streaks for all users.

    Run at the end of each day (midnight UTC) to:
    - Calculate completion stats for the previous day
    - Update streak counts
    """
    logger.info("Calculating daily reflections")

    supabase = get_supabase()

    # Calculate for yesterday
    yesterday = (datetime.utcnow() - timedelta(days=1)).date()
    day_start = datetime.combine(yesterday, datetime.min.time())
    day_end = datetime.combine(yesterday, datetime.max.time())

    # Get all users
    users_response = supabase.table("users").select("id").execute()
    users = users_response.data or []

    results = []

    for user in users:
        user_id = user["id"]

        try:
            # Get events for the day
            events_response = supabase.table("events").select(
                "id, status"
            ).eq("owner_id", user_id).is_(
                "deleted_at", "null"
            ).gte(
                "start_time", day_start.isoformat()
            ).lte(
                "start_time", day_end.isoformat()
            ).execute()

            events = events_response.data or []

            if not events:
                continue

            # Calculate stats
            total = len(events)
            completed = sum(1 for e in events if e["status"] == "completed")
            skipped = sum(1 for e in events if e["status"] == "skipped")
            partial = sum(1 for e in events if e["status"] == "partial")

            completion_rate = (completed + partial * 0.5) / total if total > 0 else 0

            # Check if this is a streak day (>= 80% completion)
            is_streak_day = completion_rate >= 0.8

            # Check for existing reflection
            existing_response = supabase.table("daily_reflections").select(
                "id"
            ).eq("user_id", user_id).eq(
                "reflection_date", yesterday.isoformat()
            ).execute()

            reflection_data = {
                "user_id": user_id,
                "reflection_date": yesterday.isoformat(),
                "events_planned": total,
                "events_completed": completed,
                "events_skipped": skipped,
                "events_partial": partial,
                "is_streak_day": is_streak_day,
                "updated_at": datetime.utcnow().isoformat(),
            }

            if existing_response.data:
                # Update existing
                supabase.table("daily_reflections").update(
                    reflection_data
                ).eq("id", existing_response.data[0]["id"]).execute()
            else:
                # Create new
                reflection_data["id"] = str(uuid4())
                reflection_data["created_at"] = datetime.utcnow().isoformat()
                supabase.table("daily_reflections").insert(reflection_data).execute()

            # Update streak
            _update_user_streak(supabase, user_id, yesterday, is_streak_day)

            results.append({
                "user_id": user_id,
                "events": total,
                "completion_rate": completion_rate,
                "is_streak_day": is_streak_day,
            })

        except Exception as e:
            logger.error(f"Failed to calculate reflection for user {user_id}: {e}")
            results.append({
                "user_id": user_id,
                "error": str(e),
            })

    logger.info(f"Calculated reflections for {len(results)} users")

    return {
        "success": True,
        "date": yesterday.isoformat(),
        "users_processed": len(results),
        "results": results,
    }


def _update_user_streak(
    supabase: Client,
    user_id: str,
    date_: date,
    is_streak_day: bool,
) -> None:
    """Update a user's streak based on the day's performance."""
    # Get or create streak record
    streak_response = supabase.table("streaks").select("*").eq(
        "user_id", user_id
    ).eq("streak_type", "daily_completion").execute()

    if streak_response.data:
        streak = streak_response.data[0]
        streak_id = streak["id"]
        current_count = streak["current_count"]
        longest_count = streak["longest_count"]
        last_date_str = streak.get("last_completed_date")
        last_date = date.fromisoformat(last_date_str) if last_date_str else None
    else:
        # Create new streak
        streak_id = str(uuid4())
        current_count = 0
        longest_count = 0
        last_date = None

        supabase.table("streaks").insert({
            "id": streak_id,
            "user_id": user_id,
            "streak_type": "daily_completion",
            "current_count": 0,
            "longest_count": 0,
            "completion_threshold": 0.8,
            "created_at": datetime.utcnow().isoformat(),
            "updated_at": datetime.utcnow().isoformat(),
        }).execute()

    if is_streak_day:
        # Check if consecutive
        if last_date and (date_ - last_date).days == 1:
            current_count += 1
        else:
            current_count = 1

        longest_count = max(longest_count, current_count)

        supabase.table("streaks").update({
            "current_count": current_count,
            "longest_count": longest_count,
            "last_completed_date": date_.isoformat(),
            "updated_at": datetime.utcnow().isoformat(),
        }).eq("id", streak_id).execute()
    else:
        # Streak broken
        if current_count > 0:
            supabase.table("streaks").update({
                "current_count": 0,
                "updated_at": datetime.utcnow().isoformat(),
            }).eq("id", streak_id).execute()
