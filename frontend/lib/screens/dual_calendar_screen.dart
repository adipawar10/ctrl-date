/// Ctrl+Shift+Date - Dual Calendar Screen
/// Side-by-side calendar comparison with a friend
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../theme.dart';
import '../providers/friends_provider.dart';
import '../providers/events_provider.dart';

/// Dual calendar screen for comparing your schedule with a friend's
class DualCalendarScreen extends ConsumerStatefulWidget {
  final String? friendUserId;

  const DualCalendarScreen({
    super.key,
    this.friendUserId,
  });

  @override
  ConsumerState<DualCalendarScreen> createState() =>
      _DualCalendarScreenState();
}

class _DualCalendarScreenState extends ConsumerState<DualCalendarScreen> {
  late DateTime _selectedDate;
  String? _selectedFriendId;
  final double _hourHeight = 50.0;
  final int _startHour = 7;
  final int _endHour = 21;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedFriendId = widget.friendUserId;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final friendsAsync = ref.watch(friendsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Calendars'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () =>
                setState(() => _selectedDate = DateTime.now()),
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
                bottom: BorderSide(
                    color: theme.colorScheme.outlineVariant),
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
                        final profile =
                            f.addressee ?? f.requester;
                        return DropdownMenuItem(
                          value: f.id,
                          child: Text(
                              profile?.displayName ?? 'Unknown'),
                        );
                      }).toList(),
                      onChanged: (id) =>
                          setState(() => _selectedFriendId = id),
                    ),
                    loading: () =>
                        const LinearProgressIndicator(),
                    error: (_, __) =>
                        const Text('Error loading friends'),
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
                  onPressed: () => setState(() => _selectedDate =
                      _selectedDate.subtract(const Duration(days: 1))),
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
                  onPressed: () => setState(() => _selectedDate =
                      _selectedDate.add(const Duration(days: 1))),
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
                : _buildDualTimeline(context),
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
                        DateFormat('ha')
                            .format(DateTime(2024, 1, 1, hour)),
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
            child: Column(
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
                      style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600)),
                ),
                ...List.generate(_endHour - _startHour, (i) {
                  return Container(
                    height: _hourHeight,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: context.csd.borderLight, width: 0.5),
                        right:
                            BorderSide(color: context.csd.borderLight, width: 0.5),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          // Friend's calendar column
          Expanded(
            child: Column(
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
                      style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600)),
                ),
                ...List.generate(_endHour - _startHour, (i) {
                  return Container(
                    height: _hourHeight,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: context.csd.borderLight, width: 0.5),
                      ),
                    ),
                  );
                }),
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
    if (picked != null) setState(() => _selectedDate = picked);
  }
}
