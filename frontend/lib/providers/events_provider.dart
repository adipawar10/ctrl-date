import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart' hide Event;
import '../main.dart';
import '../models/event.dart';
import '../services/api_service.dart';
import '../services/sync_service.dart';
import 'auth_provider.dart';

/// Provider for the API service
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService.instance;
});

/// Provider for the sync service
final syncServiceProvider = Provider<SyncService>((ref) {
  final database = ref.watch(databaseProvider);
  final syncService = SyncService.instance;
  syncService.initialize(database);
  return syncService;
});

/// Provider for all events
final eventsProvider =
    StateNotifierProvider<EventsNotifier, AsyncValue<List<Event>>>((ref) {
  return EventsNotifier(ref);
});

/// Provider for events filtered by date range
final eventsForDateRangeProvider =
    FutureProvider.family<List<Event>, DateRange>((ref, range) async {
  final eventsAsync = ref.watch(eventsProvider);

  return eventsAsync.maybeWhen(
    data: (events) {
      return events.where((event) {
        return event.startTime.isAfter(range.start) &&
            event.startTime.isBefore(range.end);
      }).toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
    },
    orElse: () => [],
  );
});

/// Provider for today's events
final todaysEventsProvider = FutureProvider<List<Event>>((ref) async {
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  return ref.watch(
    eventsForDateRangeProvider(DateRange(startOfDay, endOfDay)).future,
  );
});

/// Provider for upcoming events (next 7 days)
final upcomingEventsProvider = FutureProvider<List<Event>>((ref) async {
  final now = DateTime.now();
  final endDate = now.add(const Duration(days: 7));

  return ref.watch(
    eventsForDateRangeProvider(DateRange(now, endDate)).future,
  );
});

/// Provider for a single event by ID
final eventByIdProvider = FutureProvider.family<Event?, String>((ref, id) async {
  final database = ref.watch(databaseProvider);
  return database.getEventById(id);
});

/// Provider for events by status
final eventsByStatusProvider =
    FutureProvider.family<List<Event>, EventStatus>((ref, status) async {
  final eventsAsync = ref.watch(eventsProvider);

  return eventsAsync.maybeWhen(
    data: (events) => events.where((e) => e.status == status).toList(),
    orElse: () => [],
  );
});

/// Provider for searching events
final eventSearchProvider =
    FutureProvider.family<List<Event>, String>((ref, query) async {
  if (query.isEmpty) return [];

  final eventsAsync = ref.watch(eventsProvider);
  final lowerQuery = query.toLowerCase();

  return eventsAsync.maybeWhen(
    data: (events) {
      return events.where((event) {
        return event.title.toLowerCase().contains(lowerQuery) ||
            (event.description?.toLowerCase().contains(lowerQuery) ?? false) ||
            (event.location?.toLowerCase().contains(lowerQuery) ?? false) ||
            event.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
      }).toList();
    },
    orElse: () => [],
  );
});

/// Notifier for managing events state
class EventsNotifier extends StateNotifier<AsyncValue<List<Event>>> {
  final Ref _ref;
  StreamSubscription? _eventsSubscription;

  EventsNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadEvents();
    _subscribeToEvents();
  }

  AppDatabase get _database => _ref.read(databaseProvider);
  ApiService get _api => _ref.read(apiServiceProvider);
  SyncService get _sync => _ref.read(syncServiceProvider);

  Future<void> _loadEvents() async {
    try {
      final events = await _database.getAllEvents();
      state = AsyncValue.data(events);

      // Trigger background sync
      _sync.sync();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _subscribeToEvents() {
    _eventsSubscription = _database.watchAllEvents().listen(
      (events) {
        state = AsyncValue.data(events);
      },
      onError: (e, st) {
        state = AsyncValue.error(e, st);
      },
    );
  }

  /// Create a new event
  Future<Event?> createEvent(Event event) async {
    try {
      // Save to local database
      await _database.insertEvent(event);

      // Convert to snake_case format for the backend API
      final priorityInt = switch (event.priority) {
        EventPriority.low => 1,
        EventPriority.medium => 2,
        EventPriority.high => 3,
        EventPriority.urgent => 4,
      };

      final body = <String, dynamic>{
        'title': event.title,
        'description': event.description,
        'location': event.location,
        'start_time': event.startTime.toIso8601String(),
        'end_time': event.endTime.toIso8601String(),
        'all_day': event.isAllDay,
        'timezone': DateTime.now().timeZoneName,
        'is_locked': false,
        'priority': priorityInt,
        'color': event.color,
        'tags': event.tags,
      };

      if (event.recurrenceRule != null) {
        body['recurrence_rule'] = {
          'frequency': event.recurrenceRule!.frequency.name,
          'interval': event.recurrenceRule!.interval,
          'by_week_day': event.recurrenceRule!.byWeekDay,
          'by_month_day': event.recurrenceRule!.byMonthDay,
          'by_month': event.recurrenceRule!.byMonth,
          'count': event.recurrenceRule!.count,
          'until': event.recurrenceRule!.until?.toIso8601String(),
        };
      }

      // Sync to server
      final response = await _api.post('/events', body: body);

      if (response.isSuccess) {
        await _database.markEventSynced(event.id);
      }

      return event;
    } catch (e) {
      rethrow;
    }
  }

  /// Update an existing event
  Future<Event?> updateEvent(Event event) async {
    try {
      final updatedEvent = event.copyWith(
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      await _database.updateEvent(updatedEvent);

      // Convert to snake_case format for the backend API
      final priorityInt = switch (updatedEvent.priority) {
        EventPriority.low => 1,
        EventPriority.medium => 2,
        EventPriority.high => 3,
        EventPriority.urgent => 4,
      };

      final body = <String, dynamic>{
        'title': updatedEvent.title,
        'description': updatedEvent.description,
        'location': updatedEvent.location,
        'start_time': updatedEvent.startTime.toIso8601String(),
        'end_time': updatedEvent.endTime.toIso8601String(),
        'all_day': updatedEvent.isAllDay,
        'is_locked': false,
        'priority': priorityInt,
        'color': updatedEvent.color,
        'tags': updatedEvent.tags,
      };

      // Sync to server
      final response = await _api.put(
        '/events/${event.id}',
        body: body,
      );

      if (response.isSuccess) {
        await _database.markEventSynced(event.id);
      }

      return updatedEvent;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete an event
  Future<void> deleteEvent(String eventId) async {
    try {
      await _database.deleteEvent(eventId);

      // Sync deletion to server
      await _api.delete('/events/$eventId');
    } catch (e) {
      rethrow;
    }
  }

  /// Update event status
  Future<void> updateEventStatus(String eventId, EventStatus status) async {
    final eventsData = state.valueOrNull;
    if (eventsData == null) return;

    final event = eventsData.firstWhere(
      (e) => e.id == eventId,
      orElse: () => throw Exception('Event not found'),
    );

    await updateEvent(event.copyWith(status: status));
  }

  /// Add a reminder to an event
  Future<void> addReminder(String eventId, EventReminder reminder) async {
    final eventsData = state.valueOrNull;
    if (eventsData == null) return;

    final event = eventsData.firstWhere(
      (e) => e.id == eventId,
      orElse: () => throw Exception('Event not found'),
    );

    final updatedReminders = [...event.reminders, reminder];
    await updateEvent(event.copyWith(reminders: updatedReminders));
  }

  /// Remove a reminder from an event
  Future<void> removeReminder(String eventId, String reminderId) async {
    final eventsData = state.valueOrNull;
    if (eventsData == null) return;

    final event = eventsData.firstWhere(
      (e) => e.id == eventId,
      orElse: () => throw Exception('Event not found'),
    );

    final updatedReminders =
        event.reminders.where((r) => r.id != reminderId).toList();
    await updateEvent(event.copyWith(reminders: updatedReminders));
  }

  /// Share an event with a user
  Future<void> shareEvent(String eventId, String userId) async {
    final eventsData = state.valueOrNull;
    if (eventsData == null) return;

    final event = eventsData.firstWhere(
      (e) => e.id == eventId,
      orElse: () => throw Exception('Event not found'),
    );

    final updatedSharedWith = [...event.sharedWithUserIds, userId];
    await updateEvent(event.copyWith(
      isShared: true,
      sharedWithUserIds: updatedSharedWith,
    ));

    // Create share record on server
    await _api.post('/events/$eventId/share', body: {'user_id': userId});
  }

  /// Unshare an event with a user
  Future<void> unshareEvent(String eventId, String userId) async {
    final eventsData = state.valueOrNull;
    if (eventsData == null) return;

    final event = eventsData.firstWhere(
      (e) => e.id == eventId,
      orElse: () => throw Exception('Event not found'),
    );

    final updatedSharedWith =
        event.sharedWithUserIds.where((id) => id != userId).toList();
    await updateEvent(event.copyWith(
      isShared: updatedSharedWith.isNotEmpty,
      sharedWithUserIds: updatedSharedWith,
    ));

    // Remove share record on server
    await _api.delete('/events/$eventId/share/$userId');
  }

  /// Refresh events from server
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _sync.sync();
    await _loadEvents();
  }

  @override
  void dispose() {
    _eventsSubscription?.cancel();
    super.dispose();
  }
}

/// Provider for event actions
final eventActionsProvider = Provider<EventActions>((ref) {
  return EventActions(ref);
});

/// Class containing event actions
class EventActions {
  final Ref _ref;

  EventActions(this._ref);

  EventsNotifier get _eventsNotifier => _ref.read(eventsProvider.notifier);

  Future<Event?> create(Event event) => _eventsNotifier.createEvent(event);
  Future<Event?> update(Event event) => _eventsNotifier.updateEvent(event);
  Future<void> delete(String eventId) => _eventsNotifier.deleteEvent(eventId);

  Future<void> updateStatus(String eventId, EventStatus status) =>
      _eventsNotifier.updateEventStatus(eventId, status);

  Future<void> addReminder(String eventId, EventReminder reminder) =>
      _eventsNotifier.addReminder(eventId, reminder);

  Future<void> removeReminder(String eventId, String reminderId) =>
      _eventsNotifier.removeReminder(eventId, reminderId);

  Future<void> share(String eventId, String userId) =>
      _eventsNotifier.shareEvent(eventId, userId);

  Future<void> unshare(String eventId, String userId) =>
      _eventsNotifier.unshareEvent(eventId, userId);

  Future<void> refresh() => _eventsNotifier.refresh();
}

/// Date range helper class
class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange(this.start, this.end);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DateRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}

/// Provider for selected date (for calendar views)
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

/// Provider for calendar view mode
final calendarViewModeProvider = StateProvider<CalendarViewMode>((ref) {
  final preferences = ref.watch(userPreferencesProvider);
  return CalendarViewMode.values.firstWhere(
    (mode) => mode.name == preferences.defaultCalendarView,
    orElse: () => CalendarViewMode.week,
  );
});

/// Calendar view modes
enum CalendarViewMode {
  day,
  week,
  month,
  agenda,
}
