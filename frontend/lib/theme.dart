/// ctrl^date - Black and White Theme
/// Minimalist, high-contrast, professional design
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// App color palette - strictly black and white with semantic colors only
class AppColors {
  AppColors._();

  // Primary palette (black/white)
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkGray = Color(0xFF1A1A1A);
  static const Color gray900 = Color(0xFF212121);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color lightGray = Color(0xFFFAFAFA);

  // Semantic colors (used sparingly for meaning only)
  static const Color priorityLow = Color(0xFF4CAF50); // Green
  static const Color priorityMedium = Color(0xFF2196F3); // Blue
  static const Color priorityHigh = Color(0xFFFF9800); // Orange
  static const Color priorityCritical = Color(0xFFF44336); // Red

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  static const Color completed = Color(0xFF4CAF50);
  static const Color partial = Color(0xFFFF9800);
  static const Color skipped = Color(0xFF9E9E9E);
  static const Color cancelled = Color(0xFFF44336);

  // Mood colors for reflection
  static const Color mood1 = Color(0xFFF44336); // Very bad
  static const Color mood2 = Color(0xFFFF9800); // Bad
  static const Color mood3 = Color(0xFFFFEB3B); // Neutral
  static const Color mood4 = Color(0xFF8BC34A); // Good
  static const Color mood5 = Color(0xFF4CAF50); // Great

  /// Get priority color by level (1-4)
  static Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return priorityLow;
      case 2:
        return priorityMedium;
      case 3:
        return priorityHigh;
      case 4:
        return priorityCritical;
      default:
        return priorityMedium;
    }
  }

  /// Get mood color by level (1-5)
  static Color getMoodColor(int mood) {
    switch (mood) {
      case 1:
        return mood1;
      case 2:
        return mood2;
      case 3:
        return mood3;
      case 4:
        return mood4;
      case 5:
        return mood5;
      default:
        return mood3;
    }
  }
}

/// App typography
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Inter';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.black,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    color: AppColors.black,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.gray700,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.gray800,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.gray800,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.gray600,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.black,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.gray700,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.gray600,
  );
}

/// App spacing constants
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// App border radius constants
class AppRadius {
  AppRadius._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 999;
}

/// Theme-aware color helpers.
///
/// Use `context.csd` in any widget to get colors that adapt to light/dark mode.
extension CsdColors on BuildContext {
  _CsdColorSet get csd {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark ? _CsdColorSet._dark : _CsdColorSet._light;
  }
}

class _CsdColorSet {
  final Color surface;          // screen / card background
  final Color surfaceAlt;       // slightly contrasting container
  final Color surfaceDim;       // cards, input fills
  final Color onSurface;        // primary text / icons
  final Color onSurfaceAlt;     // secondary text
  final Color onSurfaceDim;     // tertiary / hint text
  final Color border;           // card & divider borders
  final Color borderLight;      // subtle separators
  final Color divider;          // divider lines
  final Color iconDefault;      // default icon tint
  final Color avatarBg;         // avatar / circle backgrounds
  final Color chipBg;           // chip / tag backgrounds

  const _CsdColorSet._({
    required this.surface,
    required this.surfaceAlt,
    required this.surfaceDim,
    required this.onSurface,
    required this.onSurfaceAlt,
    required this.onSurfaceDim,
    required this.border,
    required this.borderLight,
    required this.divider,
    required this.iconDefault,
    required this.avatarBg,
    required this.chipBg,
  });

  static const _light = _CsdColorSet._(
    surface: AppColors.white,
    surfaceAlt: AppColors.gray100,
    surfaceDim: AppColors.lightGray,
    onSurface: AppColors.black,
    onSurfaceAlt: AppColors.gray700,
    onSurfaceDim: AppColors.gray600,
    border: AppColors.gray300,
    borderLight: AppColors.gray200,
    divider: AppColors.gray200,
    iconDefault: AppColors.gray700,
    avatarBg: AppColors.gray200,
    chipBg: AppColors.gray100,
  );

