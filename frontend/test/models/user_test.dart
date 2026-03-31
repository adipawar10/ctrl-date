import 'package:flutter_test/flutter_test.dart';
import 'package:ctrl_shift_date/models/user.dart';

void main() {
  group('User model', () {
    test('creates with required fields', () {
      const user = User(id: 'u-1', email: 'test@example.com');
      expect(user.id, 'u-1');
      expect(user.email, 'test@example.com');
      expect(user.emailVerified, isFalse);
      expect(user.phoneVerified, isFalse);
    });

    test('optional fields default to null', () {
      const user = User(id: 'u-1', email: 'test@example.com');
      expect(user.displayName, isNull);
      expect(user.avatarUrl, isNull);
      expect(user.publicKey, isNull);
      expect(user.preferences, isNull);
    });
  });

  group('UserPreferences', () {
    test('defaults are sensible', () {
      const prefs = UserPreferences();
      expect(prefs.theme, 'system');
      expect(prefs.notificationsEnabled, isTrue);
      expect(prefs.defaultEventDuration, 30);
      expect(prefs.defaultStartTime, '09:00');
      expect(prefs.defaultEndTime, '17:00');
      expect(prefs.weekStartDay, 1); // Monday
      expect(prefs.defaultCalendarView, 'week');
      expect(prefs.showWeekNumbers, isTrue);
      expect(prefs.dailyReflectionReminder, isTrue);
      expect(prefs.reflectionReminderTime, '21:00');
      expect(prefs.showOnlineStatus, isTrue);
      expect(prefs.profileVisibility, 'friends');
      expect(prefs.autoSync, isTrue);
      expect(prefs.syncIntervalMinutes, 15);
    });
  });

  group('UserProfile', () {
    test('creates with required fields', () {
      const profile = UserProfile(
        id: 'u-1',
        displayName: 'Test User',
      );
      expect(profile.id, 'u-1');
      expect(profile.displayName, 'Test User');
      expect(profile.isOnline, isFalse);
      expect(profile.avatarUrl, isNull);
    });
  });

  group('AuthState', () {
    test('authenticated state holds user and token', () {
      const state = AuthState.authenticated(
        user: User(id: 'u-1', email: 'test@example.com'),
        accessToken: 'tok123',
      );
      expect(
        state,
        isA<AuthStateAuthenticated>(),
      );
    });

    test('unauthenticated state', () {
      const state = AuthState.unauthenticated();
      expect(state, isA<AuthStateUnauthenticated>());
    });

    test('loading state', () {
      const state = AuthState.loading();
      expect(state, isA<AuthStateLoading>());
    });

    test('error state holds message', () {
      const state = AuthState.error(message: 'Something went wrong');
      expect(state, isA<AuthStateError>());
    });
  });
}
