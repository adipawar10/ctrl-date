/// Ctrl+Shift+Date - Event Detail Screen
/// View and edit event details
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme.dart';
import '../providers/events_provider.dart';
import '../providers/friends_provider.dart';
import '../widgets/priority_indicator.dart';
import '../widgets/locked_badge.dart';
import '../widgets/conflict_warning.dart';

/// Event detail screen for viewing and editing events
class EventDetailScreen extends ConsumerStatefulWidget {
  final String eventId;

  const EventDetailScreen({
    super.key,
    required this.eventId,
  });

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  bool _isLoading = true;
  bool _isEditing = false;

  // Mock event data - replace with actual state management
  late Map<String, dynamic> _event;

  // Form controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock event data
    _event = {
      'id': widget.eventId,
      'title': 'Team Standup',
      'description': 'Daily sync with the engineering team',
      'location': 'Conference Room A / Zoom',
      'start_time': DateTime.now().copyWith(hour: 9, minute: 0),
      'end_time': DateTime.now().copyWith(hour: 9, minute: 30),
      'all_day': false,
      'is_locked': true,
      'priority': 3,
      'status': 'scheduled',
      'tags': ['work', 'meeting'],
      'recurrence': 'Daily (weekdays)',
      'completion_notes': null,
    };

    _titleController = TextEditingController(text: _event['title']);
    _descriptionController = TextEditingController(text: _event['description']);
    _locationController = TextEditingController(text: _event['location']);
    _notesController = TextEditingController(text: _event['completion_notes'] ?? '');

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: _isEditing ? const Text('Edit Event') : null,
        actions: [
          if (!_isEditing) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => setState(() => _isEditing = true),
              tooltip: 'Edit',
            ),
            PopupMenuButton<String>(
              onSelected: _handleMenuAction,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'duplicate',
                  child: ListTile(
                    leading: Icon(Icons.copy),
                    title: Text('Duplicate'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: ListTile(
                    leading: Icon(Icons.share),
                    title: Text('Share with friend'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'invite_link',
                  child: ListTile(
                    leading: Icon(Icons.link),
                    title: Text('Create invite link'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'toggle_privacy',
                  child: ListTile(
                    leading: Icon(
                      _event['is_private'] == true
                          ? Icons.lock_open
                          : Icons.lock_outline,
                    ),
                    title: Text(
                      _event['is_private'] == true
                          ? 'Make public'
                          : 'Make private',
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
                    title: Text(
                      'Delete',
                      style: TextStyle(
                        color: AppColors.error,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ] else ...[
            TextButton(
              onPressed: () => setState(() => _isEditing = false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: _saveEvent,
              child: const Text('Save'),
            ),
          ],
        ],
      ),
      body: _isEditing ? _buildEditForm(context) : _buildEventDetails(context),
      bottomNavigationBar:
          !_isEditing && _event['status'] == 'scheduled' ? _buildCompletionBar(context) : null,
    );
  }

  Widget _buildEventDetails(BuildContext context) {
    final theme = Theme.of(context);
    final startTime = _event['start_time'] as DateTime;
    final endTime = _event['end_time'] as DateTime;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  _event['title'],
                  style: theme.textTheme.displaySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (_event['is_locked']) const LockedBadge(),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Priority and status
          Row(
            children: [
              PriorityIndicator(
                priority: _event['priority'],
                showLabel: true,
              ),
              const SizedBox(width: AppSpacing.md),
              _buildStatusChip(context),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Date and time
          _buildDetailRow(
            context,
            icon: Icons.access_time,
            title: 'Time',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(startTime),
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.csd.onSurfaceDim,
                  ),
                ),
              ],
            ),
          ),

          // Recurrence
          if (_event['recurrence'] != null) ...[
            const SizedBox(height: AppSpacing.md),
            _buildDetailRow(
              context,
              icon: Icons.repeat,
              title: 'Repeats',
              content: Text(
                _event['recurrence'],
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ],

          // Location
          if (_event['location'] != null && _event['location'].isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _buildDetailRow(
              context,
              icon: Icons.location_on_outlined,
              title: 'Location',
              content: Text(
                _event['location'],
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ],

          // Description
          if (_event['description'] != null && _event['description'].isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _buildDetailRow(
              context,
              icon: Icons.notes,
              title: 'Description',
              content: Text(
                _event['description'],
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ],

          // Tags
          if (_event['tags'] != null && (_event['tags'] as List).isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _buildDetailRow(
              context,
              icon: Icons.label_outline,
              title: 'Tags',
              content: Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: (_event['tags'] as List<String>).map((tag) {
                  return Chip(
                    label: Text(tag),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ),
          ],

          // Completion notes
          if (_event['completion_notes'] != null) ...[
            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            _buildDetailRow(
              context,
              icon: Icons.check_circle_outline,
              title: 'Completion Notes',
              content: Text(
                _event['completion_notes'],
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: context.csd.iconDefault),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              content,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final status = _event['status'] as String;

    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'completed':
        color = AppColors.completed;
        label = 'Completed';
        icon = Icons.check_circle;
        break;
      case 'partial':
        color = AppColors.partial;
        label = 'Partial';
        icon = Icons.timelapse;
        break;
      case 'skipped':
        color = AppColors.skipped;
        label = 'Skipped';
        icon = Icons.skip_next;
        break;
      case 'cancelled':
        color = AppColors.cancelled;
        label = 'Cancelled';
        icon = Icons.cancel;
        break;
      default:
        color = AppColors.gray600;
        label = 'Scheduled';
        icon = Icons.schedule;
    }

    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide.none,
    );
  }

  Widget _buildEditForm(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'Event title',
            ),
            style: theme.textTheme.titleLarge,
            textCapitalization: TextCapitalization.sentences,
          ),

          const SizedBox(height: AppSpacing.md),

          // Description
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Add description',
            ),
            maxLines: 3,
          ),

          const SizedBox(height: AppSpacing.md),

          // Location
          TextField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Location',
              hintText: 'Add location',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Date and time pickers would go here
          // For now, showing placeholder
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(
              DateFormat('EEE, MMM d').format(_event['start_time']),
            ),
            subtitle: Text(
              '${DateFormat('HH:mm').format(_event['start_time'])} - ${DateFormat('HH:mm').format(_event['end_time'])}',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showDateTimePicker,
          ),

          const SizedBox(height: AppSpacing.md),

          // Priority selector
          Text('Priority', style: theme.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 1, label: Text('Low')),
              ButtonSegment(value: 2, label: Text('Medium')),
              ButtonSegment(value: 3, label: Text('High')),
              ButtonSegment(value: 4, label: Text('Critical')),
            ],
            selected: {_event['priority']},
            onSelectionChanged: (selection) {
              setState(() {
                _event['priority'] = selection.first;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionBar(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _markComplete('skipped'),
                icon: const Icon(Icons.skip_next),
                label: const Text('Skip'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _markComplete('partial'),
                icon: const Icon(Icons.timelapse),
                label: const Text('Partial'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () => _markComplete('completed'),
                icon: const Icon(Icons.check),
                label: const Text('Complete'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'duplicate':
        _duplicateEvent();
        break;
      case 'share':
        _shareEvent();
        break;
      case 'invite_link':
        _generateInviteLink();
        break;
      case 'toggle_privacy':
        _togglePrivacy();
        break;
      case 'delete':
        _deleteEvent();
        break;
    }
  }

  void _showDateTimePicker() {
    // TODO: Implement date/time picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Date/time picker coming soon')),
    );
  }

  void _saveEvent() {
    // TODO: Implement save
    setState(() {
      _event['title'] = _titleController.text;
      _event['description'] = _descriptionController.text;
      _event['location'] = _locationController.text;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event updated')),
    );
  }

  void _markComplete(String status) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mark as ${status.replaceFirst(status[0], status[0].toUpperCase())}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    hintText: 'Add any notes about this completion',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _event['status'] = status;
                        _event['completion_notes'] = _notesController.text.isEmpty
                            ? null
                            : _notesController.text;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Event marked as $status')),
                      );
                    },
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _generateInviteLink() async {
    try {
      final api = ref.read(apiServiceProvider);
      final response = await api.post(
        '/events/${widget.eventId}/invite-link',
        body: {'max_uses': 10},
      );

      if (!response.isSuccess || response.data == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.error?.message ?? 'Failed to generate invite link')),
          );
        }
        return;
      }

      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String?;
      if (token == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to generate invite link')),
          );
        }
        return;
      }

      final link = 'ctrlshiftdate://invite/$token';

      if (!mounted) return;
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
                  'Invite Link',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Share this link to invite others to this event:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.csd.onSurfaceDim,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: context.csd.surfaceAlt,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          link,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: link));
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Link copied to clipboard')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Revoke Link'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      try {
                        await api.delete(
                          '/events/${widget.eventId}/invite-link',
                        );
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invite link revoked')),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to revoke: $e')),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate link: $e')),
        );
      }
    }
  }

  void _togglePrivacy() async {
    final currentlyPrivate = _event['is_private'] == true;
    final newValue = !currentlyPrivate;

    try {
      final api = ref.read(apiServiceProvider);
      final response = await api.put(
        '/events/${widget.eventId}',
        body: {'is_private': newValue},
      );

      if (!response.isSuccess) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.error?.message ?? 'Failed to update privacy')),
          );
        }
        return;
      }

      setState(() {
        _event['is_private'] = newValue;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newValue ? 'Event is now private' : 'Event is now visible to friends',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update privacy: $e')),
        );
      }
    }
  }

  void _duplicateEvent() {
    // TODO: Implement duplicate
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event duplicated')),
    );
  }

  void _shareEvent() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ShareEventSheet(
        eventId: widget.eventId,
        eventTitle: _event['title'],
      ),
    );
  }

  void _deleteEvent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref
                    .read(eventActionsProvider)
                    .delete(widget.eventId);
                if (mounted) {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Event deleted')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete: $e')),
                  );
                }
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet for sharing an event with friends
class _ShareEventSheet extends ConsumerStatefulWidget {
  final String eventId;
  final String eventTitle;

