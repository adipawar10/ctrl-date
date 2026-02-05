// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reflection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DailyReflection _$DailyReflectionFromJson(Map<String, dynamic> json) {
  return _DailyReflection.fromJson(json);
}

/// @nodoc
mixin _$DailyReflection {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  MoodRating? get mood => throw _privateConstructorUsedError;
  EnergyLevel? get energy => throw _privateConstructorUsedError;
  ProductivityRating? get productivity => throw _privateConstructorUsedError;
  String? get gratitude => throw _privateConstructorUsedError;
  String? get accomplishments => throw _privateConstructorUsedError;
  String? get challenges => throw _privateConstructorUsedError;
  String? get learnings => throw _privateConstructorUsedError;
  String? get tomorrowGoals => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get isPrivate => throw _privateConstructorUsedError;
  String? get encryptedData => throw _privateConstructorUsedError;
  bool get isComplete => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  bool get isSynced => throw _privateConstructorUsedError;
  int? get syncVersion => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DailyReflectionCopyWith<DailyReflection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyReflectionCopyWith<$Res> {
  factory $DailyReflectionCopyWith(
          DailyReflection value, $Res Function(DailyReflection) then) =
      _$DailyReflectionCopyWithImpl<$Res, DailyReflection>;
  @useResult
  $Res call(
      {String id,
      String userId,
      DateTime date,
      MoodRating? mood,
      EnergyLevel? energy,
      ProductivityRating? productivity,
      String? gratitude,
      String? accomplishments,
      String? challenges,
      String? learnings,
      String? tomorrowGoals,
      String? notes,
      List<String> tags,
      bool isPrivate,
      String? encryptedData,
      bool isComplete,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool isSynced,
      int? syncVersion});
}

/// @nodoc
class _$DailyReflectionCopyWithImpl<$Res, $Val extends DailyReflection>
    implements $DailyReflectionCopyWith<$Res> {
  _$DailyReflectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? mood = freezed,
    Object? energy = freezed,
    Object? productivity = freezed,
    Object? gratitude = freezed,
    Object? accomplishments = freezed,
    Object? challenges = freezed,
    Object? learnings = freezed,
    Object? tomorrowGoals = freezed,
    Object? notes = freezed,
    Object? tags = null,
    Object? isPrivate = null,
    Object? encryptedData = freezed,
    Object? isComplete = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isSynced = null,
    Object? syncVersion = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      mood: freezed == mood
          ? _value.mood
          : mood // ignore: cast_nullable_to_non_nullable
              as MoodRating?,
      energy: freezed == energy
          ? _value.energy
          : energy // ignore: cast_nullable_to_non_nullable
              as EnergyLevel?,
      productivity: freezed == productivity
          ? _value.productivity
          : productivity // ignore: cast_nullable_to_non_nullable
              as ProductivityRating?,
      gratitude: freezed == gratitude
          ? _value.gratitude
          : gratitude // ignore: cast_nullable_to_non_nullable
              as String?,
      accomplishments: freezed == accomplishments
          ? _value.accomplishments
          : accomplishments // ignore: cast_nullable_to_non_nullable
              as String?,
      challenges: freezed == challenges
          ? _value.challenges
          : challenges // ignore: cast_nullable_to_non_nullable
              as String?,
      learnings: freezed == learnings
          ? _value.learnings
          : learnings // ignore: cast_nullable_to_non_nullable
              as String?,
      tomorrowGoals: freezed == tomorrowGoals
          ? _value.tomorrowGoals
          : tomorrowGoals // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      encryptedData: freezed == encryptedData
          ? _value.encryptedData
          : encryptedData // ignore: cast_nullable_to_non_nullable
              as String?,
      isComplete: null == isComplete
          ? _value.isComplete
          : isComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      syncVersion: freezed == syncVersion
          ? _value.syncVersion
          : syncVersion // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyReflectionImplCopyWith<$Res>
    implements $DailyReflectionCopyWith<$Res> {
  factory _$$DailyReflectionImplCopyWith(_$DailyReflectionImpl value,
          $Res Function(_$DailyReflectionImpl) then) =
      __$$DailyReflectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      DateTime date,
      MoodRating? mood,
      EnergyLevel? energy,
      ProductivityRating? productivity,
      String? gratitude,
      String? accomplishments,
      String? challenges,
      String? learnings,
      String? tomorrowGoals,
      String? notes,
      List<String> tags,
      bool isPrivate,
      String? encryptedData,
      bool isComplete,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool isSynced,
      int? syncVersion});
}

