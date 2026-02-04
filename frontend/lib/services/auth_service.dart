import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user.dart' as app;

/// Authentication service using Supabase Auth
class AuthService {
  AuthService._();

  static final AuthService _instance = AuthService._();
  static AuthService get instance => _instance;

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get the current user
  User? get currentUser => _supabase.auth.currentUser;

  /// Get the current session
  Session? get currentSession => _supabase.auth.currentSession;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Stream of auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Sign up with email and password
  Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: displayName != null ? {'display_name': displayName} : null,
      );

      if (response.user != null) {
        return AuthResult.success(
          user: _mapUser(response.user!),
          session: response.session,
          needsEmailVerification: response.user!.emailConfirmedAt == null,
        );
      }

      return AuthResult.failure('Sign up failed. Please try again.');
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Sign in with email and password
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return AuthResult.success(
          user: _mapUser(response.user!),
          session: response.session,
        );
      }

      return AuthResult.failure('Sign in failed. Please try again.');
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Sign in with magic link (passwordless)
  Future<AuthResult> signInWithMagicLink({
    required String email,
    String? redirectTo,
  }) async {
    try {
      await _supabase.auth.signInWithOtp(
        email: email,
        emailRedirectTo: redirectTo,
      );

      return AuthResult.success(
        user: null,
        session: null,
        message: 'Check your email for the login link.',
      );
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Sign in with OAuth provider
  Future<AuthResult> signInWithOAuth({
    required OAuthProvider provider,
    String? redirectTo,
    String? scopes,
  }) async {
    try {
      final response = await _supabase.auth.signInWithOAuth(
        _mapOAuthProvider(provider),
        redirectTo: redirectTo,
        scopes: scopes,
      );

      if (response) {
        // OAuth flow initiated - user will be redirected
        return AuthResult.success(
          user: null,
          session: null,
          message: 'Redirecting to ${provider.name}...',
        );
      }

      return AuthResult.failure('OAuth sign in failed. Please try again.');
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Sign out
  Future<AuthResult> signOut() async {
    try {
      await _supabase.auth.signOut();
      return AuthResult.success(
        user: null,
        session: null,
        message: 'Signed out successfully.',
      );
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Send password reset email
  Future<AuthResult> sendPasswordResetEmail({
    required String email,
    String? redirectTo,
  }) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: redirectTo,
      );

      return AuthResult.success(
        user: null,
        session: null,
        message: 'Password reset email sent. Check your inbox.',
      );
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Update password
  Future<AuthResult> updatePassword({
    required String newPassword,
  }) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      if (response.user != null) {
        return AuthResult.success(
          user: _mapUser(response.user!),
          session: currentSession,
          message: 'Password updated successfully.',
        );
      }

      return AuthResult.failure('Password update failed. Please try again.');
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Update user profile
  Future<AuthResult> updateProfile({
    String? email,
    String? displayName,
    String? avatarUrl,
    String? phone,
  }) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(
          email: email,
          phone: phone,
          data: {
            if (displayName != null) 'display_name': displayName,
            if (avatarUrl != null) 'avatar_url': avatarUrl,
          },
        ),
      );

      if (response.user != null) {
        return AuthResult.success(
          user: _mapUser(response.user!),
          session: currentSession,
          message: 'Profile updated successfully.',
        );
      }

      return AuthResult.failure('Profile update failed. Please try again.');
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Verify OTP (for phone or email verification)
  Future<AuthResult> verifyOTP({
    required String token,
    required OtpType type,
    String? email,
    String? phone,
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        token: token,
        type: type,
        email: email,
        phone: phone,
      );

      if (response.user != null) {
        return AuthResult.success(
          user: _mapUser(response.user!),
          session: response.session,
          message: 'Verification successful.',
        );
      }

      return AuthResult.failure('Verification failed. Please try again.');
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Refresh the current session
  Future<AuthResult> refreshSession() async {
    try {
      final response = await _supabase.auth.refreshSession();

      if (response.user != null) {
        return AuthResult.success(
          user: _mapUser(response.user!),
          session: response.session,
        );
      }

      return AuthResult.failure('Session refresh failed.');
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Get the current app user
  app.User? getCurrentAppUser() {
    final user = currentUser;
    if (user == null) return null;
    return _mapUser(user);
  }

  /// Map Supabase User to app User
  app.User _mapUser(User user) {
    return app.User(
      id: user.id,
      email: user.email ?? '',
      displayName: user.userMetadata?['display_name'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
      phoneNumber: user.phone,
      emailVerified: user.emailConfirmedAt != null,
      phoneVerified: user.phoneConfirmedAt != null,
      createdAt: DateTime.tryParse(user.createdAt),
      updatedAt: user.updatedAt != null
          ? DateTime.tryParse(user.updatedAt!)
          : null,
      lastSeenAt: user.lastSignInAt != null
          ? DateTime.tryParse(user.lastSignInAt!)
          : null,
    );
  }

  /// Map auth error to user-friendly message
  String _mapAuthError(AuthException e) {
    switch (e.statusCode) {
      case '400':
        if (e.message.contains('email')) {
          return 'Invalid email address.';
        }
        if (e.message.contains('password')) {
          return 'Password must be at least 6 characters.';
        }
        return 'Invalid request. Please check your input.';
      case '401':
        return 'Invalid credentials. Please check your email and password.';
      case '403':
        return 'Access denied. Please try again.';
      case '404':
        return 'Account not found.';
      case '409':
        return 'An account with this email already exists.';
      case '422':
        return 'Invalid input. Please check your details.';
      case '429':
        return 'Too many attempts. Please wait a moment and try again.';
      default:
        return e.message;
    }
  }

  /// Map OAuth provider enum
  OAuthProvider _mapOAuthProvider(OAuthProvider provider) {
    return provider;
  }
}

/// OAuth providers
enum OAuthProvider {
  google,
  apple,
  github,
  facebook,
  twitter,
}

/// Authentication result
class AuthResult {
  final bool isSuccess;
  final app.User? user;
  final Session? session;
  final String? message;
  final String? error;
  final bool needsEmailVerification;

  AuthResult._({
    required this.isSuccess,
    this.user,
    this.session,
    this.message,
    this.error,
    this.needsEmailVerification = false,
  });

  factory AuthResult.success({
    app.User? user,
    Session? session,
    String? message,
    bool needsEmailVerification = false,
  }) {
    return AuthResult._(
      isSuccess: true,
      user: user,
      session: session,
      message: message,
      needsEmailVerification: needsEmailVerification,
    );
  }

  factory AuthResult.failure(String error) {
    return AuthResult._(
      isSuccess: false,
      error: error,
    );
  }

  /// Execute callback based on result
  T when<T>({
    required T Function(app.User? user, Session? session, String? message)
        success,
    required T Function(String error) failure,
  }) {
    if (isSuccess) {
      return success(user, session, message);
    } else {
      return failure(error!);
    }
  }
}
