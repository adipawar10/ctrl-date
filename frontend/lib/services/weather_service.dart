/// Ctrl+Shift+Date - Weather Service
/// Integrates weather data for calendar days
library;

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// Weather condition enum
enum WeatherCondition {
  sunny,
  partlyCloudy,
  cloudy,
  rainy,
  thunderstorm,
  snowy,
  foggy,
  windy,
  unknown,
}

/// Weather data for a single day
class DayWeather {
  final DateTime date;
  final double tempHigh;
  final double tempLow;
  final WeatherCondition condition;
  final String description;
  final int humidity;
  final double windSpeed;

  const DayWeather({
    required this.date,
    required this.tempHigh,
    required this.tempLow,
    required this.condition,
    required this.description,
    this.humidity = 0,
    this.windSpeed = 0,
  });

  String get icon {
    switch (condition) {
      case WeatherCondition.sunny:
        return '☀️';
      case WeatherCondition.partlyCloudy:
        return '⛅';
      case WeatherCondition.cloudy:
        return '☁️';
      case WeatherCondition.rainy:
        return '🌧️';
      case WeatherCondition.thunderstorm:
        return '⛈️';
      case WeatherCondition.snowy:
        return '❄️';
      case WeatherCondition.foggy:
        return '🌫️';
      case WeatherCondition.windy:
        return '💨';
      case WeatherCondition.unknown:
        return '🌡️';
    }
  }

  /// Min/max for display (e.g. `9°/16°`).
  String get tempRange => '${tempLow.round()}°/${tempHigh.round()}°';
}

/// Service for fetching weather data
class WeatherService {
  WeatherService._();
  static final WeatherService _instance = WeatherService._();
  static WeatherService get instance => _instance;

