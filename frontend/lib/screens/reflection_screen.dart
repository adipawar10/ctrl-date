/// Ctrl+Shift+Date - Reflection Screen
/// Daily reflection UI for reviewing and tracking progress
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../router.dart';
import '../theme.dart';
import '../models/reflection.dart';
import '../providers/reflection_provider.dart';
import '../providers/events_provider.dart';
import '../widgets/progress_indicator.dart' as app;
import '../widgets/event_card.dart';
import '../services/streak_service.dart';

/// Reflection screen for daily review
class ReflectionScreen extends ConsumerStatefulWidget {
  final DateTime date;

  const ReflectionScreen({
    super.key,
    required this.date,
  });

  @override
  ConsumerState<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends ConsumerState<ReflectionScreen> {
  late DateTime _selectedDate;
  final _notesController = TextEditingController();
  int? _selectedMood;
  bool _isLoading = true;
  bool _hasChanges = false;

  // Mock data - replace with actual state management
  late Map<String, dynamic> _reflection;
  late List<Map<String, dynamic>> _events;
  int _productivityStreak = 0;

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

    // Mock productivity streak
    _productivityStreak = 7;

    _notesController.text = _reflection['notes'] ?? '';
    _selectedMood = _reflection['mood'];

    setState(() {
      _isLoading = false;
      _hasChanges = false;
    });
  }

  double get _completionRate {
    return StreakService.calculateDailyCompletionRate(_selectedDate, _events);
  }

  String get _supportiveMessage {
    return StreakService.getSupportiveMessage(_completionRate);
  }

