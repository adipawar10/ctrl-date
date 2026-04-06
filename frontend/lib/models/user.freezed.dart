// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  bool get emailVerified => throw _privateConstructorUsedError;
  bool get phoneVerified => throw _privateConstructorUsedError;
  String? get publicKey => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get lastSeenAt => throw _privateConstructorUsedError;
  UserPreferences? get preferences => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String id,
      String email,
      String? displayName,
      String? avatarUrl,
      String? phoneNumber,
      bool emailVerified,
      bool phoneVerified,
      String? publicKey,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? lastSeenAt,
      UserPreferences? preferences});

  $UserPreferencesCopyWith<$Res>? get preferences;
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
    Object? phoneNumber = freezed,
    Object? emailVerified = null,
    Object? phoneVerified = null,
    Object? publicKey = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? lastSeenAt = freezed,
    Object? preferences = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneVerified: null == phoneVerified
          ? _value.phoneVerified
          : phoneVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      publicKey: freezed == publicKey
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSeenAt: freezed == lastSeenAt
          ? _value.lastSeenAt
          : lastSeenAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      preferences: freezed == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as UserPreferences?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserPreferencesCopyWith<$Res>? get preferences {
    if (_value.preferences == null) {
      return null;
    }

    return $UserPreferencesCopyWith<$Res>(_value.preferences!, (value) {
      return _then(_value.copyWith(preferences: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String? displayName,
      String? avatarUrl,
      String? phoneNumber,
      bool emailVerified,
      bool phoneVerified,
      String? publicKey,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? lastSeenAt,
      UserPreferences? preferences});

  @override
  $UserPreferencesCopyWith<$Res>? get preferences;
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
    Object? phoneNumber = freezed,
    Object? emailVerified = null,
    Object? phoneVerified = null,
    Object? publicKey = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? lastSeenAt = freezed,
    Object? preferences = freezed,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneVerified: null == phoneVerified
          ? _value.phoneVerified
          : phoneVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      publicKey: freezed == publicKey
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSeenAt: freezed == lastSeenAt
          ? _value.lastSeenAt
          : lastSeenAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      preferences: freezed == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as UserPreferences?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.id,
      required this.email,
      this.displayName,
      this.avatarUrl,
      this.phoneNumber,
      this.emailVerified = false,
      this.phoneVerified = false,
      this.publicKey,
      this.createdAt,
      this.updatedAt,
      this.lastSeenAt,
      this.preferences});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String? displayName;
  @override
  final String? avatarUrl;
  @override
  final String? phoneNumber;
  @override
  @JsonKey()
  final bool emailVerified;
  @override
  @JsonKey()
  final bool phoneVerified;
  @override
  final String? publicKey;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? lastSeenAt;
  @override
  final UserPreferences? preferences;

  @override
  String toString() {
    return 'User(id: $id, email: $email, displayName: $displayName, avatarUrl: $avatarUrl, phoneNumber: $phoneNumber, emailVerified: $emailVerified, phoneVerified: $phoneVerified, publicKey: $publicKey, createdAt: $createdAt, updatedAt: $updatedAt, lastSeenAt: $lastSeenAt, preferences: $preferences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.phoneVerified, phoneVerified) ||
                other.phoneVerified == phoneVerified) &&
            (identical(other.publicKey, publicKey) ||
                other.publicKey == publicKey) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastSeenAt, lastSeenAt) ||
                other.lastSeenAt == lastSeenAt) &&
            (identical(other.preferences, preferences) ||
                other.preferences == preferences));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      displayName,
      avatarUrl,
      phoneNumber,
      emailVerified,
      phoneVerified,
      publicKey,
      createdAt,
      updatedAt,
      lastSeenAt,
      preferences);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String id,
      required final String email,
      final String? displayName,
      final String? avatarUrl,
      final String? phoneNumber,
      final bool emailVerified,
      final bool phoneVerified,
      final String? publicKey,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final DateTime? lastSeenAt,
      final UserPreferences? preferences}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String? get displayName;
  @override
  String? get avatarUrl;
  @override
  String? get phoneNumber;
  @override
  bool get emailVerified;
  @override
  bool get phoneVerified;
  @override
  String? get publicKey;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get lastSeenAt;
  @override
  UserPreferences? get preferences;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) {
  return _UserPreferences.fromJson(json);
}

