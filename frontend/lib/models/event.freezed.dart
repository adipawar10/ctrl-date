// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Event _$EventFromJson(Map<String, dynamic> json) {
  return _Event.fromJson(json);
}

/// @nodoc
mixin _$Event {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  bool get isAllDay => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get locationUrl => throw _privateConstructorUsedError;
  EventStatus get status => throw _privateConstructorUsedError;
  EventPriority get priority => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  RecurrenceRule? get recurrenceRule => throw _privateConstructorUsedError;
  String? get parentEventId => throw _privateConstructorUsedError;
  List<EventReminder> get reminders => throw _privateConstructorUsedError;
  List<EventAttachment> get attachments => throw _privateConstructorUsedError;
  bool get isPrivate => throw _privateConstructorUsedError;
  String? get encryptedData => throw _privateConstructorUsedError;
  bool get isShared => throw _privateConstructorUsedError;
  List<String> get sharedWithUserIds => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  bool get isSynced => throw _privateConstructorUsedError;
  int? get syncVersion => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res, Event>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String? description,
      DateTime startTime,
      DateTime endTime,
      bool isAllDay,
      String? location,
      String? locationUrl,
      EventStatus status,
      EventPriority priority,
      String? color,
      List<String> tags,
      RecurrenceRule? recurrenceRule,
      String? parentEventId,
      List<EventReminder> reminders,
      List<EventAttachment> attachments,
      bool isPrivate,
      String? encryptedData,
      bool isShared,
      List<String> sharedWithUserIds,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool isSynced,
      int? syncVersion});

  $RecurrenceRuleCopyWith<$Res>? get recurrenceRule;
}

