/// ctrl^date - What's New Dialog
/// Shows new features when app is updated
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/onboarding_provider.dart';
import '../theme.dart';
import '../utils/constants.dart' show AppConstants;

/// Feature item for what's new
class NewFeature {
  final IconData icon;
  final String title;
  final String description;

  const NewFeature({
    required this.icon,
    required this.title,
    required this.description,
  });
}

/// What's New dialog
class WhatsNewDialog extends ConsumerWidget {
  const WhatsNewDialog({super.key});

  // Define new features for each version
  static const List<NewFeature> _features = [
    NewFeature(
      icon: Icons.person_add_outlined,
      title: 'Profile Setup',
      description:
          'Customize your profile with a name, photo, and age for a personalized experience.',
    ),
    NewFeature(
      icon: Icons.sync_outlined,
      title: 'Calendar Import',
      description:
          'Import your existing events from Google Calendar or Apple Calendar.',
    ),
    NewFeature(
      icon: Icons.auto_awesome,
      title: 'AI Suggestions',
      description:
          'Get smart scheduling suggestions based on your habits and preferences.',
    ),
    NewFeature(
      icon: Icons.people_outline,
      title: 'Share with Friends',
      description:
          'Send event invitations and collaborate on schedules with friends.',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: const Icon(
                Icons.new_releases_outlined,
                size: 48,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'What\'s New',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Version ${AppConstants.appVersion}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.gray500,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Features list
            ...List.generate(_features.length, (index) {
              final feature = _features[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.gray100,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Icon(
                        feature.icon,
                        size: 20,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feature.title,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            feature.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: AppSpacing.md),

            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(onboardingProvider.notifier).markUpdateSeen();
                  Navigator.of(context).pop();
                },
                child: const Text('Got it!'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show the dialog
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const WhatsNewDialog(),
    );
  }
}
