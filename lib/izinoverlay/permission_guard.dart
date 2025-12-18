import 'permintaan_izin.dart';

class PermissionGuard {
  static Future<bool> allGranted() async {
    final overlay = await Permintaanizin.overlayGranted();
    final accessibility = await Permintaanizin.accessibilityGranted();
    final usage = await Permintaanizin.usageGranted();

    return overlay && accessibility && usage;
  }
}
