import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'event_dao.g.dart';

/// Data Access Object for Event operations
@DriftAccessor(tables: [Events])
class EventDao extends DatabaseAccessor<AppDatabase> with _$EventDaoMixin {
  EventDao(super.db);

  /// Get all events ordered by start time
  Future<List<Event>> getAllEvents() {
    return (select(events)
          ..orderBy([(e) => OrderingTerm.asc(e.startTime)]))
        .get();
  }

  /// Watch all events (reactive)
  Stream<List<Event>> watchAllEvents() {
    return (select(events)
          ..orderBy([(e) => OrderingTerm.asc(e.startTime)]))
        .watch();
  }

  /// Get event by ID
  Future<Event?> getEventById(String id) {
    return (select(events)..where((e) => e.id.equals(id))).getSingleOrNull();
  }

  /// Get events for a specific date
  Future<List<Event>> getEventsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(events)
          ..where((e) =>
              e.startTime.isBiggerOrEqualValue(startOfDay) &
              e.startTime.isSmallerThanValue(endOfDay))
          ..orderBy([(e) => OrderingTerm.asc(e.startTime)]))
        .get();
  }

  /// Watch events for a specific date (reactive)
  Stream<List<Event>> watchEventsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(events)
          ..where((e) =>
              e.startTime.isBiggerOrEqualValue(startOfDay) &
              e.startTime.isSmallerThanValue(endOfDay))
          ..orderBy([(e) => OrderingTerm.asc(e.startTime)]))
        .watch();
  }

  /// Get events for a date range
  Future<List<Event>> getEventsForDateRange(DateTime start, DateTime end) {
    return (select(events)
          ..where((e) =>
              e.startTime.isBiggerOrEqualValue(start) &
              e.startTime.isSmallerThanValue(end))
          ..orderBy([(e) => OrderingTerm.asc(e.startTime)]))
        .get();
  }

  /// Watch events for a date range (reactive)
  Stream<List<Event>> watchEventsForDateRange(DateTime start, DateTime end) {
    return (select(events)
          ..where((e) =>
              e.startTime.isBiggerOrEqualValue(start) &
              e.startTime.isSmallerThanValue(end))
          ..orderBy([(e) => OrderingTerm.asc(e.startTime)]))
        .watch();
  }

  /// Get events by status
  Future<List<Event>> getEventsByStatus(String status) {
    return (select(events)
          ..where((e) => e.status.equals(status))
          ..orderBy([(e) => OrderingTerm.asc(e.startTime)]))
        .get();
  }

  /// Get unsynced events
  Future<List<Event>> getUnsyncedEvents() {
    return (select(events)..where((e) => e.isSynced.equals(false))).get();
  }

  /// Get upcoming events (starting from now)
  Future<List<Event>> getUpcomingEvents({int limit = 10}) {
    return (select(events)
          ..where((e) => e.startTime.isBiggerOrEqualValue(DateTime.now()))
          ..orderBy([(e) => OrderingTerm.asc(e.startTime)])
          ..limit(limit))
        .get();
  }

  /// Get past events
  Future<List<Event>> getPastEvents({int limit = 10}) {
    return (select(events)
          ..where((e) => e.endTime.isSmallerThanValue(DateTime.now()))
          ..orderBy([(e) => OrderingTerm.desc(e.startTime)])
          ..limit(limit))
        .get();
  }

  /// Get events shared with a specific user
  Future<List<Event>> getSharedEvents() {
    return (select(events)
          ..where((e) => e.isShared.equals(true))
          ..orderBy([(e) => OrderingTerm.asc(e.startTime)]))
        .get();
  }

  /// Get recurring events
  Future<List<Event>> getRecurringEvents() {
    return (select(events)
          ..where((e) => e.recurrenceRule.isNotNull())
          ..orderBy([(e) => OrderingTerm.asc(e.startTime)]))
        .get();
  }

  /// Get child events of a recurring event
  Future<List<Event>> getChildEvents(String parentEventId) {
    return (select(events)
          ..where((e) => e.parentEventId.equals(parentEventId))
          ..orderBy([(e) => OrderingTerm.asc(e.startTime)]))
        .get();
  }

  /// Search events by title or description
  Future<List<Event>> searchEvents(String query) {
    final lowerQuery = '%${query.toLowerCase()}%';
    return (select(events)
          ..where((e) =>
              e.title.lower().like(lowerQuery) |
              e.description.lower().like(lowerQuery))
          ..orderBy([(e) => OrderingTerm.asc(e.startTime)]))
        .get();
  }

  /// Insert a new event
  Future<void> insertEvent(EventsCompanion event) {
    return into(events).insert(event);
  }

  /// Update an existing event
  Future<bool> updateEvent(EventsCompanion event) {
    return update(events).replace(event);
  }

  /// Delete an event by ID
  Future<int> deleteEventById(String id) {
    return (delete(events)..where((e) => e.id.equals(id))).go();
  }

  /// Mark event as synced
  Future<void> markAsSynced(String id) {
    return (update(events)..where((e) => e.id.equals(id)))
        .write(const EventsCompanion(isSynced: Value(true)));
  }

  /// Batch mark events as synced
  Future<void> batchMarkAsSynced(List<String> ids) {
    return (update(events)..where((e) => e.id.isIn(ids)))
        .write(const EventsCompanion(isSynced: Value(true)));
  }

  /// Get events count
  Future<int> getEventsCount() async {
    final count = countAll();
    final query = selectOnly(events)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Get events count for a specific date
  Future<int> getEventsCountForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final count = countAll();
    final query = selectOnly(events)
      ..addColumns([count])
      ..where(events.startTime.isBiggerOrEqualValue(startOfDay) &
          events.startTime.isSmallerThanValue(endOfDay));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Delete all events for a user
  Future<int> deleteAllEventsForUser(String userId) {
    return (delete(events)..where((e) => e.userId.equals(userId))).go();
  }

  /// Delete past events older than a specific date
  Future<int> deletePastEvents(DateTime olderThan) {
    return (delete(events)..where((e) => e.endTime.isSmallerThanValue(olderThan)))
        .go();
  }
}
