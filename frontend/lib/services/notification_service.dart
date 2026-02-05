import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/event.dart';
import '../models/inbox.dart';

/// Service for managing push notifications
class NotificationService {
  NotificationService._();

  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  static FlutterLocalNotificationsPlugin? _plugin;

  static const String _channelIdEvents = 'events';
  static const String _channelIdReminders = 'reminders';
  static const String _channelIdSocial = 'social';
  static const String _channelIdSystem = 'system';

  static const String _settingsKey = 'notification_settings';

  NotificationSettings _settings = const NotificationSettings();

  /// Initialize the notification service
  static Future<void> initialize(
    FlutterLocalNotificationsPlugin plugin,
  ) async {
    _plugin = plugin;

    // Initialize timezone
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTapped,
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }

    // Load settings
    await _instance._loadSettings();
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    if (_plugin == null) return false;

    if (Platform.isIOS) {
      final result = await _plugin!
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    }

    if (Platform.isAndroid) {
      final result = await _plugin!
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      return result ?? false;
    }

    return false;
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    if (_plugin == null) return false;

    if (Platform.isAndroid) {
      final result = await _plugin!
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
      return result ?? false;
    }

    // iOS doesn't have a direct way to check, assume true if initialized
    return true;
  }

  /// Schedule an event reminder notification
  Future<void> scheduleEventReminder(Event event, EventReminder reminder) async {
    if (_plugin == null) return;
    if (!_settings.eventReminders) return;

    final scheduledTime = event.startTime.subtract(
      Duration(minutes: reminder.minutesBefore),
    );

    // Don't schedule if in the past
    if (scheduledTime.isBefore(DateTime.now())) return;

    // Check quiet hours
    if (_isInQuietHours(scheduledTime)) return;

    final notificationId = _generateNotificationId(event.id, reminder.id);

    await _plugin!.zonedSchedule(
      notificationId,
      'Event Reminder',
      '${event.title} starts in ${reminder.minutesBefore} minutes',
      tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdReminders,
          'Reminders',
          channelDescription: 'Event and task reminders',
          importance: Importance.high,
          priority: Priority.high,
          sound: _settings.soundEnabled
              ? const RawResourceAndroidNotificationSound('notification')
              : null,
          enableVibration: _settings.vibrationEnabled,
        ),
        iOS: DarwinNotificationDetails(
          sound: _settings.soundEnabled ? 'notification.aiff' : null,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'event:${event.id}',
    );
  }

  /// Cancel an event reminder notification
  Future<void> cancelEventReminder(String eventId, String reminderId) async {
    if (_plugin == null) return;

    final notificationId = _generateNotificationId(eventId, reminderId);
    await _plugin!.cancel(notificationId);
  }

  /// Cancel all reminders for an event
  Future<void> cancelAllEventReminders(String eventId) async {
    if (_plugin == null) return;

    // Cancel up to 10 potential reminders per event
    for (var i = 0; i < 10; i++) {
      final notificationId = _generateNotificationId(eventId, i.toString());
      await _plugin!.cancel(notificationId);
    }
  }

  /// Show an immediate notification for inbox messages
  Future<void> showInboxNotification(InboxMessage message) async {
    if (_plugin == null) return;
    if (!_shouldShowNotification(message.type)) return;

    final channelId = _getChannelForMessageType(message.type);
    final notificationId = message.id.hashCode;

    await _plugin!.show(
      notificationId,
      message.title,
      message.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          _getChannelName(channelId),
          channelDescription: _getChannelDescription(channelId),
          importance: _getImportance(message.priority),
          priority: _getPriority(message.priority),
          sound: _settings.soundEnabled
              ? const RawResourceAndroidNotificationSound('notification')
              : null,
          enableVibration: _settings.vibrationEnabled,
        ),
        iOS: DarwinNotificationDetails(
          sound: _settings.soundEnabled ? 'notification.aiff' : null,
        ),
      ),
      payload: 'inbox:${message.id}',
    );
  }

  /// Show a poke notification
  Future<void> showPokeNotification(String senderName, String pokeType) async {
    if (_plugin == null) return;
    if (!_settings.pokes) return;

    final messages = {
      'wave': '$senderName waved at you!',
      'nudge': '$senderName nudged you!',
      'thinking_of_you': '$senderName is thinking of you!',
      'miss_you': '$senderName misses you!',
    };

    final body = messages[pokeType] ?? '$senderName sent you a poke!';

    await _plugin!.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Poke',
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdSocial,
          'Social',
          channelDescription: 'Friend requests, pokes, and social updates',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          sound: _settings.soundEnabled
              ? const RawResourceAndroidNotificationSound('poke')
              : null,
          enableVibration: _settings.vibrationEnabled,
        ),
        iOS: DarwinNotificationDetails(
          sound: _settings.soundEnabled ? 'poke.aiff' : null,
        ),
      ),
      payload: 'poke',
    );
  }

  /// Show a streak milestone notification
  Future<void> showStreakMilestoneNotification(int streakDays) async {
    if (_plugin == null) return;
    if (!_settings.streakMilestones) return;

    String title;
    String body;

    if (streakDays == 7) {
      title = 'One Week Streak!';
      body = 'You\'ve reflected for 7 days in a row. Keep it up!';
    } else if (streakDays == 30) {
      title = 'One Month Streak!';
      body = 'Amazing! 30 days of daily reflection!';
    } else if (streakDays == 100) {
      title = '100 Day Streak!';
      body = 'Incredible achievement! 100 days of reflection!';
    } else if (streakDays == 365) {
      title = 'One Year Streak!';
      body = 'You\'ve reflected every day for a year!';
    } else {
      title = '$streakDays Day Streak!';
      body = 'Great job maintaining your reflection habit!';
    }

    await _plugin!.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdSystem,
          'System',
          channelDescription: 'System notifications and achievements',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: 'streak:$streakDays',
    );
  }

  /// Schedule daily reflection reminder
  Future<void> scheduleDailyReflectionReminder(String timeString) async {
    if (_plugin == null) return;
    if (!_settings.reflectionReminders) return;

    // Cancel existing reminder
    await _plugin!.cancel(_reflectionReminderId);

    // Parse time string (HH:mm format)
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    // Calculate next occurrence
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day + 1,
        hour,
        minute,
      );
    }

    await _plugin!.zonedSchedule(
      _reflectionReminderId,
      'Daily Reflection',
      'Take a moment to reflect on your day',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdReminders,
          'Reminders',
          channelDescription: 'Event and task reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'reflection',
    );
  }

  /// Cancel daily reflection reminder
  Future<void> cancelDailyReflectionReminder() async {
    if (_plugin == null) return;
    await _plugin!.cancel(_reflectionReminderId);
  }

  /// Update notification settings
  Future<void> updateSettings(NotificationSettings settings) async {
    _settings = settings;
    await _saveSettings();

    // Update scheduled reminders if needed
    if (!settings.reflectionReminders) {
      await cancelDailyReflectionReminder();
    }
  }

  /// Get current notification settings
  NotificationSettings get settings => _settings;

  /// Cancel all notifications
  Future<void> cancelAll() async {
    if (_plugin == null) return;
    await _plugin!.cancelAll();
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    if (_plugin == null) return [];
    return _plugin!.pendingNotificationRequests();
  }

  // Private methods

  static Future<void> _createNotificationChannels() async {
    final androidPlugin = _plugin!.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelIdEvents,
        'Events',
        description: 'Event notifications and updates',
        importance: Importance.high,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelIdReminders,
        'Reminders',
        description: 'Event and task reminders',
        importance: Importance.high,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelIdSocial,
        'Social',
        description: 'Friend requests, pokes, and social updates',
        importance: Importance.defaultImportance,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelIdSystem,
        'System',
        description: 'System notifications and achievements',
        importance: Importance.defaultImportance,
      ),
    );
  }

  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Handle notification tap - navigate to appropriate screen
    // This would typically use a navigator or state management
  }

  @pragma('vm:entry-point')
  static void _onBackgroundNotificationTapped(NotificationResponse response) {
    debugPrint('Background notification tapped: ${response.payload}');
    // Handle background notification tap
  }

  int _generateNotificationId(String eventId, String reminderId) {
    return '${eventId}_$reminderId'.hashCode;
  }

  static const int _reflectionReminderId = 999999;

  bool _shouldShowNotification(MessageType type) {
    switch (type) {
      case MessageType.friendRequest:
      case MessageType.friendAccepted:
        return _settings.friendRequests;
      case MessageType.poke:
        return _settings.pokes;
      case MessageType.eventShare:
        return _settings.eventShares;
      case MessageType.eventReminder:
        return _settings.eventReminders;
      case MessageType.eventUpdate:
      case MessageType.eventCancelled:
        return _settings.eventUpdates;
      case MessageType.reflectionReminder:
        return _settings.reflectionReminders;
      case MessageType.streakMilestone:
        return _settings.streakMilestones;
      case MessageType.system:
        return _settings.systemMessages;
      case MessageType.announcement:
        return _settings.announcements;
    }
  }

  String _getChannelForMessageType(MessageType type) {
    switch (type) {
      case MessageType.friendRequest:
      case MessageType.friendAccepted:
      case MessageType.poke:
        return _channelIdSocial;
      case MessageType.eventShare:
      case MessageType.eventReminder:
      case MessageType.eventUpdate:
      case MessageType.eventCancelled:
        return _channelIdEvents;
      case MessageType.reflectionReminder:
        return _channelIdReminders;
      case MessageType.streakMilestone:
      case MessageType.system:
      case MessageType.announcement:
        return _channelIdSystem;
    }
  }

  String _getChannelName(String channelId) {
    switch (channelId) {
      case _channelIdEvents:
        return 'Events';
      case _channelIdReminders:
        return 'Reminders';
      case _channelIdSocial:
        return 'Social';
      case _channelIdSystem:
        return 'System';
      default:
        return 'Notifications';
    }
  }

  String _getChannelDescription(String channelId) {
    switch (channelId) {
      case _channelIdEvents:
        return 'Event notifications and updates';
      case _channelIdReminders:
        return 'Event and task reminders';
      case _channelIdSocial:
        return 'Friend requests, pokes, and social updates';
      case _channelIdSystem:
        return 'System notifications and achievements';
      default:
        return 'General notifications';
    }
  }

  Importance _getImportance(MessagePriority priority) {
    switch (priority) {
      case MessagePriority.low:
        return Importance.low;
      case MessagePriority.normal:
        return Importance.defaultImportance;
      case MessagePriority.high:
        return Importance.high;
      case MessagePriority.urgent:
        return Importance.max;
    }
  }

  Priority _getPriority(MessagePriority priority) {
    switch (priority) {
      case MessagePriority.low:
        return Priority.low;
      case MessagePriority.normal:
        return Priority.defaultPriority;
      case MessagePriority.high:
        return Priority.high;
      case MessagePriority.urgent:
        return Priority.max;
    }
  }

  bool _isInQuietHours(DateTime time) {
    if (!_settings.quietHoursEnabled) return false;

    final startParts = _settings.quietHoursStart.split(':');
    final endParts = _settings.quietHoursEnd.split(':');

    final startMinutes =
        int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
    final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);
    final currentMinutes = time.hour * 60 + time.minute;

    if (startMinutes < endMinutes) {
      // Same day quiet hours (e.g., 22:00 - 08:00 next day)
      return currentMinutes >= startMinutes || currentMinutes < endMinutes;
    } else {
      // Overnight quiet hours
      return currentMinutes >= startMinutes && currentMinutes < endMinutes;
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);

    if (settingsJson != null) {
      try {
        final settingsMap =
            Map<String, dynamic>.from(settingsJson as Map<String, dynamic>);
        _settings = NotificationSettings.fromJson(settingsMap);
      } catch (e) {
        debugPrint('Failed to load notification settings: $e');
      }
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, _settings.toJson().toString());
  }
}