/// @nodoc
class __$$DailyReflectionImplCopyWithImpl<$Res>
    extends _$DailyReflectionCopyWithImpl<$Res, _$DailyReflectionImpl>
    implements _$$DailyReflectionImplCopyWith<$Res> {
  __$$DailyReflectionImplCopyWithImpl(
      _$DailyReflectionImpl _value, $Res Function(_$DailyReflectionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? mood = freezed,
    Object? energy = freezed,
    Object? productivity = freezed,
    Object? gratitude = freezed,
    Object? accomplishments = freezed,
    Object? challenges = freezed,
    Object? learnings = freezed,
    Object? tomorrowGoals = freezed,
    Object? notes = freezed,
    Object? tags = null,
    Object? isPrivate = null,
    Object? encryptedData = freezed,
    Object? isComplete = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isSynced = null,
    Object? syncVersion = freezed,
  }) {
    return _then(_$DailyReflectionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      mood: freezed == mood
          ? _value.mood
          : mood // ignore: cast_nullable_to_non_nullable
              as MoodRating?,
      energy: freezed == energy
          ? _value.energy
          : energy // ignore: cast_nullable_to_non_nullable
              as EnergyLevel?,
      productivity: freezed == productivity
          ? _value.productivity
          : productivity // ignore: cast_nullable_to_non_nullable
              as ProductivityRating?,
      gratitude: freezed == gratitude
          ? _value.gratitude
          : gratitude // ignore: cast_nullable_to_non_nullable
              as String?,
      accomplishments: freezed == accomplishments
          ? _value.accomplishments
          : accomplishments // ignore: cast_nullable_to_non_nullable
              as String?,
      challenges: freezed == challenges
          ? _value.challenges
          : challenges // ignore: cast_nullable_to_non_nullable
              as String?,
      learnings: freezed == learnings
          ? _value.learnings
          : learnings // ignore: cast_nullable_to_non_nullable
              as String?,
      tomorrowGoals: freezed == tomorrowGoals
          ? _value.tomorrowGoals
          : tomorrowGoals // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      encryptedData: freezed == encryptedData
          ? _value.encryptedData
          : encryptedData // ignore: cast_nullable_to_non_nullable
              as String?,
      isComplete: null == isComplete
          ? _value.isComplete
          : isComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      syncVersion: freezed == syncVersion
          ? _value.syncVersion
          : syncVersion // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyReflectionImpl extends _DailyReflection {
  const _$DailyReflectionImpl(
      {required this.id,
      required this.userId,
      required this.date,
      this.mood,
      this.energy,
      this.productivity,
      this.gratitude,
      this.accomplishments,
      this.challenges,
      this.learnings,
      this.tomorrowGoals,
      this.notes,
      final List<String> tags = const [],
      this.isPrivate = false,
      this.encryptedData,
      this.isComplete = false,
      this.createdAt,
      this.updatedAt,
      this.isSynced = false,
      this.syncVersion})
      : _tags = tags,
        super._();

  factory _$DailyReflectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyReflectionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final DateTime date;
  @override
  final MoodRating? mood;
  @override
  final EnergyLevel? energy;
  @override
  final ProductivityRating? productivity;
  @override
  final String? gratitude;
  @override
  final String? accomplishments;
  @override
  final String? challenges;
  @override
  final String? learnings;
  @override
  final String? tomorrowGoals;
  @override
  final String? notes;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final bool isPrivate;
  @override
  final String? encryptedData;
  @override
  @JsonKey()
  final bool isComplete;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final bool isSynced;
  @override
  final int? syncVersion;

  @override
  String toString() {
    return 'DailyReflection(id: $id, userId: $userId, date: $date, mood: $mood, energy: $energy, productivity: $productivity, gratitude: $gratitude, accomplishments: $accomplishments, challenges: $challenges, learnings: $learnings, tomorrowGoals: $tomorrowGoals, notes: $notes, tags: $tags, isPrivate: $isPrivate, encryptedData: $encryptedData, isComplete: $isComplete, createdAt: $createdAt, updatedAt: $updatedAt, isSynced: $isSynced, syncVersion: $syncVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyReflectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.mood, mood) || other.mood == mood) &&
            (identical(other.energy, energy) || other.energy == energy) &&
            (identical(other.productivity, productivity) ||
                other.productivity == productivity) &&
            (identical(other.gratitude, gratitude) ||
                other.gratitude == gratitude) &&
            (identical(other.accomplishments, accomplishments) ||
                other.accomplishments == accomplishments) &&
            (identical(other.challenges, challenges) ||
                other.challenges == challenges) &&
            (identical(other.learnings, learnings) ||
                other.learnings == learnings) &&
            (identical(other.tomorrowGoals, tomorrowGoals) ||
                other.tomorrowGoals == tomorrowGoals) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.encryptedData, encryptedData) ||
                other.encryptedData == encryptedData) &&
            (identical(other.isComplete, isComplete) ||
                other.isComplete == isComplete) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced) &&
            (identical(other.syncVersion, syncVersion) ||
                other.syncVersion == syncVersion));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        date,
        mood,
        energy,
        productivity,
        gratitude,
        accomplishments,
        challenges,
        learnings,
        tomorrowGoals,
        notes,
        const DeepCollectionEquality().hash(_tags),
        isPrivate,
        encryptedData,
        isComplete,
        createdAt,
        updatedAt,
        isSynced,
        syncVersion
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyReflectionImplCopyWith<_$DailyReflectionImpl> get copyWith =>
      __$$DailyReflectionImplCopyWithImpl<_$DailyReflectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyReflectionImplToJson(
      this,
    );
  }
}

abstract class _DailyReflection extends DailyReflection {
  const factory _DailyReflection(
      {required final String id,
      required final String userId,
      required final DateTime date,
      final MoodRating? mood,
      final EnergyLevel? energy,
      final ProductivityRating? productivity,
      final String? gratitude,
      final String? accomplishments,
      final String? challenges,
      final String? learnings,
      final String? tomorrowGoals,
      final String? notes,
      final List<String> tags,
      final bool isPrivate,
      final String? encryptedData,
      final bool isComplete,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final bool isSynced,
      final int? syncVersion}) = _$DailyReflectionImpl;
  const _DailyReflection._() : super._();

