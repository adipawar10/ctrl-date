/// Ctrl+Shift+Date - AI Suggestions Screen
/// View and apply AI scheduling suggestions
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../router.dart';
import '../theme.dart';
import '../widgets/priority_indicator.dart';

/// AI suggestions screen
class AiSuggestionsScreen extends StatefulWidget {
  const AiSuggestionsScreen({super.key});

  @override
  State<AiSuggestionsScreen> createState() => _AiSuggestionsScreenState();
}

class _AiSuggestionsScreenState extends State<AiSuggestionsScreen> {
  bool _isLoading = false;
  bool _hasError = false;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));

  // Mock data - replace with actual state management
  final Map<String, dynamic> _analysis = {
    'utilization': 0.65,
    'focus_time_hours': 12.5,
    'meeting_hours': 8.0,
    'identified_gaps': [
      'No dedicated focus time blocks on Monday',
      'Back-to-back meetings on Wednesday',
      'Missing lunch breaks on most days',
    ],
  };

  final List<Map<String, dynamic>> _suggestions = [
    {
      'id': 'sug_001',
      'type': 'add_event',
      'title': 'Focus Block: Deep Work',
      'proposed_start': DateTime.now().add(const Duration(days: 1, hours: 9)),
      'proposed_end': DateTime.now().add(const Duration(days: 1, hours: 11)),
      'reasoning':
          'Your productivity data shows you work best in the morning. Adding a focus block here maximizes your cognitive peak.',
      'confidence': 0.92,
      'category': 'focus_time',
    },
    {
      'id': 'sug_002',
      'type': 'reschedule',
      'title': 'Move: Code Review',
      'event_id': '123',
      'proposed_start': DateTime.now().add(const Duration(days: 2, hours: 14)),
      'proposed_end': DateTime.now().add(const Duration(days: 2, hours: 15)),
      'reasoning':
          'This event conflicts with your regular standup. Moving it to afternoon creates a better flow.',
      'confidence': 0.78,
      'category': 'task',
    },
    {
      'id': 'sug_003',
      'type': 'add_event',
      'title': 'Break: Lunch',
      'proposed_start': DateTime.now().add(const Duration(days: 3, hours: 12)),
      'proposed_end': DateTime.now().add(const Duration(days: 3, hours: 13)),
      'reasoning':
          'You\'ve been skipping lunch. Regular breaks improve afternoon productivity by 20%.',
      'confidence': 0.85,
      'category': 'break',
    },
  ];

  final Set<String> _appliedSuggestions = {};
  final Set<String> _rejectedSuggestions = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Suggestions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshSuggestions,
            tooltip: 'Refresh suggestions',
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _showSettings,
            tooltip: 'Settings',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? _buildErrorState(context)
              : RefreshIndicator(
                  onRefresh: _refreshSuggestions,
                  child: CustomScrollView(
                    slivers: [
                      // Date range selector
                      SliverToBoxAdapter(
                        child: _buildDateRangeSelector(context),
                      ),

                      // Analysis section
                      SliverToBoxAdapter(
                        child: _buildAnalysisSection(context),
                      ),

                      // Identified gaps
                      SliverToBoxAdapter(
                        child: _buildGapsSection(context),
                      ),

                      // Suggestions header
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            AppSpacing.lg,
                            AppSpacing.md,
                            AppSpacing.sm,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Suggestions',
                                style: theme.textTheme.titleLarge,
                              ),
                              Text(
                                '${_suggestions.length - _appliedSuggestions.length - _rejectedSuggestions.length} pending',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Suggestions list
                      _suggestions.isEmpty
                          ? SliverFillRemaining(
                              child: _buildEmptyState(context),
                            )
                          : SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                              ),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final suggestion = _suggestions[index];
                                    final isApplied = _appliedSuggestions
                                        .contains(suggestion['id']);
                                    final isRejected = _rejectedSuggestions
                                        .contains(suggestion['id']);

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppSpacing.md,
                                      ),
                                      child: _buildSuggestionCard(
                                        context,
                                        suggestion,
                                        isApplied: isApplied,
                                        isRejected: isRejected,
                                      ),
                                    );
                                  },
                                  childCount: _suggestions.length,
                                ),
                              ),
                            ),

                      // Bottom padding
                      const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDateRangeSelector(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray200),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _selectDate(isStart: true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('From', style: theme.textTheme.labelSmall),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, yyyy').format(_startDate),
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          const Icon(Icons.arrow_forward, color: AppColors.gray400),
          Expanded(
            child: GestureDetector(
              onTap: () => _selectDate(isStart: false),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('To', style: theme.textTheme.labelSmall),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, yyyy').format(_endDate),
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSection(BuildContext context) {
    final theme = Theme.of(context);
    final utilization = _analysis['utilization'] as double;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Schedule Analysis',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _buildAnalysisStat(
                  context,
                  label: 'Utilization',
                  value: '${(utilization * 100).toInt()}%',
                  icon: Icons.pie_chart,
                ),
              ),
              Expanded(
                child: _buildAnalysisStat(
                  context,
                  label: 'Focus Time',
                  value: '${_analysis['focus_time_hours']}h',
                  icon: Icons.psychology,
                ),
              ),
              Expanded(
                child: _buildAnalysisStat(
                  context,
                  label: 'Meetings',
                  value: '${_analysis['meeting_hours']}h',
                  icon: Icons.groups,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisStat(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.gray600),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(label, style: theme.textTheme.labelSmall),
      ],
    );
  }

  Widget _buildGapsSection(BuildContext context) {
    final theme = Theme.of(context);
    final gaps = _analysis['identified_gaps'] as List<String>;

    if (gaps.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: AppColors.warning.withValues(alpha: 0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 18, color: AppColors.warning),
              const SizedBox(width: 8),
              Text(
                'Identified Opportunities',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...gaps.map((gap) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('  - ', style: TextStyle(color: AppColors.gray600)),
                    Expanded(
                      child: Text(
                        gap,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(
    BuildContext context,
    Map<String, dynamic> suggestion, {
    required bool isApplied,
    required bool isRejected,
  }) {
    final theme = Theme.of(context);
    final type = suggestion['type'] as String;
    final confidence = suggestion['confidence'] as double;
    final category = suggestion['category'] as String?;

    Color categoryColor;
    IconData categoryIcon;
    switch (category) {
      case 'focus_time':
        categoryColor = AppColors.priorityHigh;
        categoryIcon = Icons.psychology;
        break;
      case 'break':
        categoryColor = AppColors.priorityLow;
        categoryIcon = Icons.coffee;
        break;
      case 'meeting':
        categoryColor = AppColors.priorityMedium;
        categoryIcon = Icons.groups;
        break;
      default:
        categoryColor = AppColors.gray600;
        categoryIcon = Icons.event;
    }

    return Opacity(
      opacity: isApplied || isRejected ? 0.5 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isApplied
              ? AppColors.completed.withValues(alpha: 0.1)
              : isRejected
                  ? AppColors.gray100
                  : AppColors.white,
          border: Border.all(
            color: isApplied
                ? AppColors.completed
                : isRejected
                    ? AppColors.gray300
                    : AppColors.gray200,
          ),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(categoryIcon, size: 20, color: categoryColor),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        suggestion['title'],
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        type == 'add_event'
                            ? 'Add new event'
                            : type == 'reschedule'
                                ? 'Reschedule existing'
                                : 'Remove event',
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                _buildConfidenceBadge(context, confidence),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Time
            if (suggestion['proposed_start'] != null)
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: AppColors.gray600),
                  const SizedBox(width: 8),
                  Text(
                    '${DateFormat('EEE, MMM d').format(suggestion['proposed_start'])} at ${DateFormat('HH:mm').format(suggestion['proposed_start'])} - ${DateFormat('HH:mm').format(suggestion['proposed_end'])}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),

            const SizedBox(height: AppSpacing.sm),

            // Reasoning
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: AppColors.gray600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      suggestion['reasoning'],
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),

            // Status or actions
            const SizedBox(height: AppSpacing.md),
            if (isApplied)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 16, color: AppColors.completed),
                  const SizedBox(width: 4),
                  Text(
                    'Applied',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.completed,
                    ),
                  ),
                ],
              )
            else if (isRejected)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cancel, size: 16, color: AppColors.gray500),
                  const SizedBox(width: 4),
                  Text(
                    'Dismissed',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _rejectSuggestion(suggestion['id']),
                      child: const Text('Dismiss'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => _applySuggestion(suggestion['id']),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfidenceBadge(BuildContext context, double confidence) {
    final theme = Theme.of(context);
    final percentage = (confidence * 100).toInt();

    Color color;
    if (confidence >= 0.8) {
      color = AppColors.completed;
    } else if (confidence >= 0.6) {
      color = AppColors.warning;
    } else {
      color = AppColors.gray500;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        '$percentage%',
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
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
              Icons.auto_awesome,
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
            Icon(
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

  Future<void> _selectDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 7));
          }
        } else {
          _endDate = picked;
        }
      });
      _refreshSuggestions();
    }
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
        _appliedSuggestions.clear();
        _rejectedSuggestions.clear();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _applySuggestion(String suggestionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply Suggestion'),
        content: const Text(
          'This will create/modify the event in your calendar. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _appliedSuggestions.add(suggestionId);
              });
              // TODO: Call API to apply suggestion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Suggestion applied')),
              );
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _rejectSuggestion(String suggestionId) {
    setState(() {
      _rejectedSuggestions.add(suggestionId);
    });
    // TODO: Send feedback to API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Suggestion dismissed')),
    );
  }

  void _showSettings() {
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
                'AI Settings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              SwitchListTile(
                title: const Text('Focus time suggestions'),
                subtitle: const Text('Suggest deep work blocks'),
                value: true,
                onChanged: (value) {},
              ),
              SwitchListTile(
                title: const Text('Break suggestions'),
                subtitle: const Text('Suggest rest periods'),
                value: true,
                onChanged: (value) {},
              ),
              SwitchListTile(
                title: const Text('Reschedule suggestions'),
                subtitle: const Text('Suggest moving events'),
                value: true,
                onChanged: (value) {},
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
}