/// @nodoc
mixin _$UserPreferences {
  /// Theme preference: 'light', 'dark', or 'system'
  String get theme => throw _privateConstructorUsedError;

  /// Default notification settings
  bool get notificationsEnabled => throw _privateConstructorUsedError;
  bool get emailNotifications => throw _privateConstructorUsedError;
  bool get pushNotifications => throw _privateConstructorUsedError;

  /// Event default settings
  int get defaultEventDuration => throw _privateConstructorUsedError;
  String get defaultStartTime => throw _privateConstructorUsedError;
  String get defaultEndTime => throw _privateConstructorUsedError;

  /// Calendar preferences
  int get weekStartDay =>
      throw _privateConstructorUsedError; // 0 = Sunday, 1 = Monday
  String get defaultCalendarView => throw _privateConstructorUsedError;
  bool get showWeekNumbers => throw _privateConstructorUsedError;

  /// Reflection preferences
  bool get dailyReflectionReminder => throw _privateConstructorUsedError;
  String get reflectionReminderTime => throw _privateConstructorUsedError;

  /// Privacy settings
  bool get showOnlineStatus => throw _privateConstructorUsedError;
  String get profileVisibility =>
      throw _privateConstructorUsedError; // 'public', 'friends', 'private'
  /// Sync settings
  bool get autoSync => throw _privateConstructorUsedError;
  int get syncIntervalMinutes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserPreferencesCopyWith<UserPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPreferencesCopyWith<$Res> {
  factory $UserPreferencesCopyWith(
          UserPreferences value, $Res Function(UserPreferences) then) =
      _$UserPreferencesCopyWithImpl<$Res, UserPreferences>;
  @useResult
  $Res call(
      {String theme,
      bool notificationsEnabled,
      bool emailNotifications,
      bool pushNotifications,
      int defaultEventDuration,
      String defaultStartTime,
      String defaultEndTime,
      int weekStartDay,
      String defaultCalendarView,
      bool showWeekNumbers,
      bool dailyReflectionReminder,
      String reflectionReminderTime,
      bool showOnlineStatus,
      String profileVisibility,
      bool autoSync,
      int syncIntervalMinutes});
}

/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res, $Val extends UserPreferences>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theme = null,
    Object? notificationsEnabled = null,
    Object? emailNotifications = null,
    Object? pushNotifications = null,
    Object? defaultEventDuration = null,
    Object? defaultStartTime = null,
    Object? defaultEndTime = null,
    Object? weekStartDay = null,
    Object? defaultCalendarView = null,
    Object? showWeekNumbers = null,
    Object? dailyReflectionReminder = null,
    Object? reflectionReminderTime = null,
    Object? showOnlineStatus = null,
    Object? profileVisibility = null,
    Object? autoSync = null,
    Object? syncIntervalMinutes = null,
  }) {
    return _then(_value.copyWith(
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      emailNotifications: null == emailNotifications
          ? _value.emailNotifications
          : emailNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      pushNotifications: null == pushNotifications
          ? _value.pushNotifications
          : pushNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultEventDuration: null == defaultEventDuration
          ? _value.defaultEventDuration
          : defaultEventDuration // ignore: cast_nullable_to_non_nullable
              as int,
      defaultStartTime: null == defaultStartTime
          ? _value.defaultStartTime
          : defaultStartTime // ignore: cast_nullable_to_non_nullable
              as String,
      defaultEndTime: null == defaultEndTime
          ? _value.defaultEndTime
          : defaultEndTime // ignore: cast_nullable_to_non_nullable
              as String,
      weekStartDay: null == weekStartDay
          ? _value.weekStartDay
          : weekStartDay // ignore: cast_nullable_to_non_nullable
              as int,
      defaultCalendarView: null == defaultCalendarView
          ? _value.defaultCalendarView
          : defaultCalendarView // ignore: cast_nullable_to_non_nullable
              as String,
      showWeekNumbers: null == showWeekNumbers
          ? _value.showWeekNumbers
          : showWeekNumbers // ignore: cast_nullable_to_non_nullable
              as bool,
      dailyReflectionReminder: null == dailyReflectionReminder
          ? _value.dailyReflectionReminder
          : dailyReflectionReminder // ignore: cast_nullable_to_non_nullable
              as bool,
      reflectionReminderTime: null == reflectionReminderTime
          ? _value.reflectionReminderTime
          : reflectionReminderTime // ignore: cast_nullable_to_non_nullable
              as String,
      showOnlineStatus: null == showOnlineStatus
          ? _value.showOnlineStatus
          : showOnlineStatus // ignore: cast_nullable_to_non_nullable
              as bool,
      profileVisibility: null == profileVisibility
          ? _value.profileVisibility
          : profileVisibility // ignore: cast_nullable_to_non_nullable
              as String,
      autoSync: null == autoSync
          ? _value.autoSync
          : autoSync // ignore: cast_nullable_to_non_nullable
              as bool,
      syncIntervalMinutes: null == syncIntervalMinutes
          ? _value.syncIntervalMinutes
          : syncIntervalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPreferencesImplCopyWith<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  factory _$$UserPreferencesImplCopyWith(_$UserPreferencesImpl value,
          $Res Function(_$UserPreferencesImpl) then) =
      __$$UserPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String theme,
      bool notificationsEnabled,
      bool emailNotifications,
      bool pushNotifications,
      int defaultEventDuration,
      String defaultStartTime,
      String defaultEndTime,
      int weekStartDay,
      String defaultCalendarView,
      bool showWeekNumbers,
      bool dailyReflectionReminder,
      String reflectionReminderTime,
      bool showOnlineStatus,
      String profileVisibility,
      bool autoSync,
      int syncIntervalMinutes});
}

