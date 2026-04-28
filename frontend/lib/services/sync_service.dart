import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/database.dart' hide Event, DailyReflection;
import '../models/event.dart';
import '../models/reflection.dart';
import 'api_service.dart';
import 'encryption_service.dart';

/// Offline-first sync service for managing local and remote data synchronization
class SyncService {
  SyncService._();

  static final SyncService _instance = SyncService._();
  static SyncService get instance => _instance;

  final SupabaseClient _supabase = Supabase.instance.client;
  final ApiService _api = ApiService.instance;
  final EncryptionService _encryption = EncryptionService.instance;

  AppDatabase? _database;

  Timer? _syncTimer;
  bool _isSyncing = false;
  bool _syncQueued = false;
  Completer<SyncResult>? _activeSyncCompleter;
  DateTime? _lastSyncTime;

  final _syncStatusController = StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  static const String _lastSyncKey = 'last_sync_time';
  static const String _pendingChangesKey = 'pending_changes';

  /// Initialize the sync service with a database instance
  void initialize(AppDatabase database) {
    _database = database;
    _loadLastSyncTime();
    _setupRealtimeSubscription();
  }

  /// Start periodic sync
  void startPeriodicSync({Duration interval = const Duration(minutes: 15)}) {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(interval, (_) => sync());
  }

  /// Stop periodic sync
  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  /// Perform a full sync
  Future<SyncResult> sync() async {
    if (_isSyncing) {
      _syncQueued = true;
      return await (_activeSyncCompleter?.future ??
          Future.value(
            SyncResult(
              success: true,
              message: 'Sync already in progress, queued another run',
            ),
          ));
    }

    _isSyncing = true;
    _activeSyncCompleter = Completer<SyncResult>();
    try {
      SyncResult latestResult = SyncResult(
        success: true,
        message: 'Sync completed successfully',
      );
      do {
        _syncQueued = false;
        _syncStatusController.add(SyncStatus.syncing);

        // Step 1: Push local changes to server
        final pushResult = await _pushLocalChanges();
        if (!pushResult.success) {
          _syncStatusController.add(SyncStatus.error);
          _activeSyncCompleter?.complete(pushResult);
          return pushResult;
        }

        // Step 2: Pull remote changes
        final pullResult = await _pullRemoteChanges();
        if (!pullResult.success) {
          _syncStatusController.add(SyncStatus.error);
          _activeSyncCompleter?.complete(pullResult);
          return pullResult;
        }

        // Step 3: Resolve conflicts
        final conflictResult = await _resolveConflicts();
        if (!conflictResult.success) {
          _syncStatusController.add(SyncStatus.error);
          _activeSyncCompleter?.complete(conflictResult);
          return conflictResult;
        }

        // Update last sync time
        _lastSyncTime = DateTime.now();
        await _saveLastSyncTime();

        latestResult = SyncResult(
          success: true,
          message: 'Sync completed successfully',
          itemsPushed: pushResult.itemsPushed,
          itemsPulled: pullResult.itemsPulled,
          conflictsResolved: conflictResult.conflictsResolved,
        );
      } while (_syncQueued);

      _syncStatusController.add(SyncStatus.synced);
      _activeSyncCompleter?.complete(latestResult);
      return latestResult;
    } catch (e) {
      _syncStatusController.add(SyncStatus.error);
      final errorResult = SyncResult(
        success: false,
        message: 'Sync failed: ${e.toString()}',
      );
      _activeSyncCompleter?.complete(errorResult);
      return errorResult;
    } finally {
      _isSyncing = false;
      _activeSyncCompleter = null;
    }
  }

  /// Push local changes to the server
  Future<SyncResult> _pushLocalChanges() async {
    if (_database == null) {
      return SyncResult(success: false, message: 'Database not initialized');
    }

    int itemsPushed = 0;

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        return SyncResult(
          success: true,
          message: 'Not signed in',
          itemsPushed: 0,
        );
      }

