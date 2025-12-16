import 'package:flutter/services.dart';

class AccessibilityListener {
  static const _channel =
      MethodChannel('fokusku/accessibility');

  static void start(
    Function(String packageName) onChanged,
  ) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onAppChanged') {
        onChanged(call.arguments as String);
      }
    });
  }
}
