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
  static const String lastSeenVersion = 'last_seen_version';
  static const String userDisplayName = 'user_display_name';
  static const String userAge = 'user_age';
  static const String userAvatarUrl = 'user_avatar_url';
  static const String connectedGoogleCalendar = 'connected_google_calendar';
  static const String connectedAppleCalendar = 'connected_apple_calendar';
}

/// Onboarding state
class OnboardingState {
  final bool isComplete;
  final bool hasNewUpdate;
  final String? displayName;
  final int? age;
  final String? avatarUrl;
  final bool connectedGoogleCalendar;
  final bool connectedAppleCalendar;
  final bool isLoading;

  const OnboardingState({
    this.isComplete = false,
    this.hasNewUpdate = false,
    this.displayName,
    this.age,
    this.avatarUrl,
    this.connectedGoogleCalendar = false,
    this.connectedAppleCalendar = false,
    this.isLoading = true,
  });

  OnboardingState copyWith({
    bool? isComplete,
    bool? hasNewUpdate,
    String? displayName,
    int? age,
    String? avatarUrl,
    bool? connectedGoogleCalendar,
    bool? connectedAppleCalendar,
    bool? isLoading,
  }) {
    return OnboardingState(
      isComplete: isComplete ?? this.isComplete,
      hasNewUpdate: hasNewUpdate ?? this.hasNewUpdate,
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
      avatarUrl: avatarUrl ?? this.avatarUrl,
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
    final lastSeenVersion = prefs.getString(OnboardingKeys.lastSeenVersion);
    final displayName = prefs.getString(OnboardingKeys.userDisplayName);
    final age = prefs.getInt(OnboardingKeys.userAge);
    final avatarUrl = prefs.getString(OnboardingKeys.userAvatarUrl);
    final connectedGoogle = prefs.getBool(OnboardingKeys.connectedGoogleCalendar) ?? false;
    final connectedApple = prefs.getBool(OnboardingKeys.connectedAppleCalendar) ?? false;

    // Check if there's a new app version
    final hasNewUpdate = lastSeenVersion != null &&
        lastSeenVersion != AppConstants.appVersion;

    state = state.copyWith(
      isComplete: isComplete,
      hasNewUpdate: hasNewUpdate,
      displayName: displayName,
      age: age,
      avatarUrl: avatarUrl,
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

  /// Complete onboarding and save profile to Supabase
  Future<void> completeOnboarding() async {
    // Save to Supabase user metadata
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          data: {
            'display_name': state.displayName,
            'age': state.age,
            'avatar_url': state.avatarUrl,
            'onboarding_complete': true,
            'connected_google_calendar': state.connectedGoogleCalendar,
            'connected_apple_calendar': state.connectedAppleCalendar,
          },
        ),
      );
    } catch (e) {
      // Continue even if Supabase update fails - local state is saved
    }

    // Save locally
    await _prefs?.setBool(OnboardingKeys.onboardingComplete, true);
    await _prefs?.setString(OnboardingKeys.lastSeenVersion, AppConstants.appVersion);

    state = state.copyWith(
      isComplete: true,
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

  /// Check if user needs onboarding
  bool get needsOnboarding => !state.isComplete && !state.isLoading;
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
