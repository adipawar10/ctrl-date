/// Ctrl+Shift+Date - Dual Calendar Screen
/// Side-by-side calendar comparison with a friend
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../router.dart';
import '../theme.dart';
import '../providers/friends_provider.dart';
import '../providers/events_provider.dart' show apiServiceProvider;

/// Dual calendar screen for comparing your schedule with a friend's
class DualCalendarScreen extends ConsumerStatefulWidget {
  final String? friendUserId;
  final DateTime? initialDate;

  const DualCalendarScreen({
    super.key,
    this.friendUserId,
    this.initialDate,
  });

  @override
  ConsumerState<DualCalendarScreen> createState() => _DualCalendarScreenState();
}

class _DualCalendarScreenState extends ConsumerState<DualCalendarScreen> {
  late DateTime _selectedDate;
  String? _selectedFriendId;
  final double _hourHeight = 50.0;
  final int _startHour = 0;
  final int _endHour = 24;
  bool _isLoading = false;
  List<_CalendarEvent> _myEvents = const [];
  List<_CalendarEvent> _friendEvents = const [];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _selectedFriendId = widget.friendUserId;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDayEvents());
  }

  Future<void> _loadDayEvents() async {
    final friendId = _selectedFriendId;
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    if (friendId == null || friendId.isEmpty) {
      if (mounted) {
        setState(() {
          _myEvents = const [];
          _friendEvents = const [];
        });
      }
      return;
    }

    setState(() => _isLoading = true);
    try {
      final start = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );
      final end = start.add(const Duration(days: 1));
      final api = ref.read(apiServiceProvider);
      final myResponse = await api.get<Map<String, dynamic>>(
        '/events',
        queryParams: {
          'start': start.toIso8601String(),
          'end': end.toIso8601String(),
          'include_shared': 'true',
          'include_recurring': 'true',
        },
      );
      final friendResponse = await api.get<Map<String, dynamic>>(
        '/friends/calendar/$friendId',
        queryParams: {
          'start': start.toIso8601String(),
          'end': end.toIso8601String(),
        },
      );

      if (!myResponse.isSuccess || myResponse.data == null) {
        if (mounted) {
          setState(() {
            _myEvents = const [];
            _friendEvents = const [];
          });
        }
        return;
      }

      final myRaw = (myResponse.data!['events'] as List?) ?? const [];
      final parsedMine = myRaw
          .whereType<Map<String, dynamic>>()
          .map(_CalendarEvent.fromApi)
          .where((e) =>
              !_isBeforeDay(e.startTime, start) &&
              _isBeforeDay(e.startTime, end))
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));

      final friendRaw = (friendResponse.data?['events'] as List?) ?? const [];
      final parsedFriend = friendRaw
          .whereType<Map<String, dynamic>>()
          .map(_CalendarEvent.fromApi)
          .where((e) =>
              !_isBeforeDay(e.startTime, start) &&
              _isBeforeDay(e.startTime, end))
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));

      if (mounted) {
        setState(() {
          _myEvents = parsedMine.where((e) => e.ownerId == userId).toList();
          _friendEvents = parsedFriend;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _isBeforeDay(DateTime value, DateTime boundary) {
    return value.isBefore(boundary);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final friendsAsync = ref.watch(friendsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Calendars'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Calendar',
          onPressed: () => context.go(AppRoutes.calendar),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () => setState(() => _selectedDate = DateTime.now()),
          ),
        ],
      ),
      body: Column(
        children: [
          // Friend selector
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            child: Row(
              children: [
                Text('Compare with: ', style: theme.textTheme.bodyMedium),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: friendsAsync.when(
                    data: (friends) => DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedFriendId,
                      hint: const Text('Select a friend'),
                      items: friends.map((f) {
                        final currentUserId =
                            Supabase.instance.client.auth.currentUser?.id ?? '';
                        final profile = f.getFriendProfile(currentUserId);
                        final friendId = f.getFriendId(currentUserId);
                        return DropdownMenuItem(
                          value: friendId,
                          child: Text(profile?.displayName ?? 'Unknown'),
                        );
                      }).toList(),
                      onChanged: (id) {
                        setState(() => _selectedFriendId = id);
                        _loadDayEvents();
                      },
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const Text('Error loading friends'),
                  ),
                ),
              ],
            ),
          ),
          // Date navigation
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() => _selectedDate =
                        _selectedDate.subtract(const Duration(days: 1)));
                    _loadDayEvents();
                  },
                ),
                GestureDetector(
                  onTap: _pickDate,
                  child: Text(
                    DateFormat('EEE, MMM d').format(_selectedDate),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() => _selectedDate =
                        _selectedDate.add(const Duration(days: 1)));
                    _loadDayEvents();
                  },
                ),
              ],
            ),
          ),
          // Dual timeline
          Expanded(
            child: _selectedFriendId == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline,
                            size: 64, color: context.csd.border),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Select a friend to compare calendars',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: context.csd.onSurfaceDim,
                          ),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      _buildDualTimeline(context),
                      if (_isLoading)
                        const LinearProgressIndicator(minHeight: 2),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDualTimeline(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time labels
          SizedBox(
            width: 50,
            child: Column(
              children: List.generate(_endHour - _startHour, (i) {
                final hour = _startHour + i;
                return SizedBox(
                  height: _hourHeight,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4, top: 2),
                      child: Text(
                        DateFormat('ha').format(DateTime(2024, 1, 1, hour)),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: context.csd.onSurfaceDim,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Your calendar column
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.csd.surfaceAlt,
                        border: Border.all(color: context.csd.borderLight),
                      ),
                      child: Text('You',
                          style: theme.textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ),
                    ...List.generate(_endHour - _startHour, (i) {
                      return Container(
                        height: _hourHeight,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: context.csd.borderLight, width: 0.5),
                            right: BorderSide(
                                color: context.csd.borderLight, width: 0.5),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                ..._myEvents.map((e) => _buildEventChip(context, e)),
              ],
            ),
          ),
          // Friend's calendar column
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.csd.surfaceAlt,
                        border: Border.all(color: context.csd.borderLight),
                      ),
                      child: Text('Friend',
                          style: theme.textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ),
                    ...List.generate(_endHour - _startHour, (i) {
                      return Container(
                        height: _hourHeight,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: context.csd.borderLight, width: 0.5),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                ..._friendEvents.map((e) => _buildEventChip(context, e)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      _loadDayEvents();
    }
  }

  Widget _buildEventChip(BuildContext context, _CalendarEvent event) {
    final startMinutes =
        ((event.startTime.hour - _startHour) * 60) + event.startTime.minute;
    final durationMinutes =
        event.endTime.difference(event.startTime).inMinutes.clamp(30, 24 * 60);
    final top = 28 + (startMinutes * (_hourHeight / 60));
    final height = durationMinutes * (_hourHeight / 60);

    return Positioned(
      top: top.toDouble(),
      left: 4,
      right: 4,
      height: height.toDouble(),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: context.csd.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: context.csd.border),
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            event.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ),
    );
  }
}

class _CalendarEvent {
  final String title;
  final String ownerId;
  final DateTime startTime;
  final DateTime endTime;

  _CalendarEvent({
    required this.title,
    required this.ownerId,
    required this.startTime,
    required this.endTime,
  });

  factory _CalendarEvent.fromApi(Map<String, dynamic> json) {
    final startRaw = (json['start_time'] ?? json['startTime']).toString();
    final endRaw = (json['end_time'] ?? json['endTime']).toString();
    return _CalendarEvent(
      title: (json['title'] ?? 'Untitled').toString(),
      ownerId: (json['owner_id'] ?? json['user_id'] ?? '').toString(),
      startTime: DateTime.parse(startRaw).toLocal(),
      endTime: DateTime.parse(endRaw).toLocal(),
    );
  }
}
