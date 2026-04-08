/// Ctrl+Shift+Date - Suggestions Screen
/// View and manage scheduling suggestions
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/suggestion.dart';
import '../providers/events_provider.dart';
import '../theme.dart';

/// Suggestions screen
class AiSuggestionsScreen extends ConsumerStatefulWidget {
  const AiSuggestionsScreen({super.key});

  @override
  ConsumerState<AiSuggestionsScreen> createState() =>
      _AiSuggestionsScreenState();
}

class _AiSuggestionsScreenState extends ConsumerState<AiSuggestionsScreen> {
  bool _isLoading = false;
  bool _hasError = false;
  List<Suggestion> _suggestions = [];
  Map<String, dynamic>? _analysis;

  final Set<String> _dismissedSuggestions = {};
  final _promptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshSuggestions();
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
      body: Column(
        children: [
          // User prompt input
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.md, AppSpacing.md, 0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promptController,
                    decoration: const InputDecoration(
                      hintText: 'What do you want to schedule?',
                      prefixIcon: Icon(Icons.auto_awesome),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _refreshSuggestions(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton.filled(
                  onPressed: _isLoading ? null : _refreshSuggestions,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Main content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hasError
                    ? _buildErrorState(context)
                    : activeSuggestions.isEmpty && _analysis == null
                        ? _buildEmptyState(context)
                        : RefreshIndicator(
                            onRefresh: _refreshSuggestions,
                            child: ListView(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              children: [
                                // Schedule analysis card
                                if (_analysis != null) ...[
                                  _buildAnalysisCard(context),
                                  const SizedBox(height: AppSpacing.md),
                                ],
                          // Suggestions list
                          ...activeSuggestions.map(
                            (suggestion) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: AppSpacing.md),
                              child:
                                  _buildSuggestionCard(context, suggestion),
                            ),
                          ),
                          if (activeSuggestions.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Center(
                                child: Text(
                                  'All suggestions reviewed!',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.gray500,
                                  ),
                                ),
                              ),
                            ),
                              ],
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard(BuildContext context) {
    final theme = Theme.of(context);
    final utilization = ((_analysis?['utilization'] ?? 0) * 100).round();
    final focusHours = (_analysis?['focus_time_hours'] ?? 0).toStringAsFixed(1);
    final meetingHours = (_analysis?['meeting_hours'] ?? 0).toStringAsFixed(1);
    final gaps = (_analysis?['identified_gaps'] as List?)?.cast<String>() ?? [];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Schedule Analysis',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _AnalysisStat(label: 'Utilization', value: '$utilization%'),
              _AnalysisStat(label: 'Focus', value: '${focusHours}h'),
              _AnalysisStat(label: 'Meetings', value: '${meetingHours}h'),
            ],
          ),
          if (gaps.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            ...gaps.map((gap) => Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: AppColors.gray500),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      gap,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
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
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final api = ref.read(apiServiceProvider);
      final now = DateTime.now();
      final userPrompt = _promptController.text.trim();
      final response = await api.post<Map<String, dynamic>>(
        '/ai/suggestions',
        body: {
          'start_date': now.toIso8601String().split('T')[0],
          'end_date': now.add(const Duration(days: 7)).toIso8601String().split('T')[0],
          'max_suggestions': 5,
          if (userPrompt.isNotEmpty) 'user_prompt': userPrompt,
        },
      );

      if (!mounted) return;

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final rawSuggestions = (data['suggestions'] as List?) ?? [];

        setState(() {
          _suggestions = rawSuggestions.map((s) {
            final start = DateTime.parse(s['suggestedStart']);
            final end = DateTime.parse(s['suggestedEnd']);
            return Suggestion(
              id: s['id'] ?? '',
              title: s['title'] ?? 'Suggestion',
              durationMinutes: s['durationMinutes'] ?? end.difference(start).inMinutes,
              suggestedStart: start,
              suggestedEnd: end,
              reason: s['reason'] ?? '',
            );
          }).toList();
          _analysis = data['analysis'] as Map<String, dynamic>?;
          _isLoading = false;
          _dismissedSuggestions.clear();
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      if (!mounted) return;
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

    // Send feedback to backend
    final api = ref.read(apiServiceProvider);
    api.post('/ai/suggestions/feedback', body: {
      'suggestion_id': suggestionId,
      'accepted': false,
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
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                _dismissedSuggestions.add(suggestion.id);
              });

              try {
                final api = ref.read(apiServiceProvider);
                await api.post('/ai/suggestions/${suggestion.id}/apply');

                // Send positive feedback
                await api.post('/ai/suggestions/feedback', body: {
                  'suggestion_id': suggestion.id,
                  'accepted': true,
                });

                // Refresh events
                ref.invalidate(eventsProvider);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('"${suggestion.title}" added to calendar')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add: $e')),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

/// Analysis stat chip
class _AnalysisStat extends StatelessWidget {
  final String label;
  final String value;

  const _AnalysisStat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
