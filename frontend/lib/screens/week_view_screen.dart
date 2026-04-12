/// Ctrl+Shift+Date - Week View Screen
/// Week calendar grid showing 7 days
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../router.dart';
import '../theme.dart';

/// Week view screen showing 7-day grid
class WeekViewScreen extends StatefulWidget {
  final DateTime initialDate;

  const WeekViewScreen({
    super.key,
    required this.initialDate,
  });

  @override
  State<WeekViewScreen> createState() => _WeekViewScreenState();
}

class _WeekViewScreenState extends State<WeekViewScreen> {
  late DateTime _weekStart;
  late ScrollController _verticalScrollController;
  final double _hourHeight = 50.0;
  final int _startHour = 6;
  final int _endHour = 22;

  // Mock events - replace with actual state management
  final Map<String, List<Map<String, dynamic>>> _eventsByDay = {};

  /// Formats hour to 12-hour AM/PM format
  String _formatHour(int hour) {
    if (hour == 0 || hour == 24) {
      return '12 AM';
    } else if (hour == 12) {
      return '12 PM';
    } else if (hour < 12) {
      return '$hour AM';
    } else {
      return '${hour - 12} PM';
    }
  }

  @override
  void initState() {
    super.initState();
    _weekStart = _getWeekStart(widget.initialDate);
    _verticalScrollController = ScrollController();

    _loadMockEvents();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentTime();
    });
  }

  void _loadMockEvents() {
    // Mock events for demonstration
    final today = DateTime.now();
    final todayKey = DateFormat('yyyy-MM-dd').format(today);

    _eventsByDay[todayKey] = [
      {
        'id': '1',
        'title': 'Standup',
        'start_hour': 9,
        'start_minute': 0,
        'end_hour': 9,
        'end_minute': 30,
        'is_locked': true,
        'priority': 3,
      },
      {
        'id': '2',
        'title': 'Deep Work',
        'start_hour': 10,
        'start_minute': 0,
        'end_hour': 12,
        'end_minute': 0,
        'is_locked': false,
        'priority': 4,
      },
      {
        'id': '3',
        'title': 'Meeting',
        'start_hour': 14,
        'start_minute': 0,
        'end_hour': 15,
        'end_minute': 0,
        'is_locked': true,
        'priority': 4,
      },
    ];

    // Add event for tomorrow
    final tomorrow = today.add(const Duration(days: 1));
    final tomorrowKey = DateFormat('yyyy-MM-dd').format(tomorrow);
    _eventsByDay[tomorrowKey] = [
      {
        'id': '4',
        'title': 'Planning',
        'start_hour': 10,
        'start_minute': 0,
        'end_hour': 11,
        'end_minute': 0,
        'is_locked': false,
        'priority': 2,
      },
    ];
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    super.dispose();
  }

  DateTime _getWeekStart(DateTime date) {
    // Start week on Monday
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  void _scrollToCurrentTime() {
    final now = DateTime.now();
    final offset = (now.hour - _startHour) * _hourHeight;
    if (offset > 0 && _verticalScrollController.hasClients) {
      _verticalScrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _showDatePicker,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getWeekTitle(),
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
            tooltip: 'Go to this week',
            onPressed: () => _goToWeek(DateTime.now()),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: 'Month view',
            onPressed: () => context.go(AppRoutes.monthPath(_weekStart)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Week navigation
          _buildWeekNavigation(context),

          // Day headers
          _buildDayHeaders(context),

          // Week grid
          Expanded(
            child: _buildWeekGrid(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goToCreateEvent(),
        tooltip: 'Create Event',
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getWeekTitle() {
    final weekEnd = _weekStart.add(const Duration(days: 6));
    final startMonth = DateFormat('MMM').format(_weekStart);
    final endMonth = DateFormat('MMM').format(weekEnd);

    if (startMonth == endMonth) {
      return '$startMonth ${_weekStart.day}-${weekEnd.day}';
    }
    return '$startMonth ${_weekStart.day} - $endMonth ${weekEnd.day}';
  }

  Widget _buildWeekNavigation(BuildContext context) {
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
            onPressed: () => _goToWeek(
              _weekStart.subtract(const Duration(days: 7)),
            ),
          ),
          Text(
            DateFormat('MMMM yyyy').format(_weekStart),
            style: theme.textTheme.titleMedium,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _goToWeek(
              _weekStart.add(const Duration(days: 7)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayHeaders(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          // Time column spacer
          const SizedBox(width: 50),

          // Day headers
          ...List.generate(7, (index) {
            final day = _weekStart.add(Duration(days: index));
            final isToday = _isSameDay(day, today);

            return Expanded(
              child: GestureDetector(
                onTap: () => context.go(AppRoutes.dayPath(day)),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isToday ? context.csd.surfaceAlt : null,
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('E').format(day),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isToday ? context.csd.onSurface : context.csd.onSurfaceDim,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isToday ? context.csd.onSurface : null,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${day.day}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: isToday ? context.csd.surface : context.csd.onSurface,
                            fontWeight:
                                isToday ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWeekGrid(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();

    return SingleChildScrollView(
      controller: _verticalScrollController,
      child: Stack(
        children: [
          // Grid background
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time labels
              SizedBox(
                width: 50,
                child: Column(
                  children: List.generate(
                    _endHour - _startHour,
                    (index) {
                      final hour = _startHour + index;
                      return SizedBox(
                        height: _hourHeight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8, top: 0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              _formatHour(hour),
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Day columns
              ...List.generate(7, (dayIndex) {
                final day = _weekStart.add(Duration(days: dayIndex));
                final isToday = _isSameDay(day, today);
                final dayKey = DateFormat('yyyy-MM-dd').format(day);
                final dayEvents = _eventsByDay[dayKey] ?? [];

                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isToday ? context.csd.surfaceAlt.withValues(alpha: 0.5) : null,
                      border: Border(
                        left: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Hour lines
                        Column(
                          children: List.generate(
                            _endHour - _startHour,
                            (hourIndex) => Container(
                              height: _hourHeight,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: theme.colorScheme.outlineVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Events
                        ...dayEvents.map((event) {
                          return _buildEventBlock(context, event);
                        }),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),

          // Current time indicator
          _buildCurrentTimeIndicator(context, today),
        ],
      ),
    );
  }

  Widget _buildEventBlock(BuildContext context, Map<String, dynamic> event) {
    final startMinutes =
        ((event['start_hour'] as int) - _startHour) * 60 + (event['start_minute'] as int);
    final endMinutes =
        ((event['end_hour'] as int) - _startHour) * 60 + (event['end_minute'] as int);
    final duration = endMinutes - startMinutes;

    final top = startMinutes * (_hourHeight / 60);
    final height = duration * (_hourHeight / 60);

    final priority = event['priority'] as int;
    final isLocked = event['is_locked'] as bool;

    return Positioned(
      top: top,
      left: 2,
      right: 2,
      height: height,
      child: GestureDetector(
        onTap: () => context.goToEvent(event['id']),
        child: Container(
          padding: const EdgeInsets.all(4),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: context.csd.surface,
            border: Border.all(color: context.csd.border),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.getPriorityColor(priority),
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (isLocked) ...[
                    const SizedBox(width: 2),
                    Icon(
                      Icons.lock,
                      size: 10,
                      color: context.csd.iconDefault,
                    ),
                  ],
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event['title'],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: context.csd.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTimeIndicator(BuildContext context, DateTime today) {
    // Check if current week contains today
    final weekEnd = _weekStart.add(const Duration(days: 6));
    if (today.isBefore(_weekStart) || today.isAfter(weekEnd)) {
      return const SizedBox.shrink();
    }

    final dayIndex = today.weekday - 1;
    final now = DateTime.now();
    final minutesSinceStart = (now.hour - _startHour) * 60 + now.minute;
    final top = minutesSinceStart * (_hourHeight / 60);

    return Positioned(
      top: top,
      left: 50 + (dayIndex * ((MediaQuery.of(context).size.width - 50) / 7)),
      width: (MediaQuery.of(context).size.width - 50) / 7,
      child: Container(
        height: 2,
        color: AppColors.error,
      ),
    );
  }

  void _goToWeek(DateTime date) {
    setState(() {
      _weekStart = _getWeekStart(date);
    });
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _weekStart,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      _goToWeek(picked);
    }
  }
}
