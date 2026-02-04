import 'package:freezed_annotation/freezed_annotation.dart';

part 'reflection.freezed.dart';
part 'reflection.g.dart';

/// Mood rating scale (1-5)
enum MoodRating {
  @JsonValue(1)
  veryBad(1, 'Very Bad'),
  @JsonValue(2)
  bad(2, 'Bad'),
  @JsonValue(3)
  neutral(3, 'Neutral'),
  @JsonValue(4)
  good(4, 'Good'),
  @JsonValue(5)
  veryGood(5, 'Very Good');

  const MoodRating(this.value, this.label);
  final int value;
  final String label;
}

/// Energy level scale (1-5)
enum EnergyLevel {
  @JsonValue(1)
  exhausted(1, 'Exhausted'),
  @JsonValue(2)
  tired(2, 'Tired'),
  @JsonValue(3)
  moderate(3, 'Moderate'),
  @JsonValue(4)
  energized(4, 'Energized'),
  @JsonValue(5)
  veryEnergized(5, 'Very Energized');

  const EnergyLevel(this.value, this.label);
  final int value;
  final String label;
}

/// Productivity rating scale (1-5)
enum ProductivityRating {
  @JsonValue(1)
  veryLow(1, 'Very Low'),
  @JsonValue(2)
  low(2, 'Low'),
  @JsonValue(3)
  moderate(3, 'Moderate'),
  @JsonValue(4)
  high(4, 'High'),
  @JsonValue(5)
  veryHigh(5, 'Very High');

  const ProductivityRating(this.value, this.label);
  final int value;
  final String label;
}

/// Daily reflection model
@freezed
class DailyReflection with _$DailyReflection {
  const DailyReflection._();

  const factory DailyReflection({
    required String id,
    required String userId,
    required DateTime date,
    MoodRating? mood,
    EnergyLevel? energy,
    ProductivityRating? productivity,
    String? gratitude,
    String? accomplishments,
    String? challenges,
    String? learnings,
    String? tomorrowGoals,
    String? notes,
    @Default([]) List<String> tags,
    @Default(false) bool isPrivate,
    String? encryptedData,
    @Default(false) bool isComplete,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool isSynced,
    int? syncVersion,
  }) = _DailyReflection;

  factory DailyReflection.fromJson(Map<String, dynamic> json) =>
      _$DailyReflectionFromJson(json);

  /// Check if all required fields are filled
  bool get hasMinimumData => mood != null || gratitude != null;

  /// Get a summary score (average of mood, energy, productivity)
  double? get overallScore {
    final scores = <int>[];
    if (mood != null) scores.add(mood!.value);
    if (energy != null) scores.add(energy!.value);
    if (productivity != null) scores.add(productivity!.value);
    if (scores.isEmpty) return null;
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  /// Check if this reflection is for today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

/// Streak model for tracking reflection consistency
@freezed
class Streak with _$Streak {
  const Streak._();

  const factory Streak({
    required String id,
    required String userId,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    DateTime? lastReflectionDate,
    DateTime? streakStartDate,
    @Default(0) int totalReflections,
    @Default([]) List<StreakMilestone> milestones,
    DateTime? updatedAt,
  }) = _Streak;

  factory Streak.fromJson(Map<String, dynamic> json) => _$StreakFromJson(json);

  /// Check if the streak is active (reflection done today or yesterday)
  bool get isActive {
    if (lastReflectionDate == null) return false;
    final now = DateTime.now();
    final daysSinceLastReflection =
        now.difference(lastReflectionDate!).inDays;
    return daysSinceLastReflection <= 1;
  }

  /// Check if user reflected today
  bool get reflectedToday {
    if (lastReflectionDate == null) return false;
    final now = DateTime.now();
    return lastReflectionDate!.year == now.year &&
        lastReflectionDate!.month == now.month &&
        lastReflectionDate!.day == now.day;
  }

  /// Get days until streak breaks (0 if already broken)
  int get daysUntilStreakBreaks {
    if (!isActive) return 0;
    if (reflectedToday) return 2; // Today done, need to do tomorrow
    return 1; // Need to reflect today
  }

  /// Get the next milestone to achieve
  StreakMilestone? get nextMilestone {
    const milestoneValues = [7, 14, 30, 60, 90, 180, 365];
    for (final value in milestoneValues) {
      if (currentStreak < value) {
        return StreakMilestone(
          days: value,
          achievedAt: null,
        );
      }
    }
    return null;
  }
}

/// Streak milestone achievement
@freezed
class StreakMilestone with _$StreakMilestone {
  const StreakMilestone._();

  const factory StreakMilestone({
    required int days,
    DateTime? achievedAt,
  }) = _StreakMilestone;

  factory StreakMilestone.fromJson(Map<String, dynamic> json) =>
      _$StreakMilestoneFromJson(json);

  /// Check if this milestone has been achieved
  bool get isAchieved => achievedAt != null;

  /// Get the milestone name
  String get name {
    switch (days) {
      case 7:
        return 'One Week';
      case 14:
        return 'Two Weeks';
      case 30:
        return 'One Month';
      case 60:
        return 'Two Months';
      case 90:
        return 'Three Months';
      case 180:
        return 'Six Months';
      case 365:
        return 'One Year';
      default:
        return '$days Days';
    }
  }
}

/// Reflection statistics for analytics
@freezed
class ReflectionStats with _$ReflectionStats {
  const factory ReflectionStats({
    required int totalReflections,
    required int currentStreak,
    required int longestStreak,
    double? averageMood,
    double? averageEnergy,
    double? averageProductivity,
    Map<String, int>? moodDistribution,
    Map<String, int>? tagFrequency,
    @Default([]) List<ReflectionTrend> trends,
  }) = _ReflectionStats;

  factory ReflectionStats.fromJson(Map<String, dynamic> json) =>
      _$ReflectionStatsFromJson(json);
}

/// Trend data point for reflection analytics
@freezed
class ReflectionTrend with _$ReflectionTrend {
  const factory ReflectionTrend({
    required DateTime date,
    double? mood,
    double? energy,
    double? productivity,
  }) = _ReflectionTrend;

  factory ReflectionTrend.fromJson(Map<String, dynamic> json) =>
      _$ReflectionTrendFromJson(json);
}

/// Filter for querying reflections
@freezed
class ReflectionFilter with _$ReflectionFilter {
  const factory ReflectionFilter({
    DateTime? startDate,
    DateTime? endDate,
    List<MoodRating>? moods,
    List<String>? tags,
    @Default(false) bool hasGratitude,
    @Default(false) bool hasAccomplishments,
    String? searchQuery,
  }) = _ReflectionFilter;

  factory ReflectionFilter.fromJson(Map<String, dynamic> json) =>
      _$ReflectionFilterFromJson(json);
}

/// Reflection prompt for guiding users
@freezed
class ReflectionPrompt with _$ReflectionPrompt {
  const factory ReflectionPrompt({
    required String id,
    required String category,
    required String text,
    @Default([]) List<String> followUpQuestions,
  }) = _ReflectionPrompt;

  factory ReflectionPrompt.fromJson(Map<String, dynamic> json) =>
      _$ReflectionPromptFromJson(json);
}
