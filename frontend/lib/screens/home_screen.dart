/// Ctrl+Shift+Date - Home Screen
/// Main calendar view with today's events and quick navigation
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../router.dart';
import '../theme.dart';
import '../widgets/event_card.dart';
import '../widgets/progress_indicator.dart' as app;
import '../widgets/streak_badge.dart';

/// Home screen showing today's agenda
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime _today = DateTime.now();
  bool _isLoading = false;

  // Mock data - replace with actual state management
  final List<Map<String, dynamic>> _todayEvents = [
    {
      'id': '1',
      'title': 'Team Standup',
      'start_time': DateTime.now().copyWith(hour: 9, minute: 0),
      'end_time': DateTime.now().copyWith(hour: 9, minute: 30),
      'is_locked': true,
      'priority': 3,
      'status': 'scheduled',
    },
    {
      'id': '2',
      'title': 'Deep Work: Project Alpha',
      'start_time': DateTime.now().copyWith(hour: 10, minute: 0),
      'end_time': DateTime.now().copyWith(hour: 12, minute: 0),
      'is_locked': false,
      'priority': 4,
      'status': 'completed',
    },
    {
      'id': '3',
      'title': 'Lunch Break',
      'start_time': DateTime.now().copyWith(hour: 12, minute: 0),
      'end_time': DateTime.now().copyWith(hour: 13, minute: 0),
      'is_locked': false,
      'priority': 1,
      'status': 'scheduled',
    },
    {
      'id': '4',
      'title': 'Client Meeting',
      'start_time': DateTime.now().copyWith(hour: 14, minute: 0),
      'end_time': DateTime.now().copyWith(hour: 15, minute: 0),
      'is_locked': true,
      'priority': 4,
      'status': 'scheduled',
    },
  ];

  int get _completedCount =>
      _todayEvents.where((e) => e['status'] == 'completed').length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today',
              style: theme.textTheme.headlineMedium,
            ),
            Text(
              DateFormat('EEEE, MMMM d').format(_today),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          StreakBadge(
            count: 7,
            onTap: () => context.go(AppRoutes.reflection),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.go(AppRoutes.inbox),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go(AppRoutes.settings),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshEvents,
              child: CustomScrollView(
                slivers: [
                  // Progress section
                  SliverToBoxAdapter(
                    child: _buildProgressSection(context),
                  ),

                  // Quick actions
                  SliverToBoxAdapter(
                    child: _buildQuickActions(context),
                  ),

                  // Events list header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        AppSpacing.lg,
                        AppSpacing.md,
                        AppSpacing.sm,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Schedule',
                            style: theme.textTheme.titleLarge,
                          ),
                          TextButton(
                            onPressed: () => context.go(AppRoutes.day),
                            child: const Text('View Full Day'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Events list
                  _todayEvents.isEmpty
                      ? SliverFillRemaining(
                          child: _buildEmptyState(context),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final event = _todayEvents[index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSpacing.sm,
                                  ),
                                  child: EventCard(
                                    id: event['id'],
                                    title: event['title'],
                                    startTime: event['start_time'],
                                    endTime: event['end_time'],
                                    isLocked: event['is_locked'],
                                    priority: event['priority'],
                                    status: event['status'],
                                    onTap: () =>
                                        context.goToEvent(event['id']),
                                    onComplete: () =>
                                        _markEventComplete(event['id']),
                                  ),
                                );
                              },
                              childCount: _todayEvents.length,
                            ),
                          ),
                        ),

                  // Bottom padding
                  const SliverPadding(
                    padding: EdgeInsets.only(bottom: 100),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goToCreateEvent(_today),
        tooltip: 'Create Event',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.csd.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Progress',
                style: theme.textTheme.titleMedium,
              ),
              Text(
                '$_completedCount/${_todayEvents.length}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: context.csd.onSurfaceDim,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          app.ProgressIndicator(
            value: _todayEvents.isEmpty
                ? 0
                : _completedCount / _todayEvents.length,
            height: 8,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _getProgressMessage(),
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String _getProgressMessage() {
    final rate =
        _todayEvents.isEmpty ? 0 : _completedCount / _todayEvents.length;
    if (rate == 0) return 'Ready to start your day!';
    if (rate < 0.5) return 'Keep going, you\'re making progress!';
    if (rate < 1) return 'Almost there, great work!';
    return 'All done! Excellent work today!';
  }

  Widget _buildQuickActions(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          _QuickActionChip(
            icon: Icons.lightbulb_outline,
            label: 'Suggestions',
            onTap: () => context.go(AppRoutes.aiSuggestions),
          ),
          const SizedBox(width: AppSpacing.sm),
          _QuickActionChip(
            icon: Icons.edit_note,
            label: 'Reflection',
            onTap: () => context.go(AppRoutes.reflection),
          ),
          const SizedBox(width: AppSpacing.sm),
          _QuickActionChip(
            icon: Icons.people_outline,
            label: 'Friends',
            onTap: () => context.go(AppRoutes.friends),
          ),
          const SizedBox(width: AppSpacing.sm),
          _QuickActionChip(
            icon: Icons.calendar_view_week,
            label: 'Week View',
            onTap: () => context.go(AppRoutes.week),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No events today',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tap the + button to add an event',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.csd.onSurfaceDim,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshEvents() async {
    setState(() => _isLoading = true);
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  void _markEventComplete(String eventId) {
    setState(() {
      final index = _todayEvents.indexWhere((e) => e['id'] == eventId);
      if (index != -1) {
        _todayEvents[index]['status'] = 'completed';
      }
    });
  }
}

/// Quick action chip widget
class _QuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }
}