  static const _dark = _CsdColorSet._(
    surface: AppColors.darkGray,
    surfaceAlt: AppColors.gray900,
    surfaceDim: Color(0xFF111111),
    onSurface: AppColors.white,
    onSurfaceAlt: AppColors.gray400,
    onSurfaceDim: AppColors.gray500,
    border: AppColors.gray700,
    borderLight: AppColors.gray800,
    divider: AppColors.gray800,
    iconDefault: AppColors.gray400,
    avatarBg: AppColors.gray800,
    chipBg: AppColors.gray800,
  );
}

/// Main app theme
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: AppTypography.fontFamily,

        // Color scheme
        colorScheme: const ColorScheme.light(
          primary: AppColors.black,
          onPrimary: AppColors.white,
          primaryContainer: AppColors.gray200,
          onPrimaryContainer: AppColors.black,
          secondary: AppColors.gray700,
          onSecondary: AppColors.white,
          secondaryContainer: AppColors.gray100,
          onSecondaryContainer: AppColors.black,
          tertiary: AppColors.gray500,
          onTertiary: AppColors.white,
          tertiaryContainer: AppColors.gray100,
          onTertiaryContainer: AppColors.black,
          error: AppColors.error,
          onError: AppColors.white,
          errorContainer: Color(0xFFFFEBEE),
          onErrorContainer: AppColors.error,
          surface: AppColors.white,
          onSurface: AppColors.black,
          surfaceContainerHighest: AppColors.gray100,
          onSurfaceVariant: AppColors.gray700,
          outline: AppColors.gray300,
          outlineVariant: AppColors.gray200,
          shadow: AppColors.black,
          scrim: AppColors.black,
          inverseSurface: AppColors.gray900,
          onInverseSurface: AppColors.white,
          inversePrimary: AppColors.gray300,
        ),

        // Scaffold
        scaffoldBackgroundColor: AppColors.white,

        // AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          elevation: 0,
          scrolledUnderElevation: 1,
          shadowColor: AppColors.gray300,
          centerTitle: false,
          titleTextStyle: AppTypography.headlineMedium,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          iconTheme: IconThemeData(color: AppColors.black, size: 24),
        ),

        // Bottom navigation
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.black,
          unselectedItemColor: AppColors.gray500,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: AppTypography.labelSmall,
          unselectedLabelStyle: AppTypography.labelSmall,
        ),

        // Navigation bar (Material 3)
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.white,
          indicatorColor: AppColors.gray200,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          height: 64,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTypography.labelSmall.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              );
            }
            return AppTypography.labelSmall;
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.black, size: 24);
            }
            return const IconThemeData(color: AppColors.gray500, size: 24);
          }),
        ),

        // Cards
        cardTheme: CardThemeData(
          color: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            side: const BorderSide(color: AppColors.gray200),
          ),
          margin: EdgeInsets.zero,
        ),

        // Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.black,
            foregroundColor: AppColors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            textStyle: AppTypography.labelLarge,
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.black,
            side: const BorderSide(color: AppColors.gray300),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            textStyle: AppTypography.labelLarge,
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.black,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            textStyle: AppTypography.labelLarge,
          ),
        ),

        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.white,
          elevation: 2,
          shape: CircleBorder(),
        ),

        // Input decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.gray100,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            borderSide: const BorderSide(color: AppColors.black, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
          hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray500),
          labelStyle: AppTypography.bodyMedium,
          errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.error),
        ),

        // Checkbox
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.black;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(AppColors.white),
          side: const BorderSide(color: AppColors.gray400, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
        ),

        // Switch
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.white;
            }
            return AppColors.gray500;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.black;
            }
            return AppColors.gray300;
          }),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),

        // Radio
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.black;
            }
            return AppColors.gray500;
          }),
        ),

        // Slider
        sliderTheme: const SliderThemeData(
          activeTrackColor: AppColors.black,
          inactiveTrackColor: AppColors.gray300,
          thumbColor: AppColors.black,
          overlayColor: Color(0x1A000000),
        ),

        // Progress indicator
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.black,
          linearTrackColor: AppColors.gray200,
          circularTrackColor: AppColors.gray200,
        ),

        // Divider
        dividerTheme: const DividerThemeData(
          color: AppColors.gray200,
          thickness: 1,
          space: 1,
        ),

        // Dialog
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          titleTextStyle: AppTypography.headlineSmall,
          contentTextStyle: AppTypography.bodyMedium,
        ),

        // Bottom sheet
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
          ),
          dragHandleColor: AppColors.gray400,
          dragHandleSize: Size(32, 4),
        ),

        // Snackbar
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.gray900,
          contentTextStyle:
              AppTypography.bodyMedium.copyWith(color: AppColors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          behavior: SnackBarBehavior.floating,
        ),

        // Chip
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.gray100,
          selectedColor: AppColors.black,
          disabledColor: AppColors.gray200,
          labelStyle: AppTypography.labelMedium,
          secondaryLabelStyle:
              AppTypography.labelMedium.copyWith(color: AppColors.white),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          side: BorderSide.none,
        ),

        // List tile
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          titleTextStyle: AppTypography.bodyLarge,
          subtitleTextStyle: AppTypography.bodySmall,
          leadingAndTrailingTextStyle: AppTypography.bodyMedium,
          iconColor: AppColors.gray700,
        ),

        // Tab bar
        tabBarTheme: const TabBarThemeData(
          labelColor: AppColors.black,
          unselectedLabelColor: AppColors.gray500,
          labelStyle: AppTypography.labelLarge,
          unselectedLabelStyle: AppTypography.labelLarge,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: AppColors.black, width: 2),
          ),
          indicatorSize: TabBarIndicatorSize.label,
        ),

        // Tooltip
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColors.gray900,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          textStyle: AppTypography.bodySmall.copyWith(color: AppColors.white),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
        ),

        // Text theme
        textTheme: const TextTheme(
          displayLarge: AppTypography.displayLarge,
          displayMedium: AppTypography.displayMedium,
          displaySmall: AppTypography.displaySmall,
          headlineLarge: AppTypography.headlineLarge,
          headlineMedium: AppTypography.headlineMedium,
          headlineSmall: AppTypography.headlineSmall,
          titleLarge: AppTypography.titleLarge,
          titleMedium: AppTypography.titleMedium,
          titleSmall: AppTypography.titleSmall,
          bodyLarge: AppTypography.bodyLarge,
          bodyMedium: AppTypography.bodyMedium,
          bodySmall: AppTypography.bodySmall,
          labelLarge: AppTypography.labelLarge,
          labelMedium: AppTypography.labelMedium,
          labelSmall: AppTypography.labelSmall,
        ),
      );

  /// Dark theme (inverted black/white)
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: AppTypography.fontFamily,

        colorScheme: const ColorScheme.dark(
          primary: AppColors.white,
          onPrimary: AppColors.black,
          primaryContainer: AppColors.gray800,
          onPrimaryContainer: AppColors.white,
          secondary: AppColors.gray400,
          onSecondary: AppColors.black,
          secondaryContainer: AppColors.gray800,
          onSecondaryContainer: AppColors.white,
          tertiary: AppColors.gray500,
          onTertiary: AppColors.black,
          tertiaryContainer: AppColors.gray800,
          onTertiaryContainer: AppColors.white,
          error: AppColors.error,
          onError: AppColors.white,
          errorContainer: Color(0xFF93000A),
          onErrorContainer: Color(0xFFFFDAD6),
          surface: AppColors.darkGray,
          onSurface: AppColors.white,
          surfaceContainerHighest: AppColors.gray900,
          onSurfaceVariant: AppColors.gray400,
          outline: AppColors.gray700,
          outlineVariant: AppColors.gray800,
          shadow: AppColors.black,
          scrim: AppColors.black,
          inverseSurface: AppColors.gray200,
          onInverseSurface: AppColors.black,
          inversePrimary: AppColors.gray700,
        ),

        scaffoldBackgroundColor: AppColors.darkGray,

        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkGray,
          foregroundColor: AppColors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          shadowColor: AppColors.black,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          iconTheme: IconThemeData(color: AppColors.white, size: 24),
        ),

        // Navigation bar (Material 3)
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.darkGray,
          indicatorColor: AppColors.gray800,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          height: 64,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTypography.labelSmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              );
            }
            return AppTypography.labelSmall.copyWith(color: AppColors.gray500);
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.white, size: 24);
            }
            return const IconThemeData(color: AppColors.gray500, size: 24);
          }),
        ),

        // Cards
        cardTheme: CardThemeData(
          color: AppColors.gray900,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            side: const BorderSide(color: AppColors.gray800),
          ),
          margin: EdgeInsets.zero,
        ),

        // Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.black,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.white,
            side: const BorderSide(color: AppColors.gray600),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
        ),

        // Input decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.gray900,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            borderSide: const BorderSide(color: AppColors.white, width: 2),
          ),
          hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray500),
          labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray400),
        ),

        // List tile
        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          titleTextStyle: AppTypography.bodyLarge.copyWith(color: AppColors.white),
          subtitleTextStyle: AppTypography.bodySmall.copyWith(color: AppColors.gray400),
          iconColor: AppColors.gray400,
        ),

        // Switch
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.black;
            }
            return AppColors.gray500;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.white;
            }
            return AppColors.gray700;
          }),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),

        // Divider
        dividerTheme: const DividerThemeData(
          color: AppColors.gray800,
          thickness: 1,
          space: 1,
        ),

        // Snackbar
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.gray200,
          contentTextStyle:
              AppTypography.bodyMedium.copyWith(color: AppColors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          behavior: SnackBarBehavior.floating,
        ),

        // Dialog
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.gray900,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          titleTextStyle: AppTypography.titleLarge.copyWith(color: AppColors.white),
          contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray300),
        ),

        // Chip
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.gray800,
          labelStyle: AppTypography.labelMedium.copyWith(color: AppColors.white),
          side: const BorderSide(color: AppColors.gray700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),

        // Bottom sheet
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.gray900,
          surfaceTintColor: Colors.transparent,
        ),

        // Tab bar
        tabBarTheme: TabBarThemeData(
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.gray500,
          labelStyle: AppTypography.labelLarge.copyWith(color: AppColors.white),
          unselectedLabelStyle: AppTypography.labelLarge.copyWith(color: AppColors.gray500),
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: AppColors.white, width: 2),
          ),
          indicatorSize: TabBarIndicatorSize.label,
        ),

        // Tooltip
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColors.gray200,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          textStyle: AppTypography.bodySmall.copyWith(color: AppColors.black),
        ),

        // Text theme - reuse AppTypography with dark mode colors
        textTheme: TextTheme(
          displayLarge: AppTypography.displayLarge.copyWith(color: AppColors.white),
          displayMedium: AppTypography.displayMedium.copyWith(color: AppColors.white),
          displaySmall: AppTypography.displaySmall.copyWith(color: AppColors.white),
          headlineLarge: AppTypography.headlineLarge.copyWith(color: AppColors.white),
          headlineMedium: AppTypography.headlineMedium.copyWith(color: AppColors.white),
          headlineSmall: AppTypography.headlineSmall.copyWith(color: AppColors.white),
          titleLarge: AppTypography.titleLarge.copyWith(color: AppColors.white),
          titleMedium: AppTypography.titleMedium.copyWith(color: AppColors.white),
          titleSmall: AppTypography.titleSmall.copyWith(color: AppColors.gray400),
          bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.gray300),
          bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.gray300),
          bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.gray400),
          labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.white),
          labelMedium: AppTypography.labelMedium.copyWith(color: AppColors.gray400),
          labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.gray400),
        ),
      );
}
