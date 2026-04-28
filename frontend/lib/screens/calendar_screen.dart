/// Ctrl+Shift+Date - Unified Calendar Screen
/// Combines Day, Week, and Month views with interval switcher
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';
import '../providers/events_provider.dart';
import '../router.dart';
import '../providers/weather_location_provider.dart';
import '../services/weather_service.dart';
import '../theme.dart';
import '../utils/weather_icons.dart';

int _calendarPriorityInt(EventPriority p) {
  return switch (p) {
    EventPriority.low => 1,
    EventPriority.medium => 2,
    EventPriority.high => 3,
    EventPriority.urgent => 4,
  };
}

/// Maps an [Event] into the structure used by embedded day/week painters.
Map<String, dynamic> _eventToTimedOverlayMap(
  Event e, {
  required int visibleStartHour,
  required int visibleEndHour,
}) {
  if (e.isAllDay) {
    return <String, dynamic>{
      'id': e.id,
      'title': e.title,
      'start_hour': visibleStartHour,
      'start_minute': 0,
      'end_hour': visibleEndHour,
      'end_minute': 0,
      'is_locked': false,
      'priority': _calendarPriorityInt(e.priority),
    };
  }
  return <String, dynamic>{
    'id': e.id,
    'title': e.title,
    'start_hour': e.startTime.hour,
    'start_minute': e.startTime.minute,
    'end_hour': e.endTime.hour,
    'end_minute': e.endTime.minute,
    'is_locked': false,
    'priority': _calendarPriorityInt(e.priority),
  };
}

Map<String, dynamic> _eventToMonthDotMap(Event e) {
  return <String, dynamic>{
    'title': e.title,
    'is_locked': false,
    'priority': _calendarPriorityInt(e.priority),
  };
}

List<Event> _eventsStartingOnDay(List<Event> all, DateTime day) {
  return all
      .where(
        (e) =>
            e.startTime.year == day.year &&
            e.startTime.month == day.month &&
            e.startTime.day == day.day,
      )
      .toList();
}

Map<String, List<Map<String, dynamic>>> _groupMonthDotsByDayKey(
  List<Event> all,
) {
  final map = <String, List<Map<String, dynamic>>>{};
  for (final e in all) {
    final key = DateFormat('yyyy-MM-dd').format(e.startTime);
    map.putIfAbsent(key, () => []).add(_eventToMonthDotMap(e));
  }
  return map;
}

/// Day/week timeline: rows for each hour from midnight through 11 PM (0–23).
/// [kCalendarVisibleEndHour] is exclusive (24), matching [List.generate] length.
const int kCalendarVisibleStartHour = 0;
const int kCalendarVisibleEndHour = 24;

/// Calendar interval options
enum CalendarInterval { day, week, month }

/// Unified calendar screen with interval switching
class CalendarScreen extends StatefulWidget {
  final DateTime? initialDate;
  final CalendarInterval? initialInterval;

