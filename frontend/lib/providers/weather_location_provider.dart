/// Resolves latitude/longitude for weather (device GPS or cached / default).
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

/// Matches [WeatherService] default when nothing else is available.
const double kDefaultWeatherLatitude = 37.7749;
const double kDefaultWeatherLongitude = -122.4194;

class WeatherLocationState {
  final double latitude;
  final double longitude;
  final bool useDeviceLocation;

  const WeatherLocationState({
    required this.latitude,
    required this.longitude,
    required this.useDeviceLocation,
  });

  static const WeatherLocationState sfDefault = WeatherLocationState(
    latitude: kDefaultWeatherLatitude,
    longitude: kDefaultWeatherLongitude,
    useDeviceLocation: true,
  );
}

class WeatherLocationNotifier extends StateNotifier<WeatherLocationState> {
  WeatherLocationNotifier() : super(WeatherLocationState.sfDefault) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final useDevice = prefs.getBool(StorageKeys.weatherUseDeviceLocation) ?? true;
    final savedLat = prefs.getDouble(StorageKeys.weatherLatitude);
    final savedLon = prefs.getDouble(StorageKeys.weatherLongitude);

    if (useDevice && !kIsWeb) {
      final pos = await _tryGetCurrentPosition();
      if (pos != null) {
        await _persistCachedCoords(prefs, pos.latitude, pos.longitude);
        state = WeatherLocationState(
          latitude: pos.latitude,
          longitude: pos.longitude,
          useDeviceLocation: true,
        );
        return;
      }
    }

    if (savedLat != null && savedLon != null) {
      state = WeatherLocationState(
        latitude: savedLat,
        longitude: savedLon,
        useDeviceLocation: useDevice,
      );
      return;
    }

    state = WeatherLocationState(
      latitude: kDefaultWeatherLatitude,
      longitude: kDefaultWeatherLongitude,
      useDeviceLocation: useDevice,
    );
  }

  Future<void> _persistCachedCoords(
    SharedPreferences prefs,
    double lat,
    double lon,
  ) async {
    await prefs.setDouble(StorageKeys.weatherLatitude, lat);
    await prefs.setDouble(StorageKeys.weatherLongitude, lon);
  }

  Future<Position?> _tryGetCurrentPosition() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> setUseDeviceLocation(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.weatherUseDeviceLocation, value);
    await _load();
  }

  /// Call after the user grants permission or moves; no-op when device mode is off.
  Future<bool> refreshFromDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final useDevice = prefs.getBool(StorageKeys.weatherUseDeviceLocation) ?? true;
    if (!useDevice || kIsWeb) return false;

    final pos = await _tryGetCurrentPosition();
    if (pos == null) return false;

    await _persistCachedCoords(prefs, pos.latitude, pos.longitude);
    state = WeatherLocationState(
      latitude: pos.latitude,
      longitude: pos.longitude,
      useDeviceLocation: true,
    );
    return true;
  }
}

final weatherLocationProvider =
    StateNotifierProvider<WeatherLocationNotifier, WeatherLocationState>((ref) {
  return WeatherLocationNotifier();
});
