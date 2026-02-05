import 'dart:async';
import 'dart:convert';

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
      return SyncResult(
        success: false,
        message: 'Sync already in progress',
      );
    }

    _isSyncing = true;
    _syncStatusController.add(SyncStatus.syncing);

    try {
      // Step 1: Push local changes to server
      final pushResult = await _pushLocalChanges();
      if (!pushResult.success) {
        _syncStatusController.add(SyncStatus.error);
        return pushResult;
      }

      // Step 2: Pull remote changes
      final pullResult = await _pullRemoteChanges();
      if (!pullResult.success) {
        _syncStatusController.add(SyncStatus.error);
        return pullResult;
      }

      // Step 3: Resolve conflicts
      final conflictResult = await _resolveConflicts();
      if (!conflictResult.success) {
        _syncStatusController.add(SyncStatus.error);
        return conflictResult;
      }

      // Update last sync time
      _lastSyncTime = DateTime.now();
      await _saveLastSyncTime();

      _syncStatusController.add(SyncStatus.synced);

      return SyncResult(
        success: true,
        message: 'Sync completed successfully',
        itemsPushed: pushResult.itemsPushed,
        itemsPulled: pullResult.itemsPulled,
        conflictsResolved: conflictResult.conflictsResolved,
      );
    } catch (e) {
      _syncStatusController.add(SyncStatus.error);
      return SyncResult(
        success: false,
        message: 'Sync failed: ${e.toString()}',
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Push local changes to the server
  Future<SyncResult> _pushLocalChanges() async {
    if (_database == null) {
      return SyncResult(success: false, message: 'Database not initialized');
    }

    int itemsPushed = 0;

    try {
      // Get unsynced events
      final unsyncedEvents = await _database!.getUnsyncedEvents();

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

      // Get unsynced reflections
      final unsyncedReflections = await _database!.getUnsyncedReflections();

      for (final reflection in unsyncedReflections) {
        final reflectionData = _prepareReflectionForSync(reflection);

        final response = await _api.post(
          '/reflections',
          body: reflectionData,
        );

        if (response.isSuccess) {
          await _database!.markReflectionSynced(reflection.id);
          itemsPushed++;
        } else {
          await _storePendingChange('reflection', reflection.id, reflectionData);
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
      final since = _lastSyncTime?.toIso8601String();

      // Pull events
      final eventsResponse = await _api.get<List>(
        '/events',
        queryParams: since != null ? {'updated_since': since} : null,
      );

      if (eventsResponse.isSuccess && eventsResponse.data != null) {
        for (final eventJson in eventsResponse.data!) {
          final event = Event.fromJson(eventJson as Map<String, dynamic>);

          // Decrypt if needed
          final decryptedEvent = await _decryptEventIfNeeded(event);

          // Check for local version
          final localEvent = await _database!.getEventById(event.id);

          if (localEvent == null) {
            await _database!.insertEvent(decryptedEvent);
            itemsPulled++;
          } else if (_shouldUpdateLocal(localEvent, decryptedEvent)) {
            await _database!.updateEvent(decryptedEvent);
            itemsPulled++;
          }
        }
      }

      // Pull reflections
      final reflectionsResponse = await _api.get<List>(
        '/reflections',
        queryParams: since != null ? {'updated_since': since} : null,
      );

      if (reflectionsResponse.isSuccess && reflectionsResponse.data != null) {
        for (final reflectionJson in reflectionsResponse.data!) {
          final reflection =
              DailyReflection.fromJson(reflectionJson as Map<String, dynamic>);

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
    var data = event.toJson();

    if (event.isPrivate) {
      // Encrypt sensitive fields
      final sensitiveData = {
        'title': event.title,
        'description': event.description,
        'location': event.location,
        'notes': data['notes'],
      };

      final encrypted = _encryption.encryptData(jsonEncode(sensitiveData));
      data['encrypted_data'] = encrypted;
      data['title'] = 'Private Event';
      data['description'] = null;
      data['location'] = null;
      data.remove('notes');
    }

    return data;
  }

  /// Prepare reflection data for sync (encrypt if private)
  Map<String, dynamic> _prepareReflectionForSync(DailyReflection reflection) {
    var data = reflection.toJson();

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

      final endpoint = type == 'event' ? '/events' : '/reflections';
      final response = await _api.post(endpoint, body: data);

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
