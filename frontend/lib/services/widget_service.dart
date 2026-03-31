/// Ctrl+Shift+Date - Widget Service
/// Service for managing lock screen / home screen widgets
/// Uses home_widget package to communicate between Flutter and native widgets
library;

import 'package:flutter/foundation.dart';

/// Service for managing native widgets (iOS WidgetKit, Android Glance)
class WidgetService {
  WidgetService._();
  static final WidgetService _instance = WidgetService._();
  static WidgetService get instance => _instance;

  /// Update widget data with current event countdown
  Future<void> updateEventCountdown({
    required String eventTitle,
    required DateTime eventEnd,
    required int minutesRemaining,
  }) async {
    try {
      // TODO: Add home_widget dependency and uncomment:
      // await HomeWidget.saveWidgetData<String>('event_title', eventTitle);
      // await HomeWidget.saveWidgetData<String>('event_end', eventEnd.toIso8601String());
      // await HomeWidget.saveWidgetData<int>('minutes_remaining', minutesRemaining);
      // await HomeWidget.updateWidget(
      //   iOSName: 'CtrlShiftDateWidget',
      //   androidName: 'EventCountdownWidget',
      // );
      debugPrint('Widget updated: $eventTitle ($minutesRemaining min remaining)');
    } catch (e) {
      debugPrint('Failed to update widget: $e');
    }
  }

  /// Clear widget data (no active event)
  Future<void> clearWidget() async {
    try {
      // TODO: Add home_widget dependency and uncomment:
      // await HomeWidget.saveWidgetData<String>('event_title', '');
      // await HomeWidget.saveWidgetData<int>('minutes_remaining', 0);
      // await HomeWidget.updateWidget(
      //   iOSName: 'CtrlShiftDateWidget',
      //   androidName: 'EventCountdownWidget',
      // );
      debugPrint('Widget cleared');
    } catch (e) {
      debugPrint('Failed to clear widget: $e');
    }
  }

  /// Update widget with next upcoming event
  Future<void> updateNextEvent({
    String? eventTitle,
    DateTime? eventStart,
  }) async {
    try {
      // TODO: Add home_widget dependency and uncomment:
      // await HomeWidget.saveWidgetData<String>('next_event_title', eventTitle ?? '');
      // await HomeWidget.saveWidgetData<String>(
      //   'next_event_start',
      //   eventStart?.toIso8601String() ?? '',
      // );
      // await HomeWidget.updateWidget(
      //   iOSName: 'CtrlShiftDateWidget',
      //   androidName: 'EventCountdownWidget',
      // );
      debugPrint('Widget next event: $eventTitle');
    } catch (e) {
      debugPrint('Failed to update widget: $e');
    }
  }
}
