/// Ctrl+Shift+Date - Weather Badge Widget
/// Shows weather icon and temp for a calendar day
library;

import 'package:flutter/material.dart';

import '../services/weather_service.dart';
import '../theme.dart';

/// Compact weather badge for calendar day cells
class WeatherBadge extends StatelessWidget {
  final DayWeather weather;
  final bool compact;

  const WeatherBadge({
    super.key,
    required this.weather,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Tooltip(
        message: '${weather.description} · ${weather.tempRange}',
        child: Text(
          weather.icon,
          style: const TextStyle(fontSize: 12),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(weather.icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 2),
          Text(
            weather.tempRange,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.gray600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
