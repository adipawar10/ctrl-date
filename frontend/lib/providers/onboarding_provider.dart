/// ctrl^date - Onboarding Provider
/// Tracks user onboarding status and app version for updates
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/constants.dart';

/// Keys for local storage
class OnboardingKeys {
  static const String onboardingComplete = 'onboarding_complete';
  static const String preferencesComplete = 'preferences_complete';
  static const String lastSeenVersion = 'last_seen_version';
  static const String userDisplayName = 'user_display_name';
  static const String userAge = 'user_age';
  static const String userAvatarUrl = 'user_avatar_url';
  static const String userTimezone = 'user_timezone';
  static const String userWorkingHoursStart = 'user_working_hours_start';
  static const String userWorkingHoursEnd = 'user_working_hours_end';
  static const String userWeekStart = 'user_week_start';
  static const String connectedGoogleCalendar = 'connected_google_calendar';
  static const String connectedAppleCalendar = 'connected_apple_calendar';
}

/// Onboarding state
class OnboardingState {
  final bool isComplete;
  final bool preferencesComplete;
  final bool hasNewUpdate;
  final String? displayName;
  final int? age;
  final String? avatarUrl;
  final String timezone;
  final String workingHoursStart;
  final String workingHoursEnd;
  final String weekStart;
  final bool connectedGoogleCalendar;
  final bool connectedAppleCalendar;
  final bool isLoading;

  const OnboardingState({
    this.isComplete = false,
    this.preferencesComplete = false,
    this.hasNewUpdate = false,
    this.displayName,
    this.age,
    this.avatarUrl,
    this.timezone = 'America/New_York',
    this.workingHoursStart = '09:00',
    this.workingHoursEnd = '17:00',
    this.weekStart = 'monday',
    this.connectedGoogleCalendar = false,
    this.connectedAppleCalendar = false,
    this.isLoading = true,
  });