      // Get unsynced events for this account only
      final unsyncedEvents =
          await _database!.getUnsyncedEventsForUserId(userId);

      for (final event in unsyncedEvents) {
        final eventData = _prepareEventForSync(event);

        final response = await _api.post(
          '/events',
          body: eventData,
        );

        if (response.isSuccess) {
          await _database!.markEventSynced(event.id);
          itemsPushed++;
        } else {
          // Store for retry
          await _storePendingChange('event', event.id, eventData);
        }
      }

      // Get unsynced reflections for this account only
      final unsyncedReflections =
          await _database!.getUnsyncedReflectionsForUserId(userId);

      for (final reflection in unsyncedReflections) {
        final reflectionData = _prepareReflectionForSync(reflection);
        final reflectionDate =
            reflection.date.toIso8601String().split('T').first;
        final eventStats = _deriveReflectionEventStats(reflection);

        final response = await _api.post(
          '/reflections/$reflectionDate',
          body: {
            'notes': reflection.notes,
            'mood': reflection.mood?.value,
            ...eventStats,
          },
        );

        if (response.isSuccess) {
          await _database!.markReflectionSynced(reflection.id);
          itemsPushed++;
        } else {
          await _storePendingChange(
              'reflection', reflection.id, reflectionData);
        }
      }

      // Retry pending changes
      await _retryPendingChanges();