/// @nodoc
class __$$UserPreferencesImplCopyWithImpl<$Res>
    extends _$UserPreferencesCopyWithImpl<$Res, _$UserPreferencesImpl>
    implements _$$UserPreferencesImplCopyWith<$Res> {
  __$$UserPreferencesImplCopyWithImpl(
      _$UserPreferencesImpl _value, $Res Function(_$UserPreferencesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theme = null,
    Object? notificationsEnabled = null,
    Object? emailNotifications = null,
    Object? pushNotifications = null,
    Object? defaultEventDuration = null,
    Object? defaultStartTime = null,
    Object? defaultEndTime = null,
    Object? weekStartDay = null,
    Object? defaultCalendarView = null,
    Object? showWeekNumbers = null,
    Object? dailyReflectionReminder = null,
    Object? reflectionReminderTime = null,
    Object? showOnlineStatus = null,
    Object? profileVisibility = null,
    Object? autoSync = null,
    Object? syncIntervalMinutes = null,
  }) {
    return _then(_$UserPreferencesImpl(
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      emailNotifications: null == emailNotifications
          ? _value.emailNotifications
          : emailNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      pushNotifications: null == pushNotifications
          ? _value.pushNotifications
          : pushNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultEventDuration: null == defaultEventDuration
          ? _value.defaultEventDuration
          : defaultEventDuration // ignore: cast_nullable_to_non_nullable
              as int,
      defaultStartTime: null == defaultStartTime
          ? _value.defaultStartTime
          : defaultStartTime // ignore: cast_nullable_to_non_nullable
              as String,
      defaultEndTime: null == defaultEndTime
          ? _value.defaultEndTime
          : defaultEndTime // ignore: cast_nullable_to_non_nullable
              as String,
      weekStartDay: null == weekStartDay
          ? _value.weekStartDay
          : weekStartDay // ignore: cast_nullable_to_non_nullable
              as int,
      defaultCalendarView: null == defaultCalendarView
          ? _value.defaultCalendarView
          : defaultCalendarView // ignore: cast_nullable_to_non_nullable
              as String,
      showWeekNumbers: null == showWeekNumbers
          ? _value.showWeekNumbers
          : showWeekNumbers // ignore: cast_nullable_to_non_nullable
              as bool,
      dailyReflectionReminder: null == dailyReflectionReminder
          ? _value.dailyReflectionReminder
          : dailyReflectionReminder // ignore: cast_nullable_to_non_nullable
              as bool,
      reflectionReminderTime: null == reflectionReminderTime
          ? _value.reflectionReminderTime
          : reflectionReminderTime // ignore: cast_nullable_to_non_nullable
              as String,
      showOnlineStatus: null == showOnlineStatus
          ? _value.showOnlineStatus
          : showOnlineStatus // ignore: cast_nullable_to_non_nullable
              as bool,
      profileVisibility: null == profileVisibility
          ? _value.profileVisibility
          : profileVisibility // ignore: cast_nullable_to_non_nullable
              as String,
      autoSync: null == autoSync
          ? _value.autoSync
          : autoSync // ignore: cast_nullable_to_non_nullable
              as bool,
      syncIntervalMinutes: null == syncIntervalMinutes
          ? _value.syncIntervalMinutes
          : syncIntervalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPreferencesImpl implements _UserPreferences {
  const _$UserPreferencesImpl(
      {this.theme = 'system',
      this.notificationsEnabled = true,
      this.emailNotifications = true,
      this.pushNotifications = true,
      this.defaultEventDuration = 30,
      this.defaultStartTime = '09:00',
      this.defaultEndTime = '17:00',
      this.weekStartDay = 1,
      this.defaultCalendarView = 'week',
      this.showWeekNumbers = true,
      this.dailyReflectionReminder = true,
      this.reflectionReminderTime = '21:00',
      this.showOnlineStatus = true,
      this.profileVisibility = 'friends',
      this.autoSync = true,
      this.syncIntervalMinutes = 15});

  factory _$UserPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferencesImplFromJson(json);

  /// Theme preference: 'light', 'dark', or 'system'
  @override
  @JsonKey()
  final String theme;

  /// Default notification settings
  @override
  @JsonKey()
  final bool notificationsEnabled;
  @override
  @JsonKey()
  final bool emailNotifications;
  @override
  @JsonKey()
  final bool pushNotifications;

  /// Event default settings
  @override
  @JsonKey()
  final int defaultEventDuration;
  @override
  @JsonKey()
  final String defaultStartTime;
  @override
  @JsonKey()
  final String defaultEndTime;

  /// Calendar preferences
  @override
  @JsonKey()
  final int weekStartDay;
// 0 = Sunday, 1 = Monday
  @override
  @JsonKey()
  final String defaultCalendarView;
  @override
  @JsonKey()
  final bool showWeekNumbers;

  /// Reflection preferences
  @override
  @JsonKey()
  final bool dailyReflectionReminder;
  @override
  @JsonKey()
  final String reflectionReminderTime;

  /// Privacy settings
  @override
  @JsonKey()
  final bool showOnlineStatus;
  @override
  @JsonKey()
  final String profileVisibility;
// 'public', 'friends', 'private'
  /// Sync settings
  @override
  @JsonKey()
  final bool autoSync;
  @override
  @JsonKey()
  final int syncIntervalMinutes;

  @override
  String toString() {
    return 'UserPreferences(theme: $theme, notificationsEnabled: $notificationsEnabled, emailNotifications: $emailNotifications, pushNotifications: $pushNotifications, defaultEventDuration: $defaultEventDuration, defaultStartTime: $defaultStartTime, defaultEndTime: $defaultEndTime, weekStartDay: $weekStartDay, defaultCalendarView: $defaultCalendarView, showWeekNumbers: $showWeekNumbers, dailyReflectionReminder: $dailyReflectionReminder, reflectionReminderTime: $reflectionReminderTime, showOnlineStatus: $showOnlineStatus, profileVisibility: $profileVisibility, autoSync: $autoSync, syncIntervalMinutes: $syncIntervalMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPreferencesImpl &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.emailNotifications, emailNotifications) ||
                other.emailNotifications == emailNotifications) &&
            (identical(other.pushNotifications, pushNotifications) ||
                other.pushNotifications == pushNotifications) &&
            (identical(other.defaultEventDuration, defaultEventDuration) ||
                other.defaultEventDuration == defaultEventDuration) &&
            (identical(other.defaultStartTime, defaultStartTime) ||
                other.defaultStartTime == defaultStartTime) &&
            (identical(other.defaultEndTime, defaultEndTime) ||
                other.defaultEndTime == defaultEndTime) &&
            (identical(other.weekStartDay, weekStartDay) ||
                other.weekStartDay == weekStartDay) &&
            (identical(other.defaultCalendarView, defaultCalendarView) ||
                other.defaultCalendarView == defaultCalendarView) &&
            (identical(other.showWeekNumbers, showWeekNumbers) ||
                other.showWeekNumbers == showWeekNumbers) &&
            (identical(
                    other.dailyReflectionReminder, dailyReflectionReminder) ||
                other.dailyReflectionReminder == dailyReflectionReminder) &&
            (identical(other.reflectionReminderTime, reflectionReminderTime) ||
                other.reflectionReminderTime == reflectionReminderTime) &&
            (identical(other.showOnlineStatus, showOnlineStatus) ||
                other.showOnlineStatus == showOnlineStatus) &&
            (identical(other.profileVisibility, profileVisibility) ||
                other.profileVisibility == profileVisibility) &&
            (identical(other.autoSync, autoSync) ||
                other.autoSync == autoSync) &&
            (identical(other.syncIntervalMinutes, syncIntervalMinutes) ||
                other.syncIntervalMinutes == syncIntervalMinutes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      theme,
      notificationsEnabled,
      emailNotifications,
      pushNotifications,
      defaultEventDuration,
      defaultStartTime,
      defaultEndTime,
      weekStartDay,
      defaultCalendarView,
      showWeekNumbers,
      dailyReflectionReminder,
      reflectionReminderTime,
      showOnlineStatus,
      profileVisibility,
      autoSync,
      syncIntervalMinutes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      __$$UserPreferencesImplCopyWithImpl<_$UserPreferencesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPreferencesImplToJson(
      this,
    );
  }
}

abstract class _UserPreferences implements UserPreferences {
  const factory _UserPreferences(
      {final String theme,
      final bool notificationsEnabled,
      final bool emailNotifications,
      final bool pushNotifications,
      final int defaultEventDuration,
      final String defaultStartTime,
      final String defaultEndTime,
      final int weekStartDay,
      final String defaultCalendarView,
      final bool showWeekNumbers,
      final bool dailyReflectionReminder,
      final String reflectionReminderTime,
      final bool showOnlineStatus,
      final String profileVisibility,
      final bool autoSync,
      final int syncIntervalMinutes}) = _$UserPreferencesImpl;

  factory _UserPreferences.fromJson(Map<String, dynamic> json) =
      _$UserPreferencesImpl.fromJson;

  @override

  /// Theme preference: 'light', 'dark', or 'system'
  String get theme;
  @override

  /// Default notification settings
  bool get notificationsEnabled;
  @override
  bool get emailNotifications;
  @override
  bool get pushNotifications;
  @override

  /// Event default settings
  int get defaultEventDuration;
  @override
  String get defaultStartTime;
  @override
  String get defaultEndTime;
  @override

  /// Calendar preferences
  int get weekStartDay;
  @override // 0 = Sunday, 1 = Monday
  String get defaultCalendarView;
  @override
  bool get showWeekNumbers;
  @override

  /// Reflection preferences
  bool get dailyReflectionReminder;
  @override
  String get reflectionReminderTime;
  @override

  /// Privacy settings
  bool get showOnlineStatus;
  @override
  String get profileVisibility;
  @override // 'public', 'friends', 'private'
  /// Sync settings
  bool get autoSync;
  @override
  int get syncIntervalMinutes;
  @override
  @JsonKey(ignore: true)
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;
  DateTime? get lastSeenAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String id,
      String displayName,
      String? email,
      String? avatarUrl,
      bool isOnline,
      DateTime? lastSeenAt});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? email = freezed,
    Object? avatarUrl = freezed,
    Object? isOnline = null,
    Object? lastSeenAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSeenAt: freezed == lastSeenAt
          ? _value.lastSeenAt
          : lastSeenAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String displayName,
      String? email,
      String? avatarUrl,
      bool isOnline,
      DateTime? lastSeenAt});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? email = freezed,
    Object? avatarUrl = freezed,
    Object? isOnline = null,
    Object? lastSeenAt = freezed,
  }) {
    return _then(_$UserProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSeenAt: freezed == lastSeenAt
          ? _value.lastSeenAt
          : lastSeenAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {required this.id,
      required this.displayName,
      this.email,
      this.avatarUrl,
      this.isOnline = false,
      this.lastSeenAt});

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String displayName;
  @override
  final String? email;
  @override
  final String? avatarUrl;
  @override
  @JsonKey()
  final bool isOnline;
  @override
  final DateTime? lastSeenAt;

  @override
  String toString() {
    return 'UserProfile(id: $id, displayName: $displayName, email: $email, avatarUrl: $avatarUrl, isOnline: $isOnline, lastSeenAt: $lastSeenAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.lastSeenAt, lastSeenAt) ||
                other.lastSeenAt == lastSeenAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, displayName, email, avatarUrl, isOnline, lastSeenAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {required final String id,
      required final String displayName,
      final String? email,
      final String? avatarUrl,
      final bool isOnline,
      final DateTime? lastSeenAt}) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get displayName;
  @override
  String? get email;
  @override
  String? get avatarUrl;
  @override
  bool get isOnline;
  @override
  DateTime? get lastSeenAt;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthState _$AuthStateFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'authenticated':
      return AuthStateAuthenticated.fromJson(json);
    case 'unauthenticated':
      return AuthStateUnauthenticated.fromJson(json);
    case 'loading':
      return AuthStateLoading.fromJson(json);
    case 'error':
      return AuthStateError.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'AuthState',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            User user, String accessToken, String? refreshToken)
        authenticated,
    required TResult Function() unauthenticated,
    required TResult Function() loading,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(User user, String accessToken, String? refreshToken)?
        authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(User user, String accessToken, String? refreshToken)?
        authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? loading,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthStateAuthenticated value) authenticated,
    required TResult Function(AuthStateUnauthenticated value) unauthenticated,
    required TResult Function(AuthStateLoading value) loading,
    required TResult Function(AuthStateError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthStateAuthenticated value)? authenticated,
    TResult? Function(AuthStateUnauthenticated value)? unauthenticated,
    TResult? Function(AuthStateLoading value)? loading,
    TResult? Function(AuthStateError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthStateAuthenticated value)? authenticated,
    TResult Function(AuthStateUnauthenticated value)? unauthenticated,
    TResult Function(AuthStateLoading value)? loading,
    TResult Function(AuthStateError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AuthStateAuthenticatedImplCopyWith<$Res> {
  factory _$$AuthStateAuthenticatedImplCopyWith(
          _$AuthStateAuthenticatedImpl value,
          $Res Function(_$AuthStateAuthenticatedImpl) then) =
      __$$AuthStateAuthenticatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({User user, String accessToken, String? refreshToken});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$AuthStateAuthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthStateAuthenticatedImpl>
    implements _$$AuthStateAuthenticatedImplCopyWith<$Res> {
  __$$AuthStateAuthenticatedImplCopyWithImpl(
      _$AuthStateAuthenticatedImpl _value,
      $Res Function(_$AuthStateAuthenticatedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? accessToken = null,
    Object? refreshToken = freezed,
  }) {
    return _then(_$AuthStateAuthenticatedImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthStateAuthenticatedImpl implements AuthStateAuthenticated {
  const _$AuthStateAuthenticatedImpl(
      {required this.user,
      required this.accessToken,
      this.refreshToken,
      final String? $type})
      : $type = $type ?? 'authenticated';

  factory _$AuthStateAuthenticatedImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthStateAuthenticatedImplFromJson(json);

  @override
  final User user;
  @override
  final String accessToken;
  @override
  final String? refreshToken;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AuthState.authenticated(user: $user, accessToken: $accessToken, refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateAuthenticatedImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, user, accessToken, refreshToken);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthStateAuthenticatedImplCopyWith<_$AuthStateAuthenticatedImpl>
      get copyWith => __$$AuthStateAuthenticatedImplCopyWithImpl<
          _$AuthStateAuthenticatedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            User user, String accessToken, String? refreshToken)
        authenticated,
    required TResult Function() unauthenticated,
    required TResult Function() loading,
    required TResult Function(String message) error,
  }) {
    return authenticated(user, accessToken, refreshToken);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(User user, String accessToken, String? refreshToken)?
        authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
  }) {
    return authenticated?.call(user, accessToken, refreshToken);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(User user, String accessToken, String? refreshToken)?
        authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? loading,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(user, accessToken, refreshToken);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthStateAuthenticated value) authenticated,
    required TResult Function(AuthStateUnauthenticated value) unauthenticated,
    required TResult Function(AuthStateLoading value) loading,
    required TResult Function(AuthStateError value) error,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthStateAuthenticated value)? authenticated,
    TResult? Function(AuthStateUnauthenticated value)? unauthenticated,
    TResult? Function(AuthStateLoading value)? loading,
    TResult? Function(AuthStateError value)? error,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthStateAuthenticated value)? authenticated,
    TResult Function(AuthStateUnauthenticated value)? unauthenticated,
    TResult Function(AuthStateLoading value)? loading,
    TResult Function(AuthStateError value)? error,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthStateAuthenticatedImplToJson(
      this,
    );
  }
}

