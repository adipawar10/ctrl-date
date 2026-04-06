/// Ctrl+Shift+Date - Poll Screen
/// Create and vote on polls for event planning
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../theme.dart';
import '../providers/events_provider.dart';
import '../providers/friends_provider.dart';

/// Poll creation and viewing screen
class PollScreen extends ConsumerStatefulWidget {
  final String? pollId;

  const PollScreen({super.key, this.pollId});

  @override
  ConsumerState<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends ConsumerState<PollScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _pollType = 'time';
  final List<_PollOptionData> _options = [];
  final Set<String> _invitedFriendIds = {};
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    // Add two default empty options
    _options.add(_PollOptionData());
    _options.add(_PollOptionData());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Poll'),
        actions: [
          TextButton(
            onPressed: _isCreating ? null : _createPoll,
            child: const Text('Create'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Poll title',
                hintText: 'e.g., When should we meet?',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: AppSpacing.md),

            // Description
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Add details about this poll',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Poll type
            Text('Poll type', style: theme.textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'time',
                  label: Text('Time'),
                  icon: Icon(Icons.schedule),
                ),
                ButtonSegment(
                  value: 'place',
                  label: Text('Place'),
                  icon: Icon(Icons.location_on),
                ),
              ],
              selected: {_pollType},
              onSelectionChanged: (s) =>
                  setState(() => _pollType = s.first),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Options', style: theme.textTheme.labelLarge),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () =>
                      setState(() => _options.add(_PollOptionData())),
                ),
              ],
            ),
            ...List.generate(_options.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Option ${i + 1}',
                          hintText: _pollType == 'time'
                              ? 'e.g., Monday 3pm'
                              : 'e.g., Coffee shop',
                          suffixIcon: _options.length > 2
                              ? IconButton(
                                  icon: const Icon(Icons.remove_circle,
                                      color: AppColors.error),
                                  onPressed: () =>
                                      setState(() => _options.removeAt(i)),
                                )
                              : null,
                        ),
                        onChanged: (v) => _options[i].label = v,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: AppSpacing.lg),

            // Invite friends
            Text('Invite friends', style: theme.textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            _buildFriendSelector(context),

            const SizedBox(height: AppSpacing.xl),

            // Create button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isCreating ? null : _createPoll,
                child: _isCreating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Poll'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendSelector(BuildContext context) {
    final friendsAsync = ref.watch(friendsProvider);

    return friendsAsync.when(
      data: (friends) {
        if (friends.isEmpty) {
          return const Text('No friends to invite');
        }
        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: friends.map((f) {
            final profile =
                f.addressee ?? f.requester;
            final name = profile?.displayName ?? 'Unknown';
            final isSelected = _invitedFriendIds.contains(f.id);

            return FilterChip(
              label: Text(name),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _invitedFriendIds.add(f.id);
                  } else {
                    _invitedFriendIds.remove(f.id);
                  }
                });
              },
            );
          }).toList(),
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (_, __) => const Text('Error loading friends'),
    );
  }

  Future<void> _createPoll() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    final validOptions =
        _options.where((o) => o.label.isNotEmpty).toList();
    if (validOptions.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please add at least 2 options')),
      );
      return;
    }

    setState(() => _isCreating = true);

    try {
      final api = ref.read(apiServiceProvider);
      await api.post('/polls/polls', body: {
        'title': _titleController.text,
        'description': _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        'poll_type': _pollType,
        'options': validOptions
            .map((o) => {'label': o.label})
            .toList(),
        'invited_user_ids': _invitedFriendIds.toList(),
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Poll created!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create poll: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }
}

class _PollOptionData {
  String label = '';
}