      return SyncResult(
        success: true,
        message: 'Local changes pushed',
        itemsPushed: itemsPushed,
      );
    } catch (e) {
      return SyncResult(
        success: false,
        message: 'Failed to push local changes: ${e.toString()}',
      );
    }
  }

  /// Pull remote changes from the server
  Future<SyncResult> _pullRemoteChanges() async {
    if (_database == null) {
      return SyncResult(success: false, message: 'Database not initialized');
    }

    int itemsPulled = 0;

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        return SyncResult(
          success: true,
          message: 'Not signed in',
          itemsPulled: 0,
        );
      }

      final now = DateTime.now();
      final eventRangeStart = now.subtract(const Duration(days: 30));
      final eventRangeEnd = now.add(const Duration(days: 365));

      // Pull events
      final eventsResponse = await _api.get<Map<String, dynamic>>(
        '/events',
        queryParams: {
          'start': eventRangeStart.toIso8601String(),
          'end': eventRangeEnd.toIso8601String(),
        },
      );

      if (eventsResponse.isSuccess && eventsResponse.data != null) {
        final remoteEventsRaw = (eventsResponse.data!['events'] as List?) ?? [];
        final remoteEventMaps =
            remoteEventsRaw.whereType<Map<String, dynamic>>().toList()
              ..sort((a, b) {
                final aIsInstance =
                    (a['recurrence_parent_id']?.toString().isNotEmpty ?? false);
                final bIsInstance =
                    (b['recurrence_parent_id']?.toString().isNotEmpty ?? false);
                if (aIsInstance == bIsInstance) return 0;
                return aIsInstance ? 1 : -1; // parent/base events first
              });

        for (final eventJson in remoteEventMaps) {
          try {
            final event = _eventFromApi(eventJson);
            if (event.userId != userId) continue;

            // Decrypt if needed
            final decryptedEvent = await _decryptEventIfNeeded(event);

            // Check for local version
            final localEvent = await _database!.getEventById(event.id);

            if (localEvent == null) {
              await _database!.insertEvent(decryptedEvent);
              itemsPulled++;
            } else if (_shouldUpdateLocal(localEvent, decryptedEvent)) {
              await _database!.updateEvent(
                _mergePulledEvent(localEvent, decryptedEvent),
              );
              itemsPulled++;
            }
          } catch (e) {
            debugPrint('Skipping malformed/failed event during pull: $e');
          }
        }
      }

      // Pull reflections
      final reflectionsResponse = await _api.get<Map<String, dynamic>>(
        '/reflections',
        queryParams: {
          'start_date': DateTime(now.year, now.month, now.day)
              .subtract(const Duration(days: 30))
              .toIso8601String()
              .split('T')[0],
          'end_date': DateTime(now.year, now.month, now.day)
              .add(const Duration(days: 365))
              .toIso8601String()
              .split('T')[0],
        },
      );

      if (reflectionsResponse.isSuccess && reflectionsResponse.data != null) {
        final remoteReflections =
            (reflectionsResponse.data!['reflections'] as List?) ?? [];
        for (final reflectionJson in remoteReflections) {
          final reflection =
              _reflectionFromApi(reflectionJson as Map<String, dynamic>);
          if (reflection.userId != userId) continue;

          // Decrypt if needed
          final decryptedReflection =
              await _decryptReflectionIfNeeded(reflection);

          final localReflection =
              await _database!.getReflectionById(reflection.id);

          if (localReflection == null) {
            await _database!.insertReflection(decryptedReflection);
            itemsPulled++;
          } else if (_shouldUpdateLocal(localReflection, decryptedReflection)) {
            await _database!.updateReflection(decryptedReflection);
            itemsPulled++;
          }
        }
      }

      return SyncResult(
        success: true,
        message: 'Remote changes pulled',
        itemsPulled: itemsPulled,
      );
    } catch (e) {
      return SyncResult(
        success: false,
        message: 'Failed to pull remote changes: ${e.toString()}',
      );
    }
  }

  /// Remote payloads often omit nested recurrence/reminders; avoid wiping local
  /// columns on merge.
  Event _mergePulledEvent(Event local, Event remote) {
    return remote.copyWith(
      recurrenceRule: remote.recurrenceRule ?? local.recurrenceRule,
      reminders:
          remote.reminders.isNotEmpty ? remote.reminders : local.reminders,
      attachments: remote.attachments.isNotEmpty
          ? remote.attachments
          : local.attachments,
    );
  }

  Event _eventFromApi(Map<String, dynamic> json) {
    // Backend timestamps may include UTC offsets. Convert to local so calendar
    // UI always renders the user's local wall-clock time.
    final start =
        DateTime.parse((json['start_time'] ?? json['startTime']) as String)
            .toLocal();
    final end = DateTime.parse((json['end_time'] ?? json['endTime']) as String)
        .toLocal();
    final statusRaw = (json['status'] ?? 'scheduled').toString();
    final priorityRaw = json['priority'];
    final priority = switch (priorityRaw) {
      int p when p <= 1 => EventPriority.low,
      int p when p == 2 => EventPriority.medium,
      int p when p == 3 => EventPriority.high,
      int p when p >= 4 => EventPriority.urgent,
      String s when s == 'low' => EventPriority.low,
      String s when s == 'high' => EventPriority.high,
      String s when s == 'urgent' => EventPriority.urgent,
      _ => EventPriority.medium,
    };
    final status = EventStatus.values.firstWhere(
      (s) => s.name == statusRaw || s.name == statusRaw.replaceAll('_', ''),
      orElse: () {
        switch (statusRaw) {
          case 'in_progress':
            return EventStatus.inProgress;
          default:
            return EventStatus.scheduled;
        }
      },
    );

    RecurrenceRule? recurrenceRule;
    final recurrenceRaw = json['recurrence_rule'] ?? json['recurrenceRule'];
    if (recurrenceRaw is Map<String, dynamic>) {
      final normalized = Map<String, dynamic>.from(recurrenceRaw);
      if (normalized['byWeekDay'] == null &&
          (normalized['by_weekday'] ?? normalized['by_week_day']) != null) {
        normalized['byWeekDay'] =
            (normalized['by_weekday'] ?? normalized['by_week_day']) as List;
      }
      if (normalized['byMonthDay'] == null &&
          normalized['by_monthday'] != null) {
        normalized['byMonthDay'] = normalized['by_monthday'] as List;
      }
      if (normalized['byMonth'] == null && normalized['by_month'] != null) {
        normalized['byMonth'] = normalized['by_month'] as List;
      }
      if (normalized['until'] == null && normalized['until_date'] != null) {
        normalized['until'] = normalized['until_date'];
      }
      try {
        recurrenceRule = RecurrenceRule.fromJson(normalized);
      } catch (_) {
        recurrenceRule = null;
      }
    }

    return Event(
      id: (json['id'] ?? '').toString(),
      userId: (json['owner_id'] ?? json['userId'] ?? '').toString(),
      title: (json['title'] ?? 'Untitled event').toString(),
      description: json['description']?.toString(),
      startTime: start,
      endTime: end,
      isAllDay:
          (json['all_day'] as bool?) ?? (json['isAllDay'] as bool?) ?? false,
      location: json['location']?.toString(),
      status: status,
      priority: priority,
      color: json['color']?.toString(),
      tags: ((json['tags'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      recurrenceRule: recurrenceRule,
      parentEventId:
          (json['recurrence_parent_id'] ?? json['parentEventId'])?.toString(),
      isPrivate: (json['is_private'] as bool?) ?? false,
      encryptedData: json['encrypted_data']?.toString(),
      isShared: (json['is_shared'] as bool?) ?? false,
      sharedWithUserIds: ((json['shared_with_user_ids'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      isSynced: true,
    );
  }

  DailyReflection _reflectionFromApi(Map<String, dynamic> json) {
    MoodRating? moodFromInt(dynamic value) {
      if (value is! int) return null;
      for (final mood in MoodRating.values) {
        if (mood.value == value) return mood;
      }
      return null;
    }

    return DailyReflection(
      id: (json['id'] ?? '').toString(),
      userId: (json['user_id'] ?? json['userId'] ?? '').toString(),
      date: DateTime.parse(
        (json['reflection_date'] ?? json['date']).toString(),
      ),
      mood: moodFromInt(json['mood']),
      gratitude: json['gratitude']?.toString(),
      accomplishments: json['accomplishments']?.toString(),
      challenges: json['challenges']?.toString(),
      learnings: json['learnings']?.toString(),
      notes: json['notes']?.toString(),
      tags: ((json['tags'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      isPrivate: (json['is_private'] as bool?) ?? false,
      encryptedData: json['encrypted_data']?.toString(),
      isComplete: (json['is_complete'] as bool?) ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      isSynced: true,
    );
  }

  /// Resolve conflicts between local and remote data
  Future<SyncResult> _resolveConflicts() async {
    // Conflict resolution strategy:
    // 1. If only local changed -> push to server
    // 2. If only remote changed -> update local
    // 3. If both changed -> use most recent (by updatedAt)
    // 4. If no timestamp available -> server wins

    // For now, we use a simple "last write wins" strategy
    // More sophisticated conflict resolution can be implemented as needed

    return SyncResult(
      success: true,
      message: 'Conflicts resolved',
      conflictsResolved: 0,
    );
  }

  /// Prepare event data for sync (encrypt if private)
  Map<String, dynamic> _prepareEventForSync(Event event) {
    final priorityInt = switch (event.priority) {
      EventPriority.low => 1,
      EventPriority.medium => 2,
      EventPriority.high => 3,
      EventPriority.urgent => 4,
    };

    final data = <String, dynamic>{
      'title': event.title,
      'description': event.description,
      'location': event.location,
      'start_time': event.startTime.toUtc().toIso8601String(),
      'end_time': event.endTime.toUtc().toIso8601String(),
      'all_day': event.isAllDay,
      'timezone': DateTime.now().timeZoneName,
      'is_locked': false,
      'priority': priorityInt,
      'color': event.color,
      'tags': event.tags,
    };

    if (event.recurrenceRule != null) {
      final r = event.recurrenceRule!;
      data['recurrence_rule'] = {
        'frequency': r.frequency.name,
        'interval': r.interval,
        'by_weekday': r.byWeekDay,
        'by_monthday': r.byMonthDay,
        'by_month': r.byMonth,
        'count': r.count,
        if (r.until != null)
          'until_date': r.until!.toIso8601String().split('T').first,
      };
    }

    if (event.isPrivate) {
      // Encrypt sensitive fields
      final sensitiveData = {
        'title': event.title,
        'description': event.description,
        'location': event.location,
      };

      final encrypted = _encryption.encryptData(jsonEncode(sensitiveData));
      data['encrypted_data'] = encrypted;
      data['title'] = 'Private Event';
      data['description'] = null;
      data['location'] = null;
    }

    return data;
  }

  /// Prepare reflection data for sync (encrypt if private)
  Map<String, dynamic> _prepareReflectionForSync(DailyReflection reflection) {
    var data = reflection.toJson();
    data.addAll(_deriveReflectionEventStats(reflection));

    if (reflection.isPrivate) {
      final sensitiveData = {
        'gratitude': reflection.gratitude,
        'accomplishments': reflection.accomplishments,
        'challenges': reflection.challenges,
        'learnings': reflection.learnings,
        'notes': reflection.notes,
      };

      final encrypted = _encryption.encryptData(jsonEncode(sensitiveData));
      data['encrypted_data'] = encrypted;
      data['gratitude'] = null;
      data['accomplishments'] = null;
      data['challenges'] = null;
      data['learnings'] = null;
      data['notes'] = null;
    }

    return data;
  }

  /// Decrypt event data if encrypted
  Future<Event> _decryptEventIfNeeded(Event event) async {
    if (event.encryptedData == null || event.encryptedData!.isEmpty) {
      return event;
    }

    try {
      final decrypted = _encryption.decryptData(event.encryptedData!);
      final sensitiveData = jsonDecode(decrypted) as Map<String, dynamic>;

      return event.copyWith(
        title: sensitiveData['title'] as String? ?? event.title,
        description: sensitiveData['description'] as String?,
        location: sensitiveData['location'] as String?,
        encryptedData: null,
      );
    } catch (e) {
      debugPrint('Failed to decrypt event: $e');
      return event;
    }
  }

  /// Decrypt reflection data if encrypted
  Future<DailyReflection> _decryptReflectionIfNeeded(
      DailyReflection reflection) async {
    if (reflection.encryptedData == null || reflection.encryptedData!.isEmpty) {
      return reflection;
    }

    try {
      final decrypted = _encryption.decryptData(reflection.encryptedData!);
      final sensitiveData = jsonDecode(decrypted) as Map<String, dynamic>;

      return reflection.copyWith(
        gratitude: sensitiveData['gratitude'] as String?,
        accomplishments: sensitiveData['accomplishments'] as String?,
        challenges: sensitiveData['challenges'] as String?,
        learnings: sensitiveData['learnings'] as String?,
        notes: sensitiveData['notes'] as String?,
        encryptedData: null,
      );
    } catch (e) {
      debugPrint('Failed to decrypt reflection: $e');
      return reflection;
    }
  }

  /// Determine if local record should be updated with remote version
  bool _shouldUpdateLocal(dynamic local, dynamic remote) {
    final localUpdated = (local as dynamic).updatedAt;
    final remoteUpdated = (remote as dynamic).updatedAt;

    if (localUpdated == null) return true;
    if (remoteUpdated == null) return false;

    return remoteUpdated.isAfter(localUpdated);
  }

  /// Store a pending change for retry
  Future<void> _storePendingChange(
    String type,
    String id,
    Map<String, dynamic> data,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final pendingJson = prefs.getString(_pendingChangesKey);
    final pending = pendingJson != null
        ? jsonDecode(pendingJson) as List
        : <Map<String, dynamic>>[];

    pending.add({
      'type': type,
      'id': id,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await prefs.setString(_pendingChangesKey, jsonEncode(pending));
  }

  /// Retry pending changes
  Future<void> _retryPendingChanges() async {
    final prefs = await SharedPreferences.getInstance();
    final pendingJson = prefs.getString(_pendingChangesKey);

    if (pendingJson == null) return;

    final pending = jsonDecode(pendingJson) as List;
    final remaining = <Map<String, dynamic>>[];

    for (final change in pending) {
      final type = change['type'] as String;
      final data = change['data'] as Map<String, dynamic>;

      final endpoint = type == 'event'
          ? '/events'
          : '/reflections/${_reflectionDateFromPendingData(data)}';
      final body = type == 'event'
          ? data
          : {
              'notes': data['notes'],
              'mood': data['mood'],
              'events_planned': data['events_planned'],
              'events_completed': data['events_completed'],
              'events_skipped': data['events_skipped'],
              'events_partial': data['events_partial'],
            };
      final response = await _api.post(endpoint, body: body);

      if (!response.isSuccess) {
        remaining.add(change as Map<String, dynamic>);
      }
    }

    if (remaining.isEmpty) {
      await prefs.remove(_pendingChangesKey);
    } else {
      await prefs.setString(_pendingChangesKey, jsonEncode(remaining));
    }
  }

  String _reflectionDateFromPendingData(Map<String, dynamic> data) {
    final rawDate = data['date']?.toString();
    if (rawDate == null || rawDate.isEmpty) {
      return DateTime.now().toIso8601String().split('T').first;
    }
    final parsed = DateTime.tryParse(rawDate);
    return (parsed ?? DateTime.now()).toIso8601String().split('T').first;
  }

  Map<String, int> _deriveReflectionEventStats(DailyReflection reflection) {
    var planned = 0;
    var completed = 0;
    var skipped = 0;
    var partial = 0;

    for (final tag in reflection.tags) {
      if (!tag.startsWith('event_status:')) continue;
      final parts = tag.split(':');
      if (parts.length < 3) continue;
      planned += 1;
      switch (parts[2]) {
        case 'completed':
          completed += 1;
          break;
        case 'skipped':
          skipped += 1;
          break;
        case 'partial':
          partial += 1;
          break;
      }
    }

    return {
      'events_planned': planned,
      'events_completed': completed,
      'events_skipped': skipped,
      'events_partial': partial,
    };
  }

  /// Load the last sync time from storage
  Future<void> _loadLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncString = prefs.getString(_lastSyncKey);
    if (lastSyncString != null) {
      _lastSyncTime = DateTime.tryParse(lastSyncString);
    }
  }

  /// Save the last sync time to storage
  Future<void> _saveLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncKey, _lastSyncTime!.toIso8601String());
  }

  /// Set up realtime subscription for live updates
  void _setupRealtimeSubscription() {
    // Subscribe to events table changes
    _supabase
        .channel('public:events')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'events',
          callback: (payload) {
            _handleRealtimeEvent('events', payload);
          },
        )
        .subscribe();

    // Subscribe to reflections table changes
    _supabase
        .channel('public:reflections')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'reflections',
          callback: (payload) {
            _handleRealtimeEvent('reflections', payload);
          },
        )
        .subscribe();
  }

  /// Handle realtime events from Supabase
  void _handleRealtimeEvent(String table, PostgresChangePayload payload) {
    // Trigger a sync when remote data changes
    debugPrint('Realtime update on $table: ${payload.eventType}');

    // Debounce syncs to avoid too many rapid updates
    _debounceSync();
  }

  Timer? _debounceTimer;

  void _debounceSync() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 2), () {
      sync();
    });
  }

  /// Dispose resources
  void dispose() {
    _syncTimer?.cancel();
    _debounceTimer?.cancel();
    _syncStatusController.close();
  }
}

/// Sync status enum
enum SyncStatus {
  idle,
  syncing,
  synced,
  error,
  offline,
}

/// Sync result
class SyncResult {
  final bool success;
  final String message;
  final int itemsPushed;
  final int itemsPulled;
  final int conflictsResolved;

  SyncResult({
    required this.success,
    required this.message,
    this.itemsPushed = 0,
    this.itemsPulled = 0,
    this.conflictsResolved = 0,
  });
}