/// @nodoc
class _$EventCopyWithImpl<$Res, $Val extends Event>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? startTime = null,
    Object? endTime = null,
    Object? isAllDay = null,
    Object? location = freezed,
    Object? locationUrl = freezed,
    Object? status = null,
    Object? priority = null,
    Object? color = freezed,
    Object? tags = null,
    Object? recurrenceRule = freezed,
    Object? parentEventId = freezed,
    Object? reminders = null,
    Object? attachments = null,
    Object? isPrivate = null,
    Object? encryptedData = freezed,
    Object? isShared = null,
    Object? sharedWithUserIds = null,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isAllDay: null == isAllDay
          ? _value.isAllDay
          : isAllDay // ignore: cast_nullable_to_non_nullable
              as bool,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      locationUrl: freezed == locationUrl
          ? _value.locationUrl
          : locationUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as EventPriority,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recurrenceRule: freezed == recurrenceRule
          ? _value.recurrenceRule
          : recurrenceRule // ignore: cast_nullable_to_non_nullable
              as RecurrenceRule?,
      parentEventId: freezed == parentEventId
          ? _value.parentEventId
          : parentEventId // ignore: cast_nullable_to_non_nullable
              as String?,
      reminders: null == reminders
          ? _value.reminders
          : reminders // ignore: cast_nullable_to_non_nullable
              as List<EventReminder>,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<EventAttachment>,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      encryptedData: freezed == encryptedData
          ? _value.encryptedData
          : encryptedData // ignore: cast_nullable_to_non_nullable
              as String?,
      isShared: null == isShared
          ? _value.isShared
          : isShared // ignore: cast_nullable_to_non_nullable
              as bool,
      sharedWithUserIds: null == sharedWithUserIds
          ? _value.sharedWithUserIds
          : sharedWithUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
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

  @override
  @pragma('vm:prefer-inline')
  $RecurrenceRuleCopyWith<$Res>? get recurrenceRule {
    if (_value.recurrenceRule == null) {
      return null;
    }

    return $RecurrenceRuleCopyWith<$Res>(_value.recurrenceRule!, (value) {
      return _then(_value.copyWith(recurrenceRule: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventImplCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$EventImplCopyWith(
          _$EventImpl value, $Res Function(_$EventImpl) then) =
      __$$EventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String? description,
      DateTime startTime,
      DateTime endTime,
      bool isAllDay,
      String? location,
      String? locationUrl,
      EventStatus status,
      EventPriority priority,
      String? color,
      List<String> tags,
      RecurrenceRule? recurrenceRule,
      String? parentEventId,
      List<EventReminder> reminders,
      List<EventAttachment> attachments,
      bool isPrivate,
      String? encryptedData,
      bool isShared,
      List<String> sharedWithUserIds,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool isSynced,
      int? syncVersion});

  @override
  $RecurrenceRuleCopyWith<$Res>? get recurrenceRule;
}

/// @nodoc
class __$$EventImplCopyWithImpl<$Res>
    extends _$EventCopyWithImpl<$Res, _$EventImpl>
    implements _$$EventImplCopyWith<$Res> {
  __$$EventImplCopyWithImpl(
      _$EventImpl _value, $Res Function(_$EventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? startTime = null,
    Object? endTime = null,
    Object? isAllDay = null,
    Object? location = freezed,
    Object? locationUrl = freezed,
    Object? status = null,
    Object? priority = null,
    Object? color = freezed,
    Object? tags = null,
    Object? recurrenceRule = freezed,
    Object? parentEventId = freezed,
    Object? reminders = null,
    Object? attachments = null,
    Object? isPrivate = null,
    Object? encryptedData = freezed,
    Object? isShared = null,
    Object? sharedWithUserIds = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isSynced = null,
    Object? syncVersion = freezed,
  }) {
    return _then(_$EventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isAllDay: null == isAllDay
          ? _value.isAllDay
          : isAllDay // ignore: cast_nullable_to_non_nullable
              as bool,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      locationUrl: freezed == locationUrl
          ? _value.locationUrl
          : locationUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as EventPriority,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recurrenceRule: freezed == recurrenceRule
          ? _value.recurrenceRule
          : recurrenceRule // ignore: cast_nullable_to_non_nullable
              as RecurrenceRule?,
      parentEventId: freezed == parentEventId
          ? _value.parentEventId
          : parentEventId // ignore: cast_nullable_to_non_nullable
              as String?,
      reminders: null == reminders
          ? _value._reminders
          : reminders // ignore: cast_nullable_to_non_nullable
              as List<EventReminder>,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<EventAttachment>,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      encryptedData: freezed == encryptedData
          ? _value.encryptedData
          : encryptedData // ignore: cast_nullable_to_non_nullable
              as String?,
      isShared: null == isShared
          ? _value.isShared
          : isShared // ignore: cast_nullable_to_non_nullable
              as bool,
      sharedWithUserIds: null == sharedWithUserIds
          ? _value._sharedWithUserIds
          : sharedWithUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
class _$EventImpl extends _Event {
  const _$EventImpl(
      {required this.id,
      required this.userId,
      required this.title,
      this.description,
      required this.startTime,
      required this.endTime,
      this.isAllDay = false,
      this.location,
      this.locationUrl,
      this.status = EventStatus.scheduled,
      this.priority = EventPriority.medium,
      this.color,
      final List<String> tags = const [],
      this.recurrenceRule,
      this.parentEventId,
      final List<EventReminder> reminders = const [],
      final List<EventAttachment> attachments = const [],
      this.isPrivate = false,
      this.encryptedData,
      this.isShared = false,
      final List<String> sharedWithUserIds = const [],
      this.createdAt,
      this.updatedAt,
      this.isSynced = false,
      this.syncVersion})
      : _tags = tags,
        _reminders = reminders,
        _attachments = attachments,
        _sharedWithUserIds = sharedWithUserIds,
        super._();

  factory _$EventImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  @JsonKey()
  final bool isAllDay;
  @override
  final String? location;
  @override
  final String? locationUrl;
  @override
  @JsonKey()
  final EventStatus status;
  @override
  @JsonKey()
  final EventPriority priority;
  @override
  final String? color;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final RecurrenceRule? recurrenceRule;
  @override
  final String? parentEventId;
  final List<EventReminder> _reminders;
  @override
  @JsonKey()
  List<EventReminder> get reminders {
    if (_reminders is EqualUnmodifiableListView) return _reminders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reminders);
  }

  final List<EventAttachment> _attachments;
  @override
  @JsonKey()
  List<EventAttachment> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  @JsonKey()
  final bool isPrivate;
  @override
  final String? encryptedData;
  @override
  @JsonKey()
  final bool isShared;
  final List<String> _sharedWithUserIds;
  @override
  @JsonKey()
  List<String> get sharedWithUserIds {
    if (_sharedWithUserIds is EqualUnmodifiableListView)
      return _sharedWithUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sharedWithUserIds);
  }

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
    return 'Event(id: $id, userId: $userId, title: $title, description: $description, startTime: $startTime, endTime: $endTime, isAllDay: $isAllDay, location: $location, locationUrl: $locationUrl, status: $status, priority: $priority, color: $color, tags: $tags, recurrenceRule: $recurrenceRule, parentEventId: $parentEventId, reminders: $reminders, attachments: $attachments, isPrivate: $isPrivate, encryptedData: $encryptedData, isShared: $isShared, sharedWithUserIds: $sharedWithUserIds, createdAt: $createdAt, updatedAt: $updatedAt, isSynced: $isSynced, syncVersion: $syncVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.isAllDay, isAllDay) ||
                other.isAllDay == isAllDay) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.locationUrl, locationUrl) ||
                other.locationUrl == locationUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.color, color) || other.color == color) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.recurrenceRule, recurrenceRule) ||
                other.recurrenceRule == recurrenceRule) &&
            (identical(other.parentEventId, parentEventId) ||
                other.parentEventId == parentEventId) &&
            const DeepCollectionEquality()
                .equals(other._reminders, _reminders) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.encryptedData, encryptedData) ||
                other.encryptedData == encryptedData) &&
            (identical(other.isShared, isShared) ||
                other.isShared == isShared) &&
            const DeepCollectionEquality()
                .equals(other._sharedWithUserIds, _sharedWithUserIds) &&
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
        title,
        description,
        startTime,
        endTime,
        isAllDay,
        location,
        locationUrl,
        status,
        priority,
        color,
        const DeepCollectionEquality().hash(_tags),
        recurrenceRule,
        parentEventId,
        const DeepCollectionEquality().hash(_reminders),
        const DeepCollectionEquality().hash(_attachments),
        isPrivate,
        encryptedData,
        isShared,
        const DeepCollectionEquality().hash(_sharedWithUserIds),
        createdAt,
        updatedAt,
        isSynced,
        syncVersion
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      __$$EventImplCopyWithImpl<_$EventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventImplToJson(
      this,
    );
  }
}

