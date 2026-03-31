import 'package:flutter_test/flutter_test.dart';
import 'package:ctrl_shift_date/utils/constants.dart';

void main() {
  group('AppConstants', () {
    test('app name is set', () {
      expect(AppConstants.appName, isNotEmpty);
    });

    test('API timeout is reasonable', () {
      expect(AppConstants.apiTimeout.inSeconds, greaterThan(0));
      expect(AppConstants.apiTimeout.inSeconds, lessThanOrEqualTo(60));
    });

    test('page sizes are sensible', () {
      expect(AppConstants.defaultPageSize, greaterThan(0));
      expect(AppConstants.maxPageSize, greaterThanOrEqualTo(AppConstants.defaultPageSize));
    });

    test('event duration default is positive', () {
      expect(AppConstants.defaultEventDurationMinutes, greaterThan(0));
    });

    test('max title and description lengths are sensible', () {
      expect(AppConstants.maxEventTitleLength, greaterThan(0));
      expect(AppConstants.maxEventDescriptionLength, greaterThan(AppConstants.maxEventTitleLength));
    });

    test('max friends is reasonable', () {
      expect(AppConstants.maxFriends, greaterThan(0));
    });

    test('default reminder minutes are ordered', () {
      for (int i = 0; i < AppConstants.defaultReminderMinutes.length - 1; i++) {
        expect(
          AppConstants.defaultReminderMinutes[i],
          lessThan(AppConstants.defaultReminderMinutes[i + 1]),
        );
      }
    });

    test('animation durations are ordered short < medium < long', () {
      expect(
        AppConstants.shortAnimationDuration,
        lessThan(AppConstants.mediumAnimationDuration),
      );
      expect(
        AppConstants.mediumAnimationDuration,
        lessThan(AppConstants.longAnimationDuration),
      );
    });

    test('breakpoints are ordered mobile < tablet < desktop', () {
      expect(AppConstants.mobileBreakpoint, lessThan(AppConstants.tabletBreakpoint));
      expect(AppConstants.tabletBreakpoint, lessThan(AppConstants.desktopBreakpoint));
    });

    test('sync interval is positive', () {
      expect(AppConstants.syncInterval.inMinutes, greaterThan(0));
    });

    test('retry settings are sensible', () {
      expect(AppConstants.maxRetryAttempts, greaterThan(0));
      expect(AppConstants.retryDelay.inSeconds, greaterThan(0));
    });
  });

  group('AppColors', () {
    test('primary light color is black', () {
      expect(AppColors.primaryLight.value, 0xFF000000);
    });

    test('surface light color is white', () {
      expect(AppColors.surfaceLight.value, 0xFFFFFFFF);
    });
  });
}
