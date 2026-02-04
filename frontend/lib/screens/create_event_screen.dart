/// Ctrl+Shift+Date - Create Event Screen
/// Form for creating new events
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../theme.dart';
import '../widgets/conflict_warning.dart';

/// Create event screen with form
class CreateEventScreen extends StatefulWidget {
  final DateTime? initialDate;

  const CreateEventScreen({
    super.key,
    this.initialDate,
  });

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
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
          onPressed: () => context.pop(),
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
            SegmentedButton<int>(
              segments: [
                ButtonSegment(
                  value: 1,
                  label: const Text('Low'),
                  icon: Icon(Icons.circle, size: 12, color: AppColors.priorityLow),
                ),
                ButtonSegment(
                  value: 2,
                  label: const Text('Medium'),
                  icon: Icon(Icons.circle, size: 12, color: AppColors.priorityMedium),
                ),
                ButtonSegment(
                  value: 3,
                  label: const Text('High'),
                  icon: Icon(Icons.circle, size: 12, color: AppColors.priorityHigh),
                ),
                ButtonSegment(
                  value: 4,
                  label: const Text('Critical'),
                  icon: Icon(Icons.circle, size: 12, color: AppColors.priorityCritical),
                ),
              ],
              selected: {_priority},
              onSelectionChanged: (selection) {
                setState(() => _priority = selection.first);
              },
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

  void _saveEvent() {
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

    final eventData = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'location': _locationController.text.trim(),
      'start_time': startDateTime.toIso8601String(),
      'end_time': endDateTime.toIso8601String(),
      'all_day': _allDay,
      'is_locked': _isLocked,
      'priority': _priority,
      'recurrence': _recurrence,
      'tags': _tags,
    };

    // TODO: Send to API
    debugPrint('Creating event: $eventData');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event created')),
    );

    context.pop();
  }
}
