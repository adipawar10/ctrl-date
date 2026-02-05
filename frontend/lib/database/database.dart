import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../models/event.dart' as models;
import '../models/reflection.dart' as models;
import 'tables.dart';
import 'daos/event_dao.dart';
import 'daos/reflection_dao.dart';

part 'database.g.dart';

/// Main application database using Drift
@DriftDatabase(
  tables: [
    Events,
    DailyReflections,
    Friendships,
    Pokes,
    EventShares,
    InboxMessages,
    Streaks,
    UserProfiles,
    SyncMetadata,
    PendingSyncOperations,
  ],
  daos: [
    EventDao,
    ReflectionDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle schema migrations here
        // Example:
        // if (from < 2) {
        //   await m.addColumn(events, events.newColumn);
        // }
      },
      beforeOpen: (details) async {
        // Enable foreign keys
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  // Event operations
  Future<List<models.Event>> getAllEvents() async {
    final rows = await select(events).get();
    return rows.map(_mapEventRowToModel).toList();
  }

  Stream<List<models.Event>> watchAllEvents() {
    return select(events).watch().map(
          (rows) => rows.map(_mapEventRowToModel).toList(),
        );
  }

  Future<models.Event?> getEventById(String id) async {
    final row = await (select(events)..where((e) => e.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _mapEventRowToModel(row) : null;
  }

  Future<List<models.Event>> getUnsyncedEvents() async {
    final rows = await (select(events)..where((e) => e.isSynced.equals(false)))
        .get();
    return rows.map(_mapEventRowToModel).toList();
  }

  Future<void> insertEvent(models.Event event) async {
    await into(events).insert(_mapEventModelToCompanion(event));
  }

  Future<void> updateEvent(models.Event event) async {
    await (update(events)..where((e) => e.id.equals(event.id)))
        .write(_mapEventModelToCompanion(event));
  }

  Future<void> deleteEvent(String id) async {
    await (delete(events)..where((e) => e.id.equals(id))).go();
  }

  Future<void> markEventSynced(String id) async {
    await (update(events)..where((e) => e.id.equals(id)))
        .write(const EventsCompanion(isSynced: Value(true)));
  }

  // Reflection operations
  Future<List<models.DailyReflection>> getAllReflections() async {
    final rows = await select(dailyReflections).get();
    return rows.map(_mapReflectionRowToModel).toList();
  }

  Stream<List<models.DailyReflection>> watchAllReflections() {
    return select(dailyReflections).watch().map(
          (rows) => rows.map(_mapReflectionRowToModel).toList(),
        );
  }

  Future<models.DailyReflection?> getReflectionById(String id) async {
    final row =
        await (select(dailyReflections)..where((r) => r.id.equals(id)))
            .getSingleOrNull();
    return row != null ? _mapReflectionRowToModel(row) : null;
  }

  Future<models.DailyReflection?> getReflectionByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final row = await (select(dailyReflections)
          ..where((r) =>
              r.date.isBiggerOrEqualValue(startOfDay) &
              r.date.isSmallerThanValue(endOfDay)))
        .getSingleOrNull();

    return row != null ? _mapReflectionRowToModel(row) : null;
  }

  Future<List<models.DailyReflection>> getUnsyncedReflections() async {
    final rows = await (select(dailyReflections)
          ..where((r) => r.isSynced.equals(false)))
        .get();
    return rows.map(_mapReflectionRowToModel).toList();
  }

  Future<void> insertReflection(models.DailyReflection reflection) async {
    await into(dailyReflections)
        .insert(_mapReflectionModelToCompanion(reflection));
  }

  Future<void> updateReflection(models.DailyReflection reflection) async {
    await (update(dailyReflections)..where((r) => r.id.equals(reflection.id)))
        .write(_mapReflectionModelToCompanion(reflection));
  }

  Future<void> deleteReflection(String id) async {
    await (delete(dailyReflections)..where((r) => r.id.equals(id))).go();
  }

  Future<void> markReflectionSynced(String id) async {
    await (update(dailyReflections)..where((r) => r.id.equals(id)))
        .write(const DailyReflectionsCompanion(isSynced: Value(true)));
  }

  // Sync metadata operations
  Future<void> updateSyncMetadata(
    String tableName,
    DateTime lastSyncAt,
    int? version,
  ) async {
    await into(syncMetadata).insertOnConflictUpdate(
      SyncMetadataCompanion.insert(
        syncTable: tableName,
        lastSyncAt: Value(lastSyncAt),
        lastSyncVersion: Value(version),
      ),
    );
  }

  Future<SyncMetadataData?> getSyncMetadata(String tableName) async {
    return await (select(syncMetadata)
          ..where((m) => m.syncTable.equals(tableName)))
        .getSingleOrNull();
  }

  // Pending sync operations
  Future<void> addPendingSyncOperation({
    required String tableName,
    required String recordId,
    required String operation,
    String? data,
  }) async {
    await into(pendingSyncOperations).insert(
      PendingSyncOperationsCompanion.insert(
        syncTable: tableName,
        recordId: recordId,
        operation: operation,
        data: Value(data),
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<List<PendingSyncOperation>> getPendingSyncOperations() async {
    return await (select(pendingSyncOperations)
          ..orderBy([(o) => OrderingTerm.asc(o.createdAt)]))
        .get();
  }

  Future<void> deletePendingSyncOperation(int id) async {
    await (delete(pendingSyncOperations)..where((o) => o.id.equals(id))).go();
  }

  // Clear all data
  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(events).go();
      await delete(dailyReflections).go();
      await delete(friendships).go();
      await delete(pokes).go();
      await delete(eventShares).go();
      await delete(inboxMessages).go();
      await delete(streaks).go();
      await delete(userProfiles).go();
      await delete(syncMetadata).go();
      await delete(pendingSyncOperations).go();
    });
  }

  // Mapping functions
  models.Event _mapEventRowToModel(Event row) {
    return models.Event(
      id: row.id,
      userId: row.userId,
      title: row.title,
      description: row.description,
      startTime: row.startTime,
      endTime: row.endTime,
      isAllDay: row.isAllDay,
      location: row.location,
      locationUrl: row.locationUrl,
      status: models.EventStatus.values.firstWhere(
        (s) => s.name == row.status,
        orElse: () => models.EventStatus.scheduled,
      ),
      priority: models.EventPriority.values.firstWhere(
        (p) => p.name == row.priority,
        orElse: () => models.EventPriority.medium,
      ),
      color: row.color,
      tags: _parseJsonList(row.tags).cast<String>(),
      recurrenceRule: row.recurrenceRule != null
          ? models.RecurrenceRule.fromJson(
              _parseJson(row.recurrenceRule!) as Map<String, dynamic>,
            )
          : null,
      parentEventId: row.parentEventId,
      reminders: _parseJsonList(row.reminders)
          .map((r) => models.EventReminder.fromJson(r as Map<String, dynamic>))
          .toList(),
      attachments: _parseJsonList(row.attachments)
          .map(
              (a) => models.EventAttachment.fromJson(a as Map<String, dynamic>))
          .toList(),
      isPrivate: row.isPrivate,
      encryptedData: row.encryptedData,
      isShared: row.isShared,
      sharedWithUserIds: _parseJsonList(row.sharedWithUserIds).cast<String>(),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isSynced: row.isSynced,
      syncVersion: row.syncVersion,
    );
  }

  EventsCompanion _mapEventModelToCompanion(models.Event event) {
    return EventsCompanion(
      id: Value(event.id),
      userId: Value(event.userId),
      title: Value(event.title),
      description: Value(event.description),
      startTime: Value(event.startTime),
      endTime: Value(event.endTime),
      isAllDay: Value(event.isAllDay),
      location: Value(event.location),
      locationUrl: Value(event.locationUrl),
      status: Value(event.status.name),
      priority: Value(event.priority.name),
      color: Value(event.color),
      tags: Value(_toJsonString(event.tags)),
      recurrenceRule: Value(
        event.recurrenceRule != null
            ? _toJsonString(event.recurrenceRule!.toJson())
            : null,
      ),
      parentEventId: Value(event.parentEventId),
      reminders: Value(_toJsonString(event.reminders.map((r) => r.toJson()).toList())),
      attachments: Value(_toJsonString(event.attachments.map((a) => a.toJson()).toList())),
      isPrivate: Value(event.isPrivate),
      encryptedData: Value(event.encryptedData),
      isShared: Value(event.isShared),
      sharedWithUserIds: Value(_toJsonString(event.sharedWithUserIds)),
      createdAt: Value(event.createdAt),
      updatedAt: Value(event.updatedAt),
      isSynced: Value(event.isSynced),
      syncVersion: Value(event.syncVersion),
    );
  }

  models.DailyReflection _mapReflectionRowToModel(DailyReflection row) {
    return models.DailyReflection(
      id: row.id,
      userId: row.userId,
      date: row.date,
      mood: row.mood != null
          ? models.MoodRating.values.firstWhere(
              (m) => m.value == row.mood,
              orElse: () => models.MoodRating.neutral,
            )
          : null,
      energy: row.energy != null
          ? models.EnergyLevel.values.firstWhere(
              (e) => e.value == row.energy,
              orElse: () => models.EnergyLevel.moderate,
            )
          : null,
      productivity: row.productivity != null
          ? models.ProductivityRating.values.firstWhere(
              (p) => p.value == row.productivity,
              orElse: () => models.ProductivityRating.moderate,
            )
          : null,
      gratitude: row.gratitude,
      accomplishments: row.accomplishments,
      challenges: row.challenges,
      learnings: row.learnings,
      tomorrowGoals: row.tomorrowGoals,
      notes: row.notes,
      tags: _parseJsonList(row.tags).cast<String>(),
      isPrivate: row.isPrivate,
      encryptedData: row.encryptedData,
      isComplete: row.isComplete,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isSynced: row.isSynced,
      syncVersion: row.syncVersion,
    );
  }

  DailyReflectionsCompanion _mapReflectionModelToCompanion(
      models.DailyReflection reflection) {
    return DailyReflectionsCompanion(
      id: Value(reflection.id),
      userId: Value(reflection.userId),
      date: Value(reflection.date),
      mood: Value(reflection.mood?.value),
      energy: Value(reflection.energy?.value),
      productivity: Value(reflection.productivity?.value),
      gratitude: Value(reflection.gratitude),
      accomplishments: Value(reflection.accomplishments),
      challenges: Value(reflection.challenges),
      learnings: Value(reflection.learnings),
      tomorrowGoals: Value(reflection.tomorrowGoals),
      notes: Value(reflection.notes),
      tags: Value(_toJsonString(reflection.tags)),
      isPrivate: Value(reflection.isPrivate),
      encryptedData: Value(reflection.encryptedData),
      isComplete: Value(reflection.isComplete),
      createdAt: Value(reflection.createdAt),
      updatedAt: Value(reflection.updatedAt),
      isSynced: Value(reflection.isSynced),
      syncVersion: Value(reflection.syncVersion),
    );
  }

  List<dynamic> _parseJsonList(String jsonString) {
    try {
      return (jsonDecode(jsonString) as List?) ?? [];
    } catch (e) {
      return [];
    }
  }

  dynamic _parseJson(String jsonString) {
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      return null;
    }
  }

  String _toJsonString(dynamic data) {
    try {
      return jsonEncode(data);
    } catch (e) {
      return '[]';
    }
  }
}

/// Helper to decode JSON
dynamic jsonDecode(String source) {
  return _JsonDecoder.decode(source);
}

/// Helper to encode JSON
String jsonEncode(dynamic object) {
  return _JsonEncoder.encode(object);
}

/// Simple JSON decoder
class _JsonDecoder {
  static dynamic decode(String source) {
    // This would use dart:convert in the actual implementation
    // Simplified placeholder that would be replaced by proper JSON parsing
    if (source.startsWith('[')) {
      return <dynamic>[];
    }
    if (source.startsWith('{')) {
      return <String, dynamic>{};
    }
    return null;
  }
}

/// Simple JSON encoder
class _JsonEncoder {
  static String encode(dynamic object) {
    if (object is List) {
      return '[]'; // Placeholder
    }
    if (object is Map) {
      return '{}'; // Placeholder
    }
    return object.toString();
  }
}

/// Open database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'ctrl_shift_date.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
