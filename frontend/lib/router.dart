/// Ctrl+Shift+Date - GoRouter Configuration
/// All app routes and navigation logic
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/home_screen.dart';
import 'screens/day_view_screen.dart';
import 'screens/week_view_screen.dart';
import 'screens/month_view_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/create_event_screen.dart';
import 'screens/reflection_screen.dart';
import 'screens/friends_screen.dart';
import 'screens/inbox_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/ai_suggestions_screen.dart';

/// Route names for type-safe navigation
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String day = '/day';
  static const String week = '/week';
  static const String month = '/month';
  static const String eventDetail = '/event/:id';
  static const String createEvent = '/event/create';
  static const String reflection = '/reflection';
  static const String friends = '/friends';
  static const String inbox = '/inbox';
  static const String settings = '/settings';
  static const String aiSuggestions = '/ai-suggestions';

  /// Build event detail path with ID
  static String eventDetailPath(String id) => '/event/$id';

  /// Build day view path with optional date
  static String dayPath([DateTime? date]) {
    if (date == null) return day;
    return '$day?date=${date.toIso8601String().split('T')[0]}';
  }

  /// Build week view path with optional date
  static String weekPath([DateTime? date]) {
    if (date == null) return week;
    return '$week?date=${date.toIso8601String().split('T')[0]}';
  }

  /// Build month view path with optional date
  static String monthPath([DateTime? date]) {
    if (date == null) return month;
    return '$month?date=${date.toIso8601String().split('T')[0]}';
  }

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
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true,
  routes: [
    // Shell route for bottom navigation
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) => _ScaffoldWithNavigation(child: child),
      routes: [
        // Home (Today view)
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),

        // Day view
        GoRoute(
          path: AppRoutes.day,
          name: 'day',
          pageBuilder: (context, state) {
            final dateStr = state.uri.queryParameters['date'];
            final date =
                dateStr != null ? DateTime.tryParse(dateStr) : DateTime.now();
            return NoTransitionPage(
              child: DayViewScreen(initialDate: date ?? DateTime.now()),
            );
          },
        ),

        // Week view
        GoRoute(
          path: AppRoutes.week,
          name: 'week',
          pageBuilder: (context, state) {
            final dateStr = state.uri.queryParameters['date'];
            final date =
                dateStr != null ? DateTime.tryParse(dateStr) : DateTime.now();
            return NoTransitionPage(
              child: WeekViewScreen(initialDate: date ?? DateTime.now()),
            );
          },
        ),

        // Month view
        GoRoute(
          path: AppRoutes.month,
          name: 'month',
          pageBuilder: (context, state) {
            final dateStr = state.uri.queryParameters['date'];
            final date =
                dateStr != null ? DateTime.tryParse(dateStr) : DateTime.now();
            return NoTransitionPage(
              child: MonthViewScreen(initialDate: date ?? DateTime.now()),
            );
          },
        ),

        // Reflection
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

        // Friends
        GoRoute(
          path: AppRoutes.friends,
          name: 'friends',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: FriendsScreen(),
          ),
        ),

        // Inbox
        GoRoute(
          path: AppRoutes.inbox,
          name: 'inbox',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: InboxScreen(),
          ),
        ),

        // Settings
        GoRoute(
          path: AppRoutes.settings,
          name: 'settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsScreen(),
          ),
        ),

        // AI Suggestions
        GoRoute(
          path: AppRoutes.aiSuggestions,
          name: 'ai-suggestions',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AiSuggestionsScreen(),
          ),
        ),
      ],
    ),

    // Full-screen routes (outside shell)
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
  ],

  // Error handling
  errorBuilder: (context, state) => _ErrorScreen(error: state.error),

  // Redirect logic (for auth, etc.)
  redirect: (context, state) {
    // Add authentication redirects here
    // final isAuthenticated = authProvider.isAuthenticated;
    // final isLoggingIn = state.matchedLocation == '/login';
    // if (!isAuthenticated && !isLoggingIn) return '/login';
    // if (isAuthenticated && isLoggingIn) return '/';
    return null;
  },
);

/// Scaffold with bottom navigation
class _ScaffoldWithNavigation extends StatelessWidget {
  final Widget child;

  const _ScaffoldWithNavigation({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            selectedIcon: Icon(Icons.today),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_view_week_outlined),
            selectedIcon: Icon(Icons.calendar_view_week),
            label: 'Week',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Month',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'AI',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz),
            selectedIcon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location == AppRoutes.home || location == AppRoutes.day) return 0;
    if (location == AppRoutes.week) return 1;
    if (location == AppRoutes.month) return 2;
    if (location == AppRoutes.aiSuggestions) return 3;
    if (location == AppRoutes.reflection ||
        location == AppRoutes.friends ||
        location == AppRoutes.inbox ||
        location == AppRoutes.settings) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.week);
        break;
      case 2:
        context.go(AppRoutes.month);
        break;
      case 3:
        context.go(AppRoutes.aiSuggestions);
        break;
      case 4:
        _showMoreMenu(context);
        break;
    }
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.edit_note),
              title: const Text('Daily Reflection'),
              onTap: () {
                Navigator.pop(context);
                context.go(AppRoutes.reflection);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('Friends'),
              onTap: () {
                Navigator.pop(context);
                context.go(AppRoutes.friends);
              },
            ),
            ListTile(
              leading: const Icon(Icons.inbox_outlined),
              title: const Text('Inbox'),
              onTap: () {
                Navigator.pop(context);
                context.go(AppRoutes.inbox);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                context.go(AppRoutes.settings);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

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
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Go Home'),
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

  /// Navigate to day view
  void goToDay([DateTime? date]) => go(AppRoutes.dayPath(date));

  /// Navigate to week view
  void goToWeek([DateTime? date]) => go(AppRoutes.weekPath(date));

  /// Navigate to month view
  void goToMonth([DateTime? date]) => go(AppRoutes.monthPath(date));

  /// Navigate to reflection
  void goToReflection([DateTime? date]) => go(AppRoutes.reflectionPath(date));
}
