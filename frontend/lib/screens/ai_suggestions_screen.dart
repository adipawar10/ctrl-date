/// Ctrl+Shift+Date - Suggestions Screen
/// View and manage scheduling suggestions
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/suggestion.dart';
import '../theme.dart';

/// Suggestions screen
class AiSuggestionsScreen extends StatefulWidget {
  const AiSuggestionsScreen({super.key});

  @override
  State<AiSuggestionsScreen> createState() => _AiSuggestionsScreenState();
}

class _AiSuggestionsScreenState extends State<AiSuggestionsScreen> {
  bool _isLoading = false;
  bool _hasError = false;

  // Mock suggestions data - replace with actual state management
  final List<Suggestion> _suggestions = [
    Suggestion(
      id: 'sug_001',
      title: 'Focus Block: Deep Work',
      durationMinutes: 120,
      suggestedStart: DateTime.now().add(const Duration(days: 1, hours: 9)),
      suggestedEnd: DateTime.now().add(const Duration(days: 1, hours: 11)),
      reason:
          'Your productivity data shows you work best in the morning. Adding a focus block here maximizes your cognitive peak.',
    ),
    Suggestion(
      id: 'sug_002',
      title: 'Code Review Session',
      durationMinutes: 60,
      suggestedStart: DateTime.now().add(const Duration(days: 2, hours: 14)),
      suggestedEnd: DateTime.now().add(const Duration(days: 2, hours: 15)),
      reason:
          'You have pending code reviews. This slot is free and follows your usual review pattern.',
    ),
    Suggestion(
      id: 'sug_003',
      title: 'Lunch Break',
      durationMinutes: 60,
      suggestedStart: DateTime.now().add(const Duration(days: 3, hours: 12)),
      suggestedEnd: DateTime.now().add(const Duration(days: 3, hours: 13)),
      reason:
          'You have been skipping lunch. Regular breaks improve afternoon productivity by 20%.',
    ),
    Suggestion(
      id: 'sug_004',
      title: 'Team Sync',
      durationMinutes: 30,
      suggestedStart: DateTime.now().add(const Duration(days: 1, hours: 15)),
      suggestedEnd:
          DateTime.now().add(const Duration(days: 1, hours: 15, minutes: 30)),
      reason:
          'Weekly team sync is due. This time works for all team members based on their calendars.',
    ),
  ];

  final Set<String> _dismissedSuggestions = {};

  @override
  Widget build(BuildContext context) {
    final activeSuggestions = _suggestions
        .where((s) => !_dismissedSuggestions.contains(s.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggestions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshSuggestions,
            tooltip: 'Refresh suggestions',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? _buildErrorState(context)
              : activeSuggestions.isEmpty
                  ? _buildEmptyState(context)
                  : RefreshIndicator(
                      onRefresh: _refreshSuggestions,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: activeSuggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = activeSuggestions[index];
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSpacing.md),
                            child: _buildSuggestionCard(context, suggestion),
                          );
                        },
                      ),
                    ),
    );
  }

  Widget _buildSuggestionCard(BuildContext context, Suggestion suggestion) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('h:mm a');
    final dateFormat = DateFormat('EEE, MMM d');

    final timeWindow =
        '${timeFormat.format(suggestion.suggestedStart)} - ${timeFormat.format(suggestion.suggestedEnd)}';
    final dateString = dateFormat.format(suggestion.suggestedStart);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.gray200),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title (bold)
          Text(
            suggestion.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Duration and time window row
          Row(
            children: [
              // Duration chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  suggestion.formattedDuration,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.gray700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              // Time window
              const Icon(Icons.access_time, size: 16, color: AppColors.gray600),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '$dateString, $timeWindow',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Reason text
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: AppColors.gray600,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    suggestion.reason,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Action buttons
          Row(
            children: [
              // Dismiss button (TextButton)
              TextButton(
                onPressed: () => _dismissSuggestion(suggestion.id),
                child: const Text('Dismiss'),
              ),

              const Spacer(),

              // Add to Calendar button (ElevatedButton)
              ElevatedButton(
                onPressed: () => _addToCalendar(suggestion),
                child: const Text('Add to Calendar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No suggestions',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Your schedule looks great! Check back later for optimization ideas.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Failed to load suggestions',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Please check your connection and try again.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: _refreshSuggestions,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshSuggestions() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _dismissedSuggestions.clear();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _dismissSuggestion(String suggestionId) {
    setState(() {
      _dismissedSuggestions.add(suggestionId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Suggestion dismissed')),
    );
  }

  void _addToCalendar(Suggestion suggestion) {
    // Show confirmation dialog - never auto-add
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Calendar'),
        content: Text(
          'Add "${suggestion.title}" to your calendar?\n\n'
          'This will create an event from '
          '${DateFormat('h:mm a').format(suggestion.suggestedStart)} to '
          '${DateFormat('h:mm a').format(suggestion.suggestedEnd)} on '
          '${DateFormat('EEEE, MMMM d').format(suggestion.suggestedStart)}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _dismissedSuggestions.add(suggestion.id);
              });
              // TODO: Call API to create event
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('"${suggestion.title}" added to calendar')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
