/// Ctrl+Shift+Date - Day View Screen
/// Single day calendar with hourly time slots
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../router.dart';
import '../theme.dart';
import '../widgets/time_slot_widget.dart';
import '../widgets/event_card.dart';

/// Day view screen showing hourly breakdown
class DayViewScreen extends StatefulWidget {
  final DateTime initialDate;

  const DayViewScreen({
    super.key,
    required this.initialDate,
  });

  @override
  State<DayViewScreen> createState() => _DayViewScreenState();
}

class _DayViewScreenState extends State<DayViewScreen> {
  late DateTime _selectedDate;
  late ScrollController _scrollController;
  final double _hourHeight = 60.0;
  final int _startHour = 6;
  final int _endHour = 22;

  // Mock data - replace with actual state management
  final List<Map<String, dynamic>> _events = [
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
      body: Column(
        children: [
          // Date navigation
          _buildDateNavigation(context),

          // Day timeline
          Expanded(
            child: _buildDayTimeline(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goToCreateEvent(_selectedDate),
        tooltip: 'Create Event',
        child: const Icon(Icons.add),
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

  Widget _buildDayTimeline(BuildContext context) {
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
          ..._buildEventOverlays(context),
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

  List<Widget> _buildEventOverlays(BuildContext context) {
    final overlays = <Widget>[];

    for (final event in _events) {
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
      );
    }

    return overlays;
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