abstract class AuthStateAuthenticated implements AuthState {
  const factory AuthStateAuthenticated(
      {required final User user,
      required final String accessToken,
      final String? refreshToken}) = _$AuthStateAuthenticatedImpl;

  factory AuthStateAuthenticated.fromJson(Map<String, dynamic> json) =
      _$AuthStateAuthenticatedImpl.fromJson;

  User get user;
  String get accessToken;
  String? get refreshToken;
  @JsonKey(ignore: true)
  _$$AuthStateAuthenticatedImplCopyWith<_$AuthStateAuthenticatedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthStateUnauthenticatedImplCopyWith<$Res> {
  factory _$$AuthStateUnauthenticatedImplCopyWith(
          _$AuthStateUnauthenticatedImpl value,
          $Res Function(_$AuthStateUnauthenticatedImpl) then) =
      __$$AuthStateUnauthenticatedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthStateUnauthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthStateUnauthenticatedImpl>
    implements _$$AuthStateUnauthenticatedImplCopyWith<$Res> {
  __$$AuthStateUnauthenticatedImplCopyWithImpl(
      _$AuthStateUnauthenticatedImpl _value,
      $Res Function(_$AuthStateUnauthenticatedImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$AuthStateUnauthenticatedImpl implements AuthStateUnauthenticated {
  const _$AuthStateUnauthenticatedImpl({final String? $type})
      : $type = $type ?? 'unauthenticated';

  factory _$AuthStateUnauthenticatedImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthStateUnauthenticatedImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AuthState.unauthenticated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateUnauthenticatedImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            User user, String accessToken, String? refreshToken)
        authenticated,
    required TResult Function() unauthenticated,
    required TResult Function() loading,
    required TResult Function(String message) error,
  }) {
    return unauthenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(User user, String accessToken, String? refreshToken)?
        authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
  }) {
    return unauthenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(User user, String accessToken, String? refreshToken)?
        authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? loading,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthStateAuthenticated value) authenticated,
    required TResult Function(AuthStateUnauthenticated value) unauthenticated,
    required TResult Function(AuthStateLoading value) loading,
    required TResult Function(AuthStateError value) error,
  }) {
    return unauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthStateAuthenticated value)? authenticated,
    TResult? Function(AuthStateUnauthenticated value)? unauthenticated,
    TResult? Function(AuthStateLoading value)? loading,
    TResult? Function(AuthStateError value)? error,
  }) {
    return unauthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthStateAuthenticated value)? authenticated,
    TResult Function(AuthStateUnauthenticated value)? unauthenticated,
    TResult Function(AuthStateLoading value)? loading,
    TResult Function(AuthStateError value)? error,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthStateUnauthenticatedImplToJson(
      this,
    );
  }
}

