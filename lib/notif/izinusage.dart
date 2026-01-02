import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class Izinusage {
  static const _askedUsage = 'asked_usage_permission';
  static const MethodChannel _channel =
      MethodChannel('focus_session');

  /// cek flag sudah pernah ditanya
  static Future<bool> sudahPernahDitanya() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_askedUsage) ?? false;
  }

  /// tandai sudah pernah ditanya
  static Future<void> tandaiSudahDitanya() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_askedUsage, true);
  }

  /// CEK izin usage access dari native
  static Future<bool> cekSudahDiizinkan() async {
    try {
      final bool result =
          await _channel.invokeMethod('checkUsagePermission');
      return result;
    } catch (_) {
      return false;
    }
  }

  /// buka halaman settings
  static Future<void> bukaPengaturan() async {
    await _channel.invokeMethod('openUsageSettings');
  }
}
