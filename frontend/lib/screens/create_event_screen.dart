/// ctrl^date - Create Event Screen
/// Form for creating new events
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../models/event.dart';
import '../providers/events_provider.dart';
import '../router.dart';
import '../theme.dart';
import '../widgets/conflict_warning.dart';

/// Create event screen with form
class CreateEventScreen extends ConsumerStatefulWidget {
  final DateTime? initialDate;

  const CreateEventScreen({
    super.key,
    this.initialDate,
  });

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  // Form state
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  bool _allDay = false;
  bool _isLocked = false;
  int _priority = 2;
  String? _recurrence;
  List<String> _tags = [];

  // Conflict detection
  bool _hasConflict = false;
  String? _conflictMessage;

  @override
  void initState() {
    super.initState();

    final initialDate = widget.initialDate ?? DateTime.now();
    _startDate = DateTime(initialDate.year, initialDate.month, initialDate.day);

    // Default to next hour
    final now = DateTime.now();
    _startTime = TimeOfDay(hour: now.hour + 1, minute: 0);
    _endTime = TimeOfDay(hour: now.hour + 2, minute: 0);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        title: const Text('New Event'),
        actions: [
          TextButton(
            onPressed: _saveEvent,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Event title',
              ),
              style: theme.textTheme.titleLarge,
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.lg),

            // Conflict warning
            if (_hasConflict)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: ConflictWarning(message: _conflictMessage),
              ),

            // All day toggle
            SwitchListTile(
              title: const Text('All day'),
              value: _allDay,
              onChanged: (value) => setState(() => _allDay = value),
              contentPadding: EdgeInsets.zero,
            ),

            const Divider(),

            // Date
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Date'),
              trailing: Text(
                DateFormat('EEE, MMM d, yyyy').format(_startDate),
                style: theme.textTheme.bodyLarge,
              ),
              onTap: _selectDate,
            ),

            // Time (if not all day)
            if (!_allDay) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.access_time),
                title: const Text('Start time'),
                trailing: Text(
                  _startTime.format(context),
                  style: theme.textTheme.bodyLarge,
                ),
                onTap: () => _selectTime(isStart: true),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const SizedBox(width: 24),
                title: const Text('End time'),
                trailing: Text(
                  _endTime.format(context),
                  style: theme.textTheme.bodyLarge,
                ),
                onTap: () => _selectTime(isStart: false),
              ),
            ],

            const Divider(),

            // Recurrence
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.repeat),
              title: const Text('Repeat'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _recurrence ?? 'Never',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: _selectRecurrence,
            ),

            const Divider(),

            // Location
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'Add location',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Add description',
                prefixIcon: Icon(Icons.notes),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),

            const SizedBox(height: AppSpacing.lg),

            // Priority
            Text('Priority', style: theme.textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _buildPriorityChip(1, 'Low', AppColors.priorityLow),
                const SizedBox(width: AppSpacing.sm),
                _buildPriorityChip(2, 'Med', AppColors.priorityMedium),
                const SizedBox(width: AppSpacing.sm),
                _buildPriorityChip(3, 'High', AppColors.priorityHigh),
                const SizedBox(width: AppSpacing.sm),
                _buildPriorityChip(4, 'Critical', AppColors.priorityCritical),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Lock toggle
            SwitchListTile(
              title: const Text('Lock event'),
              subtitle: Text(
                'Locked events cannot be moved by AI suggestions',
                style: theme.textTheme.bodySmall,
              ),
              value: _isLocked,
              onChanged: (value) => setState(() => _isLocked = value),
              contentPadding: EdgeInsets.zero,
              secondary: Icon(
                _isLocked ? Icons.lock : Icons.lock_open,
                color: _isLocked ? AppColors.black : AppColors.gray500,
              ),
            ),

            const Divider(),

            // Tags
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.label_outline),
              title: const Text('Tags'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _editTags,
            ),

            if (_tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: _tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () {
                        setState(() => _tags.remove(tag));
                      },
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 100), // Bottom padding for FAB
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (picked != null) {
      setState(() => _startDate = picked);
      _checkConflicts();
    }
  }

  Future<void> _selectTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
          // Auto-adjust end time if it's before start
          final startMinutes = picked.hour * 60 + picked.minute;
          final endMinutes = _endTime.hour * 60 + _endTime.minute;
          if (endMinutes <= startMinutes) {
            _endTime = TimeOfDay(
              hour: (picked.hour + 1) % 24,
              minute: picked.minute,
            );
          }
        } else {
          _endTime = picked;
        }
      });
      _checkConflicts();
    }
  }

  void _selectRecurrence() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.md),
            ListTile(
              title: const Text('Never'),
              trailing: _recurrence == null ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() => _recurrence = null);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Daily'),
              trailing: _recurrence == 'Daily' ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() => _recurrence = 'Daily');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Weekly'),
              trailing: _recurrence == 'Weekly' ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() => _recurrence = 'Weekly');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Monthly'),
              trailing: _recurrence == 'Monthly' ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() => _recurrence = 'Monthly');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Yearly'),
              trailing: _recurrence == 'Yearly' ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() => _recurrence = 'Yearly');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Custom...'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show custom recurrence dialog
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  void _editTags() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Tag'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter tag name',
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final tag = controller.text.trim();
              if (tag.isNotEmpty && !_tags.contains(tag)) {
                setState(() => _tags.add(tag));
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _checkConflicts() {
    // TODO: Implement actual conflict detection with API
    // For now, mock conflict detection
    setState(() {
      _hasConflict = false;
      _conflictMessage = null;
    });
  }

  Widget _buildPriorityChip(int value, String label, Color color) {
    final isSelected = _priority == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _priority = value),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.2) : AppColors.gray100,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: isSelected ? color : AppColors.gray300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
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
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? color : AppColors.gray700,
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

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Build event data
    final startDateTime = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _allDay ? 0 : _startTime.hour,
      _allDay ? 0 : _startTime.minute,
    );

    final endDateTime = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _allDay ? 23 : _endTime.hour,
      _allDay ? 59 : _endTime.minute,
    );

    // Map priority int to EventPriority enum
    final priority = switch (_priority) {
      1 => EventPriority.low,
      2 => EventPriority.medium,
      3 => EventPriority.high,
      4 => EventPriority.urgent,
      _ => EventPriority.medium,
    };

    // Create the Event object
    final event = Event(
      id: const Uuid().v4(),
      userId: '', // Will be set by the backend
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      startTime: startDateTime,
      endTime: endDateTime,
      isAllDay: _allDay,
      location: _locationController.text.trim().isNotEmpty
          ? _locationController.text.trim()
          : null,
      priority: priority,
      tags: _tags,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      // Save using events provider
      final eventActions = ref.read(eventActionsProvider);
      await eventActions.create(event);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created')),
        );

        // Navigate back to calendar
        context.go(AppRoutes.calendar);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create event: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