  const CalendarScreen({
    super.key,
    this.initialDate,
    this.initialInterval,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;
  late CalendarInterval _selectedInterval;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _selectedInterval = widget.initialInterval ?? CalendarInterval.week;
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
              // Logo matching auth screen
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: context.csd.surfaceAlt,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_month,
                  size: 20,
                  color: context.csd.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'ctrl^date',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
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
            onPressed: _goToToday,
          ),
        ],
      ),
      body: Column(
        children: [
          // Interval switcher and navigation
          _buildIntervalSwitcher(context),

          // Navigation arrows
          _buildNavigation(context),

          // Calendar view
          Expanded(
            child: _buildCalendarView(),
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

  Widget _buildIntervalSwitcher(BuildContext context) {
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
      child: Center(
        child: SegmentedButton<CalendarInterval>(
          segments: const [
            ButtonSegment<CalendarInterval>(
              value: CalendarInterval.day,
              label: Text('Day'),
              icon: Icon(Icons.calendar_view_day, size: 18),
            ),
            ButtonSegment<CalendarInterval>(
              value: CalendarInterval.week,
              label: Text('Week'),
              icon: Icon(Icons.calendar_view_week, size: 18),
            ),
            ButtonSegment<CalendarInterval>(
              value: CalendarInterval.month,
              label: Text('Month'),
              icon: Icon(Icons.calendar_view_month, size: 18),
            ),
          ],
          selected: {_selectedInterval},
          onSelectionChanged: (Set<CalendarInterval> newSelection) {
            setState(() {
              _selectedInterval = newSelection.first;
            });
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return context.csd.onSurface;
              }
              return context.csd.surface;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return context.csd.surface;
              }
              return context.csd.onSurface;
            }),
            side: WidgetStateProperty.all(
              BorderSide(color: context.csd.border),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigation(BuildContext context) {
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
            onPressed: _navigatePrevious,
            tooltip: _getPreviousTooltip(),
          ),
          Expanded(
            child: Center(
              child: Text(
                _getNavigationTitle(),
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _navigateNext,
            tooltip: _getNextTooltip(),
          ),
        ],
      ),
    );
  }

  String _getNavigationTitle() {
    switch (_selectedInterval) {
      case CalendarInterval.day:
        final isToday = _isSameDay(_selectedDate, DateTime.now());
        if (isToday) {
          return 'Today, ${DateFormat('MMMM d, yyyy').format(_selectedDate)}';
        }
        return DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate);
      case CalendarInterval.week:
        final weekStart = _getWeekStart(_selectedDate);
        final weekEnd = weekStart.add(const Duration(days: 6));
        final startMonth = DateFormat('MMM').format(weekStart);
        final endMonth = DateFormat('MMM').format(weekEnd);
        if (startMonth == endMonth) {
          return '$startMonth ${weekStart.day} - ${weekEnd.day}, ${weekStart.year}';
        }
        return '$startMonth ${weekStart.day} - $endMonth ${weekEnd.day}, ${weekStart.year}';
      case CalendarInterval.month:
        return DateFormat('MMMM yyyy').format(_selectedDate);
    }
  }

  String _getPreviousTooltip() {
    switch (_selectedInterval) {
      case CalendarInterval.day:
        return 'Previous day';
      case CalendarInterval.week:
        return 'Previous week';
      case CalendarInterval.month:
        return 'Previous month';
    }
  }

  String _getNextTooltip() {
    switch (_selectedInterval) {
      case CalendarInterval.day:
        return 'Next day';
      case CalendarInterval.week:
        return 'Next week';
      case CalendarInterval.month:
        return 'Next month';
    }
  }

  void _navigatePrevious() {
    setState(() {
      switch (_selectedInterval) {
        case CalendarInterval.day:
          _selectedDate = _selectedDate.subtract(const Duration(days: 1));
          break;
        case CalendarInterval.week:
          _selectedDate = _selectedDate.subtract(const Duration(days: 7));
          break;
        case CalendarInterval.month:
          _selectedDate = DateTime(
            _selectedDate.year,
            _selectedDate.month - 1,
            _selectedDate.day,
          );
          break;
      }
    });
  }

  void _navigateNext() {
    setState(() {
      switch (_selectedInterval) {
        case CalendarInterval.day:
          _selectedDate = _selectedDate.add(const Duration(days: 1));
          break;
        case CalendarInterval.week:
          _selectedDate = _selectedDate.add(const Duration(days: 7));
          break;
        case CalendarInterval.month:
          _selectedDate = DateTime(
            _selectedDate.year,
            _selectedDate.month + 1,
            _selectedDate.day,
          );
          break;
      }
    });
  }

  Widget _buildCalendarView() {
    // Use a key based on interval and date to force rebuild when switching
    final key = ValueKey(
        '${_selectedInterval.name}_${_selectedDate.toIso8601String()}');

    switch (_selectedInterval) {
      case CalendarInterval.day:
        return _EmbeddedDayView(
          key: key,
          date: _selectedDate,
          onDateChanged: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        );
      case CalendarInterval.week:
        return _EmbeddedWeekView(
          key: key,
          date: _selectedDate,
          onDateChanged: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        );
      case CalendarInterval.month:
        return _EmbeddedMonthView(
          key: key,
          date: _selectedDate,
          onDateChanged: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        );
    }
  }

  void _goToToday() {
    setState(() {
      _selectedDate = DateTime.now();
    });
  }

  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}

/// Embedded Day View without its own AppBar
class _EmbeddedDayView extends ConsumerStatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onDateChanged;

  const _EmbeddedDayView({
    super.key,
    required this.date,
    required this.onDateChanged,
  });

  @override
  ConsumerState<_EmbeddedDayView> createState() => _EmbeddedDayViewState();
}

