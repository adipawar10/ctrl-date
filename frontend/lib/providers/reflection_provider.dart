import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import '../main.dart';
import '../models/reflection.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../services/sync_service.dart';
import 'auth_provider.dart';
import 'events_provider.dart';

/// Provider for all reflections
final reflectionsProvider =
    StateNotifierProvider<ReflectionsNotifier, AsyncValue<List<DailyReflection>>>(
        (ref) {
  return ReflectionsNotifier(ref);
});

/// Provider for today's reflection
final todaysReflectionProvider = FutureProvider<DailyReflection?>((ref) async {
  final reflectionsAsync = ref.watch(reflectionsProvider);
  final now = DateTime.now();

  return reflectionsAsync.maybeWhen(
    data: (reflections) {
      return reflections.where((r) {
        return r.date.year == now.year &&
            r.date.month == now.month &&
            r.date.day == now.day;
      }).firstOrNull;
    },
    orElse: () => null,
  );
});

/// Provider for reflections in a date range
final reflectionsForDateRangeProvider =
    FutureProvider.family<List<DailyReflection>, DateRange>(
        (ref, range) async {
  final reflectionsAsync = ref.watch(reflectionsProvider);

  return reflectionsAsync.maybeWhen(
    data: (reflections) {
      return reflections.where((r) {
        return r.date.isAfter(range.start.subtract(const Duration(days: 1))) &&
            r.date.isBefore(range.end.add(const Duration(days: 1)));
      }).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    },
    orElse: () => [],
  );
});

/// Provider for a single reflection by ID
final reflectionByIdProvider =
    FutureProvider.family<DailyReflection?, String>((ref, id) async {
  final database = ref.watch(databaseProvider);
  return database.getReflectionById(id);
});

/// Provider for reflection by date
final reflectionByDateProvider =
    FutureProvider.family<DailyReflection?, DateTime>((ref, date) async {
  final reflectionsAsync = ref.watch(reflectionsProvider);

  return reflectionsAsync.maybeWhen(
    data: (reflections) {
      return reflections.where((r) {
        return r.date.year == date.year &&
            r.date.month == date.month &&
            r.date.day == date.day;
      }).firstOrNull;
    },
    orElse: () => null,
  );
});

/// Provider for user's streak
final streakProvider = StateNotifierProvider<StreakNotifier, AsyncValue<Streak>>(
    (ref) {
  return StreakNotifier(ref);
});

/// Provider for reflection statistics
final reflectionStatsProvider =
    FutureProvider<ReflectionStats>((ref) async {
  final reflectionsAsync = ref.watch(reflectionsProvider);
  final streakAsync = ref.watch(streakProvider);

  final reflections = reflectionsAsync.valueOrNull ?? [];
  final streak = streakAsync.valueOrNull;

  if (reflections.isEmpty) {
    return ReflectionStats(
      totalReflections: 0,
      currentStreak: 0,
      longestStreak: 0,
    );
  }

  // Calculate averages
  final moodValues = reflections
      .where((r) => r.mood != null)
      .map((r) => r.mood!.value)
      .toList();
  final energyValues = reflections
      .where((r) => r.energy != null)
      .map((r) => r.energy!.value)
      .toList();
  final productivityValues = reflections
      .where((r) => r.productivity != null)
      .map((r) => r.productivity!.value)
      .toList();

  double? averageMood;
  double? averageEnergy;
  double? averageProductivity;

  if (moodValues.isNotEmpty) {
    averageMood = moodValues.reduce((a, b) => a + b) / moodValues.length;
  }
  if (energyValues.isNotEmpty) {
    averageEnergy = energyValues.reduce((a, b) => a + b) / energyValues.length;
  }
  if (productivityValues.isNotEmpty) {
    averageProductivity =
        productivityValues.reduce((a, b) => a + b) / productivityValues.length;
  }

  // Calculate mood distribution
  final moodDistribution = <String, int>{};
  for (final rating in MoodRating.values) {
    moodDistribution[rating.label] =
        reflections.where((r) => r.mood == rating).length;
  }

  // Calculate tag frequency
  final tagFrequency = <String, int>{};
  for (final reflection in reflections) {
    for (final tag in reflection.tags) {
      tagFrequency[tag] = (tagFrequency[tag] ?? 0) + 1;
    }
  }

  // Calculate trends (last 30 days)
  final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
  final recentReflections = reflections
      .where((r) => r.date.isAfter(thirtyDaysAgo))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  final trends = recentReflections.map((r) {
    return ReflectionTrend(
      date: r.date,
      mood: r.mood?.value.toDouble(),
      energy: r.energy?.value.toDouble(),
      productivity: r.productivity?.value.toDouble(),
    );
  }).toList();

  return ReflectionStats(
    totalReflections: reflections.length,
    currentStreak: streak?.currentStreak ?? 0,
    longestStreak: streak?.longestStreak ?? 0,
    averageMood: averageMood,
    averageEnergy: averageEnergy,
    averageProductivity: averageProductivity,
    moodDistribution: moodDistribution,
    tagFrequency: tagFrequency,
    trends: trends,
  );
});

