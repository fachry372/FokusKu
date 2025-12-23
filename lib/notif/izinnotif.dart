import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Izinnotif {
  static const _askedKey = 'notif_permission_asked';

  static Future<void> showIfNeeded(BuildContext context) async {
    if (!Platform.isAndroid) return;

    final prefs = await SharedPreferences.getInstance();

    
    final alreadyAsked = prefs.getBool(_askedKey) ?? false;
    if (alreadyAsked) return;

    final status = await Permission.notification.status;

   
    if (status.isGranted) {
      await prefs.setBool(_askedKey, true);
      return;
    }

    
    PermissionStatus result = status;
    if (!status.isPermanentlyDenied) {
      result = await Permission.notification.request();
    }

   
    if (!result.isGranted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Izin notifikasi ditolak. Untuk mengaktifkan nya silakan buka pengaturan.",
            ),
            
            duration: Duration(seconds: 3),
          ),
        );
      }
    }

   
    await prefs.setBool(_askedKey, true);
  }
}