abstract class AuthStateUnauthenticated implements AuthState {
  const factory AuthStateUnauthenticated() = _$AuthStateUnauthenticatedImpl;

  factory AuthStateUnauthenticated.fromJson(Map<String, dynamic> json) =
      _$AuthStateUnauthenticatedImpl.fromJson;
}

/// @nodoc
abstract class _$$AuthStateLoadingImplCopyWith<$Res> {
  factory _$$AuthStateLoadingImplCopyWith(_$AuthStateLoadingImpl value,
          $Res Function(_$AuthStateLoadingImpl) then) =
      __$$AuthStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthStateLoadingImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthStateLoadingImpl>
    implements _$$AuthStateLoadingImplCopyWith<$Res> {
  __$$AuthStateLoadingImplCopyWithImpl(_$AuthStateLoadingImpl _value,
      $Res Function(_$AuthStateLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$AuthStateLoadingImpl implements AuthStateLoading {
  const _$AuthStateLoadingImpl({final String? $type})
      : $type = $type ?? 'loading';

  factory _$AuthStateLoadingImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthStateLoadingImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AuthState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthStateLoadingImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            User user, String accessToken, String? refreshToken)
        authenticated,
    required TResult Function() unauthenticated,
    required TResult Function() loading,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(User user, String accessToken, String? refreshToken)?
        authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(User user, String accessToken, String? refreshToken)?
        authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? loading,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthStateAuthenticated value) authenticated,
    required TResult Function(AuthStateUnauthenticated value) unauthenticated,
    required TResult Function(AuthStateLoading value) loading,
    required TResult Function(AuthStateError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthStateAuthenticated value)? authenticated,
    TResult? Function(AuthStateUnauthenticated value)? unauthenticated,
    TResult? Function(AuthStateLoading value)? loading,
    TResult? Function(AuthStateError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthStateAuthenticated value)? authenticated,
    TResult Function(AuthStateUnauthenticated value)? unauthenticated,
    TResult Function(AuthStateLoading value)? loading,
    TResult Function(AuthStateError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthStateLoadingImplToJson(
      this,
    );
  }
}

abstract class AuthStateLoading implements AuthState {
  const factory AuthStateLoading() = _$AuthStateLoadingImpl;

  factory AuthStateLoading.fromJson(Map<String, dynamic> json) =
      _$AuthStateLoadingImpl.fromJson;
}

/// @nodoc
abstract class _$$AuthStateErrorImplCopyWith<$Res> {
  factory _$$AuthStateErrorImplCopyWith(_$AuthStateErrorImpl value,
          $Res Function(_$AuthStateErrorImpl) then) =
      __$$AuthStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$AuthStateErrorImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthStateErrorImpl>
    implements _$$AuthStateErrorImplCopyWith<$Res> {
  __$$AuthStateErrorImplCopyWithImpl(
      _$AuthStateErrorImpl _value, $Res Function(_$AuthStateErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$AuthStateErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthStateErrorImpl implements AuthStateError {
  const _$AuthStateErrorImpl({required this.message, final String? $type})
      : $type = $type ?? 'error';

  factory _$AuthStateErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthStateErrorImplFromJson(json);

  @override
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AuthState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthStateErrorImplCopyWith<_$AuthStateErrorImpl> get copyWith =>
      __$$AuthStateErrorImplCopyWithImpl<_$AuthStateErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            User user, String accessToken, String? refreshToken)
        authenticated,
    required TResult Function() unauthenticated,
    required TResult Function() loading,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(User user, String accessToken, String? refreshToken)?
        authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(User user, String accessToken, String? refreshToken)?
        authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? loading,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthStateAuthenticated value) authenticated,
    required TResult Function(AuthStateUnauthenticated value) unauthenticated,
    required TResult Function(AuthStateLoading value) loading,
    required TResult Function(AuthStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthStateAuthenticated value)? authenticated,
    TResult? Function(AuthStateUnauthenticated value)? unauthenticated,
    TResult? Function(AuthStateLoading value)? loading,
    TResult? Function(AuthStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthStateAuthenticated value)? authenticated,
    TResult Function(AuthStateUnauthenticated value)? unauthenticated,
    TResult Function(AuthStateLoading value)? loading,
    TResult Function(AuthStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthStateErrorImplToJson(
      this,
    );
  }
}

abstract class AuthStateError implements AuthState {
  const factory AuthStateError({required final String message}) =
      _$AuthStateErrorImpl;

  factory AuthStateError.fromJson(Map<String, dynamic> json) =
      _$AuthStateErrorImpl.fromJson;

  String get message;
  @JsonKey(ignore: true)
  _$$AuthStateErrorImplCopyWith<_$AuthStateErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
