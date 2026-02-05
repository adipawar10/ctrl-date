// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reflection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyReflectionImpl _$$DailyReflectionImplFromJson(
        Map<String, dynamic> json) =>
    _$DailyReflectionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      mood: $enumDecodeNullable(_$MoodRatingEnumMap, json['mood']),
      energy: $enumDecodeNullable(_$EnergyLevelEnumMap, json['energy']),
      productivity: $enumDecodeNullable(
          _$ProductivityRatingEnumMap, json['productivity']),
      gratitude: json['gratitude'] as String?,
      accomplishments: json['accomplishments'] as String?,
      challenges: json['challenges'] as String?,
      learnings: json['learnings'] as String?,
      tomorrowGoals: json['tomorrowGoals'] as String?,
      notes: json['notes'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isPrivate: json['isPrivate'] as bool? ?? false,
      encryptedData: json['encryptedData'] as String?,
      isComplete: json['isComplete'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isSynced: json['isSynced'] as bool? ?? false,
      syncVersion: (json['syncVersion'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$DailyReflectionImplToJson(
        _$DailyReflectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'date': instance.date.toIso8601String(),
      'mood': _$MoodRatingEnumMap[instance.mood],
      'energy': _$EnergyLevelEnumMap[instance.energy],
      'productivity': _$ProductivityRatingEnumMap[instance.productivity],
      'gratitude': instance.gratitude,
      'accomplishments': instance.accomplishments,
      'challenges': instance.challenges,
      'learnings': instance.learnings,
      'tomorrowGoals': instance.tomorrowGoals,
      'notes': instance.notes,
      'tags': instance.tags,
      'isPrivate': instance.isPrivate,
      'encryptedData': instance.encryptedData,
      'isComplete': instance.isComplete,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isSynced': instance.isSynced,
      'syncVersion': instance.syncVersion,
    };

const _$MoodRatingEnumMap = {
  MoodRating.veryBad: 1,
  MoodRating.bad: 2,
  MoodRating.neutral: 3,
  MoodRating.good: 4,
  MoodRating.veryGood: 5,
};

const _$EnergyLevelEnumMap = {
  EnergyLevel.exhausted: 1,
  EnergyLevel.tired: 2,
  EnergyLevel.moderate: 3,
  EnergyLevel.energized: 4,
  EnergyLevel.veryEnergized: 5,
};

const _$ProductivityRatingEnumMap = {
  ProductivityRating.veryLow: 1,
  ProductivityRating.low: 2,
  ProductivityRating.moderate: 3,
  ProductivityRating.high: 4,
  ProductivityRating.veryHigh: 5,
};

_$StreakImpl _$$StreakImplFromJson(Map<String, dynamic> json) => _$StreakImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      lastReflectionDate: json['lastReflectionDate'] == null
          ? null
          : DateTime.parse(json['lastReflectionDate'] as String),
      streakStartDate: json['streakStartDate'] == null
          ? null
          : DateTime.parse(json['streakStartDate'] as String),
      totalReflections: (json['totalReflections'] as num?)?.toInt() ?? 0,
      milestones: (json['milestones'] as List<dynamic>?)
              ?.map((e) => StreakMilestone.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$StreakImplToJson(_$StreakImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'lastReflectionDate': instance.lastReflectionDate?.toIso8601String(),
      'streakStartDate': instance.streakStartDate?.toIso8601String(),
      'totalReflections': instance.totalReflections,
      'milestones': instance.milestones,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$StreakMilestoneImpl _$$StreakMilestoneImplFromJson(
        Map<String, dynamic> json) =>
    _$StreakMilestoneImpl(
      days: (json['days'] as num).toInt(),
      achievedAt: json['achievedAt'] == null
          ? null
          : DateTime.parse(json['achievedAt'] as String),
    );

Map<String, dynamic> _$$StreakMilestoneImplToJson(
        _$StreakMilestoneImpl instance) =>
    <String, dynamic>{
      'days': instance.days,
      'achievedAt': instance.achievedAt?.toIso8601String(),
    };

_$ReflectionStatsImpl _$$ReflectionStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$ReflectionStatsImpl(
      totalReflections: (json['totalReflections'] as num).toInt(),
      currentStreak: (json['currentStreak'] as num).toInt(),
      longestStreak: (json['longestStreak'] as num).toInt(),
      averageMood: (json['averageMood'] as num?)?.toDouble(),
      averageEnergy: (json['averageEnergy'] as num?)?.toDouble(),
      averageProductivity: (json['averageProductivity'] as num?)?.toDouble(),
      moodDistribution:
          (json['moodDistribution'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      tagFrequency: (json['tagFrequency'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      trends: (json['trends'] as List<dynamic>?)
              ?.map((e) => ReflectionTrend.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ReflectionStatsImplToJson(
        _$ReflectionStatsImpl instance) =>
    <String, dynamic>{
      'totalReflections': instance.totalReflections,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'averageMood': instance.averageMood,
      'averageEnergy': instance.averageEnergy,
      'averageProductivity': instance.averageProductivity,
      'moodDistribution': instance.moodDistribution,
      'tagFrequency': instance.tagFrequency,
      'trends': instance.trends,
    };

_$ReflectionTrendImpl _$$ReflectionTrendImplFromJson(
        Map<String, dynamic> json) =>
    _$ReflectionTrendImpl(
      date: DateTime.parse(json['date'] as String),
      mood: (json['mood'] as num?)?.toDouble(),
      energy: (json['energy'] as num?)?.toDouble(),
      productivity: (json['productivity'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$ReflectionTrendImplToJson(
        _$ReflectionTrendImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'mood': instance.mood,
      'energy': instance.energy,
      'productivity': instance.productivity,
    };

_$ReflectionFilterImpl _$$ReflectionFilterImplFromJson(
        Map<String, dynamic> json) =>
    _$ReflectionFilterImpl(
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      moods: (json['moods'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$MoodRatingEnumMap, e))
          .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      hasGratitude: json['hasGratitude'] as bool? ?? false,
      hasAccomplishments: json['hasAccomplishments'] as bool? ?? false,
      searchQuery: json['searchQuery'] as String?,
    );

Map<String, dynamic> _$$ReflectionFilterImplToJson(
        _$ReflectionFilterImpl instance) =>
    <String, dynamic>{
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'moods': instance.moods?.map((e) => _$MoodRatingEnumMap[e]!).toList(),
      'tags': instance.tags,
      'hasGratitude': instance.hasGratitude,
      'hasAccomplishments': instance.hasAccomplishments,
      'searchQuery': instance.searchQuery,
    };

_$ReflectionPromptImpl _$$ReflectionPromptImplFromJson(
        Map<String, dynamic> json) =>
    _$ReflectionPromptImpl(
      id: json['id'] as String,
      category: json['category'] as String,
      text: json['text'] as String,
      followUpQuestions: (json['followUpQuestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ReflectionPromptImplToJson(
        _$ReflectionPromptImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'text': instance.text,
      'followUpQuestions': instance.followUpQuestions,
    };
