import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// User model representing an authenticated user in the system
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? displayName,
    String? avatarUrl,
    String? phoneNumber,
    @Default(false) bool emailVerified,
    @Default(false) bool phoneVerified,
    String? publicKey,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSeenAt,
    UserPreferences? preferences,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// User preferences for app customization
@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    /// Theme preference: 'light', 'dark', or 'system'
    @Default('system') String theme,

    /// Default notification settings
    @Default(true) bool notificationsEnabled,
    @Default(true) bool emailNotifications,
    @Default(true) bool pushNotifications,

    /// Event default settings
    @Default(30) int defaultEventDuration,
    @Default('09:00') String defaultStartTime,
    @Default('17:00') String defaultEndTime,

    /// Calendar preferences
    @Default(1) int weekStartDay, // 0 = Sunday, 1 = Monday
    @Default('week') String defaultCalendarView,
    @Default(true) bool showWeekNumbers,

    /// Reflection preferences
    @Default(true) bool dailyReflectionReminder,
    @Default('21:00') String reflectionReminderTime,

    /// Privacy settings
    @Default(true) bool showOnlineStatus,
    @Default('friends') String profileVisibility, // 'public', 'friends', 'private'

    /// Sync settings
    @Default(true) bool autoSync,
    @Default(15) int syncIntervalMinutes,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}

/// User profile for displaying in friend lists and social features
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String displayName,
    String? avatarUrl,
    @Default(false) bool isOnline,
    DateTime? lastSeenAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

/// Authentication state for the current user session
@freezed
class AuthState with _$AuthState {
  const factory AuthState.authenticated({
    required User user,
    required String accessToken,
    String? refreshToken,
  }) = AuthStateAuthenticated;

  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;

  const factory AuthState.loading() = AuthStateLoading;

  const factory AuthState.error({
    required String message,
  }) = AuthStateError;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}
