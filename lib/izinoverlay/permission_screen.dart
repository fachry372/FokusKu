import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokusku/auth/auth_gate.dart';
import 'permintaan_izin.dart';
import 'permission_guard.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen>
    with WidgetsBindingObserver {

  static const platform = MethodChannel('fokusku/focus_service');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // cek izin saat app kembali dari setting
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final granted = await PermissionGuard.allGranted();
      if (granted && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthGate()),
        );
      }
    }
  }

 Future<void> _activateAll() async {
  bool overlayGranted = await Permintaanizin.overlayGranted();
  bool accessibilityGranted = await Permintaanizin.accessibilityGranted();
  bool usageGranted = await Permintaanizin.usageGranted();

  if (!overlayGranted || !accessibilityGranted || !usageGranted) {
    // tampilkan dialog edukasi
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Izin Diperlukan'),
        content: Text(
          'Fokusku membutuhkan izin berikut agar dapat berjalan:\n\n'
          '- Tampil di atas aplikasi lain\n'
          '- Aksesibilitas\n'
          '- Akses penggunaan aplikasi\n\n'
          'Silakan aktifkan izin melalui pengaturan.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // buka setting sesuai izin yang belum aktif
              if (!overlayGranted) {
                platform.invokeMethod('openOverlaySettings');
              } else if (!accessibilityGranted) {
                platform.invokeMethod('openAccessibilitySettings');
              } else if (!usageGranted) {
                platform.invokeMethod('openUsageAccessSettings');
              }
            },
            child: const Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  } else {
    // semua izin sudah diberikan → lanjut
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthGate()),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Izin Diperlukan')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),
            Text(
              'FokusKu membutuhkan izin berikut agar bisa berjalan:\n\n'
              '- Tampil di atas aplikasi lain\n'
              '- Aksesibilitas\n'
              '- Akses penggunaan aplikasi',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _activateAll,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Aktifkan Semua Izin'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
