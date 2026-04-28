/// Material icons for [WeatherCondition] (reliable on iOS; emoji often shows as �).
library;

import 'package:flutter/material.dart';

import '../services/weather_service.dart';

IconData weatherIconFor(WeatherCondition condition) {
  switch (condition) {
    case WeatherCondition.sunny:
      return Icons.wb_sunny_outlined;
    case WeatherCondition.partlyCloudy:
      return Icons.wb_cloudy;
    case WeatherCondition.cloudy:
      return Icons.cloud_outlined;
    case WeatherCondition.rainy:
      return Icons.water_drop_outlined;
    case WeatherCondition.thunderstorm:
      return Icons.flash_on_outlined;
    case WeatherCondition.snowy:
      return Icons.ac_unit;
    case WeatherCondition.foggy:
      return Icons.blur_on;
    case WeatherCondition.windy:
      return Icons.air;
    case WeatherCondition.unknown:
      return Icons.thermostat_outlined;
  }
}

extension DayWeatherMaterialIcon on DayWeather {
  IconData get weatherIconData => weatherIconFor(condition);
}
