import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'reflection_dao.g.dart';

/// Data Access Object for DailyReflection operations
@DriftAccessor(tables: [DailyReflections])
class ReflectionDao extends DatabaseAccessor<AppDatabase>
    with _$ReflectionDaoMixin {
  ReflectionDao(super.db);

  /// Get all reflections ordered by date (most recent first)
  Future<List<DailyReflection>> getAllReflections() {
    return (select(dailyReflections)
          ..orderBy([(r) => OrderingTerm.desc(r.date)]))
        .get();
  }

  /// Watch all reflections (reactive)
  Stream<List<DailyReflection>> watchAllReflections() {
    return (select(dailyReflections)
          ..orderBy([(r) => OrderingTerm.desc(r.date)]))
        .watch();
  }

  /// Get reflection by ID
  Future<DailyReflection?> getReflectionById(String id) {
    return (select(dailyReflections)..where((r) => r.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get reflection for a specific date
  Future<DailyReflection?> getReflectionForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(dailyReflections)
          ..where((r) =>
              r.date.isBiggerOrEqualValue(startOfDay) &
              r.date.isSmallerThanValue(endOfDay)))
        .getSingleOrNull();
  }

  /// Watch reflection for a specific date (reactive)
  Stream<DailyReflection?> watchReflectionForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(dailyReflections)
          ..where((r) =>
              r.date.isBiggerOrEqualValue(startOfDay) &
              r.date.isSmallerThanValue(endOfDay)))
        .watchSingleOrNull();
  }

  /// Get reflections for a date range
  Future<List<DailyReflection>> getReflectionsForDateRange(
    DateTime start,
    DateTime end,
  ) {
    return (select(dailyReflections)
          ..where((r) =>
              r.date.isBiggerOrEqualValue(start) &
              r.date.isSmallerThanValue(end))
          ..orderBy([(r) => OrderingTerm.desc(r.date)]))
        .get();
  }

  /// Watch reflections for a date range (reactive)
  Stream<List<DailyReflection>> watchReflectionsForDateRange(
    DateTime start,
    DateTime end,
  ) {
    return (select(dailyReflections)
          ..where((r) =>
              r.date.isBiggerOrEqualValue(start) &
              r.date.isSmallerThanValue(end))
          ..orderBy([(r) => OrderingTerm.desc(r.date)]))
        .watch();
  }

  /// Get unsynced reflections
  Future<List<DailyReflection>> getUnsyncedReflections() {
    return (select(dailyReflections)..where((r) => r.isSynced.equals(false)))
        .get();
  }

  /// Get recent reflections
  Future<List<DailyReflection>> getRecentReflections({int limit = 7}) {
    return (select(dailyReflections)
          ..orderBy([(r) => OrderingTerm.desc(r.date)])
          ..limit(limit))
        .get();
  }

  /// Get reflections by mood rating
  Future<List<DailyReflection>> getReflectionsByMood(int moodValue) {
    return (select(dailyReflections)
          ..where((r) => r.mood.equals(moodValue))
          ..orderBy([(r) => OrderingTerm.desc(r.date)]))
        .get();
  }

  /// Get completed reflections
  Future<List<DailyReflection>> getCompletedReflections() {
    return (select(dailyReflections)
          ..where((r) => r.isComplete.equals(true))
          ..orderBy([(r) => OrderingTerm.desc(r.date)]))
        .get();
  }

  /// Get incomplete reflections
  Future<List<DailyReflection>> getIncompleteReflections() {
    return (select(dailyReflections)
          ..where((r) => r.isComplete.equals(false))
          ..orderBy([(r) => OrderingTerm.desc(r.date)]))
        .get();
  }

  /// Search reflections
  Future<List<DailyReflection>> searchReflections(String query) {
    final lowerQuery = '%${query.toLowerCase()}%';
    return (select(dailyReflections)
          ..where((r) =>
              r.gratitude.lower().like(lowerQuery) |
              r.accomplishments.lower().like(lowerQuery) |
              r.challenges.lower().like(lowerQuery) |
              r.learnings.lower().like(lowerQuery) |
              r.notes.lower().like(lowerQuery))
          ..orderBy([(r) => OrderingTerm.desc(r.date)]))
        .get();
  }

  /// Insert a new reflection
  Future<void> insertReflection(DailyReflectionsCompanion reflection) {
    return into(dailyReflections).insert(reflection);
  }

  /// Insert or update reflection (upsert)
  Future<void> upsertReflection(DailyReflectionsCompanion reflection) {
    return into(dailyReflections).insertOnConflictUpdate(reflection);
  }

  /// Update an existing reflection
  Future<bool> updateReflection(DailyReflectionsCompanion reflection) {
    return update(dailyReflections).replace(reflection);
  }

  /// Delete a reflection by ID
  Future<int> deleteReflectionById(String id) {
    return (delete(dailyReflections)..where((r) => r.id.equals(id))).go();
  }

  /// Mark reflection as synced
  Future<void> markAsSynced(String id) {
    return (update(dailyReflections)..where((r) => r.id.equals(id)))
        .write(const DailyReflectionsCompanion(isSynced: Value(true)));
  }

  /// Batch mark reflections as synced
  Future<void> batchMarkAsSynced(List<String> ids) {
    return (update(dailyReflections)..where((r) => r.id.isIn(ids)))
        .write(const DailyReflectionsCompanion(isSynced: Value(true)));
  }

  /// Get total reflections count
  Future<int> getReflectionsCount() async {
    final count = countAll();
    final query = selectOnly(dailyReflections)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Get reflections count for a specific month
  Future<int> getReflectionsCountForMonth(int year, int month) async {
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = DateTime(year, month + 1, 1);

    final count = countAll();
    final query = selectOnly(dailyReflections)
      ..addColumns([count])
      ..where(dailyReflections.date.isBiggerOrEqualValue(startOfMonth) &
          dailyReflections.date.isSmallerThanValue(endOfMonth));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Get average mood for a date range
  Future<double?> getAverageMoodForDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final avgMood = dailyReflections.mood.avg();
    final query = selectOnly(dailyReflections)
      ..addColumns([avgMood])
      ..where(dailyReflections.date.isBiggerOrEqualValue(start) &
          dailyReflections.date.isSmallerThanValue(end) &
          dailyReflections.mood.isNotNull());
    final result = await query.getSingle();
    return result.read(avgMood);
  }

  /// Get average energy for a date range
  Future<double?> getAverageEnergyForDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final avgEnergy = dailyReflections.energy.avg();
    final query = selectOnly(dailyReflections)
      ..addColumns([avgEnergy])
      ..where(dailyReflections.date.isBiggerOrEqualValue(start) &
          dailyReflections.date.isSmallerThanValue(end) &
          dailyReflections.energy.isNotNull());
    final result = await query.getSingle();
    return result.read(avgEnergy);
  }

  /// Get average productivity for a date range
  Future<double?> getAverageProductivityForDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final avgProductivity = dailyReflections.productivity.avg();
    final query = selectOnly(dailyReflections)
      ..addColumns([avgProductivity])
      ..where(dailyReflections.date.isBiggerOrEqualValue(start) &
          dailyReflections.date.isSmallerThanValue(end) &
          dailyReflections.productivity.isNotNull());
    final result = await query.getSingle();
    return result.read(avgProductivity);
  }

  /// Get dates with reflections for a month (for calendar highlighting)
  Future<List<DateTime>> getReflectionDatesForMonth(int year, int month) async {
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = DateTime(year, month + 1, 1);

    final reflections = await (select(dailyReflections)
          ..where((r) =>
              r.date.isBiggerOrEqualValue(startOfMonth) &
              r.date.isSmallerThanValue(endOfMonth)))
        .get();

    return reflections.map((r) => r.date).toList();
  }

  /// Delete all reflections for a user
  Future<int> deleteAllReflectionsForUser(String userId) {
    return (delete(dailyReflections)..where((r) => r.userId.equals(userId)))
        .go();
  }

  /// Get streak data (consecutive days with reflections)
  Future<int> calculateCurrentStreak(String userId) async {
    final reflections = await (select(dailyReflections)
          ..where((r) =>
              r.userId.equals(userId) & r.isComplete.equals(true))
          ..orderBy([(r) => OrderingTerm.desc(r.date)]))
        .get();

    if (reflections.isEmpty) return 0;

    int streak = 0;
    DateTime? expectedDate = DateTime.now();

    for (final reflection in reflections) {
      final reflectionDate = DateTime(
        reflection.date.year,
        reflection.date.month,
        reflection.date.day,
      );
      final expected = DateTime(
        expectedDate!.year,
        expectedDate.month,
        expectedDate.day,
      );

      // Check if this reflection is for today or the expected date
      final difference = expected.difference(reflectionDate).inDays;

      if (difference == 0 || (streak == 0 && difference == 1)) {
        streak++;
        expectedDate = reflectionDate.subtract(const Duration(days: 1));
      } else if (difference == 1) {
        streak++;
        expectedDate = reflectionDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }
}
