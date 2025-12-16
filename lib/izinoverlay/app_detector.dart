import 'package:flutter/services.dart';

class AppDetector {
  static const MethodChannel _channel =
      MethodChannel('fokusku/usage');

      static Future<void> ensurePermission() async {
  final app = await getForegroundApp();
  if (app == null) {
    await openUsageSettings();
  }
}


      
      static Future<String?> getLauncherPackage() async {
  return await _channel.invokeMethod<String>('getLauncherPackage');
}



  static Future<String?> getForegroundApp() async {
    try {
      return await _channel.invokeMethod<String>('getForegroundApp');
    } catch (e) {
      return null;
    }
  }

  static Future<void> openUsageSettings() async {
    await _channel.invokeMethod('openUsageSettings');
  }
}