abstract class _Event extends Event {
  const factory _Event(
      {required final String id,
      required final String userId,
      required final String title,
      final String? description,
      required final DateTime startTime,
      required final DateTime endTime,
      final bool isAllDay,
      final String? location,
      final String? locationUrl,
      final EventStatus status,
      final EventPriority priority,
      final String? color,
      final List<String> tags,
      final RecurrenceRule? recurrenceRule,
      final String? parentEventId,
      final List<EventReminder> reminders,
      final List<EventAttachment> attachments,
      final bool isPrivate,
      final String? encryptedData,
      final bool isShared,
      final List<String> sharedWithUserIds,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final bool isSynced,
      final int? syncVersion}) = _$EventImpl;
  const _Event._() : super._();

  factory _Event.fromJson(Map<String, dynamic> json) = _$EventImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get title;
  @override
  String? get description;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  bool get isAllDay;
  @override
  String? get location;
  @override
  String? get locationUrl;
  @override
  EventStatus get status;
  @override
  EventPriority get priority;
  @override
  String? get color;
  @override
  List<String> get tags;
  @override
  RecurrenceRule? get recurrenceRule;
  @override
  String? get parentEventId;
  @override
  List<EventReminder> get reminders;
  @override
  List<EventAttachment> get attachments;
  @override
  bool get isPrivate;
  @override
  String? get encryptedData;
  @override
  bool get isShared;
  @override
  List<String> get sharedWithUserIds;
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
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecurrenceRule _$RecurrenceRuleFromJson(Map<String, dynamic> json) {
  return _RecurrenceRule.fromJson(json);
}

/// @nodoc
mixin _$RecurrenceRule {
  RecurrenceFrequency get frequency => throw _privateConstructorUsedError;
  int get interval => throw _privateConstructorUsedError;
  List<int> get byWeekDay =>
      throw _privateConstructorUsedError; // 0 = Monday, 6 = Sunday
  List<int> get byMonthDay => throw _privateConstructorUsedError; // 1-31
  List<int> get byMonth => throw _privateConstructorUsedError; // 1-12
  int? get count => throw _privateConstructorUsedError;
  DateTime? get until => throw _privateConstructorUsedError;
  List<DateTime> get exceptions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecurrenceRuleCopyWith<RecurrenceRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurrenceRuleCopyWith<$Res> {
  factory $RecurrenceRuleCopyWith(
          RecurrenceRule value, $Res Function(RecurrenceRule) then) =
      _$RecurrenceRuleCopyWithImpl<$Res, RecurrenceRule>;
  @useResult
  $Res call(
      {RecurrenceFrequency frequency,
      int interval,
      List<int> byWeekDay,
      List<int> byMonthDay,
      List<int> byMonth,
      int? count,
      DateTime? until,
      List<DateTime> exceptions});
}

/// @nodoc
class _$RecurrenceRuleCopyWithImpl<$Res, $Val extends RecurrenceRule>
    implements $RecurrenceRuleCopyWith<$Res> {
  _$RecurrenceRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frequency = null,
    Object? interval = null,
    Object? byWeekDay = null,
    Object? byMonthDay = null,
    Object? byMonth = null,
    Object? count = freezed,
    Object? until = freezed,
    Object? exceptions = null,
  }) {
    return _then(_value.copyWith(
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as RecurrenceFrequency,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      byWeekDay: null == byWeekDay
          ? _value.byWeekDay
          : byWeekDay // ignore: cast_nullable_to_non_nullable
              as List<int>,
      byMonthDay: null == byMonthDay
          ? _value.byMonthDay
          : byMonthDay // ignore: cast_nullable_to_non_nullable
              as List<int>,
      byMonth: null == byMonth
          ? _value.byMonth
          : byMonth // ignore: cast_nullable_to_non_nullable
              as List<int>,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      until: freezed == until
          ? _value.until
          : until // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      exceptions: null == exceptions
          ? _value.exceptions
          : exceptions // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecurrenceRuleImplCopyWith<$Res>
    implements $RecurrenceRuleCopyWith<$Res> {
  factory _$$RecurrenceRuleImplCopyWith(_$RecurrenceRuleImpl value,
          $Res Function(_$RecurrenceRuleImpl) then) =
      __$$RecurrenceRuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {RecurrenceFrequency frequency,
      int interval,
      List<int> byWeekDay,
      List<int> byMonthDay,
      List<int> byMonth,
      int? count,
      DateTime? until,
      List<DateTime> exceptions});
}

/// @nodoc
class __$$RecurrenceRuleImplCopyWithImpl<$Res>
    extends _$RecurrenceRuleCopyWithImpl<$Res, _$RecurrenceRuleImpl>
    implements _$$RecurrenceRuleImplCopyWith<$Res> {
  __$$RecurrenceRuleImplCopyWithImpl(
      _$RecurrenceRuleImpl _value, $Res Function(_$RecurrenceRuleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frequency = null,
    Object? interval = null,
    Object? byWeekDay = null,
    Object? byMonthDay = null,
    Object? byMonth = null,
    Object? count = freezed,
    Object? until = freezed,
    Object? exceptions = null,
  }) {
    return _then(_$RecurrenceRuleImpl(
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as RecurrenceFrequency,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      byWeekDay: null == byWeekDay
          ? _value._byWeekDay
          : byWeekDay // ignore: cast_nullable_to_non_nullable
              as List<int>,
      byMonthDay: null == byMonthDay
          ? _value._byMonthDay
          : byMonthDay // ignore: cast_nullable_to_non_nullable
              as List<int>,
      byMonth: null == byMonth
          ? _value._byMonth
          : byMonth // ignore: cast_nullable_to_non_nullable
              as List<int>,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      until: freezed == until
          ? _value.until
          : until // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      exceptions: null == exceptions
          ? _value._exceptions
          : exceptions // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecurrenceRuleImpl extends _RecurrenceRule {
  const _$RecurrenceRuleImpl(
      {required this.frequency,
      this.interval = 1,
      final List<int> byWeekDay = const [],
      final List<int> byMonthDay = const [],
      final List<int> byMonth = const [],
      this.count,
      this.until,
      final List<DateTime> exceptions = const []})
      : _byWeekDay = byWeekDay,
        _byMonthDay = byMonthDay,
        _byMonth = byMonth,
        _exceptions = exceptions,
        super._();

  factory _$RecurrenceRuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecurrenceRuleImplFromJson(json);

  @override
  final RecurrenceFrequency frequency;
  @override
  @JsonKey()
  final int interval;
  final List<int> _byWeekDay;
  @override
  @JsonKey()
  List<int> get byWeekDay {
    if (_byWeekDay is EqualUnmodifiableListView) return _byWeekDay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byWeekDay);
  }

// 0 = Monday, 6 = Sunday
  final List<int> _byMonthDay;
// 0 = Monday, 6 = Sunday
  @override
  @JsonKey()
  List<int> get byMonthDay {
    if (_byMonthDay is EqualUnmodifiableListView) return _byMonthDay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byMonthDay);
  }

// 1-31
  final List<int> _byMonth;
// 1-31
  @override
  @JsonKey()
  List<int> get byMonth {
    if (_byMonth is EqualUnmodifiableListView) return _byMonth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byMonth);
  }

// 1-12
  @override
  final int? count;
  @override
  final DateTime? until;
  final List<DateTime> _exceptions;
  @override
  @JsonKey()
  List<DateTime> get exceptions {
    if (_exceptions is EqualUnmodifiableListView) return _exceptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exceptions);
  }

  @override
  String toString() {
    return 'RecurrenceRule(frequency: $frequency, interval: $interval, byWeekDay: $byWeekDay, byMonthDay: $byMonthDay, byMonth: $byMonth, count: $count, until: $until, exceptions: $exceptions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurrenceRuleImpl &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            const DeepCollectionEquality()
                .equals(other._byWeekDay, _byWeekDay) &&
            const DeepCollectionEquality()
                .equals(other._byMonthDay, _byMonthDay) &&
            const DeepCollectionEquality().equals(other._byMonth, _byMonth) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.until, until) || other.until == until) &&
            const DeepCollectionEquality()
                .equals(other._exceptions, _exceptions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      frequency,
      interval,
      const DeepCollectionEquality().hash(_byWeekDay),
      const DeepCollectionEquality().hash(_byMonthDay),
      const DeepCollectionEquality().hash(_byMonth),
      count,
      until,
      const DeepCollectionEquality().hash(_exceptions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurrenceRuleImplCopyWith<_$RecurrenceRuleImpl> get copyWith =>
      __$$RecurrenceRuleImplCopyWithImpl<_$RecurrenceRuleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurrenceRuleImplToJson(
      this,
    );
  }
}

abstract class _RecurrenceRule extends RecurrenceRule {
  const factory _RecurrenceRule(
      {required final RecurrenceFrequency frequency,
      final int interval,
      final List<int> byWeekDay,
      final List<int> byMonthDay,
      final List<int> byMonth,
      final int? count,
      final DateTime? until,
      final List<DateTime> exceptions}) = _$RecurrenceRuleImpl;
  const _RecurrenceRule._() : super._();

  factory _RecurrenceRule.fromJson(Map<String, dynamic> json) =
      _$RecurrenceRuleImpl.fromJson;

  @override
  RecurrenceFrequency get frequency;
  @override
  int get interval;
  @override
  List<int> get byWeekDay;
  @override // 0 = Monday, 6 = Sunday
  List<int> get byMonthDay;
  @override // 1-31
  List<int> get byMonth;
  @override // 1-12
  int? get count;
  @override
  DateTime? get until;
  @override
  List<DateTime> get exceptions;
  @override
  @JsonKey(ignore: true)
  _$$RecurrenceRuleImplCopyWith<_$RecurrenceRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventReminder _$EventReminderFromJson(Map<String, dynamic> json) {
  return _EventReminder.fromJson(json);
}

/// @nodoc
mixin _$EventReminder {
  String get id => throw _privateConstructorUsedError;
  int get minutesBefore => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'push', 'email', 'sms'
  bool get isSent => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventReminderCopyWith<EventReminder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventReminderCopyWith<$Res> {
  factory $EventReminderCopyWith(
          EventReminder value, $Res Function(EventReminder) then) =
      _$EventReminderCopyWithImpl<$Res, EventReminder>;
  @useResult
  $Res call({String id, int minutesBefore, String type, bool isSent});
}

/// @nodoc
class _$EventReminderCopyWithImpl<$Res, $Val extends EventReminder>
    implements $EventReminderCopyWith<$Res> {
  _$EventReminderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? minutesBefore = null,
    Object? type = null,
    Object? isSent = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      minutesBefore: null == minutesBefore
          ? _value.minutesBefore
          : minutesBefore // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      isSent: null == isSent
          ? _value.isSent
          : isSent // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventReminderImplCopyWith<$Res>
    implements $EventReminderCopyWith<$Res> {
  factory _$$EventReminderImplCopyWith(
          _$EventReminderImpl value, $Res Function(_$EventReminderImpl) then) =
      __$$EventReminderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, int minutesBefore, String type, bool isSent});
}

/// @nodoc
class __$$EventReminderImplCopyWithImpl<$Res>
    extends _$EventReminderCopyWithImpl<$Res, _$EventReminderImpl>
    implements _$$EventReminderImplCopyWith<$Res> {
  __$$EventReminderImplCopyWithImpl(
      _$EventReminderImpl _value, $Res Function(_$EventReminderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? minutesBefore = null,
    Object? type = null,
    Object? isSent = null,
  }) {
    return _then(_$EventReminderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      minutesBefore: null == minutesBefore
          ? _value.minutesBefore
          : minutesBefore // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      isSent: null == isSent
          ? _value.isSent
          : isSent // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventReminderImpl implements _EventReminder {
  const _$EventReminderImpl(
      {required this.id,
      required this.minutesBefore,
      this.type = 'push',
      this.isSent = false});

  factory _$EventReminderImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventReminderImplFromJson(json);

  @override
  final String id;
  @override
  final int minutesBefore;
  @override
  @JsonKey()
  final String type;
// 'push', 'email', 'sms'
  @override
  @JsonKey()
  final bool isSent;

  @override
  String toString() {
    return 'EventReminder(id: $id, minutesBefore: $minutesBefore, type: $type, isSent: $isSent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventReminderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.minutesBefore, minutesBefore) ||
                other.minutesBefore == minutesBefore) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isSent, isSent) || other.isSent == isSent));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, minutesBefore, type, isSent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventReminderImplCopyWith<_$EventReminderImpl> get copyWith =>
      __$$EventReminderImplCopyWithImpl<_$EventReminderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventReminderImplToJson(
      this,
    );
  }
}

abstract class _EventReminder implements EventReminder {
  const factory _EventReminder(
      {required final String id,
      required final int minutesBefore,
      final String type,
      final bool isSent}) = _$EventReminderImpl;

