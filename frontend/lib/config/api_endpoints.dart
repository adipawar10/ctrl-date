import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// Resolves the FastAPI backend base URL for each platform.
///
/// - **iOS Simulator:** host machine is reachable at `127.0.0.1` (not always `localhost`).
/// - **Android Emulator:** use `10.0.2.2` (special alias to host loopback).
/// - **Web:** `localhost` is usual.
///
/// Override at build time: `--dart-define=API_BASE_URL=http://192.168.1.5:8000` (physical device on LAN).
class ApiEndpoints {
  ApiEndpoints._();

  static const String _fromEnv = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_fromEnv.isNotEmpty) {
      return _fromEnv;
    }
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    }
    if (Platform.isIOS) {
      return 'http://127.0.0.1:8000';
    }
    return 'http://localhost:8000';
  }
}
