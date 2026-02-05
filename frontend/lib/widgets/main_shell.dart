/// Ctrl+Shift+Date - Main Shell with Bottom Navigation
/// 5-tab navigation structure for the app
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';

/// Main shell widget with bottom navigation bar
class MainShell extends StatelessWidget {
  /// The child widget to display in the body
  final Widget child;

  const MainShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.gray200,
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _calculateSelectedIndex(context),
          onDestinationSelected: (index) => _onDestinationSelected(context, index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              selectedIcon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            NavigationDestination(
              icon: Icon(Icons.inbox_outlined),
              selectedIcon: Icon(Icons.inbox),
              label: 'Inbox',
            ),
            NavigationDestination(
              icon: Icon(Icons.lightbulb_outlined),
              selectedIcon: Icon(Icons.lightbulb),
              label: 'Suggestions',
            ),
            NavigationDestination(
              icon: Icon(Icons.self_improvement_outlined),
              selectedIcon: Icon(Icons.self_improvement),
              label: 'Reflection',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  /// Calculate the selected index based on the current route
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    if (location.startsWith('/calendar')) {
      return 0;
    }
    if (location.startsWith('/inbox')) {
      return 1;
    }
    if (location.startsWith('/suggestions')) {
      return 2;
    }
    if (location.startsWith('/reflection')) {
      return 3;
    }
    if (location.startsWith('/settings')) {
      return 4;
    }

    // Default to calendar
    return 0;
  }

  /// Handle navigation when a destination is selected
  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/calendar');
        break;
      case 1:
        context.go('/inbox');
        break;
      case 2:
        context.go('/suggestions');
        break;
      case 3:
        context.go('/reflection');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }
}
