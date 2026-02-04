/// Ctrl+Shift+Date - Settings Screen
/// User preferences and app settings
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';

/// Settings screen for user preferences
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Mock settings - replace with actual state management
  String _timezone = 'America/New_York';
  String _weekStart = 'monday';
  int _defaultDuration = 60;
  String _workingHoursStart = '09:00';
  String _workingHoursEnd = '17:00';
  int _notificationLeadTime = 15;
  bool _notificationsEnabled = true;
  bool _aiSuggestionsEnabled = true;
  bool _darkMode = false;
  double _streakThreshold = 0.8;

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
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.gray200,
              child: const Icon(Icons.person, color: AppColors.black),
            ),
            title: const Text('John Doe'),
            subtitle: const Text('john@example.com'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _editProfile,
          ),

          const Divider(),

          // Calendar settings
          _buildSectionHeader(context, 'Calendar'),
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
          ListTile(
            enabled: _notificationsEnabled,
            leading: const Icon(Icons.alarm),
            title: const Text('Reminder lead time'),
            subtitle: Text('$_notificationLeadTime minutes before'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _notificationsEnabled ? _selectLeadTime : null,
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

          // Appearance
          _buildSectionHeader(context, 'Appearance'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark mode'),
            value: _darkMode,
            onChanged: (value) {
              setState(() => _darkMode = value);
              // TODO: Apply theme change
            },
          ),

          const Divider(),

          // Data & Privacy
          _buildSectionHeader(context, 'Data & Privacy'),
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
            title: const Text('Sign out'),
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
              color: AppColors.gray600,
            ),
      ),
    );
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _EditProfileSheet(),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account and all associated data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
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
      applicationName: 'Ctrl+Shift+Date',
      applicationVersion: '1.0.0',
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement sign out
              context.go('/');
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

/// Edit profile sheet
class _EditProfileSheet extends StatefulWidget {
  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final _nameController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'john@example.com');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.gray200,
                      child: const Icon(Icons.person, size: 48, color: AppColors.black),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: AppColors.white, size: 16),
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            // TODO: Pick image
                          },
                        ),
                      ),
                    ),
                  ],
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
                  onPressed: () {
                    // TODO: Save profile
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated')),
                    );
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