  factory _EventReminder.fromJson(Map<String, dynamic> json) =
      _$EventReminderImpl.fromJson;

  @override
  String get id;
  @override
  int get minutesBefore;
  @override
  String get type;
  @override // 'push', 'email', 'sms'
  bool get isSent;
  @override
  @JsonKey(ignore: true)
  _$$EventReminderImplCopyWith<_$EventReminderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventAttachment _$EventAttachmentFromJson(Map<String, dynamic> json) {
  return _EventAttachment.fromJson(json);
}

/// @nodoc
mixin _$EventAttachment {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String? get mimeType => throw _privateConstructorUsedError;
  int? get sizeBytes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventAttachmentCopyWith<EventAttachment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventAttachmentCopyWith<$Res> {
  factory $EventAttachmentCopyWith(
          EventAttachment value, $Res Function(EventAttachment) then) =
      _$EventAttachmentCopyWithImpl<$Res, EventAttachment>;
  @useResult
  $Res call(
      {String id,
      String name,
      String url,
      String? mimeType,
      int? sizeBytes,
      DateTime? createdAt});
}

/// @nodoc
class _$EventAttachmentCopyWithImpl<$Res, $Val extends EventAttachment>
    implements $EventAttachmentCopyWith<$Res> {
  _$EventAttachmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? url = null,
    Object? mimeType = freezed,
    Object? sizeBytes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      sizeBytes: freezed == sizeBytes
          ? _value.sizeBytes
          : sizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventAttachmentImplCopyWith<$Res>
    implements $EventAttachmentCopyWith<$Res> {
  factory _$$EventAttachmentImplCopyWith(_$EventAttachmentImpl value,
          $Res Function(_$EventAttachmentImpl) then) =
      __$$EventAttachmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String url,
      String? mimeType,
      int? sizeBytes,
      DateTime? createdAt});
}

/// @nodoc
class __$$EventAttachmentImplCopyWithImpl<$Res>
    extends _$EventAttachmentCopyWithImpl<$Res, _$EventAttachmentImpl>
    implements _$$EventAttachmentImplCopyWith<$Res> {
  __$$EventAttachmentImplCopyWithImpl(
      _$EventAttachmentImpl _value, $Res Function(_$EventAttachmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? url = null,
    Object? mimeType = freezed,
    Object? sizeBytes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$EventAttachmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      sizeBytes: freezed == sizeBytes
          ? _value.sizeBytes
          : sizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventAttachmentImpl implements _EventAttachment {
  const _$EventAttachmentImpl(
      {required this.id,
      required this.name,
      required this.url,
      this.mimeType,
      this.sizeBytes,
      this.createdAt});

  factory _$EventAttachmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventAttachmentImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String url;
  @override
  final String? mimeType;
  @override
  final int? sizeBytes;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'EventAttachment(id: $id, name: $name, url: $url, mimeType: $mimeType, sizeBytes: $sizeBytes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventAttachmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.sizeBytes, sizeBytes) ||
                other.sizeBytes == sizeBytes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, url, mimeType, sizeBytes, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventAttachmentImplCopyWith<_$EventAttachmentImpl> get copyWith =>
      __$$EventAttachmentImplCopyWithImpl<_$EventAttachmentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventAttachmentImplToJson(
      this,
    );
  }
}

abstract class _EventAttachment implements EventAttachment {
  const factory _EventAttachment(
      {required final String id,
      required final String name,
      required final String url,
      final String? mimeType,
      final int? sizeBytes,
      final DateTime? createdAt}) = _$EventAttachmentImpl;

  factory _EventAttachment.fromJson(Map<String, dynamic> json) =
      _$EventAttachmentImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get url;
  @override
  String? get mimeType;
  @override
  int? get sizeBytes;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$EventAttachmentImplCopyWith<_$EventAttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventOccurrence _$EventOccurrenceFromJson(Map<String, dynamic> json) {
  return _EventOccurrence.fromJson(json);
}

/// @nodoc
mixin _$EventOccurrence {
  String get eventId => throw _privateConstructorUsedError;
  DateTime get originalStartTime => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  bool get isCancelled => throw _privateConstructorUsedError;
  bool get isModified => throw _privateConstructorUsedError;
  Event? get modifiedEvent => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventOccurrenceCopyWith<EventOccurrence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventOccurrenceCopyWith<$Res> {
  factory $EventOccurrenceCopyWith(
          EventOccurrence value, $Res Function(EventOccurrence) then) =
      _$EventOccurrenceCopyWithImpl<$Res, EventOccurrence>;
  @useResult
  $Res call(
      {String eventId,
      DateTime originalStartTime,
      DateTime startTime,
      DateTime endTime,
      bool isCancelled,
      bool isModified,
      Event? modifiedEvent});

  $EventCopyWith<$Res>? get modifiedEvent;
}

/// @nodoc
class _$EventOccurrenceCopyWithImpl<$Res, $Val extends EventOccurrence>
    implements $EventOccurrenceCopyWith<$Res> {
  _$EventOccurrenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? originalStartTime = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isCancelled = null,
    Object? isModified = null,
    Object? modifiedEvent = freezed,
  }) {
    return _then(_value.copyWith(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      originalStartTime: null == originalStartTime
          ? _value.originalStartTime
          : originalStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isCancelled: null == isCancelled
          ? _value.isCancelled
          : isCancelled // ignore: cast_nullable_to_non_nullable
              as bool,
      isModified: null == isModified
          ? _value.isModified
          : isModified // ignore: cast_nullable_to_non_nullable
              as bool,
      modifiedEvent: freezed == modifiedEvent
          ? _value.modifiedEvent
          : modifiedEvent // ignore: cast_nullable_to_non_nullable
              as Event?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $EventCopyWith<$Res>? get modifiedEvent {
    if (_value.modifiedEvent == null) {
      return null;
    }

    return $EventCopyWith<$Res>(_value.modifiedEvent!, (value) {
      return _then(_value.copyWith(modifiedEvent: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventOccurrenceImplCopyWith<$Res>
    implements $EventOccurrenceCopyWith<$Res> {
  factory _$$EventOccurrenceImplCopyWith(_$EventOccurrenceImpl value,
          $Res Function(_$EventOccurrenceImpl) then) =
      __$$EventOccurrenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String eventId,
      DateTime originalStartTime,
      DateTime startTime,
      DateTime endTime,
      bool isCancelled,
      bool isModified,
      Event? modifiedEvent});

  @override
  $EventCopyWith<$Res>? get modifiedEvent;
}

/// @nodoc
class __$$EventOccurrenceImplCopyWithImpl<$Res>
    extends _$EventOccurrenceCopyWithImpl<$Res, _$EventOccurrenceImpl>
    implements _$$EventOccurrenceImplCopyWith<$Res> {
  __$$EventOccurrenceImplCopyWithImpl(
      _$EventOccurrenceImpl _value, $Res Function(_$EventOccurrenceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? originalStartTime = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isCancelled = null,
    Object? isModified = null,
    Object? modifiedEvent = freezed,
  }) {
    return _then(_$EventOccurrenceImpl(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      originalStartTime: null == originalStartTime
          ? _value.originalStartTime
          : originalStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isCancelled: null == isCancelled
          ? _value.isCancelled
          : isCancelled // ignore: cast_nullable_to_non_nullable
              as bool,
      isModified: null == isModified
          ? _value.isModified
          : isModified // ignore: cast_nullable_to_non_nullable
              as bool,
      modifiedEvent: freezed == modifiedEvent
          ? _value.modifiedEvent
          : modifiedEvent // ignore: cast_nullable_to_non_nullable
              as Event?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventOccurrenceImpl implements _EventOccurrence {
  const _$EventOccurrenceImpl(
      {required this.eventId,
      required this.originalStartTime,
      required this.startTime,
      required this.endTime,
      this.isCancelled = false,
      this.isModified = false,
      this.modifiedEvent});

  factory _$EventOccurrenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventOccurrenceImplFromJson(json);

  @override
  final String eventId;
  @override
  final DateTime originalStartTime;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  @JsonKey()
  final bool isCancelled;
  @override
  @JsonKey()
  final bool isModified;
  @override
  final Event? modifiedEvent;

  @override
  String toString() {
    return 'EventOccurrence(eventId: $eventId, originalStartTime: $originalStartTime, startTime: $startTime, endTime: $endTime, isCancelled: $isCancelled, isModified: $isModified, modifiedEvent: $modifiedEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventOccurrenceImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.originalStartTime, originalStartTime) ||
                other.originalStartTime == originalStartTime) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.isCancelled, isCancelled) ||
                other.isCancelled == isCancelled) &&
            (identical(other.isModified, isModified) ||
                other.isModified == isModified) &&
            (identical(other.modifiedEvent, modifiedEvent) ||
                other.modifiedEvent == modifiedEvent));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, eventId, originalStartTime,
      startTime, endTime, isCancelled, isModified, modifiedEvent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventOccurrenceImplCopyWith<_$EventOccurrenceImpl> get copyWith =>
      __$$EventOccurrenceImplCopyWithImpl<_$EventOccurrenceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventOccurrenceImplToJson(
      this,
    );
  }
}

abstract class _EventOccurrence implements EventOccurrence {
  const factory _EventOccurrence(
      {required final String eventId,
      required final DateTime originalStartTime,
      required final DateTime startTime,
      required final DateTime endTime,
      final bool isCancelled,
      final bool isModified,
      final Event? modifiedEvent}) = _$EventOccurrenceImpl;

  factory _EventOccurrence.fromJson(Map<String, dynamic> json) =
      _$EventOccurrenceImpl.fromJson;

  @override
  String get eventId;
  @override
  DateTime get originalStartTime;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  bool get isCancelled;
  @override
  bool get isModified;
  @override
  Event? get modifiedEvent;
  @override
  @JsonKey(ignore: true)
  _$$EventOccurrenceImplCopyWith<_$EventOccurrenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventFilter _$EventFilterFromJson(Map<String, dynamic> json) {
  return _EventFilter.fromJson(json);
}

/// @nodoc
mixin _$EventFilter {
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  List<EventStatus>? get statuses => throw _privateConstructorUsedError;
  List<EventPriority>? get priorities => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;
  bool get includeRecurring => throw _privateConstructorUsedError;
  bool get onlyShared => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventFilterCopyWith<EventFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventFilterCopyWith<$Res> {
  factory $EventFilterCopyWith(
          EventFilter value, $Res Function(EventFilter) then) =
      _$EventFilterCopyWithImpl<$Res, EventFilter>;
  @useResult
  $Res call(
      {DateTime? startDate,
      DateTime? endDate,
      List<EventStatus>? statuses,
      List<EventPriority>? priorities,
      List<String>? tags,
      String? searchQuery,
      bool includeRecurring,
      bool onlyShared});
}

/// @nodoc
class _$EventFilterCopyWithImpl<$Res, $Val extends EventFilter>
    implements $EventFilterCopyWith<$Res> {
  _$EventFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? statuses = freezed,
    Object? priorities = freezed,
    Object? tags = freezed,
    Object? searchQuery = freezed,
    Object? includeRecurring = null,
    Object? onlyShared = null,
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
      statuses: freezed == statuses
          ? _value.statuses
          : statuses // ignore: cast_nullable_to_non_nullable
              as List<EventStatus>?,
      priorities: freezed == priorities
          ? _value.priorities
          : priorities // ignore: cast_nullable_to_non_nullable
              as List<EventPriority>?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      includeRecurring: null == includeRecurring
          ? _value.includeRecurring
          : includeRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      onlyShared: null == onlyShared
          ? _value.onlyShared
          : onlyShared // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventFilterImplCopyWith<$Res>
    implements $EventFilterCopyWith<$Res> {
  factory _$$EventFilterImplCopyWith(
          _$EventFilterImpl value, $Res Function(_$EventFilterImpl) then) =
      __$$EventFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime? startDate,
      DateTime? endDate,
      List<EventStatus>? statuses,
      List<EventPriority>? priorities,
      List<String>? tags,
      String? searchQuery,
      bool includeRecurring,
      bool onlyShared});
}

/// @nodoc
class __$$EventFilterImplCopyWithImpl<$Res>
    extends _$EventFilterCopyWithImpl<$Res, _$EventFilterImpl>
    implements _$$EventFilterImplCopyWith<$Res> {
  __$$EventFilterImplCopyWithImpl(
      _$EventFilterImpl _value, $Res Function(_$EventFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? statuses = freezed,
    Object? priorities = freezed,
    Object? tags = freezed,
    Object? searchQuery = freezed,
    Object? includeRecurring = null,
    Object? onlyShared = null,
  }) {
    return _then(_$EventFilterImpl(
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      statuses: freezed == statuses
          ? _value._statuses
          : statuses // ignore: cast_nullable_to_non_nullable
              as List<EventStatus>?,
      priorities: freezed == priorities
          ? _value._priorities
          : priorities // ignore: cast_nullable_to_non_nullable
              as List<EventPriority>?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      includeRecurring: null == includeRecurring
          ? _value.includeRecurring
          : includeRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      onlyShared: null == onlyShared
          ? _value.onlyShared
          : onlyShared // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventFilterImpl implements _EventFilter {
  const _$EventFilterImpl(
      {this.startDate,
      this.endDate,
      final List<EventStatus>? statuses,
      final List<EventPriority>? priorities,
      final List<String>? tags,
      this.searchQuery,
      this.includeRecurring = false,
      this.onlyShared = false})
      : _statuses = statuses,
        _priorities = priorities,
        _tags = tags;

  factory _$EventFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventFilterImplFromJson(json);

  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  final List<EventStatus>? _statuses;
  @override
  List<EventStatus>? get statuses {
    final value = _statuses;
    if (value == null) return null;
    if (_statuses is EqualUnmodifiableListView) return _statuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<EventPriority>? _priorities;
  @override
  List<EventPriority>? get priorities {
    final value = _priorities;
    if (value == null) return null;
    if (_priorities is EqualUnmodifiableListView) return _priorities;
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
  final String? searchQuery;
  @override
  @JsonKey()
  final bool includeRecurring;
  @override
  @JsonKey()
  final bool onlyShared;

  @override
  String toString() {
    return 'EventFilter(startDate: $startDate, endDate: $endDate, statuses: $statuses, priorities: $priorities, tags: $tags, searchQuery: $searchQuery, includeRecurring: $includeRecurring, onlyShared: $onlyShared)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventFilterImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(other._statuses, _statuses) &&
            const DeepCollectionEquality()
                .equals(other._priorities, _priorities) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.includeRecurring, includeRecurring) ||
                other.includeRecurring == includeRecurring) &&
            (identical(other.onlyShared, onlyShared) ||
                other.onlyShared == onlyShared));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      startDate,
      endDate,
      const DeepCollectionEquality().hash(_statuses),
      const DeepCollectionEquality().hash(_priorities),
      const DeepCollectionEquality().hash(_tags),
      searchQuery,
      includeRecurring,
      onlyShared);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventFilterImplCopyWith<_$EventFilterImpl> get copyWith =>
      __$$EventFilterImplCopyWithImpl<_$EventFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventFilterImplToJson(
      this,
    );
  }
}

abstract class _EventFilter implements EventFilter {
  const factory _EventFilter(
      {final DateTime? startDate,
      final DateTime? endDate,
      final List<EventStatus>? statuses,
      final List<EventPriority>? priorities,
      final List<String>? tags,
      final String? searchQuery,
      final bool includeRecurring,
      final bool onlyShared}) = _$EventFilterImpl;

  factory _EventFilter.fromJson(Map<String, dynamic> json) =
      _$EventFilterImpl.fromJson;

  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  List<EventStatus>? get statuses;
  @override
  List<EventPriority>? get priorities;
  @override
  List<String>? get tags;
  @override
  String? get searchQuery;
  @override
  bool get includeRecurring;
  @override
  bool get onlyShared;
  @override
  @JsonKey(ignore: true)
  _$$EventFilterImplCopyWith<_$EventFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
