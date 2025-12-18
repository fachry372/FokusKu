import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class Permintaanizin {
  static const platform = MethodChannel('fokusku/focus_service');

  // cek overlay
  static Future<bool> overlayGranted() async {
    if (!Platform.isAndroid) return true;
    return await Permission.systemAlertWindow.isGranted;
  }

  // cek accessibility
  static Future<bool> accessibilityGranted() async {
    if (!Platform.isAndroid) return true;
    try {
      final granted = await platform.invokeMethod<bool>('isAccessibilityGranted');
      return granted ?? false;
    } catch (e) {
      return false;
    }
  }

  // cek usage access
  static Future<bool> usageGranted() async {
    if (!Platform.isAndroid) return true;
    try {
      final granted = await platform.invokeMethod<bool>('isUsageAccessGranted');
      return granted ?? false;
    } catch (e) {
      return false;
    }
  }
}
