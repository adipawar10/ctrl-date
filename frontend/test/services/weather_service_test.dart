import 'package:flutter_test/flutter_test.dart';
import 'package:ctrl_shift_date/services/weather_service.dart';

void main() {
  group('WeatherCondition', () {
    test('all 9 conditions defined', () {
      expect(WeatherCondition.values.length, 9);
    });
  });

  group('DayWeather', () {
    test('icon returns correct emoji for sunny', () {
      final w = DayWeather(
        date: DateTime(2026, 4, 1),
        tempHigh: 25,
        tempLow: 15,
        condition: WeatherCondition.sunny,
        description: 'Clear sky',
      );
      expect(w.icon, '☀️');
    });

    test('icon returns correct emoji for rainy', () {
      final w = DayWeather(
        date: DateTime(2026, 4, 1),
        tempHigh: 18,
        tempLow: 12,
        condition: WeatherCondition.rainy,
        description: 'Rain',
      );
      expect(w.icon, '🌧️');
    });

    test('icon returns correct emoji for snowy', () {
      final w = DayWeather(
        date: DateTime(2026, 4, 1),
        tempHigh: -2,
        tempLow: -8,
        condition: WeatherCondition.snowy,
        description: 'Snowfall',
      );
      expect(w.icon, '❄️');
    });

    test('icon for thunderstorm', () {
      final w = DayWeather(
        date: DateTime(2026, 4, 1),
        tempHigh: 20,
        tempLow: 15,
        condition: WeatherCondition.thunderstorm,
        description: 'Storm',
      );
      expect(w.icon, '⛈️');
    });

    test('icon for unknown', () {
      final w = DayWeather(
        date: DateTime(2026, 4, 1),
        tempHigh: 20,
        tempLow: 15,
        condition: WeatherCondition.unknown,
        description: 'Unknown',
      );
      expect(w.icon, '🌡️');
    });

    test('tempRange formats correctly', () {
      final w = DayWeather(
        date: DateTime(2026, 4, 1),
        tempHigh: 25.6,
        tempLow: 14.3,
        condition: WeatherCondition.sunny,
        description: 'Clear',
      );
      expect(w.tempRange, '26°/14°');
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

  group('WeatherService._mapWeatherCode (via condition mapping)', () {
    // We test the weather code mapping indirectly by verifying
    // the WeatherCondition enum covers all expected scenarios
    test('all weather icon types have unique emojis', () {
      final icons = <String>{};
      for (final condition in WeatherCondition.values) {
        final w = DayWeather(
          date: DateTime(2026, 4, 1),
          tempHigh: 20,
          tempLow: 10,
          condition: condition,
          description: 'test',
        );
        icons.add(w.icon);
      }
      // All conditions should produce a non-empty icon
      expect(icons.length, WeatherCondition.values.length);
    });
  });
}