  const _ShareEventSheet({
    required this.eventId,
    required this.eventTitle,
  });

  @override
  ConsumerState<_ShareEventSheet> createState() => _ShareEventSheetState();
}

class _ShareEventSheetState extends ConsumerState<_ShareEventSheet> {
  String _selectedPermission = 'view';
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final friendsAsync = ref.watch(friendsProvider);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share Event',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              widget.eventTitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.csd.onSurfaceDim,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Permission selector
            Text('Permission', style: theme.textTheme.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'view', label: Text('View')),
                ButtonSegment(value: 'edit', label: Text('Edit')),
                ButtonSegment(value: 'admin', label: Text('Admin')),
              ],
              selected: {_selectedPermission},
              onSelectionChanged: (selection) {
                setState(() => _selectedPermission = selection.first);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Share with', style: theme.textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            // Friends list
            friendsAsync.when(
              data: (friends) {
                if (friends.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Center(
                      child: Text('No friends yet. Add friends to share events.'),
                    ),
                  );
                }
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      final friend = friends[index];
                      final currentUserId =
                          Supabase.instance.client.auth.currentUser?.id ?? '';
                      final friendId = friend.getFriendId(currentUserId);
                      final profile = friend.getFriendProfile(currentUserId);
                      final displayName =
                          profile?.displayName ?? 'Unknown';

                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            displayName.isNotEmpty
                                ? displayName[0].toUpperCase()
                                : '?',
                          ),
                        ),
                        title: Text(displayName),
                        trailing: _isSending
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () => _shareWithFriend(
                                  friendId,
                                  displayName,
                                ),
                              ),
                      );
                    },
                  ),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error loading friends: $e')),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareWithFriend(String friendUserId, String name) async {
    setState(() => _isSending = true);

    try {
      final api = ref.read(apiServiceProvider);
      final response = await api.post(
        '/sharing/events/${widget.eventId}/share',
        body: {
          'user_id': friendUserId,
          'permission': _selectedPermission,
        },
      );

      if (mounted) {
        if (response.isSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Event shared with $name')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.error?.message ?? 'Failed to share event'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }
}
