import 'package:flutter/material.dart';

/// Application constants
class AppConstants {
  AppConstants._();

  /// Application name
  static const String appName = 'ctrl^date';

  /// Application version
  static const String appVersion = '1.0.0';

  /// Supabase configuration
  /// These should be replaced with environment variables in production
  static const String supabaseUrl = 'https://qsinqjlxfvkguagpaqdf.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_qTzpzY8e785uuv4y1tEvTA_5TROfz7q';

  /// API configuration
  static const String apiBaseUrl = 'https://api.ctrldate.app/v1';
  static const Duration apiTimeout = Duration(seconds: 30);

  /// Cache configuration
  static const Duration cacheExpiry = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB

  /// Sync configuration
  static const Duration syncInterval = Duration(minutes: 15);
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 5);

  /// Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  /// Event defaults
  static const int defaultEventDurationMinutes = 60;
  static const int maxEventTitleLength = 200;
  static const int maxEventDescriptionLength = 5000;

  /// Reflection defaults
  static const int maxReflectionTextLength = 2000;
  static const int maxTagsPerReflection = 10;
  static const int maxTagLength = 50;

  /// Friend defaults
  static const int maxFriends = 500;
  static const int maxPendingRequests = 50;

  /// Notification defaults
  static const List<int> defaultReminderMinutes = [5, 15, 30, 60, 1440];

  /// Date/Time formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';
  static const String displayDateFormat = 'MMM d, yyyy';
  static const String displayTimeFormat = 'h:mm a';
  static const String displayDateTimeFormat = 'MMM d, yyyy h:mm a';

  /// Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  /// UI dimensions
  static const double defaultBorderRadius = 12.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 8.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  /// Breakpoints for responsive design
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
}

/// Application color palette - Black/White minimalist theme
class AppColors {
  AppColors._();

  // Primary colors - Light theme
  static const Color primaryLight = Color(0xFF000000);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color primaryContainerLight = Color(0xFF1A1A1A);
  static const Color onPrimaryContainerLight = Color(0xFFFFFFFF);

  // Secondary colors - Light theme
  static const Color secondaryLight = Color(0xFF424242);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color secondaryContainerLight = Color(0xFFE0E0E0);
  static const Color onSecondaryContainerLight = Color(0xFF000000);

  // Surface colors - Light theme
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF000000);
  static const Color surfaceVariantLight = Color(0xFFF5F5F5);
  static const Color onSurfaceVariantLight = Color(0xFF424242);

  // Background colors - Light theme
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color onBackgroundLight = Color(0xFF000000);

  // Primary colors - Dark theme
  static const Color primaryDark = Color(0xFFFFFFFF);
  static const Color onPrimaryDark = Color(0xFF000000);
  static const Color primaryContainerDark = Color(0xFFE0E0E0);
  static const Color onPrimaryContainerDark = Color(0xFF000000);

  // Secondary colors - Dark theme
  static const Color secondaryDark = Color(0xFFBDBDBD);
  static const Color onSecondaryDark = Color(0xFF000000);
  static const Color secondaryContainerDark = Color(0xFF424242);
  static const Color onSecondaryContainerDark = Color(0xFFFFFFFF);

  // Surface colors - Dark theme
  static const Color surfaceDark = Color(0xFF121212);
  static const Color onSurfaceDark = Color(0xFFFFFFFF);
  static const Color surfaceVariantDark = Color(0xFF1E1E1E);
  static const Color onSurfaceVariantDark = Color(0xFFBDBDBD);

  // Background colors - Dark theme
  static const Color backgroundDark = Color(0xFF000000);
  static const Color onBackgroundDark = Color(0xFFFFFFFF);

  // Semantic colors (same for both themes)
  static const Color error = Color(0xFFCF6679);
  static const Color onError = Color(0xFF000000);
  static const Color success = Color(0xFF4CAF50);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color warning = Color(0xFFFFC107);
  static const Color onWarning = Color(0xFF000000);
  static const Color info = Color(0xFF2196F3);
  static const Color onInfo = Color(0xFFFFFFFF);

  // Neutral grays
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // Event priority colors
  static const Color priorityLow = Color(0xFF9E9E9E);
  static const Color priorityMedium = Color(0xFF757575);
  static const Color priorityHigh = Color(0xFF424242);
  static const Color priorityUrgent = Color(0xFF000000);

  // Mood colors (subtle variations)
  static const Color moodVeryBad = Color(0xFF757575);
  static const Color moodBad = Color(0xFF9E9E9E);
  static const Color moodNeutral = Color(0xFFBDBDBD);
  static const Color moodGood = Color(0xFF616161);
  static const Color moodVeryGood = Color(0xFF424242);

  // Streak colors
  static const Color streakActive = Color(0xFF000000);
  static const Color streakInactive = Color(0xFFBDBDBD);
  static const Color streakMilestone = Color(0xFF424242);

  // Calendar colors
  static const Color calendarToday = Color(0xFF000000);
  static const Color calendarSelected = Color(0xFF424242);
  static const Color calendarEvent = Color(0xFF757575);
  static const Color calendarReflection = Color(0xFF9E9E9E);

  // Opacity levels
  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.60;
  static const double opacityHigh = 0.87;
}

/// Text styles
class AppTextStyles {
  AppTextStyles._();

  // Display styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
  );

  // Headline styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  // Title styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  // Body styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  // Label styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
}

/// Spacing constants
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

/// Icon sizes
class AppIconSizes {
  AppIconSizes._();

  static const double xs = 12.0;
  static const double sm = 16.0;
  static const double md = 24.0;
  static const double lg = 32.0;
  static const double xl = 48.0;
  static const double xxl = 64.0;
}

/// Route names
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String auth = '/auth';
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String forgotPassword = '/auth/forgot-password';

  static const String home = '/home';
  static const String calendar = '/calendar';
  static const String today = '/today';

  static const String events = '/events';
  static const String eventDetails = '/events/:id';
  static const String createEvent = '/events/create';
  static const String editEvent = '/events/:id/edit';

  static const String reflections = '/reflections';
  static const String reflectionDetails = '/reflections/:id';
  static const String createReflection = '/reflections/create';
  static const String editReflection = '/reflections/:id/edit';

  static const String friends = '/friends';
  static const String friendProfile = '/friends/:id';
  static const String addFriend = '/friends/add';

  static const String inbox = '/inbox';
  static const String messageDetails = '/inbox/:id';

  static const String settings = '/settings';
  static const String profile = '/settings/profile';
  static const String notifications = '/settings/notifications';
  static const String privacy = '/settings/privacy';
  static const String appearance = '/settings/appearance';
  static const String about = '/settings/about';
}

/// Storage keys for SharedPreferences
class StorageKeys {
  StorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userPreferences = 'user_preferences';
  static const String lastSyncTime = 'last_sync_time';
  static const String notificationSettings = 'notification_settings';
  static const String onboardingComplete = 'onboarding_complete';
  static const String themeMode = 'theme_mode';
  static const String encryptionPrivateKey = 'encryption_private_key';
  static const String encryptionPublicKey = 'encryption_public_key';
}
