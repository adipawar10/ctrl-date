import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/encryption_service.dart';

/// Provider for the AuthService instance
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService.instance;
});

/// Provider for the current Supabase auth state
final authStateProvider = StreamProvider<supabase.User?>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange.map(
    (event) => event.session?.user,
  );
});

/// Provider for the current authenticated user
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (supabaseUser) {
      if (supabaseUser == null) return null;

      return User(
        id: supabaseUser.id,
        email: supabaseUser.email ?? '',
        displayName: supabaseUser.userMetadata?['display_name'] as String?,
        avatarUrl: supabaseUser.userMetadata?['avatar_url'] as String?,
        phoneNumber: supabaseUser.phone,
        emailVerified: supabaseUser.emailConfirmedAt != null,
        phoneVerified: supabaseUser.phoneConfirmedAt != null,
        createdAt: DateTime.tryParse(supabaseUser.createdAt),
        updatedAt: supabaseUser.updatedAt != null
            ? DateTime.tryParse(supabaseUser.updatedAt!)
            : null,
        lastSeenAt: supabaseUser.lastSignInAt != null
            ? DateTime.tryParse(supabaseUser.lastSignInAt!)
            : null,
      );
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Provider for checking if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );
});

/// Provider for user preferences
final userPreferencesProvider =
    StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) {
  return UserPreferencesNotifier(ref);
});

/// Notifier for managing user preferences
class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  final Ref _ref;

  UserPreferencesNotifier(this._ref) : super(const UserPreferences()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    // Load preferences from Supabase or local storage
    final user = await _ref.read(currentUserProvider.future);
    if (user?.preferences != null) {
      state = user!.preferences!;
    }
  }

  Future<void> updateTheme(String theme) async {
    state = state.copyWith(theme: theme);
    await _savePreferences();
  }

  Future<void> updateNotificationsEnabled(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);
    await _savePreferences();
  }

  Future<void> updateEmailNotifications(bool enabled) async {
    state = state.copyWith(emailNotifications: enabled);
    await _savePreferences();
  }

  Future<void> updatePushNotifications(bool enabled) async {
    state = state.copyWith(pushNotifications: enabled);
    await _savePreferences();
  }

  Future<void> updateDefaultEventDuration(int minutes) async {
    state = state.copyWith(defaultEventDuration: minutes);
    await _savePreferences();
  }

  Future<void> updateWeekStartDay(int day) async {
    state = state.copyWith(weekStartDay: day);
    await _savePreferences();
  }

  Future<void> updateDefaultCalendarView(String view) async {
    state = state.copyWith(defaultCalendarView: view);
    await _savePreferences();
  }

  Future<void> updateReflectionReminderEnabled(bool enabled) async {
    state = state.copyWith(dailyReflectionReminder: enabled);
    await _savePreferences();
  }

  Future<void> updateReflectionReminderTime(String time) async {
    state = state.copyWith(reflectionReminderTime: time);
    await _savePreferences();
  }

  Future<void> updateProfileVisibility(String visibility) async {
    state = state.copyWith(profileVisibility: visibility);
    await _savePreferences();
  }

  Future<void> updateAutoSync(bool enabled) async {
    state = state.copyWith(autoSync: enabled);
    await _savePreferences();
  }

  Future<void> updateSyncInterval(int minutes) async {
    state = state.copyWith(syncIntervalMinutes: minutes);
    await _savePreferences();
  }

  Future<void> _savePreferences() async {
    // Save preferences to Supabase
    try {
      await Supabase.instance.client.auth.updateUser(
        supabase.UserAttributes(
          data: {'preferences': state.toJson()},
        ),
      );
    } catch (e) {
      // Handle error - maybe save locally as fallback
    }
  }
}

/// Provider for authentication actions
final authActionsProvider = Provider<AuthActions>((ref) {
  return AuthActions(ref);
});

/// Class containing authentication actions
class AuthActions {
  final Ref _ref;

  AuthActions(this._ref);

  AuthService get _authService => _ref.read(authServiceProvider);
  EncryptionService get _encryptionService => EncryptionService.instance;

  /// Sign up with email and password
  Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final result = await _authService.signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );

    if (result.isSuccess && result.user != null) {
      // Initialize encryption keys for the new user
      await _encryptionService.initialize();
      final publicKey = await _encryptionService.getPublicKey();

      // Store public key in user profile
      await _authService.updateProfile(
        displayName: displayName,
      );
    }

    return result;
  }

  /// Sign in with email and password
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final result = await _authService.signInWithEmail(
      email: email,
      password: password,
    );

    if (result.isSuccess) {
      // Initialize encryption service
      await _encryptionService.initialize();
    }

    return result;
  }

  /// Sign in with magic link
  Future<AuthResult> signInWithMagicLink({
    required String email,
  }) async {
    return _authService.signInWithMagicLink(email: email);
  }

  /// Sign in with OAuth provider
  Future<AuthResult> signInWithOAuth(OAuthProvider provider) async {
    return _authService.signInWithOAuth(provider: provider);
  }

  /// Sign out
  Future<AuthResult> signOut() async {
    final result = await _authService.signOut();

    if (result.isSuccess) {
      // Clear encryption keys
      await _encryptionService.clearKeys();
    }

    return result;
  }

  /// Send password reset email
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    return _authService.sendPasswordResetEmail(email: email);
  }

  /// Update password
  Future<AuthResult> updatePassword(String newPassword) async {
    return _authService.updatePassword(newPassword: newPassword);
  }

  /// Update profile
  Future<AuthResult> updateProfile({
    String? email,
    String? displayName,
    String? avatarUrl,
    String? phone,
  }) async {
    return _authService.updateProfile(
      email: email,
      displayName: displayName,
      avatarUrl: avatarUrl,
      phone: phone,
    );
  }

  /// Refresh session
  Future<AuthResult> refreshSession() async {
    return _authService.refreshSession();
  }

  /// Delete account
  Future<AuthResult> deleteAccount() async {
    // Clear all local data
    await _encryptionService.clearKeys();

    // Sign out (account deletion would be handled by backend)
    return _authService.signOut();
  }
}

/// Provider for the current session
final currentSessionProvider = Provider<supabase.Session?>((ref) {
  return Supabase.instance.client.auth.currentSession;
});

/// Provider for checking if session is expired
final isSessionExpiredProvider = Provider<bool>((ref) {
  final session = ref.watch(currentSessionProvider);
  if (session == null) return true;

  final expiresAt = DateTime.fromMillisecondsSinceEpoch(
    session.expiresAt! * 1000,
  );

  return DateTime.now().isAfter(expiresAt);
});
