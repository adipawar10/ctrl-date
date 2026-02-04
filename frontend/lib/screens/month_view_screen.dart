/// Ctrl+Shift+Date - Month View Screen
/// Month calendar grid
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../router.dart';
import '../theme.dart';
import '../widgets/calendar_day_cell.dart';

/// Month view screen showing full month grid
class MonthViewScreen extends StatefulWidget {
  final DateTime initialDate;

  const MonthViewScreen({
    super.key,
    required this.initialDate,
  });

  @override
  State<MonthViewScreen> createState() => _MonthViewScreenState();
}

class _MonthViewScreenState extends State<MonthViewScreen> {
  late DateTime _currentMonth;

  // Mock events - replace with actual state management
  final Map<String, List<Map<String, dynamic>>> _eventsByDay = {};

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
    _loadMockEvents();
  }

  void _loadMockEvents() {
    // Generate some mock events for the month
    final now = DateTime.now();

    // Events for today
    _eventsByDay[DateFormat('yyyy-MM-dd').format(now)] = [
      {'title': 'Standup', 'priority': 3, 'is_locked': true},
      {'title': 'Deep Work', 'priority': 4, 'is_locked': false},
      {'title': 'Meeting', 'priority': 4, 'is_locked': true},
    ];

    // Events for tomorrow
    final tomorrow = now.add(const Duration(days: 1));
    _eventsByDay[DateFormat('yyyy-MM-dd').format(tomorrow)] = [
      {'title': 'Planning', 'priority': 2, 'is_locked': false},
    ];

    // Events for next week
    final nextWeek = now.add(const Duration(days: 7));
    _eventsByDay[DateFormat('yyyy-MM-dd').format(nextWeek)] = [
      {'title': 'Review', 'priority': 3, 'is_locked': false},
      {'title': 'Demo', 'priority': 4, 'is_locked': true},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _showMonthPicker,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('MMMM yyyy').format(_currentMonth),
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
            tooltip: 'Go to this month',
            onPressed: () => _goToMonth(DateTime.now()),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_view_week),
            tooltip: 'Week view',
            onPressed: () => context.go(AppRoutes.week),
          ),
        ],
      ),
      body: Column(
        children: [
          // Month navigation
          _buildMonthNavigation(context),

          // Weekday headers
          _buildWeekdayHeaders(context),

          // Calendar grid
          Expanded(
            child: _buildCalendarGrid(context),
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

  Widget _buildMonthNavigation(BuildContext context) {
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
            onPressed: () => _goToMonth(
              DateTime(_currentMonth.year, _currentMonth.month - 1),
            ),
          ),
          Row(
            children: [
              _buildYearButton(context, -1),
              const SizedBox(width: AppSpacing.sm),
              Text(
                DateFormat('yyyy').format(_currentMonth),
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildYearButton(context, 1),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _goToMonth(
              DateTime(_currentMonth.year, _currentMonth.month + 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearButton(BuildContext context, int direction) {
    return IconButton(
      icon: Icon(
        direction < 0 ? Icons.keyboard_double_arrow_left : Icons.keyboard_double_arrow_right,
        size: 16,
      ),
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      padding: EdgeInsets.zero,
      onPressed: () => _goToMonth(
        DateTime(_currentMonth.year + direction, _currentMonth.month),
      ),
      tooltip: direction < 0 ? 'Previous year' : 'Next year',
    );
  }

  Widget _buildWeekdayHeaders(BuildContext context) {
    final theme = Theme.of(context);
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: weekdays.map((day) {
          final isWeekend = day == 'Sat' || day == 'Sun';
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isWeekend ? AppColors.gray500 : AppColors.gray700,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final days = _getCalendarDays();
    final today = DateTime.now();

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.sm),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        final isCurrentMonth = day.month == _currentMonth.month;
        final isToday = _isSameDay(day, today);
        final dayKey = DateFormat('yyyy-MM-dd').format(day);
        final events = _eventsByDay[dayKey] ?? [];

        return CalendarDayCell(
          date: day,
          isCurrentMonth: isCurrentMonth,
          isToday: isToday,
          isSelected: false,
          eventCount: events.length,
          hasLockedEvent: events.any((e) => e['is_locked'] == true),
          highestPriority:
              events.isEmpty ? null : _getHighestPriority(events),
          onTap: () => context.go(AppRoutes.dayPath(day)),
          onLongPress: () => context.goToCreateEvent(day),
        );
      },
    );
  }

  List<DateTime> _getCalendarDays() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

    // Get the Monday before or on the first day of the month
    var firstCalendarDay = firstDayOfMonth;
    while (firstCalendarDay.weekday != DateTime.monday) {
      firstCalendarDay = firstCalendarDay.subtract(const Duration(days: 1));
    }

    // Get the Sunday after or on the last day of the month
    var lastCalendarDay = lastDayOfMonth;
    while (lastCalendarDay.weekday != DateTime.sunday) {
      lastCalendarDay = lastCalendarDay.add(const Duration(days: 1));
    }

    // Generate all days
    final days = <DateTime>[];
    var currentDay = firstCalendarDay;
    while (!currentDay.isAfter(lastCalendarDay)) {
      days.add(currentDay);
      currentDay = currentDay.add(const Duration(days: 1));
    }

    return days;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  int _getHighestPriority(List<Map<String, dynamic>> events) {
    return events
        .map((e) => e['priority'] as int)
        .reduce((a, b) => a > b ? a : b);
  }

  void _goToMonth(DateTime date) {
    setState(() {
      _currentMonth = DateTime(date.year, date.month);
    });
  }

  Future<void> _showMonthPicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _currentMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null) {
      _goToMonth(picked);
    }
  }
}
