import 'package:flutter_test/flutter_test.dart';
import 'package:ctrl_shift_date/services/weather_service.dart';
import 'package:ctrl_shift_date/utils/weather_icons.dart';

void main() {
  group('WeatherCondition', () {
    test('all 9 conditions defined', () {
      expect(WeatherCondition.values.length, 9);
    });
  });

  group('DayWeather', () {
    test('icon returns emoji string for tooltips/legacy', () {
      final w = DayWeather(
        date: DateTime(2026, 4, 1),
        tempHigh: 25,
        tempLow: 15,
        condition: WeatherCondition.sunny,
        description: 'Clear sky',
      );
      expect(w.icon, '☀️');
    });

    test('tempRange formats min then max', () {
      final w = DayWeather(
        date: DateTime(2026, 4, 1),
        tempHigh: 25.6,
        tempLow: 14.3,
        condition: WeatherCondition.sunny,
        description: 'Clear',
      );
      expect(w.tempRange, '14°/26°');
    });

    test('humidity and windSpeed default to 0', () {
      final w = DayWeather(
        date: DateTime(2026, 4, 1),
        tempHigh: 20,
        tempLow: 10,
        condition: WeatherCondition.cloudy,
        description: 'Overcast',
      );
      expect(w.humidity, 0);
      expect(w.windSpeed, 0);
    });
  });

  group('weatherIconFor', () {
    test('each condition maps to a distinct Material icon', () {
      final codePoints = <int>{};
      for (final condition in WeatherCondition.values) {
        codePoints.add(weatherIconFor(condition).codePoint);
      }
      expect(codePoints.length, WeatherCondition.values.length);
    });

    test('DayWeather extension matches condition', () {
      final w = DayWeather(
        date: DateTime(2026, 4, 1),
        tempHigh: 20,
        tempLow: 10,
        condition: WeatherCondition.rainy,
        description: 'Rain',
      );
      expect(w.weatherIconData, weatherIconFor(WeatherCondition.rainy));
    });
  });
}