class _EmbeddedDayViewState extends ConsumerState<_EmbeddedDayView> {
  late ScrollController _scrollController;
  final double _hourHeight = 60.0;
  final int _startHour = kCalendarVisibleStartHour;
  final int _endHour = kCalendarVisibleEndHour;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

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
    if (_isSameDay(widget.date, now)) {
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
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsProvider);
    final dayEvents = eventsAsync.maybeWhen(
      data: (all) => _eventsStartingOnDay(all, widget.date),
      orElse: () => <Event>[],
    );
    final overlayMaps = dayEvents
        .map(
          (e) => _eventToTimedOverlayMap(
            e,
            visibleStartHour: _startHour,
            visibleEndHour: _endHour,
          ),
        )
        .toList();

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
                return _buildTimeSlot(context, hour);
              },
            ),
          ),

          // Current time indicator
          if (_isSameDay(widget.date, DateTime.now()))
            _buildCurrentTimeIndicator(context),

          // Events overlay
          ..._buildEventOverlays(context, overlayMaps),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(BuildContext context, int hour) {
    final theme = Theme.of(context);

    return Container(
      height: _hourHeight,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
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
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _createEventAtHour(hour),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                ),
              ),
            ),
          ),
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
              DateFormat('h:mm a').format(now),
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

  List<Widget> _buildEventOverlays(
    BuildContext context,
    List<Map<String, dynamic>> events,
  ) {
    final overlays = <Widget>[];

    for (final event in events) {
      final startMinutes = ((event['start_hour'] as int) - _startHour) * 60 +
          (event['start_minute'] as int);
      final endMinutes = ((event['end_hour'] as int) - _startHour) * 60 +
          (event['end_minute'] as int);
      final duration = endMinutes - startMinutes;

      final top = startMinutes * (_hourHeight / 60);
      final height = duration * (_hourHeight / 60);

      final priority = event['priority'] as int;
      final isLocked = event['is_locked'] as bool;

      // Adjust padding based on height to prevent overflow
      final padding = height < 24 ? 2.0 : (height < 40 ? 4.0 : 8.0);

      overlays.add(
        Positioned(
          top: top,
          left: 64,
          right: 8,
          height: height,
          child: GestureDetector(
            onTap: () => context.goToEvent(event['id']),
            child: Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: context.csd.surface,
                border: Border.all(color: context.csd.border),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ClipRect(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.getPriorityColor(priority),
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (isLocked) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.lock,
                            size: 12,
                            color: context.csd.iconDefault,
                          ),
                        ],
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event['title'],
                            style: TextStyle(
                              fontSize: height < 24 ? 10 : 12,
                              fontWeight: FontWeight.w500,
                              color: context.csd.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (height > 40) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${_formatHour(event['start_hour'] as int)} - ${_formatHour(event['end_hour'] as int)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: context.csd.onSurfaceDim,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return overlays;
  }

  void _createEventAtHour(int hour) {
    final startTime = DateTime(
      widget.date.year,
      widget.date.month,
      widget.date.day,
      hour,
    );
    context.goToCreateEvent(startTime);
  }
}

/// Embedded Week View without its own AppBar
class _EmbeddedWeekView extends ConsumerStatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onDateChanged;

  const _EmbeddedWeekView({
    super.key,
    required this.date,
    required this.onDateChanged,
  });

  @override
  ConsumerState<_EmbeddedWeekView> createState() => _EmbeddedWeekViewState();
}

class _EmbeddedWeekViewState extends ConsumerState<_EmbeddedWeekView> {
  late DateTime _weekStart;
  late Future<List<DayWeather>> _weekWeatherFuture;
  int? _weatherKey;
  late ScrollController _verticalScrollController;
  final double _hourHeight = 50.0;
  final int _startHour = kCalendarVisibleStartHour;
  final int _endHour = kCalendarVisibleEndHour;

  bool _calendarWeekChanged(DateTime a, DateTime b) {
    final wa = _getWeekStart(a);
    final wb = _getWeekStart(b);
    return wa.year != wb.year || wa.month != wb.month || wa.day != wb.day;
  }

  @override
  void initState() {
    super.initState();
    _weekStart = _getWeekStart(widget.date);
    final start = DateTime(_weekStart.year, _weekStart.month, _weekStart.day);
    _weekWeatherFuture = WeatherService.instance.getForecastForDateRange(
      start: start,
      end: start.add(const Duration(days: 6)),
    );
    _verticalScrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentTime();
    });
  }

  @override
  void didUpdateWidget(_EmbeddedWeekView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.date.year != widget.date.year ||
        oldWidget.date.month != widget.date.month ||
        oldWidget.date.day != widget.date.day) {
      final nextWeekStart = _getWeekStart(widget.date);
      final weekChanged = _calendarWeekChanged(oldWidget.date, widget.date);
      setState(() {
        _weekStart = nextWeekStart;
        if (weekChanged) {
          _weatherKey = null;
        }
      });
    }
  }

  Map<String, List<Map<String, dynamic>>> _buildEventsByDay(
    List<Event> all,
  ) {
    final out = <String, List<Map<String, dynamic>>>{};
    for (var i = 0; i < 7; i++) {
      final day = _weekStart.add(Duration(days: i));
      final key = DateFormat('yyyy-MM-dd').format(day);
      final maps = _eventsStartingOnDay(all, day)
          .map(
            (e) => _eventToTimedOverlayMap(
              e,
              visibleStartHour: _startHour,
              visibleEndHour: _endHour,
            ),
          )
          .toList();
      if (maps.isNotEmpty) {
        out[key] = maps;
      }
    }
    return out;
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    super.dispose();
  }

  DateTime _getWeekStart(DateTime date) {
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
  Widget build(BuildContext context) {
    final loc = ref.watch(weatherLocationProvider);
    final weekStartDay =
        DateTime(_weekStart.year, _weekStart.month, _weekStart.day);
    final weekEndDay = weekStartDay.add(const Duration(days: 6));
    final weatherKey = Object.hash(
      weekStartDay.year,
      weekStartDay.month,
      weekStartDay.day,
      (loc.latitude * 10000).round(),
      (loc.longitude * 10000).round(),
    );
    if (_weatherKey != weatherKey) {
      _weatherKey = weatherKey;
      _weekWeatherFuture = WeatherService.instance.getForecastForDateRange(
        start: weekStartDay,
        end: weekEndDay,
        latitude: loc.latitude,
        longitude: loc.longitude,
      );
    }

    final eventsAsync = ref.watch(eventsProvider);
    final all = eventsAsync.valueOrNull ?? <Event>[];
    final eventsByDay = _buildEventsByDay(all);

    return Column(
      children: [
        // Day headers
        _buildDayHeaders(context),

        // Week grid
        Expanded(
          child: _buildWeekGrid(context, eventsByDay),
        ),
      ],
    );
  }

  Widget _buildDayHeaders(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();

    return FutureBuilder<List<DayWeather>>(
      future: _weekWeatherFuture,
      builder: (context, snapshot) {
        final byDate = <String, DayWeather>{};
        if (snapshot.hasData) {
          for (final w in snapshot.data!) {
            byDate[DateFormat('yyyy-MM-dd').format(w.date)] = w;
          }
        }
        final loading = snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading)
              LinearProgressIndicator(
                minHeight: 2,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: theme.colorScheme.outline,
              ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 50),
                  ...List.generate(7, (index) {
                    final day = _weekStart.add(Duration(days: index));
                    final dayKey = DateFormat('yyyy-MM-dd').format(day);
                    final w = byDate[dayKey];
                    final isToday = _isSameDay(day, today);

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => widget.onDateChanged(day),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: isToday ? context.csd.surfaceAlt : null,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 34,
                                child: Center(
                                  child: loading
                                      ? const SizedBox.shrink()
                                      : w != null
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  w.weatherIconData,
                                                  size: 16,
                                                  color: isToday
                                                      ? context.csd.onSurface
                                                      : context
                                                          .csd.onSurfaceDim,
                                                ),
                                                Text(
                                                  w.tempRange,
                                                  style: theme
                                                      .textTheme.labelSmall
                                                      ?.copyWith(
                                                    fontSize: 9,
                                                    height: 1.1,
                                                    color: isToday
                                                        ? context.csd.onSurface
                                                        : context
                                                            .csd.onSurfaceDim,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Text(
                                              '—',
                                              style: theme.textTheme.labelSmall
                                                  ?.copyWith(
                                                color: context.csd.onSurfaceDim,
                                              ),
                                            ),
                                ),
                              ),
                              Text(
                                DateFormat('E').format(day),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: isToday
                                      ? context.csd.onSurface
                                      : context.csd.onSurfaceDim,
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
                                    color: isToday
                                        ? context.csd.surface
                                        : context.csd.onSurface,
                                    fontWeight: isToday
                                        ? FontWeight.w700
                                        : FontWeight.w500,
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
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeekGrid(
    BuildContext context,
    Map<String, List<Map<String, dynamic>>> eventsByDay,
  ) {
    final theme = Theme.of(context);
    final today = DateTime.now();

    return SingleChildScrollView(
      controller: _verticalScrollController,
      child: Stack(
        children: [
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
                final dayEvents = eventsByDay[dayKey] ?? [];

                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isToday
                          ? context.csd.surfaceAlt.withValues(alpha: 0.5)
                          : null,
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
    final startMinutes = ((event['start_hour'] as int) - _startHour) * 60 +
        (event['start_minute'] as int);
    final endMinutes = ((event['end_hour'] as int) - _startHour) * 60 +
        (event['end_minute'] as int);
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
}

/// Embedded Month View without its own AppBar
class _EmbeddedMonthView extends ConsumerStatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onDateChanged;

  const _EmbeddedMonthView({
    super.key,
    required this.date,
    required this.onDateChanged,
  });

  @override
  ConsumerState<_EmbeddedMonthView> createState() => _EmbeddedMonthViewState();
}

class _EmbeddedMonthViewState extends ConsumerState<_EmbeddedMonthView> {
  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsProvider);
    final eventsByDay = eventsAsync.maybeWhen(
      data: _groupMonthDotsByDayKey,
      orElse: () => <String, List<Map<String, dynamic>>>{},
    );

    return Column(
      children: [
        // Weekday headers
        _buildWeekdayHeaders(context),

        // Calendar grid
        Expanded(
          child: _buildCalendarGrid(context, eventsByDay),
        ),
      ],
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
                  color: isWeekend
                      ? context.csd.onSurfaceDim
                      : context.csd.iconDefault,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid(
    BuildContext context,
    Map<String, List<Map<String, dynamic>>> eventsByDay,
  ) {
    final days = _getCalendarDays();
    final today = DateTime.now();
    final currentMonth = DateTime(widget.date.year, widget.date.month);

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
        final isCurrentMonth = day.month == currentMonth.month;
        final isToday = _isSameDay(day, today);
        final dayKey = DateFormat('yyyy-MM-dd').format(day);
        final events = eventsByDay[dayKey] ?? [];

        return _buildDayCell(
          context,
          day: day,
          isCurrentMonth: isCurrentMonth,
          isToday: isToday,
          events: events,
        );
      },
    );
  }

  Widget _buildDayCell(
    BuildContext context, {
    required DateTime day,
    required bool isCurrentMonth,
    required bool isToday,
    required List<Map<String, dynamic>> events,
  }) {
    final theme = Theme.of(context);
    final hasLockedEvent = events.any((e) => e['is_locked'] == true);
    final highestPriority = events.isEmpty ? null : _getHighestPriority(events);

    return GestureDetector(
      onTap: () => widget.onDateChanged(day),
      onLongPress: () => context.goToCreateEvent(day),
      child: Container(
        decoration: BoxDecoration(
          color: isToday ? context.csd.surfaceAlt : null,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  color: isToday
                      ? context.csd.surface
                      : isCurrentMonth
                          ? context.csd.onSurface
                          : context.csd.onSurfaceAlt,
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (events.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (hasLockedEvent)
                    Icon(
                      Icons.lock,
                      size: 8,
                      color: context.csd.iconDefault,
                    ),
                  const SizedBox(width: 2),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: highestPriority != null
                          ? AppColors.getPriorityColor(highestPriority)
                          : context.csd.onSurfaceAlt,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (events.length > 1) ...[
                    const SizedBox(width: 2),
                    Text(
                      '+${events.length - 1}',
                      style: TextStyle(
                        fontSize: 8,
                        color: context.csd.onSurfaceDim,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<DateTime> _getCalendarDays() {
    final currentMonth = DateTime(widget.date.year, widget.date.month);
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0);

    var firstCalendarDay = firstDayOfMonth;
    while (firstCalendarDay.weekday != DateTime.monday) {
      firstCalendarDay = firstCalendarDay.subtract(const Duration(days: 1));
    }

    var lastCalendarDay = lastDayOfMonth;
    while (lastCalendarDay.weekday != DateTime.sunday) {
      lastCalendarDay = lastCalendarDay.add(const Duration(days: 1));
    }

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
}
