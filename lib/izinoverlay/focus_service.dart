import 'package:flutter/services.dart';

class FocusService {
  static const MethodChannel _channel = MethodChannel('fokusku/focus_service');

  static Future<void> start() async {
    await _channel.invokeMethod('startService');
  }

  static Future<void> stop() async {
    await _channel.invokeMethod('stopService');
  }

  static Future<void> setAllowedApps(List<String> apps) async {
    await _channel.invokeMethod('setAllowedApps', {'apps': apps});
  }
}