  factory _DailyReflection.fromJson(Map<String, dynamic> json) =
      _$DailyReflectionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  DateTime get date;
  @override
  MoodRating? get mood;
  @override
  EnergyLevel? get energy;
  @override
  ProductivityRating? get productivity;
  @override
  String? get gratitude;
  @override
  String? get accomplishments;
  @override
  String? get challenges;
  @override
  String? get learnings;
  @override
  String? get tomorrowGoals;
  @override
  String? get notes;
  @override
  List<String> get tags;
  @override
  bool get isPrivate;
  @override
  String? get encryptedData;
  @override
  bool get isComplete;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  bool get isSynced;
  @override
  int? get syncVersion;
  @override
  @JsonKey(ignore: true)
  _$$DailyReflectionImplCopyWith<_$DailyReflectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Streak _$StreakFromJson(Map<String, dynamic> json) {
  return _Streak.fromJson(json);
}

/// @nodoc
mixin _$Streak {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  DateTime? get lastReflectionDate => throw _privateConstructorUsedError;
  DateTime? get streakStartDate => throw _privateConstructorUsedError;
  int get totalReflections => throw _privateConstructorUsedError;
  List<StreakMilestone> get milestones => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StreakCopyWith<Streak> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreakCopyWith<$Res> {
  factory $StreakCopyWith(Streak value, $Res Function(Streak) then) =
      _$StreakCopyWithImpl<$Res, Streak>;
  @useResult
  $Res call(
      {String id,
      String userId,
      int currentStreak,
      int longestStreak,
      DateTime? lastReflectionDate,
      DateTime? streakStartDate,
      int totalReflections,
      List<StreakMilestone> milestones,
      DateTime? updatedAt});
}

/// @nodoc
class _$StreakCopyWithImpl<$Res, $Val extends Streak>
    implements $StreakCopyWith<$Res> {
  _$StreakCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastReflectionDate = freezed,
    Object? streakStartDate = freezed,
    Object? totalReflections = null,
    Object? milestones = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastReflectionDate: freezed == lastReflectionDate
          ? _value.lastReflectionDate
          : lastReflectionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      streakStartDate: freezed == streakStartDate
          ? _value.streakStartDate
          : streakStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalReflections: null == totalReflections
          ? _value.totalReflections
          : totalReflections // ignore: cast_nullable_to_non_nullable
              as int,
      milestones: null == milestones
          ? _value.milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<StreakMilestone>,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StreakImplCopyWith<$Res> implements $StreakCopyWith<$Res> {
  factory _$$StreakImplCopyWith(
          _$StreakImpl value, $Res Function(_$StreakImpl) then) =
      __$$StreakImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      int currentStreak,
      int longestStreak,
      DateTime? lastReflectionDate,
      DateTime? streakStartDate,
      int totalReflections,
      List<StreakMilestone> milestones,
      DateTime? updatedAt});
}

/// @nodoc
class __$$StreakImplCopyWithImpl<$Res>
    extends _$StreakCopyWithImpl<$Res, _$StreakImpl>
    implements _$$StreakImplCopyWith<$Res> {
  __$$StreakImplCopyWithImpl(
      _$StreakImpl _value, $Res Function(_$StreakImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastReflectionDate = freezed,
    Object? streakStartDate = freezed,
    Object? totalReflections = null,
    Object? milestones = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$StreakImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastReflectionDate: freezed == lastReflectionDate
          ? _value.lastReflectionDate
          : lastReflectionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      streakStartDate: freezed == streakStartDate
          ? _value.streakStartDate
          : streakStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalReflections: null == totalReflections
          ? _value.totalReflections
          : totalReflections // ignore: cast_nullable_to_non_nullable
              as int,
      milestones: null == milestones
          ? _value._milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<StreakMilestone>,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreakImpl extends _Streak {
  const _$StreakImpl(
      {required this.id,
      required this.userId,
      this.currentStreak = 0,
      this.longestStreak = 0,
      this.lastReflectionDate,
      this.streakStartDate,
      this.totalReflections = 0,
      final List<StreakMilestone> milestones = const [],
      this.updatedAt})
      : _milestones = milestones,
        super._();

  factory _$StreakImpl.fromJson(Map<String, dynamic> json) =>
      _$$StreakImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  @JsonKey()
  final int currentStreak;
  @override
  @JsonKey()
  final int longestStreak;
  @override
  final DateTime? lastReflectionDate;
  @override
  final DateTime? streakStartDate;
  @override
  @JsonKey()
  final int totalReflections;
  final List<StreakMilestone> _milestones;
  @override
  @JsonKey()
  List<StreakMilestone> get milestones {
    if (_milestones is EqualUnmodifiableListView) return _milestones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_milestones);
  }

  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Streak(id: $id, userId: $userId, currentStreak: $currentStreak, longestStreak: $longestStreak, lastReflectionDate: $lastReflectionDate, streakStartDate: $streakStartDate, totalReflections: $totalReflections, milestones: $milestones, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastReflectionDate, lastReflectionDate) ||
                other.lastReflectionDate == lastReflectionDate) &&
            (identical(other.streakStartDate, streakStartDate) ||
                other.streakStartDate == streakStartDate) &&
            (identical(other.totalReflections, totalReflections) ||
                other.totalReflections == totalReflections) &&
            const DeepCollectionEquality()
                .equals(other._milestones, _milestones) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      currentStreak,
      longestStreak,
      lastReflectionDate,
      streakStartDate,
      totalReflections,
      const DeepCollectionEquality().hash(_milestones),
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakImplCopyWith<_$StreakImpl> get copyWith =>
      __$$StreakImplCopyWithImpl<_$StreakImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StreakImplToJson(
      this,
    );
  }
}

abstract class _Streak extends Streak {
  const factory _Streak(
      {required final String id,
      required final String userId,
      final int currentStreak,
      final int longestStreak,
      final DateTime? lastReflectionDate,
      final DateTime? streakStartDate,
      final int totalReflections,
      final List<StreakMilestone> milestones,
      final DateTime? updatedAt}) = _$StreakImpl;
  const _Streak._() : super._();

