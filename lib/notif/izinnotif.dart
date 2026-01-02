import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Izinnotif {
  /// Minta izin notifikasi (hanya Android 13+)
  static Future<bool> request(BuildContext context) async {
    // Hanya Android
    if (!Platform.isAndroid) return true;

    // Cek SDK Android 13+ (permission POST_NOTIFICATIONS)
    final status = await Permission.notification.status;

    // Jika sudah diizinkan → langsung return true
    if (status.isGranted) return true;

    // Jika ditolak permanen (user pilih "Jangan tanya lagi")
    if (status.isPermanentlyDenied) {
      _showGoToSettings(context);
      return false;
    }

    // Request permission
    final result = await Permission.notification.request();

    // Jika ditolak setelah request
    if (!result.isGranted) {
      _showDeniedSnack(context);
      return false;
    }

    return true;
  }

  // Tampilkan Snack untuk izin ditolak
  static void _showDeniedSnack(BuildContext context) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Izin notifikasi ditolak. Sesuaikan di Pengaturan jika ingin mengaktifkannya.',
        ),
      ),
    );
  }

  // Arahkan user ke Settings bila sudah permanently denied
  static void _showGoToSettings(BuildContext context) {
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Izin Notifikasi Diperlukan'),
        content: const Text(
          'Agar notifikasi bekerja, buka Pengaturan aplikasi dan aktifkan izin notifikasi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  }
}
