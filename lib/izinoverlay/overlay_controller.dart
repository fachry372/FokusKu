import 'package:flutter/services.dart';

class OverlayController {
  static const _channel = MethodChannel('overlay_channel');

  static Future<void> showOverlay() async {
    try {
      await _channel.invokeMethod('showOverlay');
    } catch (e) {
      print("Error showOverlay: $e");
    }
  }

  static Future<void> closeOverlay() async {
    try {
      await _channel.invokeMethod('closeOverlay');
    } catch (e) {
      print("Error closeOverlay: $e");
    }
  }
}
