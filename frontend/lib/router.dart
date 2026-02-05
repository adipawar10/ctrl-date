/// ctrl^date - GoRouter Configuration
/// All app routes and navigation logic
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/calendar_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/create_event_screen.dart';
import 'screens/reflection_screen.dart';
import 'screens/inbox_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/ai_suggestions_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/onboarding_screen.dart';
import 'providers/onboarding_provider.dart';
import 'widgets/main_shell.dart';

/// Route names for type-safe navigation
class AppRoutes {
  AppRoutes._();

  // Auth routes
  static const String auth = '/auth';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String onboarding = '/onboarding';

  // Main app routes (5 tabs)
  static const String calendar = '/calendar';
  static const String inbox = '/inbox';
  static const String suggestions = '/suggestions';
  static const String reflection = '/reflection';
  static const String settings = '/settings';

  // Legacy routes (redirect to new tabs)
  static const String home = '/calendar';
  static const String day = '/calendar';
  static const String week = '/calendar';
  static const String month = '/calendar';
  static const String aiSuggestions = '/suggestions';
  static const String friends = '/inbox';

  // Detail routes
  static const String eventDetail = '/event/:id';
  static const String createEvent = '/event/create';

  /// Build event detail path with ID
  static String eventDetailPath(String id) => '/event/$id';

  /// Build day view path (legacy - redirects to calendar)
  static String dayPath([DateTime? date]) => calendar;

  /// Build week view path (legacy - redirects to calendar)
  static String weekPath([DateTime? date]) => calendar;

  /// Build month view path (legacy - redirects to calendar)
  static String monthPath([DateTime? date]) => calendar;

  /// Build reflection path with optional date
  static String reflectionPath([DateTime? date]) {
    if (date == null) return reflection;
    return '$reflection?date=${date.toIso8601String().split('T')[0]}';
  }
}

/// Navigator keys for nested navigation
final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

/// App router configuration
final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.calendar,
  debugLogDiagnostics: true,
  routes: [
    // Authentication routes (outside shell)
    GoRoute(
      path: AppRoutes.auth,
      name: 'auth',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: AppRoutes.signIn,
      name: 'sign-in',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      name: 'sign-up',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Shell route with 5-tab bottom navigation
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        // Tab 1: Calendar
        GoRoute(
          path: AppRoutes.calendar,
          name: 'calendar',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CalendarScreen(),
          ),
        ),

        // Tab 2: Inbox
        GoRoute(
          path: AppRoutes.inbox,
          name: 'inbox',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: InboxScreen(),
          ),
        ),

        // Tab 3: Suggestions
        GoRoute(
          path: AppRoutes.suggestions,
          name: 'suggestions',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AiSuggestionsScreen(),
          ),
        ),

        // Tab 4: Reflection
        GoRoute(
          path: AppRoutes.reflection,
          name: 'reflection',
          pageBuilder: (context, state) {
            final dateStr = state.uri.queryParameters['date'];
            final date =
                dateStr != null ? DateTime.tryParse(dateStr) : DateTime.now();
            return NoTransitionPage(
              child: ReflectionScreen(date: date ?? DateTime.now()),
            );
          },
        ),

        // Tab 5: Settings
        GoRoute(
          path: AppRoutes.settings,
          name: 'settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsScreen(),
          ),
        ),
      ],
    ),

    // Full-screen routes (outside shell, no bottom nav)
    GoRoute(
      path: AppRoutes.createEvent,
      name: 'create-event',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final dateStr = state.uri.queryParameters['date'];
        final date = dateStr != null ? DateTime.tryParse(dateStr) : null;
        return CreateEventScreen(initialDate: date);
      },
    ),

    GoRoute(
      path: AppRoutes.eventDetail,
      name: 'event-detail',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return EventDetailScreen(eventId: id);
      },
    ),

    // Legacy route redirects
    GoRoute(
      path: '/',
      redirect: (context, state) => AppRoutes.calendar,
    ),
  ],

  // Error handling
  errorBuilder: (context, state) => _ErrorScreen(error: state.error),

  // Redirect logic for auth and onboarding
  redirect: (context, state) async {
    final supabase = Supabase.instance.client;
    final isAuthenticated = supabase.auth.currentSession != null;
    final isAuthRoute = state.matchedLocation.startsWith('/auth') ||
        state.matchedLocation == '/sign-in' ||
        state.matchedLocation == '/sign-up';
    final isOnboardingRoute = state.matchedLocation == '/onboarding';

    // If not authenticated and not on an auth route, redirect to auth
    if (!isAuthenticated && !isAuthRoute) return AppRoutes.auth;

    // If authenticated, check onboarding status
    if (isAuthenticated) {
      // If on an auth route, redirect to calendar (onboarding will check later)
      if (isAuthRoute) return AppRoutes.calendar;

      // Check if onboarding is complete
      final prefs = await SharedPreferences.getInstance();
      final onboardingComplete = prefs.getBool(OnboardingKeys.onboardingComplete) ?? false;

      // If onboarding not complete and not on onboarding route, redirect to onboarding
      if (!onboardingComplete && !isOnboardingRoute) {
        return AppRoutes.onboarding;
      }

      // If onboarding is complete and on onboarding route, redirect to calendar
      if (onboardingComplete && isOnboardingRoute) {
        return AppRoutes.calendar;
      }
    }

    return null;
  },
);

/// Error screen for navigation errors
class _ErrorScreen extends StatelessWidget {
  final Exception? error;

  const _ErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Page Not Found',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error?.toString() ?? 'The requested page could not be found.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.calendar),
                child: const Text('Go to Calendar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Extension methods for navigation
extension GoRouterExtension on BuildContext {
  /// Navigate to event detail
  void goToEvent(String id) => go(AppRoutes.eventDetailPath(id));

  /// Navigate to create event
  void goToCreateEvent([DateTime? date]) {
    if (date != null) {
      go('${AppRoutes.createEvent}?date=${date.toIso8601String().split('T')[0]}');
    } else {
      go(AppRoutes.createEvent);
    }
  }

  /// Navigate to reflection
  void goToReflection([DateTime? date]) => go(AppRoutes.reflectionPath(date));
}
