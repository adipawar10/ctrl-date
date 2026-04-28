/// Ctrl+Shift+Date - Day View Screen
/// Single day calendar with hourly time slots
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../router.dart';
import '../theme.dart';
import '../providers/events_provider.dart';
import '../models/event.dart';
import '../widgets/time_slot_widget.dart';
import '../widgets/event_card.dart';

/// Day view screen showing hourly breakdown
class DayViewScreen extends ConsumerStatefulWidget {
  final DateTime initialDate;

  const DayViewScreen({
    super.key,
    required this.initialDate,
  });

  @override
  ConsumerState<DayViewScreen> createState() => _DayViewScreenState();
}

class _DayViewScreenState extends ConsumerState<DayViewScreen> {
  late DateTime _selectedDate;
  late ScrollController _scrollController;
  final double _hourHeight = 60.0;
  final int _startHour = 0;
  final int _endHour = 24;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _scrollController = ScrollController();

    // Scroll to current hour on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentTime();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentTime() {
    final now = DateTime.now();
    if (_isSameDay(_selectedDate, now)) {
      final offset = (now.hour - _startHour) * _hourHeight;
      if (offset > 0 && _scrollController.hasClients) {
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isToday = _isSameDay(_selectedDate, DateTime.now());
    final dateRange = DateRange(
      DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day),
      DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 23, 59, 59),
    );
    final eventsAsync = ref.watch(eventsForDateRangeProvider(dateRange));

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
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: 'Go to today',
            onPressed: () => _goToDate(DateTime.now()),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_view_week),
            tooltip: 'Week view',
            onPressed: () => context.go(AppRoutes.weekPath(_selectedDate)),
          ),
        ],
      ),
      body: eventsAsync.when(
        data: (events) {
          // Convert Event models to maps for compatibility with existing widgets
          final eventMaps = events.map((e) => {
            'id': e.id,
            'title': e.title,
            'start_time': e.startTime,
            'end_time': e.endTime,
            'is_locked': false,
            'priority': e.priority.index + 1,
            'status': e.status.name,
          }).toList();

          return Column(
            children: [
              // Daily productivity score bar
              _buildProductivityBar(context, eventMaps),
              // Date navigation
              _buildDateNavigation(context),
              // Day timeline
              Expanded(
                child: _buildDayTimeline(context, eventMaps),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading events: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goToCreateEvent(_selectedDate),
        tooltip: 'Create Event',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductivityBar(BuildContext context, List<Map<String, dynamic>> events) {
    final theme = Theme.of(context);
    final total = events.length;
    if (total == 0) return const SizedBox.shrink();

    final completed = events.where((e) => e['status'] == 'completed').length;
    final partial = events.where((e) => e['status'] == 'partial').length;
    final skipped = events.where((e) => e['status'] == 'skipped').length;
    final score = total > 0 ? ((completed + partial * 0.5) / total * 100).round() : 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      color: score >= 70
          ? AppColors.completed.withValues(alpha: 0.05)
          : score >= 40
              ? AppColors.partial.withValues(alpha: 0.05)
              : context.csd.surfaceAlt,
      child: Row(
        children: [
          Text(
            '$score%',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: score >= 70
                  ? AppColors.completed
                  : score >= 40
                      ? AppColors.partial
                      : context.csd.onSurfaceDim,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: score / 100,
                backgroundColor: context.csd.borderLight,
                color: score >= 70
                    ? AppColors.completed
                    : score >= 40
                        ? AppColors.partial
                        : context.csd.onSurfaceAlt,
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '$completed✓ $partial~ $skipped✗',
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.csd.onSurfaceDim,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateNavigation(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _goToDate(
              _selectedDate.subtract(const Duration(days: 1)),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                DateFormat('MMMM yyyy').format(_selectedDate),
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _goToDate(
              _selectedDate.add(const Duration(days: 1)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayTimeline(BuildContext context, List<Map<String, dynamic>> events) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Stack(
        children: [
          // Time slots background
          Column(
            children: List.generate(
              _endHour - _startHour,
              (index) {
                final hour = _startHour + index;
                return TimeSlotWidget(
                  hour: hour,
                  height: _hourHeight,
                  onTap: () => _createEventAtHour(hour),
                );
              },
            ),
          ),

          // Current time indicator
          if (_isSameDay(_selectedDate, DateTime.now()))
            _buildCurrentTimeIndicator(context),

          // Events overlay
          ..._buildEventOverlays(context, events),
        ],
      ),
    );
  }

  Widget _buildCurrentTimeIndicator(BuildContext context) {
    final now = DateTime.now();
    final minutesSinceStart = (now.hour - _startHour) * 60 + now.minute;
    final top = minutesSinceStart * (_hourHeight / 60);

    return Positioned(
      top: top,
      left: 0,
      right: 0,
      child: Row(
        children: [
          Container(
            width: 56,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              DateFormat('HH:mm').format(now),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 2,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEventOverlays(BuildContext context, List<Map<String, dynamic>> events) {
    final overlays = <Widget>[];

    for (final event in events) {
      final startTime = event['start_time'] as DateTime;
      final endTime = event['end_time'] as DateTime;

      // Only show events for selected date
      if (!_isSameDay(startTime, _selectedDate)) continue;

      final minutesFromStart =
          (startTime.hour - _startHour) * 60 + startTime.minute;
      final duration = endTime.difference(startTime).inMinutes;

      final top = minutesFromStart * (_hourHeight / 60);
      final height = duration * (_hourHeight / 60);

      overlays.add(
        Positioned(
          top: top,
          left: 64,
          right: 8,
          height: height,
          child: GestureDetector(
            onLongPress: () => _showStatusPicker(context, event),
            child: EventCard(
              id: event['id'],
              title: event['title'],
              startTime: startTime,
              endTime: endTime,
              isLocked: event['is_locked'],
              priority: event['priority'],
              status: event['status'],
              compact: height < 50,
              onTap: () => context.goToEvent(event['id']),
            ),
          ),
        ),
      );
    }

    return overlays;
  }

  void _showStatusPicker(BuildContext context, Map<String, dynamic> event) {
    final theme = Theme.of(context);
    final currentStatus = event['status'] as String;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event['title'] as String,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Mark this event as:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.csd.onSurfaceDim,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _StatusOption(
                icon: Icons.check_circle,
                label: 'Completed',
                color: AppColors.completed,
                isSelected: currentStatus == 'completed',
                onTap: () {
                  Navigator.pop(context);
                  _updateEventStatus(event['id'], 'completed');
                },
              ),
              _StatusOption(
                icon: Icons.timelapse,
                label: 'Partial',
                color: AppColors.partial,
                isSelected: currentStatus == 'partial',
                onTap: () {
                  Navigator.pop(context);
                  _updateEventStatus(event['id'], 'partial');
                },
              ),
              _StatusOption(
                icon: Icons.skip_next,
                label: 'Skipped',
                color: AppColors.skipped,
                isSelected: currentStatus == 'skipped',
                onTap: () {
                  Navigator.pop(context);
                  _updateEventStatus(event['id'], 'skipped');
                },
              ),
              if (currentStatus != 'scheduled')
                _StatusOption(
                  icon: Icons.schedule,
                  label: 'Reset to Scheduled',
                  color: context.csd.onSurfaceDim,
                  isSelected: false,
                  onTap: () {
                    Navigator.pop(context);
                    _updateEventStatus(event['id'], 'scheduled');
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateEventStatus(String eventId, String status) async {
    try {
      final eventStatus = EventStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => EventStatus.scheduled,
      );
      await ref.read(eventActionsProvider).updateStatus(eventId, eventStatus);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: $e')),
        );
      }
    }
  }

  void _goToDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      _goToDate(picked);
    }
  }

  void _createEventAtHour(int hour) {
    final startTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      hour,
    );
    context.goToCreateEvent(startTime);
  }
}

/// Status option tile for the completion picker
class _StatusOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? color : context.csd.onSurfaceDim,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : null,
          color: isSelected ? color : null,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: color)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      tileColor: isSelected ? color.withValues(alpha: 0.05) : null,
      onTap: onTap,
    );
  }
}