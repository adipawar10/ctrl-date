// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      phoneVerified: json['phoneVerified'] as bool? ?? false,
      publicKey: json['publicKey'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      lastSeenAt: json['lastSeenAt'] == null
          ? null
          : DateTime.parse(json['lastSeenAt'] as String),
      preferences: json['preferences'] == null
          ? null
          : UserPreferences.fromJson(
              json['preferences'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'phoneNumber': instance.phoneNumber,
      'emailVerified': instance.emailVerified,
      'phoneVerified': instance.phoneVerified,
      'publicKey': instance.publicKey,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'lastSeenAt': instance.lastSeenAt?.toIso8601String(),
      'preferences': instance.preferences,
    };

_$UserPreferencesImpl _$$UserPreferencesImplFromJson(
        Map<String, dynamic> json) =>
    _$UserPreferencesImpl(
      theme: json['theme'] as String? ?? 'system',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      defaultEventDuration:
          (json['defaultEventDuration'] as num?)?.toInt() ?? 30,
      defaultStartTime: json['defaultStartTime'] as String? ?? '09:00',
      defaultEndTime: json['defaultEndTime'] as String? ?? '17:00',
      weekStartDay: (json['weekStartDay'] as num?)?.toInt() ?? 1,
      defaultCalendarView: json['defaultCalendarView'] as String? ?? 'week',
      showWeekNumbers: json['showWeekNumbers'] as bool? ?? true,
      dailyReflectionReminder: json['dailyReflectionReminder'] as bool? ?? true,
      reflectionReminderTime:
          json['reflectionReminderTime'] as String? ?? '21:00',
      showOnlineStatus: json['showOnlineStatus'] as bool? ?? true,
      profileVisibility: json['profileVisibility'] as String? ?? 'friends',
      autoSync: json['autoSync'] as bool? ?? true,
      syncIntervalMinutes: (json['syncIntervalMinutes'] as num?)?.toInt() ?? 15,
    );

Map<String, dynamic> _$$UserPreferencesImplToJson(
        _$UserPreferencesImpl instance) =>
    <String, dynamic>{
      'theme': instance.theme,
      'notificationsEnabled': instance.notificationsEnabled,
      'emailNotifications': instance.emailNotifications,
      'pushNotifications': instance.pushNotifications,
      'defaultEventDuration': instance.defaultEventDuration,
      'defaultStartTime': instance.defaultStartTime,
      'defaultEndTime': instance.defaultEndTime,
      'weekStartDay': instance.weekStartDay,
      'defaultCalendarView': instance.defaultCalendarView,
      'showWeekNumbers': instance.showWeekNumbers,
      'dailyReflectionReminder': instance.dailyReflectionReminder,
      'reflectionReminderTime': instance.reflectionReminderTime,
      'showOnlineStatus': instance.showOnlineStatus,
      'profileVisibility': instance.profileVisibility,
      'autoSync': instance.autoSync,
      'syncIntervalMinutes': instance.syncIntervalMinutes,
    };

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      isOnline: json['isOnline'] as bool? ?? false,
      lastSeenAt: json['lastSeenAt'] == null
          ? null
          : DateTime.parse(json['lastSeenAt'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'isOnline': instance.isOnline,
      'lastSeenAt': instance.lastSeenAt?.toIso8601String(),
    };

_$AuthStateAuthenticatedImpl _$$AuthStateAuthenticatedImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthStateAuthenticatedImpl(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AuthStateAuthenticatedImplToJson(
        _$AuthStateAuthenticatedImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'runtimeType': instance.$type,
    };

_$AuthStateUnauthenticatedImpl _$$AuthStateUnauthenticatedImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthStateUnauthenticatedImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AuthStateUnauthenticatedImplToJson(
        _$AuthStateUnauthenticatedImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$AuthStateLoadingImpl _$$AuthStateLoadingImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthStateLoadingImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AuthStateLoadingImplToJson(
        _$AuthStateLoadingImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$AuthStateErrorImpl _$$AuthStateErrorImplFromJson(Map<String, dynamic> json) =>
    _$AuthStateErrorImpl(
      message: json['message'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AuthStateErrorImplToJson(
        _$AuthStateErrorImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'runtimeType': instance.$type,
    };
