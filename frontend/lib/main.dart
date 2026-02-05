/// ctrl^date - Main Application Entry Point
/// Cross-platform productivity app with intelligent scheduling
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// Theme mode provider
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// Main application widget
class CtrlShiftDateApp extends ConsumerStatefulWidget {
  const CtrlShiftDateApp({super.key});

  @override
  ConsumerState<CtrlShiftDateApp> createState() => _CtrlShiftDateAppState();
}

class _CtrlShiftDateAppState extends ConsumerState<CtrlShiftDateApp> {
  bool _checkedForUpdates = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final onboardingState = ref.watch(onboardingProvider);

    // Show What's New dialog for returning users with updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_checkedForUpdates &&
          !onboardingState.isLoading &&
          onboardingState.isComplete &&
          onboardingState.hasNewUpdate) {
        _checkedForUpdates = true;
        final ctx = appRouter.routerDelegate.navigatorKey.currentContext;
        if (ctx != null) {
          WhatsNewDialog.show(ctx);
        }
      }
    });

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Use our black/white theme
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // Use GoRouter for navigation
      routerConfig: appRouter,
    );
  }
}