  OnboardingState copyWith({
    bool? isComplete,
    bool? preferencesComplete,
    bool? hasNewUpdate,
    String? displayName,
    int? age,
    String? avatarUrl,
    String? timezone,
    String? workingHoursStart,
    String? workingHoursEnd,
    String? weekStart,
    bool? connectedGoogleCalendar,
    bool? connectedAppleCalendar,
    bool? isLoading,
  }) {
    return OnboardingState(
      isComplete: isComplete ?? this.isComplete,
      preferencesComplete: preferencesComplete ?? this.preferencesComplete,
      hasNewUpdate: hasNewUpdate ?? this.hasNewUpdate,
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      timezone: timezone ?? this.timezone,
      workingHoursStart: workingHoursStart ?? this.workingHoursStart,
      workingHoursEnd: workingHoursEnd ?? this.workingHoursEnd,
      weekStart: weekStart ?? this.weekStart,
      connectedGoogleCalendar: connectedGoogleCalendar ?? this.connectedGoogleCalendar,
      connectedAppleCalendar: connectedAppleCalendar ?? this.connectedAppleCalendar,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Onboarding notifier
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final Ref _ref;
  SharedPreferences? _prefs;

  OnboardingNotifier(this._ref) : super(const OnboardingState()) {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadState();
  }

  Future<void> _loadState() async {
    final prefs = _prefs;
    if (prefs == null) return;

    final isComplete = prefs.getBool(OnboardingKeys.onboardingComplete) ?? false;
    final preferencesComplete = prefs.getBool(OnboardingKeys.preferencesComplete) ?? false;
    final lastSeenVersion = prefs.getString(OnboardingKeys.lastSeenVersion);
    final displayName = prefs.getString(OnboardingKeys.userDisplayName);
    final age = prefs.getInt(OnboardingKeys.userAge);
    final avatarUrl = prefs.getString(OnboardingKeys.userAvatarUrl);
    final timezone = prefs.getString(OnboardingKeys.userTimezone) ?? 'America/New_York';
    final workingHoursStart = prefs.getString(OnboardingKeys.userWorkingHoursStart) ?? '09:00';
    final workingHoursEnd = prefs.getString(OnboardingKeys.userWorkingHoursEnd) ?? '17:00';
    final weekStart = prefs.getString(OnboardingKeys.userWeekStart) ?? 'monday';
    final connectedGoogle = prefs.getBool(OnboardingKeys.connectedGoogleCalendar) ?? false;
    final connectedApple = prefs.getBool(OnboardingKeys.connectedAppleCalendar) ?? false;

    // Check if there's a new app version
    final hasNewUpdate = lastSeenVersion != null &&
        lastSeenVersion != AppConstants.appVersion;

    state = state.copyWith(
      isComplete: isComplete,
      preferencesComplete: preferencesComplete,
      hasNewUpdate: hasNewUpdate,
      displayName: displayName,
      age: age,
      avatarUrl: avatarUrl,
      timezone: timezone,
      workingHoursStart: workingHoursStart,
      workingHoursEnd: workingHoursEnd,
      weekStart: weekStart,
      connectedGoogleCalendar: connectedGoogle,
      connectedAppleCalendar: connectedApple,
      isLoading: false,
    );

    // If user is logged in but hasn't completed onboarding, check Supabase user metadata
    final supabaseUser = Supabase.instance.client.auth.currentUser;
    if (supabaseUser != null && !isComplete) {
      final metadata = supabaseUser.userMetadata;
      if (metadata != null) {
        final savedName = metadata['display_name'] as String?;
        final savedAge = metadata['age'] as int?;
        final savedAvatar = metadata['avatar_url'] as String?;

        if (savedName != null || savedAge != null) {
          state = state.copyWith(
            displayName: savedName ?? state.displayName,
            age: savedAge ?? state.age,
            avatarUrl: savedAvatar ?? state.avatarUrl,
          );
        }
      }
    }
  }

  /// Update display name
  Future<void> updateDisplayName(String name) async {
    state = state.copyWith(displayName: name);
    await _prefs?.setString(OnboardingKeys.userDisplayName, name);
  }

  /// Update age
  Future<void> updateAge(int age) async {
    state = state.copyWith(age: age);
    await _prefs?.setInt(OnboardingKeys.userAge, age);
  }

  /// Update avatar URL
  Future<void> updateAvatarUrl(String url) async {
    state = state.copyWith(avatarUrl: url);
    await _prefs?.setString(OnboardingKeys.userAvatarUrl, url);
  }

  /// Mark Google Calendar as connected
  Future<void> setGoogleCalendarConnected(bool connected) async {
    state = state.copyWith(connectedGoogleCalendar: connected);
    await _prefs?.setBool(OnboardingKeys.connectedGoogleCalendar, connected);
  }

  /// Mark Apple Calendar as connected
  Future<void> setAppleCalendarConnected(bool connected) async {
    state = state.copyWith(connectedAppleCalendar: connected);
    await _prefs?.setBool(OnboardingKeys.connectedAppleCalendar, connected);
  }

  /// Update timezone
  Future<void> updateTimezone(String timezone) async {
    state = state.copyWith(timezone: timezone);
    await _prefs?.setString(OnboardingKeys.userTimezone, timezone);
  }

  /// Update working hours
  Future<void> updateWorkingHours(String start, String end) async {
    state = state.copyWith(workingHoursStart: start, workingHoursEnd: end);
    await _prefs?.setString(OnboardingKeys.userWorkingHoursStart, start);
    await _prefs?.setString(OnboardingKeys.userWorkingHoursEnd, end);
  }

  /// Update week start day
  Future<void> updateWeekStart(String weekStart) async {
    state = state.copyWith(weekStart: weekStart);
    await _prefs?.setString(OnboardingKeys.userWeekStart, weekStart);
  }

  /// Complete onboarding and save profile to Supabase
  Future<void> completeOnboarding() async {
    final supabase = Supabase.instance.client;

    // Save to Supabase user metadata
    try {
      await supabase.auth.updateUser(
        UserAttributes(
          data: {
            'display_name': state.displayName,
            'age': state.age,
            'avatar_url': state.avatarUrl,
            'onboarding_complete': true,
            'preferences_complete': true,
            'connected_google_calendar': state.connectedGoogleCalendar,
            'connected_apple_calendar': state.connectedAppleCalendar,
          },
        ),
      );
    } catch (e) {
      // Continue even if Supabase update fails - local state is saved
    }

    // Save preferences to users table
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        await supabase.from('users').upsert({
          'id': userId,
          'email': supabase.auth.currentUser?.email ?? '',
          'display_name': state.displayName ?? 'User',
          'avatar_url': state.avatarUrl,
          'timezone': state.timezone,
          'preferences': {
            'working_hours_start': state.workingHoursStart,
            'working_hours_end': state.workingHoursEnd,
            'week_start': state.weekStart,
            'default_event_duration': 60,
            'notification_lead_time': 15,
            'preferred_focus_hours': [9, 10, 11, 14, 15],
          },
        });
      }
    } catch (e) {
      // Continue even if users table update fails
    }

    // Save locally
    await _prefs?.setBool(OnboardingKeys.onboardingComplete, true);
    await _prefs?.setBool(OnboardingKeys.preferencesComplete, true);
    await _prefs?.setString(OnboardingKeys.lastSeenVersion, AppConstants.appVersion);

    state = state.copyWith(
      isComplete: true,
      preferencesComplete: true,
      hasNewUpdate: false,
    );
  }

  /// Mark update as seen
  Future<void> markUpdateSeen() async {
    await _prefs?.setString(OnboardingKeys.lastSeenVersion, AppConstants.appVersion);
    state = state.copyWith(hasNewUpdate: false);
  }

  /// Reset onboarding (for testing or re-onboarding)
  Future<void> resetOnboarding() async {
    await _prefs?.setBool(OnboardingKeys.onboardingComplete, false);
    state = state.copyWith(isComplete: false);
  }

  /// Check if user needs onboarding (includes preference setup)
  bool get needsOnboarding => (!state.isComplete || !state.preferencesComplete) && !state.isLoading;
}

/// Provider for onboarding state
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(ref);
});

/// Provider to check if user needs onboarding
final needsOnboardingProvider = Provider<bool>((ref) {
  final onboarding = ref.watch(onboardingProvider);
  return !onboarding.isComplete && !onboarding.isLoading;
});

/// Provider to check if there's a new app update
final hasNewUpdateProvider = Provider<bool>((ref) {
  final onboarding = ref.watch(onboardingProvider);
  return onboarding.hasNewUpdate;
});