  void _updateEventStatus(String eventId, String newStatus) {
    setState(() {
      final index = _events.indexWhere((e) => e['id'] == eventId);
      if (index != -1) {
        _events[index] = {
          ..._events[index],
          'status': newStatus,
        };
        _hasChanges = true;
      }
    });
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
          IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Reflection history',
            onPressed: _showReflectionHistory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadReflection,
              child: CustomScrollView(
                slivers: [
                  // Streak card at the top
                  SliverToBoxAdapter(
                    child: _buildStreakCard(context),
                  ),

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

                  // Events list with completion status buttons
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final event = _events[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: _buildEventWithStatusButtons(context, event),
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

  Widget _buildStreakCard(BuildContext context) {
    final theme = Theme.of(context);
    final completionPercentage = (_completionRate * 100).toInt();

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Streak row
          Row(
            children: [
              // Flame icon with streak count
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: _productivityStreak > 0
                      ? AppColors.warning.withValues(alpha: 0.1)
                      : AppColors.gray200,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _productivityStreak >= 30
                          ? Icons.whatshot
                          : Icons.local_fire_department,
                      size: 24,
                      color: _productivityStreak > 0
                          ? AppColors.warning
                          : AppColors.gray400,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '$_productivityStreak',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _productivityStreak > 0
                            ? AppColors.black
                            : AppColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Streak info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _productivityStreak == 1
                          ? 'Day Streak'
                          : 'Day Streak',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      StreakService.getStreakMessage(_productivityStreak),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              // Completion percentage
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$completionPercentage%',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _getCompletionColor(),
                    ),
                  ),
                  Text(
                    'Today',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Progress bar
          app.ProgressIndicator(
            value: _completionRate,
            height: 8,
          ),
          const SizedBox(height: AppSpacing.md),
          // Supportive message
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: [
                Icon(
                  _getMessageIcon(),
                  size: 20,
                  color: _getCompletionColor(),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    _supportiveMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.gray700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMessageIcon() {
    if (_completionRate >= 1.0) return Icons.celebration;
    if (_completionRate >= 0.7) return Icons.thumb_up;
    if (_completionRate >= 0.5) return Icons.trending_up;
    return Icons.favorite;
  }

  Color _getCompletionColor() {
    if (_completionRate >= 1.0) return AppColors.completed;
    if (_completionRate >= 0.7) return AppColors.completed;
    if (_completionRate >= 0.5) return AppColors.partial;
    return AppColors.gray600;
  }

  Widget _buildStatsSection(BuildContext context) {
    final theme = Theme.of(context);
    final completed = _events.where((e) => e['status'] == 'completed').length;
    final partial = _events.where((e) => e['status'] == 'partial').length;
    final skipped = _events.where((e) => e['status'] == 'skipped').length;
    final pending = _events.where((e) =>
        e['status'] != 'completed' &&
        e['status'] != 'partial' &&
        e['status'] != 'skipped').length;

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
            'Breakdown',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          // Stats breakdown
          Row(
            children: [
              _buildStatItem(
                context,
                count: completed,
                label: 'Completed',
                color: AppColors.completed,
              ),
              _buildStatItem(
                context,
                count: partial,
                label: 'Partial',
                color: AppColors.partial,
              ),
              _buildStatItem(
                context,
                count: skipped,
                label: 'Skipped',
                color: AppColors.skipped,
              ),
              _buildStatItem(
                context,
                count: pending,
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
      margin: const EdgeInsets.all(AppSpacing.md),
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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

  Widget _buildEventWithStatusButtons(
    BuildContext context,
    Map<String, dynamic> event,
  ) {
    final theme = Theme.of(context);
    final currentStatus = event['status'] as String;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray200),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          // Event card
          EventCard(
            id: event['id'],
            title: event['title'],
            startTime: event['start_time'],
            endTime: event['end_time'],
            isLocked: event['is_locked'],
            priority: event['priority'],
            status: currentStatus,
            onTap: () => context.goToEvent(event['id']),
          ),
          // Status buttons
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: const BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppRadius.md),
                bottomRight: Radius.circular(AppRadius.md),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Mark as:',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _buildStatusButton(
                  context,
                  eventId: event['id'],
                  status: 'completed',
                  label: 'Done',
                  icon: Icons.check_circle_outline,
                  color: AppColors.completed,
                  isSelected: currentStatus == 'completed',
                ),
                const SizedBox(width: AppSpacing.xs),
                _buildStatusButton(
                  context,
                  eventId: event['id'],
                  status: 'partial',
                  label: 'Partial',
                  icon: Icons.timelapse,
                  color: AppColors.partial,
                  isSelected: currentStatus == 'partial',
                ),
                const SizedBox(width: AppSpacing.xs),
                _buildStatusButton(
                  context,
                  eventId: event['id'],
                  status: 'skipped',
                  label: 'Skip',
                  icon: Icons.skip_next_outlined,
                  color: AppColors.skipped,
                  isSelected: currentStatus == 'skipped',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(
    BuildContext context, {
    required String eventId,
    required String status,
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: () => _updateEventStatus(eventId, status),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.15) : AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: isSelected ? color : AppColors.gray300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? color : AppColors.gray500,
              ),
              const SizedBox(width: 2),
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSelected ? color : AppColors.gray600,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
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

  void _showReflectionHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => _ReflectionHistorySheet(
          scrollController: scrollController,
          onDateSelected: (date) {
            Navigator.pop(context);
            setState(() => _selectedDate = date);
            _loadReflection();
          },
        ),
      ),
    );
  }

  Future<void> _saveReflection() async {
    // TODO: Implement save to API
    final reflectionData = {
      'date': _selectedDate.toIso8601String(),
      'notes': _notesController.text,
      'mood': _selectedMood,
      'events': _events.map((e) => {
        'id': e['id'],
        'status': e['status'],
      }).toList(),
    };

    debugPrint('Saving reflection: $reflectionData');

    setState(() => _hasChanges = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reflection saved')),
    );
  }
}

/// Bottom sheet showing reflection history
class _ReflectionHistorySheet extends ConsumerWidget {
  final ScrollController scrollController;
  final ValueChanged<DateTime> onDateSelected;

  const _ReflectionHistorySheet({
    required this.scrollController,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final last30Days = DateRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    );
    final reflectionsAsync = ref.watch(reflectionsForDateRangeProvider(last30Days));
    final statsAsync = ref.watch(reflectionStatsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Handle
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: AppSpacing.sm),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        // Header
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reflection History',
                style: theme.textTheme.titleLarge,
              ),
              // Stats summary
              statsAsync.when(
                data: (stats) => Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      size: 20,
                      color: stats.currentStreak > 0
                          ? AppColors.warning
                          : AppColors.gray400,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${stats.currentStreak} day streak',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Stats row
        statsAsync.when(
          data: (stats) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                _StatChip(
                  label: 'Total',
                  value: '${stats.totalReflections}',
                  icon: Icons.calendar_today,
                ),
                const SizedBox(width: AppSpacing.sm),
                _StatChip(
                  label: 'Longest',
                  value: '${stats.longestStreak}d',
                  icon: Icons.emoji_events,
                ),
                if (stats.averageMood != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  _StatChip(
                    label: 'Avg Mood',
                    value: stats.averageMood!.toStringAsFixed(1),
                    icon: Icons.sentiment_satisfied,
                  ),
                ],
                if (stats.averageProductivity != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  _StatChip(
                    label: 'Avg Prod',
                    value: stats.averageProductivity!.toStringAsFixed(1),
                    icon: Icons.trending_up,
                  ),
                ],
              ],
            ),
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        const Divider(height: 1),
        // Reflections list
        Expanded(
          child: reflectionsAsync.when(
            data: (reflections) {
              if (reflections.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: AppColors.gray300),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'No reflections yet',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Complete today\'s reflection to get started',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.gray400,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                itemCount: reflections.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final r = reflections[index];
                  final isToday = _isSameDay(r.date, DateTime.now());

                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: r.mood != null
                            ? AppColors.getMoodColor(r.mood!.value)
                            : AppColors.gray100,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Center(
                        child: Text(
                          r.mood != null ? _moodEmoji(r.mood!.value) : '—',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    title: Text(
                      isToday
                          ? 'Today'
                          : DateFormat('EEEE, MMM d').format(r.date),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: isToday ? FontWeight.w700 : null,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        if (r.productivity != null)
                          Text(
                            'Productivity: ${r.productivity!.label}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.gray600,
                            ),
                          ),
                        if (r.productivity != null && r.notes != null)
                          Text(
                            ' · ',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.gray400,
                            ),
                          ),
                        if (r.notes != null)
                          Expanded(
                            child: Text(
                              r.notes!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.gray500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () => onDateSelected(r.date),
                  );
                },
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  String _moodEmoji(int mood) {
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

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

/// Small stat chip for the history header
class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: AppColors.gray600),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.gray500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}