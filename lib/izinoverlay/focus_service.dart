import 'package:flutter/services.dart';

class FocusService {
  static const MethodChannel _channel = MethodChannel('fokusku/focus_service');

  /// Mulai overlay / sesi fokus
  static Future<void> start() async {
    await _channel.invokeMethod('startService');
  }

  /// Hentikan overlay / sesi fokus
  static Future<void> stop() async {
    await _channel.invokeMethod('stopService');
  }

  /// Set aplikasi yang diizinkan (optional)
  static Future<void> setAllowedApps(List<String> apps) async {
    await _channel.invokeMethod('setAllowedApps', {'apps': apps});
  }
}