  // Cache weather data
  final Map<String, List<DayWeather>> _cache = {};
  DateTime? _lastFetch;

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Daily forecast for an inclusive date range (e.g. one calendar week).
  /// Uses Open-Meteo (free, no API key). [start] and [end] are calendar dates.
  Future<List<DayWeather>> getForecastForDateRange({
    required DateTime start,
    required DateTime end,
    double latitude = 37.7749,
    double longitude = -122.4194,
  }) async {
    final startD = DateTime(start.year, start.month, start.day);
    final endD = DateTime(end.year, end.month, end.day);
    final cacheKey =
        '${latitude.toStringAsFixed(2)},${longitude.toStringAsFixed(2)},${_dateKey(startD)},${_dateKey(endD)}';

    if (_cache.containsKey(cacheKey) &&
        _lastFetch != null &&
        DateTime.now().difference(_lastFetch!) < const Duration(hours: 1)) {
      return _cache[cacheKey]!;
    }

    try {
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&daily=temperature_2m_max,temperature_2m_min,weathercode,windspeed_10m_max'
        '&timezone=auto'
        '&start_date=${_dateKey(startD)}'
        '&end_date=${_dateKey(endD)}',
      );

      final client = HttpClient();
      final request = await client.getUrl(url);
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final daily = data['daily'] as Map<String, dynamic>;
      final dates = (daily['time'] as List).cast<String>();
      final maxTemps = (daily['temperature_2m_max'] as List).cast<num>();
      final minTemps = (daily['temperature_2m_min'] as List).cast<num>();
      final weatherCodes = (daily['weathercode'] as List).cast<num>();

      final forecast = <DayWeather>[];
      for (var i = 0; i < dates.length; i++) {
        forecast.add(DayWeather(
          date: DateTime.parse(dates[i]),
          tempHigh: maxTemps[i].toDouble(),
          tempLow: minTemps[i].toDouble(),
          condition: _mapWeatherCode(weatherCodes[i].toInt()),
          description: _describeWeatherCode(weatherCodes[i].toInt()),
        ));
      }

      _cache[cacheKey] = forecast;
      _lastFetch = DateTime.now();
      return forecast;
    } catch (e) {
      debugPrint('Weather range fetch failed: $e');
      return [];
    }
  }

  /// Fetch 7-day forecast for a location
  /// Uses Open-Meteo API (free, no key required)
  Future<List<DayWeather>> getForecast({
    double latitude = 37.7749,  // Default: San Francisco
    double longitude = -122.4194,
  }) async {
    final cacheKey = '${latitude.toStringAsFixed(2)},${longitude.toStringAsFixed(2)}';

    // Return cache if less than 1 hour old
    if (_cache.containsKey(cacheKey) &&
        _lastFetch != null &&
        DateTime.now().difference(_lastFetch!) < const Duration(hours: 1)) {
      return _cache[cacheKey]!;
    }

    try {
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&daily=temperature_2m_max,temperature_2m_min,weathercode,windspeed_10m_max'
        '&timezone=auto'
        '&forecast_days=7',
      );

      final client = HttpClient();
      final request = await client.getUrl(url);
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final daily = data['daily'] as Map<String, dynamic>;
      final dates = (daily['time'] as List).cast<String>();
      final maxTemps = (daily['temperature_2m_max'] as List).cast<num>();
      final minTemps = (daily['temperature_2m_min'] as List).cast<num>();
      final weatherCodes = (daily['weathercode'] as List).cast<num>();

      final forecast = <DayWeather>[];
      for (var i = 0; i < dates.length; i++) {
        forecast.add(DayWeather(
          date: DateTime.parse(dates[i]),
          tempHigh: maxTemps[i].toDouble(),
          tempLow: minTemps[i].toDouble(),
          condition: _mapWeatherCode(weatherCodes[i].toInt()),
          description: _describeWeatherCode(weatherCodes[i].toInt()),
        ));
      }

      _cache[cacheKey] = forecast;
      _lastFetch = DateTime.now();

      return forecast;
    } catch (e) {
      debugPrint('Weather fetch failed: $e');
      return [];
    }
  }

  /// Get weather for a specific date (from cached forecast)
  DayWeather? getWeatherForDate(DateTime date) {
    for (final forecast in _cache.values) {
      for (final day in forecast) {
        if (day.date.year == date.year &&
            day.date.month == date.month &&
            day.date.day == date.day) {
          return day;
        }
      }
    }
    return null;
  }

  WeatherCondition _mapWeatherCode(int code) {
    if (code == 0 || code == 1) return WeatherCondition.sunny;
    if (code == 2) return WeatherCondition.partlyCloudy;
    if (code == 3) return WeatherCondition.cloudy;
    if (code == 45 || code == 48) return WeatherCondition.foggy;
    if (code >= 51 && code <= 67) return WeatherCondition.rainy;
    if (code >= 71 && code <= 77) return WeatherCondition.snowy;
    if (code >= 80 && code <= 82) return WeatherCondition.rainy;
    if (code >= 95 && code <= 99) return WeatherCondition.thunderstorm;
    return WeatherCondition.unknown;
  }

  String _describeWeatherCode(int code) {
    if (code == 0) return 'Clear sky';
    if (code == 1) return 'Mainly clear';
    if (code == 2) return 'Partly cloudy';
    if (code == 3) return 'Overcast';
    if (code == 45) return 'Foggy';
    if (code == 48) return 'Rime fog';
    if (code >= 51 && code <= 55) return 'Drizzle';
    if (code >= 56 && code <= 57) return 'Freezing drizzle';
    if (code >= 61 && code <= 65) return 'Rain';
    if (code >= 66 && code <= 67) return 'Freezing rain';
    if (code >= 71 && code <= 75) return 'Snowfall';
    if (code == 77) return 'Snow grains';
    if (code >= 80 && code <= 82) return 'Rain showers';
    if (code == 85 || code == 86) return 'Snow showers';
    if (code == 95) return 'Thunderstorm';
    if (code == 96 || code == 99) return 'Thunderstorm with hail';
    return 'Unknown';
  }
}
