/// Ctrl+Shift+Date - Main Application Entry Point
/// Cross-platform productivity app with intelligent scheduling
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'utils/constants.dart';
import 'services/notification_service.dart';
import 'database/database.dart';
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
class CtrlShiftDateApp extends ConsumerWidget {
  const CtrlShiftDateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

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

/// Splash screen shown during app initialization
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Ctrl+Shift+Date',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for Auth screen - implement with actual auth UI
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 64,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Ctrl+Shift+Date',
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Intelligent productivity scheduling',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement authentication
                  },
                  child: const Text('Sign In'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Implement registration
                  },
                  child: const Text('Create Account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