/// Provider for whether user has reflected today
final hasReflectedTodayProvider = Provider<bool>((ref) {
  final todaysReflection = ref.watch(todaysReflectionProvider);
  return todaysReflection.maybeWhen(
    data: (reflection) => reflection != null && reflection.isComplete,
    orElse: () => false,
  );
});

/// Notifier for managing reflections state
class ReflectionsNotifier
    extends StateNotifier<AsyncValue<List<DailyReflection>>> {
  final Ref _ref;
  StreamSubscription? _reflectionsSubscription;

  ReflectionsNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadReflections();
    _subscribeToReflections();
  }

  AppDatabase get _database => _ref.read(databaseProvider);
  ApiService get _api => _ref.read(apiServiceProvider);
  SyncService get _sync => _ref.read(syncServiceProvider);

  Future<void> _loadReflections() async {
    try {
      final reflections = await _database.getAllReflections();
      state = AsyncValue.data(reflections);

      // Trigger background sync
      _sync.sync();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _subscribeToReflections() {
    _reflectionsSubscription = _database.watchAllReflections().listen(
      (reflections) {
        state = AsyncValue.data(reflections);
      },
      onError: (e, st) {
        state = AsyncValue.error(e, st);
      },
    );
  }

  /// Create or update today's reflection
  Future<DailyReflection?> saveReflection(DailyReflection reflection) async {
    try {
      // Check if exists
      final existing = await _database.getReflectionByDate(reflection.date);

      DailyReflection reflectionToSave;
      if (existing != null) {
        reflectionToSave = reflection.copyWith(
          id: existing.id,
          createdAt: existing.createdAt,
          updatedAt: DateTime.now(),
        );
        await _database.updateReflection(reflectionToSave);
      } else {
        reflectionToSave = reflection.copyWith(
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _database.insertReflection(reflectionToSave);
      }

      // Sync to server
      final response = await _api.post(
        '/reflections',
        body: reflectionToSave.toJson(),
      );

      if (response.isSuccess) {
        await _database.markReflectionSynced(reflectionToSave.id);
      }

      // Update streak
      _ref.read(streakProvider.notifier).updateAfterReflection();

      return reflectionToSave;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a reflection
  Future<void> deleteReflection(String reflectionId) async {
    try {
      await _database.deleteReflection(reflectionId);
      await _api.delete('/reflections/$reflectionId');
    } catch (e) {
      rethrow;
    }
  }

  /// Search reflections
  Future<List<DailyReflection>> search(String query) async {
    final reflectionsData = state.valueOrNull;
    if (reflectionsData == null || query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();

    return reflectionsData.where((reflection) {
      return (reflection.gratitude?.toLowerCase().contains(lowerQuery) ??
              false) ||
          (reflection.accomplishments?.toLowerCase().contains(lowerQuery) ??
              false) ||
          (reflection.challenges?.toLowerCase().contains(lowerQuery) ?? false) ||
          (reflection.learnings?.toLowerCase().contains(lowerQuery) ?? false) ||
          (reflection.notes?.toLowerCase().contains(lowerQuery) ?? false) ||
          reflection.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// Refresh reflections
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _sync.sync();
    await _loadReflections();
  }

  @override
  void dispose() {
    _reflectionsSubscription?.cancel();
    super.dispose();
  }
}

/// Notifier for managing streak state
class StreakNotifier extends StateNotifier<AsyncValue<Streak>> {
  final Ref _ref;

  StreakNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadStreak();
  }

  ApiService get _api => _ref.read(apiServiceProvider);
  NotificationService get _notificationService => NotificationService.instance;

  Future<void> _loadStreak() async {
    try {
      final response = await _api.get<Map<String, dynamic>>('/streaks/me');

      if (response.isSuccess && response.data != null) {
        final streak = Streak.fromJson(response.data!);
        state = AsyncValue.data(streak);
      } else {
        // Create default streak
        state = AsyncValue.data(Streak(
          id: '',
          userId: '',
          currentStreak: 0,
          longestStreak: 0,
        ));
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update streak after a reflection is saved
  Future<void> updateAfterReflection() async {
    try {
      final response = await _api.post<Map<String, dynamic>>('/streaks/update');

      if (response.isSuccess && response.data != null) {
        final newStreak = Streak.fromJson(response.data!);
        final oldStreak = state.valueOrNull;

        state = AsyncValue.data(newStreak);

        // Check for milestone notifications
        if (oldStreak != null) {
          _checkMilestones(oldStreak.currentStreak, newStreak.currentStreak);
        }
      }
    } catch (e) {
      // Silently fail - streak will be updated on next sync
    }
  }

  void _checkMilestones(int oldStreak, int newStreak) {
    const milestones = [7, 14, 30, 60, 90, 180, 365];

    for (final milestone in milestones) {
      if (oldStreak < milestone && newStreak >= milestone) {
        _notificationService.showStreakMilestoneNotification(milestone);
        break;
      }
    }
  }

  /// Refresh streak
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadStreak();
  }
}

/// Provider for reflection actions
final reflectionActionsProvider = Provider<ReflectionActions>((ref) {
  return ReflectionActions(ref);
});

/// Class containing reflection actions
class ReflectionActions {
  final Ref _ref;

  ReflectionActions(this._ref);

  ReflectionsNotifier get _reflectionsNotifier =>
      _ref.read(reflectionsProvider.notifier);

  Future<DailyReflection?> save(DailyReflection reflection) =>
      _reflectionsNotifier.saveReflection(reflection);

  Future<void> delete(String reflectionId) =>
      _reflectionsNotifier.deleteReflection(reflectionId);

  Future<List<DailyReflection>> search(String query) =>
      _reflectionsNotifier.search(query);

  Future<void> refresh() => _reflectionsNotifier.refresh();
}

/// Provider for reflection prompts
final reflectionPromptsProvider =
    FutureProvider<List<ReflectionPrompt>>((ref) async {
  // These could be loaded from the API or stored locally
  return [
    const ReflectionPrompt(
      id: '1',
      category: 'gratitude',
      text: 'What are three things you\'re grateful for today?',
      followUpQuestions: [
        'Why are these things meaningful to you?',
        'How did they make you feel?',
      ],
    ),
    const ReflectionPrompt(
      id: '2',
      category: 'accomplishments',
      text: 'What did you accomplish today, no matter how small?',
      followUpQuestions: [
        'What made this possible?',
        'How can you build on this success?',
      ],
    ),
    const ReflectionPrompt(
      id: '3',
      category: 'challenges',
      text: 'What challenges did you face today?',
      followUpQuestions: [
        'How did you handle them?',
        'What would you do differently?',
      ],
    ),
    const ReflectionPrompt(
      id: '4',
      category: 'learnings',
      text: 'What did you learn today?',
      followUpQuestions: [
        'How can you apply this knowledge?',
        'Who could benefit from knowing this?',
      ],
    ),
    const ReflectionPrompt(
      id: '5',
      category: 'tomorrow',
      text: 'What is your main goal for tomorrow?',
      followUpQuestions: [
        'What steps will you take to achieve it?',
        'What obstacles might you face?',
      ],
    ),
  ];
});

/// Provider for checking if reflection reminder should be shown
final shouldShowReflectionReminderProvider = Provider<bool>((ref) {
  final preferences = ref.watch(userPreferencesProvider);
  final hasReflectedToday = ref.watch(hasReflectedTodayProvider);

  if (!preferences.dailyReflectionReminder) return false;
  if (hasReflectedToday) return false;

  // Check if it's past reminder time
  final reminderTime = preferences.reflectionReminderTime;
  final parts = reminderTime.split(':');
  final reminderHour = int.parse(parts[0]);
  final reminderMinute = int.parse(parts[1]);

  final now = DateTime.now();
  final reminderDateTime = DateTime(
    now.year,
    now.month,
    now.day,
    reminderHour,
    reminderMinute,
  );

  return now.isAfter(reminderDateTime);
});
