/// Ctrl+Shift+Date - Reflection Screen
/// Daily reflection UI for reviewing and tracking progress
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../router.dart';
import '../theme.dart';
import '../widgets/progress_indicator.dart' as app;
import '../widgets/streak_badge.dart';
import '../widgets/event_card.dart';

/// Reflection screen for daily review
class ReflectionScreen extends StatefulWidget {
  final DateTime date;

  const ReflectionScreen({
    super.key,
    required this.date,
  });

  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  late DateTime _selectedDate;
  final _notesController = TextEditingController();
  int? _selectedMood;
  bool _isLoading = true;
  bool _hasChanges = false;

  // Mock data - replace with actual state management
  late Map<String, dynamic> _reflection;
  late List<Map<String, dynamic>> _events;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date;
    _loadReflection();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadReflection() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data
    _reflection = {
      'events_planned': 5,
      'events_completed': 3,
      'events_skipped': 1,
      'events_partial': 1,
      'notes': 'Productive day overall. Need to improve focus in afternoon.',
      'mood': 4,
      'is_streak_day': true,
    };

    _events = [
      {
        'id': '1',
        'title': 'Team Standup',
        'start_time': _selectedDate.copyWith(hour: 9, minute: 0),
        'end_time': _selectedDate.copyWith(hour: 9, minute: 30),
        'status': 'completed',
        'priority': 3,
        'is_locked': true,
      },
      {
        'id': '2',
        'title': 'Deep Work: Project Alpha',
        'start_time': _selectedDate.copyWith(hour: 10, minute: 0),
        'end_time': _selectedDate.copyWith(hour: 12, minute: 0),
        'status': 'completed',
        'priority': 4,
        'is_locked': false,
      },
      {
        'id': '3',
        'title': 'Lunch Break',
        'start_time': _selectedDate.copyWith(hour: 12, minute: 0),
        'end_time': _selectedDate.copyWith(hour: 13, minute: 0),
        'status': 'skipped',
        'priority': 1,
        'is_locked': false,
      },
      {
        'id': '4',
        'title': 'Client Meeting',
        'start_time': _selectedDate.copyWith(hour: 14, minute: 0),
        'end_time': _selectedDate.copyWith(hour: 15, minute: 0),
        'status': 'completed',
        'priority': 4,
        'is_locked': true,
      },
      {
        'id': '5',
        'title': 'Code Review',
        'start_time': _selectedDate.copyWith(hour: 16, minute: 0),
        'end_time': _selectedDate.copyWith(hour: 17, minute: 0),
        'status': 'partial',
        'priority': 2,
        'is_locked': false,
      },
    ];

    _notesController.text = _reflection['notes'] ?? '';
    _selectedMood = _reflection['mood'];

    setState(() {
      _isLoading = false;
      _hasChanges = false;
    });
  }

  double get _completionRate {
    final planned = _reflection['events_planned'] as int;
    if (planned == 0) return 0;
    final completed = _reflection['events_completed'] as int;
    final partial = _reflection['events_partial'] as int;
    return (completed + partial * 0.5) / planned;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isToday = _isSameDay(_selectedDate, DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _showDatePicker,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isToday ? 'Today' : DateFormat('EEE, MMM d').format(_selectedDate),
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, size: 20),
            ],
          ),
        ),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _saveReflection,
              child: const Text('Save'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadReflection,
              child: CustomScrollView(
                slivers: [
                  // Stats section
                  SliverToBoxAdapter(
                    child: _buildStatsSection(context),
                  ),

                  // Mood section
                  SliverToBoxAdapter(
                    child: _buildMoodSection(context),
                  ),

                  // Notes section
                  SliverToBoxAdapter(
                    child: _buildNotesSection(context),
                  ),

                  // Events header
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
                            'Events',
                            style: theme.textTheme.titleLarge,
                          ),
                          TextButton(
                            onPressed: () => context.go(AppRoutes.dayPath(_selectedDate)),
                            child: const Text('View Day'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Events list
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final event = _events[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: EventCard(
                              id: event['id'],
                              title: event['title'],
                              startTime: event['start_time'],
                              endTime: event['end_time'],
                              isLocked: event['is_locked'],
                              priority: event['priority'],
                              status: event['status'],
                              onTap: () => context.goToEvent(event['id']),
                            ),
                          );
                        },
                        childCount: _events.length,
                      ),
                    ),
                  ),

                  // Bottom padding
                  const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Completion Rate',
                style: theme.textTheme.titleMedium,
              ),
              Row(
                children: [
                  StreakBadge(
                    count: 7,
                    compact: true,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${(_completionRate * 100).toInt()}%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          app.ProgressIndicator(
            value: _completionRate,
            height: 8,
          ),
          const SizedBox(height: AppSpacing.md),

          // Stats breakdown
          Row(
            children: [
              _buildStatItem(
                context,
                count: _reflection['events_completed'],
                label: 'Completed',
                color: AppColors.completed,
              ),
              _buildStatItem(
                context,
                count: _reflection['events_partial'],
                label: 'Partial',
                color: AppColors.partial,
              ),
              _buildStatItem(
                context,
                count: _reflection['events_skipped'],
                label: 'Skipped',
                color: AppColors.skipped,
              ),
              _buildStatItem(
                context,
                count: _reflection['events_planned'] -
                    _reflection['events_completed'] -
                    _reflection['events_partial'] -
                    _reflection['events_skipped'],
                label: 'Pending',
                color: AppColors.gray500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required int count,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '$count',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray200),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How was your day?',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (index) {
              final mood = index + 1;
              final isSelected = _selectedMood == mood;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMood = mood;
                    _hasChanges = true;
                  });
                },
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.getMoodColor(mood)
                            : AppColors.gray100,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: AppColors.getMoodColor(mood),
                                width: 2,
                              )
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          _getMoodEmoji(mood),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getMoodLabel(mood),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isSelected ? AppColors.black : AppColors.gray500,
                        fontWeight: isSelected ? FontWeight.w600 : null,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getMoodEmoji(int mood) {
    switch (mood) {
      case 1:
        return ':(';
      case 2:
        return ':|';
      case 3:
        return ':)';
      case 4:
        return ':D';
      case 5:
        return 'XD';
      default:
        return ':)';
    }
  }

  String _getMoodLabel(int mood) {
    switch (mood) {
      case 1:
        return 'Bad';
      case 2:
        return 'Meh';
      case 3:
        return 'OK';
      case 4:
        return 'Good';
      case 5:
        return 'Great';
      default:
        return '';
    }
  }

  Widget _buildNotesSection(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              hintText: 'How did your day go? Any thoughts or learnings?',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            onChanged: (_) {
              if (!_hasChanges) {
                setState(() => _hasChanges = true);
              }
            },
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
      _loadReflection();
    }
  }

  Future<void> _saveReflection() async {
    // TODO: Implement save to API
    final reflectionData = {
      'date': _selectedDate.toIso8601String(),
      'notes': _notesController.text,
      'mood': _selectedMood,
    };

    debugPrint('Saving reflection: $reflectionData');

    setState(() => _hasChanges = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reflection saved')),
    );
  }
}
