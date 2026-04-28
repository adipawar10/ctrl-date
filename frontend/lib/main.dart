/// ctrl^date - Main Application Entry Point
/// Cross-platform productivity app with intelligent scheduling
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'utils/constants.dart';
import 'services/notification_service.dart';
import 'database/database.dart';
import 'providers/onboarding_provider.dart';
import 'widgets/whats_new_dialog.dart';
import 'theme.dart';
import 'router.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  // Initialize local notifications
  await NotificationService.initialize(flutterLocalNotificationsPlugin);

  // Initialize local database
  final database = AppDatabase();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
      child: const CtrlShiftDateApp(),
    ),
  );
}

/// Global database provider
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Database must be initialized before use');
});

/// Theme mode provider with persistence
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }

  Timer? _persistTimer;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('theme_mode');
    if (value != null) {
      state = ThemeMode.values.firstWhere(
        (m) => m.name == value,
        orElse: () => ThemeMode.system,
      );
    }
  }

  /// Updates theme immediately; persists after a short debounce so rapid
  /// toggles do not stack async work that can race with rebuilds.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) return;
    state = mode;
    _persistTimer?.cancel();
    final persisted = mode;
    _persistTimer = Timer(const Duration(milliseconds: 200), () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme_mode', persisted.name);
    });
  }

  @override
  void dispose() {
    _persistTimer?.cancel();
    super.dispose();
  }
}

/// Main application widget
class CtrlShiftDateApp extends ConsumerStatefulWidget {
  const CtrlShiftDateApp({super.key});

  @override
  ConsumerState<CtrlShiftDateApp> createState() => _CtrlShiftDateAppState();
}

class _CtrlShiftDateAppState extends ConsumerState<CtrlShiftDateApp> {
  bool _checkedForUpdates = false;

  @override
  void initState() {
    super.initState();
    // One-shot: do not schedule post-frame work on every rebuild (e.g. theme
    // toggles), which could stack callbacks and trigger framework assertions.
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryShowWhatsNew());
  }

  void _tryShowWhatsNew() {
    if (!mounted || _checkedForUpdates) return;
    final onboarding = ref.read(onboardingProvider);
    if (onboarding.isLoading ||
        !onboarding.isComplete ||
        !onboarding.hasNewUpdate) {
      return;
    }
    _checkedForUpdates = true;
    final ctx = appRouter.routerDelegate.navigatorKey.currentContext;
    if (ctx != null) {
      WhatsNewDialog.show(ctx);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    ref.listen(onboardingProvider, (previous, next) {
      if (_checkedForUpdates) return;
      if (next.isLoading || !next.isComplete || !next.hasNewUpdate) return;
      _checkedForUpdates = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final ctx = appRouter.routerDelegate.navigatorKey.currentContext;
        if (ctx != null) {
          WhatsNewDialog.show(ctx);
        }
      });
    });

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Use our black/white theme
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      // Avoid animated theme cross-fade stacking when toggling light/dark quickly.
      themeAnimationDuration: Duration.zero,

      // Use GoRouter for navigation
      routerConfig: appRouter,
    );
  }
}

