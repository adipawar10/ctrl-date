/// ctrl^date - Settings Screen
/// User preferences and app settings
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';
import '../providers/auth_provider.dart';
import '../router.dart';
import '../theme.dart';

/// Settings screen for user preferences
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Mock settings - replace with actual state management
  String _timezone = 'America/New_York';
  String _weekStart = 'monday';
  int _defaultDuration = 60;
  String _workingHoursStart = '09:00';
  String _workingHoursEnd = '17:00';
  int _notificationLeadTime = 15;
  bool _notificationsEnabled = true;
  bool _aiSuggestionsEnabled = true;
  double _streakThreshold = 0.8;
  String _defaultCalendarView = 'day';
  bool _eventRemindersEnabled = true;
  bool _reflectionReminderEnabled = true;

  // Priority colors
  Color _priorityLowColor = AppColors.priorityLow;
  Color _priorityMediumColor = AppColors.priorityMedium;
  Color _priorityHighColor = AppColors.priorityHigh;
  Color _priorityCriticalColor = AppColors.priorityCritical;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Profile section
          _buildSectionHeader(context, 'Profile'),
          Consumer(
            builder: (context, ref, child) {
              final currentUser = ref.watch(currentUserProvider);
              return currentUser.when(
                data: (user) {
                  if (user == null) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: context.csd.avatarBg,
                        child: Icon(Icons.person, color: context.csd.onSurface),
                      ),
                      title: const Text('Not signed in'),
                      subtitle: const Text('Tap to sign in'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go(AppRoutes.auth),
                    );
                  }
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: context.csd.avatarBg,
                      backgroundImage: user.avatarUrl != null
                          ? NetworkImage(user.avatarUrl!)
                          : null,
                      child: user.avatarUrl == null
                          ? Icon(Icons.person, color: context.csd.onSurface)
                          : null,
                    ),
                    title: Text(user.displayName ?? user.email),
                    subtitle: Text(user.email),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _editProfile,
                  );
                },
                loading: () => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: context.csd.avatarBg,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                  title: const Text('Loading...'),
                ),
                error: (_, __) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: context.csd.avatarBg,
                    child: Icon(Icons.person, color: context.csd.onSurface),
                  ),
                  title: const Text('Not signed in'),
                  subtitle: const Text('Tap to sign in'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go(AppRoutes.auth),
                ),
              );
            },
          ),

          const Divider(),

          // Appearance
          _buildSectionHeader(context, 'Appearance'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            subtitle: const Text('Switch between light and dark theme'),
            value: ref.watch(themeModeProvider) == ThemeMode.dark,
            onChanged: (value) {
              ref.read(themeModeProvider.notifier).setThemeMode(
                  value ? ThemeMode.dark : ThemeMode.light);
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Priority Colors'),
            subtitle: const Text('Customize priority level colors'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showPriorityColorsPicker,
          ),

          const Divider(),

          // Calendar settings
          _buildSectionHeader(context, 'Calendar'),
          ListTile(
            leading: const Icon(Icons.view_agenda),
            title: const Text('Default Calendar View'),
            subtitle: Text(_getCalendarViewLabel(_defaultCalendarView)),
            trailing: const Icon(Icons.chevron_right),
            onTap: _selectDefaultCalendarView,
          ),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text('Timezone'),
            subtitle: Text(_timezone),
            trailing: const Icon(Icons.chevron_right),
            onTap: _selectTimezone,
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Week starts on'),
            subtitle: Text(_weekStart == 'monday' ? 'Monday' : 'Sunday'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _selectWeekStart,
          ),
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Default event duration'),
            subtitle: Text('$_defaultDuration minutes'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _selectDefaultDuration,
          ),

          const Divider(),

          // Working hours
          _buildSectionHeader(context, 'Working Hours'),
          ListTile(
            leading: const Icon(Icons.wb_sunny_outlined),
            title: const Text('Start time'),
            subtitle: Text(_workingHoursStart),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _selectWorkingHour(isStart: true),
          ),
          ListTile(
            leading: const Icon(Icons.nightlight_outlined),
            title: const Text('End time'),
            subtitle: Text(_workingHoursEnd),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _selectWorkingHour(isStart: false),
          ),

          const Divider(),

          // Notifications
          _buildSectionHeader(context, 'Notifications'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Enable notifications'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.alarm),
            title: const Text('Event Reminders'),
            subtitle: const Text('Get notified before events start'),
            value: _eventRemindersEnabled,
            onChanged: _notificationsEnabled
                ? (value) {
                    setState(() => _eventRemindersEnabled = value);
                  }
                : null,
          ),
          ListTile(
            enabled: _notificationsEnabled && _eventRemindersEnabled,
            leading: const Icon(Icons.timer_outlined),
            title: const Text('Reminder lead time'),
            subtitle: Text('$_notificationLeadTime minutes before'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _notificationsEnabled && _eventRemindersEnabled
                ? _selectLeadTime
                : null,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.self_improvement),
            title: const Text('Reflection Reminder'),
            subtitle: const Text('Daily reminder to complete reflection'),
            value: _reflectionReminderEnabled,
            onChanged: _notificationsEnabled
                ? (value) {
                    setState(() => _reflectionReminderEnabled = value);
                  }
                : null,
          ),

          const Divider(),

          // AI Settings
          _buildSectionHeader(context, 'AI Assistant'),
          SwitchListTile(
            secondary: const Icon(Icons.auto_awesome),
            title: const Text('AI suggestions'),
            subtitle: const Text('Get intelligent scheduling recommendations'),
            value: _aiSuggestionsEnabled,
            onChanged: (value) {
              setState(() => _aiSuggestionsEnabled = value);
            },
          ),

          const Divider(),

          // Streaks
          _buildSectionHeader(context, 'Streaks'),
          ListTile(
            leading: const Icon(Icons.local_fire_department),
            title: const Text('Completion threshold'),
            subtitle: Text('${(_streakThreshold * 100).toInt()}% to maintain streak'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _selectStreakThreshold,
          ),

          const Divider(),

          // Data & Privacy
          _buildSectionHeader(context, 'Data & Privacy'),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Import calendar'),
            subtitle: const Text('Import events from CSV or ICS file'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _importCalendar,
          ),
          ListTile(
            leading: const Icon(Icons.key),
            title: const Text('Encryption keys'),
            subtitle: const Text('Manage your E2E encryption keys'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _manageEncryptionKeys,
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Export data'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _exportData,
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: AppColors.error),
            title: Text('Delete account', style: TextStyle(color: AppColors.error)),
            onTap: _deleteAccount,
          ),

          const Divider(),

          // About
          _buildSectionHeader(context, 'About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _openUrl('https://example.com/terms'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _openUrl('https://example.com/privacy'),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Open Source Licenses'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showLicenses,
          ),

          const Divider(),

          // Sign out
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: _signOut,
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: context.csd.onSurfaceDim,
            ),
      ),
    );
  }

  String _getCalendarViewLabel(String view) {
    switch (view) {
      case 'day':
        return 'Day';
      case 'week':
        return 'Week';
      case 'month':
        return 'Month';
      default:
        return 'Day';
    }
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _EditProfileSheet(),
    );
  }

  void _showPriorityColorsPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Priority Colors',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildColorOption(
                    context,
                    setModalState,
                    'Low Priority',
                    _priorityLowColor,
                    (color) {
                      setState(() => _priorityLowColor = color);
                      setModalState(() {});
                    },
                  ),
                  _buildColorOption(
                    context,
                    setModalState,
                    'Medium Priority',
                    _priorityMediumColor,
                    (color) {
                      setState(() => _priorityMediumColor = color);
                      setModalState(() {});
                    },
                  ),
                  _buildColorOption(
                    context,
                    setModalState,
                    'High Priority',
                    _priorityHighColor,
                    (color) {
                      setState(() => _priorityHighColor = color);
                      setModalState(() {});
                    },
                  ),
                  _buildColorOption(
                    context,
                    setModalState,
                    'Critical Priority',
                    _priorityCriticalColor,
                    (color) {
                      setState(() => _priorityCriticalColor = color);
                      setModalState(() {});
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _priorityLowColor = AppColors.priorityLow;
                          _priorityMediumColor = AppColors.priorityMedium;
                          _priorityHighColor = AppColors.priorityHigh;
                          _priorityCriticalColor = AppColors.priorityCritical;
                        });
                        setModalState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Colors reset to defaults')),
                        );
                      },
                      child: const Text('Reset to Defaults'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Priority colors saved')),
                        );
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildColorOption(
    BuildContext context,
    StateSetter setModalState,
    String label,
    Color currentColor,
    Function(Color) onColorSelected,
  ) {
    final colorOptions = [
      AppColors.priorityLow,
      AppColors.priorityMedium,
      AppColors.priorityHigh,
      AppColors.priorityCritical,
      const Color(0xFF9C27B0), // Purple
      const Color(0xFF00BCD4), // Cyan
      const Color(0xFF795548), // Brown
      const Color(0xFF607D8B), // Blue Gray
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text('Select $label Color'),
                  content: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: colorOptions.map((color) {
                      final isSelected = color.value == currentColor.value;
                      return GestureDetector(
                        onTap: () {
                          onColorSelected(color);
                          Navigator.pop(dialogContext);
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: context.csd.onSurface, width: 3)
                                : null,
                          ),
                          child: isSelected
                              ? Icon(Icons.check, color: context.csd.surface)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: currentColor,
                shape: BoxShape.circle,
                border: Border.all(color: context.csd.border),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectDefaultCalendarView() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'Default Calendar View',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.view_day),
              title: const Text('Day'),
              trailing: _defaultCalendarView == 'day'
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                setState(() => _defaultCalendarView = 'day');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_week),
              title: const Text('Week'),
              trailing: _defaultCalendarView == 'week'
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                setState(() => _defaultCalendarView = 'week');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_view_month),
              title: const Text('Month'),
              trailing: _defaultCalendarView == 'month'
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                setState(() => _defaultCalendarView = 'month');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _selectTimezone() {
    final timezones = [
      'America/New_York',
      'America/Chicago',
      'America/Denver',
      'America/Los_Angeles',
      'Europe/London',
      'Europe/Paris',
      'Asia/Tokyo',
      'Australia/Sydney',
      'UTC',
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'Select Timezone',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: timezones.length,
                itemBuilder: (context, index) {
                  final tz = timezones[index];
                  return ListTile(
                    title: Text(tz),
                    trailing: _timezone == tz ? const Icon(Icons.check) : null,
                    onTap: () {
                      setState(() => _timezone = tz);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectWeekStart() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Monday'),
              trailing: _weekStart == 'monday' ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() => _weekStart = 'monday');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sunday'),
              trailing: _weekStart == 'sunday' ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() => _weekStart = 'sunday');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _selectDefaultDuration() {
    final durations = [15, 30, 45, 60, 90, 120];

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: durations.map((d) {
            return ListTile(
              title: Text('$d minutes'),
              trailing: _defaultDuration == d ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() => _defaultDuration = d);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _selectWorkingHour({required bool isStart}) async {
    final current = isStart ? _workingHoursStart : _workingHoursEnd;
    final parts = current.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final formatted =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setState(() {
        if (isStart) {
          _workingHoursStart = formatted;
        } else {
          _workingHoursEnd = formatted;
        }
      });
    }
  }

  void _selectLeadTime() {
    final times = [5, 10, 15, 30, 60];

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: times.map((t) {
            return ListTile(
              title: Text('$t minutes'),
              trailing:
                  _notificationLeadTime == t ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() => _notificationLeadTime = t);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _selectStreakThreshold() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Completion Threshold',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Complete at least ${(_streakThreshold * 100).toInt()}% of daily events to maintain your streak',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              StatefulBuilder(
                builder: (context, setModalState) {
                  return Column(
                    children: [
                      Slider(
                        value: _streakThreshold,
                        min: 0.5,
                        max: 1.0,
                        divisions: 10,
                        label: '${(_streakThreshold * 100).toInt()}%',
                        onChanged: (value) {
                          setModalState(() {});
                          setState(() => _streakThreshold = value);
                        },
                      ),
                      Text(
                        '${(_streakThreshold * 100).toInt()}%',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _importCalendar() {
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
                'Import Calendar',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Import events from a CSV or ICS file',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.csd.onSurfaceDim,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ListTile(
                leading: const Icon(Icons.table_chart),
                title: const Text('Import CSV'),
                subtitle: const Text('Google Calendar CSV export format'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndImportFile('csv');
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text('Import ICS'),
                subtitle: const Text('Standard iCalendar format'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndImportFile('ics');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndImportFile(String format) async {
    // TODO: Use file_picker package to select file, then upload to backend
    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: [format],
    // );
    // if (result != null) {
    //   final file = result.files.single;
    //   await apiService.uploadFile('/import/$format', file.path!);
    // }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${format.toUpperCase()} import coming soon - add file_picker package'),
      ),
    );
  }

  void _manageEncryptionKeys() {
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
                'Encryption Keys',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              ListTile(
                leading: const Icon(Icons.key),
                title: const Text('Export public key'),
                subtitle: const Text('Share with friends for secure messaging'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Public key copied to clipboard')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.backup),
                title: const Text('Backup private key'),
                subtitle: const Text('Required to recover your messages'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement secure key backup
                },
              ),
              ListTile(
                leading: Icon(Icons.refresh, color: AppColors.warning),
                title: Text('Regenerate keys', style: TextStyle(color: AppColors.warning)),
                subtitle: const Text('Warning: You will lose access to old messages'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmRegenerateKeys();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmRegenerateKeys() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Regenerate Keys?'),
        content: const Text(
          'This will create new encryption keys. You will not be able to decrypt old messages. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Regenerate keys
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('New keys generated')),
              );
            },
            child: Text('Regenerate', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preparing export...')),
    );
    // TODO: Implement data export
  }

  void _deleteAccount() {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final authActions = ref.read(authActionsProvider);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account and all associated data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              scaffoldMessenger.showSnackBar(
                const SnackBar(content: Text('Deleting account...')),
              );
              final result = await authActions.deleteAccount();
              if (result.isSuccess) {
                router.go(AppRoutes.auth);
              } else {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(result.error ?? 'Failed to delete account'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _openUrl(String url) {
    // TODO: Launch URL
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $url')),
    );
  }

  void _showLicenses() {
    showLicensePage(
      context: context,
      applicationName: 'ctrl^date',
      applicationVersion: '1.0.0',
    );
  }

  void _signOut() {
    // Capture references before showing dialog
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final authActions = ref.read(authActionsProvider);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              // Show loading indicator
              scaffoldMessenger.showSnackBar(
                const SnackBar(content: Text('Signing out...')),
              );

              // Actually sign out using auth actions
              final result = await authActions.signOut();

              if (result.isSuccess) {
                // Navigate to auth screen
                router.go(AppRoutes.auth);
              } else {
                // Show error
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(result.error ?? 'Sign out failed'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

/// Edit profile sheet
class _EditProfileSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<_EditProfileSheet> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _initialized = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _initFromUser() {
    if (_initialized) return;
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
      _emailController.text = user.email;
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _initFromUser();

    return Padding(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Avatar
              Center(
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Consumer(
                        builder: (context, ref, _) {
                          final user = ref.watch(currentUserProvider).valueOrNull;
                          return CircleAvatar(
                            radius: 48,
                            backgroundColor: context.csd.avatarBg,
                            backgroundImage: user?.avatarUrl != null
                                ? NetworkImage(user!.avatarUrl!)
                                : null,
                            child: user?.avatarUrl == null
                                ? Icon(Icons.person, size: 48, color: context.csd.onSurface)
                                : null,
                          );
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        right: -4,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: context.csd.onSurface,
                            shape: BoxShape.circle,
                            border: Border.all(color: context.csd.surface, width: 2),
                          ),
                          child: Icon(Icons.camera_alt, color: context.csd.surface, size: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Display name',
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                enabled: false,
              ),

              const SizedBox(height: AppSpacing.lg),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving
                      ? null
                      : () async {
                          setState(() => _isSaving = true);
                          final authActions = ref.read(authActionsProvider);
                          final result = await authActions.updateProfile(
                            displayName: _nameController.text.trim(),
                          );
                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  result.isSuccess
                                      ? 'Profile updated'
                                      : result.error ?? 'Update failed',
                                ),
                              ),
                            );
                          }
                        },
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