  factory _Streak.fromJson(Map<String, dynamic> json) = _$StreakImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  DateTime? get lastReflectionDate;
  @override
  DateTime? get streakStartDate;
  @override
  int get totalReflections;
  @override
  List<StreakMilestone> get milestones;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$StreakImplCopyWith<_$StreakImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StreakMilestone _$StreakMilestoneFromJson(Map<String, dynamic> json) {
  return _StreakMilestone.fromJson(json);
}

/// @nodoc
mixin _$StreakMilestone {
  int get days => throw _privateConstructorUsedError;
  DateTime? get achievedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StreakMilestoneCopyWith<StreakMilestone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreakMilestoneCopyWith<$Res> {
  factory $StreakMilestoneCopyWith(
          StreakMilestone value, $Res Function(StreakMilestone) then) =
      _$StreakMilestoneCopyWithImpl<$Res, StreakMilestone>;
  @useResult
  $Res call({int days, DateTime? achievedAt});
}

/// @nodoc
class _$StreakMilestoneCopyWithImpl<$Res, $Val extends StreakMilestone>
    implements $StreakMilestoneCopyWith<$Res> {
  _$StreakMilestoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? days = null,
    Object? achievedAt = freezed,
  }) {
    return _then(_value.copyWith(
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as int,
      achievedAt: freezed == achievedAt
          ? _value.achievedAt
          : achievedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StreakMilestoneImplCopyWith<$Res>
    implements $StreakMilestoneCopyWith<$Res> {
  factory _$$StreakMilestoneImplCopyWith(_$StreakMilestoneImpl value,
          $Res Function(_$StreakMilestoneImpl) then) =
      __$$StreakMilestoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int days, DateTime? achievedAt});
}

/// @nodoc
class __$$StreakMilestoneImplCopyWithImpl<$Res>
    extends _$StreakMilestoneCopyWithImpl<$Res, _$StreakMilestoneImpl>
    implements _$$StreakMilestoneImplCopyWith<$Res> {
  __$$StreakMilestoneImplCopyWithImpl(
      _$StreakMilestoneImpl _value, $Res Function(_$StreakMilestoneImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? days = null,
    Object? achievedAt = freezed,
  }) {
    return _then(_$StreakMilestoneImpl(
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as int,
      achievedAt: freezed == achievedAt
          ? _value.achievedAt
          : achievedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreakMilestoneImpl extends _StreakMilestone {
  const _$StreakMilestoneImpl({required this.days, this.achievedAt})
      : super._();

  factory _$StreakMilestoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$StreakMilestoneImplFromJson(json);

  @override
  final int days;
  @override
  final DateTime? achievedAt;

  @override
  String toString() {
    return 'StreakMilestone(days: $days, achievedAt: $achievedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakMilestoneImpl &&
            (identical(other.days, days) || other.days == days) &&
            (identical(other.achievedAt, achievedAt) ||
                other.achievedAt == achievedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, days, achievedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakMilestoneImplCopyWith<_$StreakMilestoneImpl> get copyWith =>
      __$$StreakMilestoneImplCopyWithImpl<_$StreakMilestoneImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StreakMilestoneImplToJson(
      this,
    );
  }
}

abstract class _StreakMilestone extends StreakMilestone {
  const factory _StreakMilestone(
      {required final int days,
      final DateTime? achievedAt}) = _$StreakMilestoneImpl;
  const _StreakMilestone._() : super._();

  factory _StreakMilestone.fromJson(Map<String, dynamic> json) =
      _$StreakMilestoneImpl.fromJson;

  @override
  int get days;
  @override
  DateTime? get achievedAt;
  @override
  @JsonKey(ignore: true)
  _$$StreakMilestoneImplCopyWith<_$StreakMilestoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReflectionStats _$ReflectionStatsFromJson(Map<String, dynamic> json) {
  return _ReflectionStats.fromJson(json);
}

/// @nodoc
mixin _$ReflectionStats {
  int get totalReflections => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  double? get averageMood => throw _privateConstructorUsedError;
  double? get averageEnergy => throw _privateConstructorUsedError;
  double? get averageProductivity => throw _privateConstructorUsedError;
  Map<String, int>? get moodDistribution => throw _privateConstructorUsedError;
  Map<String, int>? get tagFrequency => throw _privateConstructorUsedError;
  List<ReflectionTrend> get trends => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReflectionStatsCopyWith<ReflectionStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReflectionStatsCopyWith<$Res> {
  factory $ReflectionStatsCopyWith(
          ReflectionStats value, $Res Function(ReflectionStats) then) =
      _$ReflectionStatsCopyWithImpl<$Res, ReflectionStats>;
  @useResult
  $Res call(
      {int totalReflections,
      int currentStreak,
      int longestStreak,
      double? averageMood,
      double? averageEnergy,
      double? averageProductivity,
      Map<String, int>? moodDistribution,
      Map<String, int>? tagFrequency,
      List<ReflectionTrend> trends});
}

/// @nodoc
class _$ReflectionStatsCopyWithImpl<$Res, $Val extends ReflectionStats>
    implements $ReflectionStatsCopyWith<$Res> {
  _$ReflectionStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalReflections = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? averageMood = freezed,
    Object? averageEnergy = freezed,
    Object? averageProductivity = freezed,
    Object? moodDistribution = freezed,
    Object? tagFrequency = freezed,
    Object? trends = null,
  }) {
    return _then(_value.copyWith(
      totalReflections: null == totalReflections
          ? _value.totalReflections
          : totalReflections // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      averageMood: freezed == averageMood
          ? _value.averageMood
          : averageMood // ignore: cast_nullable_to_non_nullable
              as double?,
      averageEnergy: freezed == averageEnergy
          ? _value.averageEnergy
          : averageEnergy // ignore: cast_nullable_to_non_nullable
              as double?,
      averageProductivity: freezed == averageProductivity
          ? _value.averageProductivity
          : averageProductivity // ignore: cast_nullable_to_non_nullable
              as double?,
      moodDistribution: freezed == moodDistribution
          ? _value.moodDistribution
          : moodDistribution // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      tagFrequency: freezed == tagFrequency
          ? _value.tagFrequency
          : tagFrequency // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      trends: null == trends
          ? _value.trends
          : trends // ignore: cast_nullable_to_non_nullable
              as List<ReflectionTrend>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReflectionStatsImplCopyWith<$Res>
    implements $ReflectionStatsCopyWith<$Res> {
  factory _$$ReflectionStatsImplCopyWith(_$ReflectionStatsImpl value,
          $Res Function(_$ReflectionStatsImpl) then) =
      __$$ReflectionStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalReflections,
      int currentStreak,
      int longestStreak,
      double? averageMood,
      double? averageEnergy,
      double? averageProductivity,
      Map<String, int>? moodDistribution,
      Map<String, int>? tagFrequency,
      List<ReflectionTrend> trends});
}

/// @nodoc
class __$$ReflectionStatsImplCopyWithImpl<$Res>
    extends _$ReflectionStatsCopyWithImpl<$Res, _$ReflectionStatsImpl>
    implements _$$ReflectionStatsImplCopyWith<$Res> {
  __$$ReflectionStatsImplCopyWithImpl(
      _$ReflectionStatsImpl _value, $Res Function(_$ReflectionStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalReflections = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? averageMood = freezed,
    Object? averageEnergy = freezed,
    Object? averageProductivity = freezed,
    Object? moodDistribution = freezed,
    Object? tagFrequency = freezed,
    Object? trends = null,
  }) {
    return _then(_$ReflectionStatsImpl(
      totalReflections: null == totalReflections
          ? _value.totalReflections
          : totalReflections // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      averageMood: freezed == averageMood
          ? _value.averageMood
          : averageMood // ignore: cast_nullable_to_non_nullable
              as double?,
      averageEnergy: freezed == averageEnergy
          ? _value.averageEnergy
          : averageEnergy // ignore: cast_nullable_to_non_nullable
              as double?,
      averageProductivity: freezed == averageProductivity
          ? _value.averageProductivity
          : averageProductivity // ignore: cast_nullable_to_non_nullable
              as double?,
      moodDistribution: freezed == moodDistribution
          ? _value._moodDistribution
          : moodDistribution // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      tagFrequency: freezed == tagFrequency
          ? _value._tagFrequency
          : tagFrequency // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      trends: null == trends
          ? _value._trends
          : trends // ignore: cast_nullable_to_non_nullable
              as List<ReflectionTrend>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReflectionStatsImpl implements _ReflectionStats {
  const _$ReflectionStatsImpl(
      {required this.totalReflections,
      required this.currentStreak,
      required this.longestStreak,
      this.averageMood,
      this.averageEnergy,
      this.averageProductivity,
      final Map<String, int>? moodDistribution,
      final Map<String, int>? tagFrequency,
      final List<ReflectionTrend> trends = const []})
      : _moodDistribution = moodDistribution,
        _tagFrequency = tagFrequency,
        _trends = trends;

  factory _$ReflectionStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReflectionStatsImplFromJson(json);

  @override
  final int totalReflections;
  @override
  final int currentStreak;
  @override
  final int longestStreak;
  @override
  final double? averageMood;
  @override
  final double? averageEnergy;
  @override
  final double? averageProductivity;
  final Map<String, int>? _moodDistribution;
  @override
  Map<String, int>? get moodDistribution {
    final value = _moodDistribution;
    if (value == null) return null;
    if (_moodDistribution is EqualUnmodifiableMapView) return _moodDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, int>? _tagFrequency;
  @override
  Map<String, int>? get tagFrequency {
    final value = _tagFrequency;
    if (value == null) return null;
    if (_tagFrequency is EqualUnmodifiableMapView) return _tagFrequency;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<ReflectionTrend> _trends;
  @override
  @JsonKey()
  List<ReflectionTrend> get trends {
    if (_trends is EqualUnmodifiableListView) return _trends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trends);
  }

  @override
  String toString() {
    return 'ReflectionStats(totalReflections: $totalReflections, currentStreak: $currentStreak, longestStreak: $longestStreak, averageMood: $averageMood, averageEnergy: $averageEnergy, averageProductivity: $averageProductivity, moodDistribution: $moodDistribution, tagFrequency: $tagFrequency, trends: $trends)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReflectionStatsImpl &&
            (identical(other.totalReflections, totalReflections) ||
                other.totalReflections == totalReflections) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.averageMood, averageMood) ||
                other.averageMood == averageMood) &&
            (identical(other.averageEnergy, averageEnergy) ||
                other.averageEnergy == averageEnergy) &&
            (identical(other.averageProductivity, averageProductivity) ||
                other.averageProductivity == averageProductivity) &&
            const DeepCollectionEquality()
                .equals(other._moodDistribution, _moodDistribution) &&
            const DeepCollectionEquality()
                .equals(other._tagFrequency, _tagFrequency) &&
            const DeepCollectionEquality().equals(other._trends, _trends));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalReflections,
      currentStreak,
      longestStreak,
      averageMood,
      averageEnergy,
      averageProductivity,
      const DeepCollectionEquality().hash(_moodDistribution),
      const DeepCollectionEquality().hash(_tagFrequency),
      const DeepCollectionEquality().hash(_trends));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReflectionStatsImplCopyWith<_$ReflectionStatsImpl> get copyWith =>
      __$$ReflectionStatsImplCopyWithImpl<_$ReflectionStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReflectionStatsImplToJson(
      this,
    );
  }
}

abstract class _ReflectionStats implements ReflectionStats {
  const factory _ReflectionStats(
      {required final int totalReflections,
      required final int currentStreak,
      required final int longestStreak,
      final double? averageMood,
      final double? averageEnergy,
      final double? averageProductivity,
      final Map<String, int>? moodDistribution,
      final Map<String, int>? tagFrequency,
      final List<ReflectionTrend> trends}) = _$ReflectionStatsImpl;

  factory _ReflectionStats.fromJson(Map<String, dynamic> json) =
      _$ReflectionStatsImpl.fromJson;

  @override
  int get totalReflections;
  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  double? get averageMood;
  @override
  double? get averageEnergy;
  @override
  double? get averageProductivity;
  @override
  Map<String, int>? get moodDistribution;
  @override
  Map<String, int>? get tagFrequency;
  @override
  List<ReflectionTrend> get trends;
  @override
  @JsonKey(ignore: true)
  _$$ReflectionStatsImplCopyWith<_$ReflectionStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReflectionTrend _$ReflectionTrendFromJson(Map<String, dynamic> json) {
  return _ReflectionTrend.fromJson(json);
}

/// @nodoc
mixin _$ReflectionTrend {
  DateTime get date => throw _privateConstructorUsedError;
  double? get mood => throw _privateConstructorUsedError;
  double? get energy => throw _privateConstructorUsedError;
  double? get productivity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReflectionTrendCopyWith<ReflectionTrend> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReflectionTrendCopyWith<$Res> {
  factory $ReflectionTrendCopyWith(
          ReflectionTrend value, $Res Function(ReflectionTrend) then) =
      _$ReflectionTrendCopyWithImpl<$Res, ReflectionTrend>;
  @useResult
  $Res call(
      {DateTime date, double? mood, double? energy, double? productivity});
}

/// @nodoc
class _$ReflectionTrendCopyWithImpl<$Res, $Val extends ReflectionTrend>
    implements $ReflectionTrendCopyWith<$Res> {
  _$ReflectionTrendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? mood = freezed,
    Object? energy = freezed,
    Object? productivity = freezed,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      mood: freezed == mood
          ? _value.mood
          : mood // ignore: cast_nullable_to_non_nullable
              as double?,
      energy: freezed == energy
          ? _value.energy
          : energy // ignore: cast_nullable_to_non_nullable
              as double?,
      productivity: freezed == productivity
          ? _value.productivity
          : productivity // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReflectionTrendImplCopyWith<$Res>
    implements $ReflectionTrendCopyWith<$Res> {
  factory _$$ReflectionTrendImplCopyWith(_$ReflectionTrendImpl value,
          $Res Function(_$ReflectionTrendImpl) then) =
      __$$ReflectionTrendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date, double? mood, double? energy, double? productivity});
}

/// @nodoc
class __$$ReflectionTrendImplCopyWithImpl<$Res>
    extends _$ReflectionTrendCopyWithImpl<$Res, _$ReflectionTrendImpl>
    implements _$$ReflectionTrendImplCopyWith<$Res> {
  __$$ReflectionTrendImplCopyWithImpl(
      _$ReflectionTrendImpl _value, $Res Function(_$ReflectionTrendImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? mood = freezed,
    Object? energy = freezed,
    Object? productivity = freezed,
  }) {
    return _then(_$ReflectionTrendImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      mood: freezed == mood
          ? _value.mood
          : mood // ignore: cast_nullable_to_non_nullable
              as double?,
      energy: freezed == energy
          ? _value.energy
          : energy // ignore: cast_nullable_to_non_nullable
              as double?,
      productivity: freezed == productivity
          ? _value.productivity
          : productivity // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReflectionTrendImpl implements _ReflectionTrend {
  const _$ReflectionTrendImpl(
      {required this.date, this.mood, this.energy, this.productivity});

  factory _$ReflectionTrendImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReflectionTrendImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double? mood;
  @override
  final double? energy;
  @override
  final double? productivity;

  @override
  String toString() {
    return 'ReflectionTrend(date: $date, mood: $mood, energy: $energy, productivity: $productivity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReflectionTrendImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.mood, mood) || other.mood == mood) &&
            (identical(other.energy, energy) || other.energy == energy) &&
            (identical(other.productivity, productivity) ||
                other.productivity == productivity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, mood, energy, productivity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReflectionTrendImplCopyWith<_$ReflectionTrendImpl> get copyWith =>
      __$$ReflectionTrendImplCopyWithImpl<_$ReflectionTrendImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReflectionTrendImplToJson(
      this,
    );
  }
}

abstract class _ReflectionTrend implements ReflectionTrend {
  const factory _ReflectionTrend(
      {required final DateTime date,
      final double? mood,
      final double? energy,
      final double? productivity}) = _$ReflectionTrendImpl;

  factory _ReflectionTrend.fromJson(Map<String, dynamic> json) =
      _$ReflectionTrendImpl.fromJson;

  @override
  DateTime get date;
  @override
  double? get mood;
  @override
  double? get energy;
  @override
  double? get productivity;
  @override
  @JsonKey(ignore: true)
  _$$ReflectionTrendImplCopyWith<_$ReflectionTrendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReflectionFilter _$ReflectionFilterFromJson(Map<String, dynamic> json) {
  return _ReflectionFilter.fromJson(json);
}

/// @nodoc
mixin _$ReflectionFilter {
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  List<MoodRating>? get moods => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  bool get hasGratitude => throw _privateConstructorUsedError;
  bool get hasAccomplishments => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReflectionFilterCopyWith<ReflectionFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReflectionFilterCopyWith<$Res> {
  factory $ReflectionFilterCopyWith(
          ReflectionFilter value, $Res Function(ReflectionFilter) then) =
      _$ReflectionFilterCopyWithImpl<$Res, ReflectionFilter>;
  @useResult
  $Res call(
      {DateTime? startDate,
      DateTime? endDate,
      List<MoodRating>? moods,
      List<String>? tags,
      bool hasGratitude,
      bool hasAccomplishments,
      String? searchQuery});
}

/// @nodoc
class _$ReflectionFilterCopyWithImpl<$Res, $Val extends ReflectionFilter>
    implements $ReflectionFilterCopyWith<$Res> {
  _$ReflectionFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? moods = freezed,
    Object? tags = freezed,
    Object? hasGratitude = null,
    Object? hasAccomplishments = null,
    Object? searchQuery = freezed,
  }) {
    return _then(_value.copyWith(
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      moods: freezed == moods
          ? _value.moods
          : moods // ignore: cast_nullable_to_non_nullable
              as List<MoodRating>?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hasGratitude: null == hasGratitude
          ? _value.hasGratitude
          : hasGratitude // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAccomplishments: null == hasAccomplishments
          ? _value.hasAccomplishments
          : hasAccomplishments // ignore: cast_nullable_to_non_nullable
              as bool,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReflectionFilterImplCopyWith<$Res>
    implements $ReflectionFilterCopyWith<$Res> {
  factory _$$ReflectionFilterImplCopyWith(_$ReflectionFilterImpl value,
          $Res Function(_$ReflectionFilterImpl) then) =
      __$$ReflectionFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime? startDate,
      DateTime? endDate,
      List<MoodRating>? moods,
      List<String>? tags,
      bool hasGratitude,
      bool hasAccomplishments,
      String? searchQuery});
}

/// @nodoc
class __$$ReflectionFilterImplCopyWithImpl<$Res>
    extends _$ReflectionFilterCopyWithImpl<$Res, _$ReflectionFilterImpl>
    implements _$$ReflectionFilterImplCopyWith<$Res> {
  __$$ReflectionFilterImplCopyWithImpl(_$ReflectionFilterImpl _value,
      $Res Function(_$ReflectionFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? moods = freezed,
    Object? tags = freezed,
    Object? hasGratitude = null,
    Object? hasAccomplishments = null,
    Object? searchQuery = freezed,
  }) {
    return _then(_$ReflectionFilterImpl(
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      moods: freezed == moods
          ? _value._moods
          : moods // ignore: cast_nullable_to_non_nullable
              as List<MoodRating>?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hasGratitude: null == hasGratitude
          ? _value.hasGratitude
          : hasGratitude // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAccomplishments: null == hasAccomplishments
          ? _value.hasAccomplishments
          : hasAccomplishments // ignore: cast_nullable_to_non_nullable
              as bool,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReflectionFilterImpl implements _ReflectionFilter {
  const _$ReflectionFilterImpl(
      {this.startDate,
      this.endDate,
      final List<MoodRating>? moods,
      final List<String>? tags,
      this.hasGratitude = false,
      this.hasAccomplishments = false,
      this.searchQuery})
      : _moods = moods,
        _tags = tags;

  factory _$ReflectionFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReflectionFilterImplFromJson(json);

  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  final List<MoodRating>? _moods;
  @override
  List<MoodRating>? get moods {
    final value = _moods;
    if (value == null) return null;
    if (_moods is EqualUnmodifiableListView) return _moods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool hasGratitude;
  @override
  @JsonKey()
  final bool hasAccomplishments;
  @override
  final String? searchQuery;

  @override
  String toString() {
    return 'ReflectionFilter(startDate: $startDate, endDate: $endDate, moods: $moods, tags: $tags, hasGratitude: $hasGratitude, hasAccomplishments: $hasAccomplishments, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReflectionFilterImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(other._moods, _moods) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.hasGratitude, hasGratitude) ||
                other.hasGratitude == hasGratitude) &&
            (identical(other.hasAccomplishments, hasAccomplishments) ||
                other.hasAccomplishments == hasAccomplishments) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      startDate,
      endDate,
      const DeepCollectionEquality().hash(_moods),
      const DeepCollectionEquality().hash(_tags),
      hasGratitude,
      hasAccomplishments,
      searchQuery);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReflectionFilterImplCopyWith<_$ReflectionFilterImpl> get copyWith =>
      __$$ReflectionFilterImplCopyWithImpl<_$ReflectionFilterImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReflectionFilterImplToJson(
      this,
    );
  }
}

abstract class _ReflectionFilter implements ReflectionFilter {
  const factory _ReflectionFilter(
      {final DateTime? startDate,
      final DateTime? endDate,
      final List<MoodRating>? moods,
      final List<String>? tags,
      final bool hasGratitude,
      final bool hasAccomplishments,
      final String? searchQuery}) = _$ReflectionFilterImpl;

  factory _ReflectionFilter.fromJson(Map<String, dynamic> json) =
      _$ReflectionFilterImpl.fromJson;

  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  List<MoodRating>? get moods;
  @override
  List<String>? get tags;
  @override
  bool get hasGratitude;
  @override
  bool get hasAccomplishments;
  @override
  String? get searchQuery;
  @override
  @JsonKey(ignore: true)
  _$$ReflectionFilterImplCopyWith<_$ReflectionFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReflectionPrompt _$ReflectionPromptFromJson(Map<String, dynamic> json) {
  return _ReflectionPrompt.fromJson(json);
}

/// @nodoc
mixin _$ReflectionPrompt {
  String get id => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  List<String> get followUpQuestions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReflectionPromptCopyWith<ReflectionPrompt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReflectionPromptCopyWith<$Res> {
  factory $ReflectionPromptCopyWith(
          ReflectionPrompt value, $Res Function(ReflectionPrompt) then) =
      _$ReflectionPromptCopyWithImpl<$Res, ReflectionPrompt>;
  @useResult
  $Res call(
      {String id,
      String category,
      String text,
      List<String> followUpQuestions});
}

/// @nodoc
class _$ReflectionPromptCopyWithImpl<$Res, $Val extends ReflectionPrompt>
    implements $ReflectionPromptCopyWith<$Res> {
  _$ReflectionPromptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? text = null,
    Object? followUpQuestions = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      followUpQuestions: null == followUpQuestions
          ? _value.followUpQuestions
          : followUpQuestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReflectionPromptImplCopyWith<$Res>
    implements $ReflectionPromptCopyWith<$Res> {
  factory _$$ReflectionPromptImplCopyWith(_$ReflectionPromptImpl value,
          $Res Function(_$ReflectionPromptImpl) then) =
      __$$ReflectionPromptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String category,
      String text,
      List<String> followUpQuestions});
}

/// @nodoc
class __$$ReflectionPromptImplCopyWithImpl<$Res>
    extends _$ReflectionPromptCopyWithImpl<$Res, _$ReflectionPromptImpl>
    implements _$$ReflectionPromptImplCopyWith<$Res> {
  __$$ReflectionPromptImplCopyWithImpl(_$ReflectionPromptImpl _value,
      $Res Function(_$ReflectionPromptImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? text = null,
    Object? followUpQuestions = null,
  }) {
    return _then(_$ReflectionPromptImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      followUpQuestions: null == followUpQuestions
          ? _value._followUpQuestions
          : followUpQuestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReflectionPromptImpl implements _ReflectionPrompt {
  const _$ReflectionPromptImpl(
      {required this.id,
      required this.category,
      required this.text,
      final List<String> followUpQuestions = const []})
      : _followUpQuestions = followUpQuestions;

  factory _$ReflectionPromptImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReflectionPromptImplFromJson(json);

  @override
  final String id;
  @override
  final String category;
  @override
  final String text;
  final List<String> _followUpQuestions;
  @override
  @JsonKey()
  List<String> get followUpQuestions {
    if (_followUpQuestions is EqualUnmodifiableListView)
      return _followUpQuestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_followUpQuestions);
  }

  @override
  String toString() {
    return 'ReflectionPrompt(id: $id, category: $category, text: $text, followUpQuestions: $followUpQuestions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReflectionPromptImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality()
                .equals(other._followUpQuestions, _followUpQuestions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, category, text,
      const DeepCollectionEquality().hash(_followUpQuestions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReflectionPromptImplCopyWith<_$ReflectionPromptImpl> get copyWith =>
      __$$ReflectionPromptImplCopyWithImpl<_$ReflectionPromptImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReflectionPromptImplToJson(
      this,
    );
  }
}

abstract class _ReflectionPrompt implements ReflectionPrompt {
  const factory _ReflectionPrompt(
      {required final String id,
      required final String category,
      required final String text,
      final List<String> followUpQuestions}) = _$ReflectionPromptImpl;

  factory _ReflectionPrompt.fromJson(Map<String, dynamic> json) =
      _$ReflectionPromptImpl.fromJson;

  @override
  String get id;
  @override
  String get category;
  @override
  String get text;
  @override
  List<String> get followUpQuestions;
  @override
  @JsonKey(ignore: true)
  _$$ReflectionPromptImplCopyWith<_$ReflectionPromptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
