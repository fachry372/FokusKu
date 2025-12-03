import 'package:permission_handler/permission_handler.dart';

Future<void> permintaanizin() async {
  final status = await Permission.systemAlertWindow.status;

  if (status.isGranted) {
    print("Izin overlay sudah diberikan");
  } else {
    final result = await Permission.systemAlertWindow.request();
    if (result.isGranted) {
      print("Izin overlay diberikan");
    } else {
      print("Izin overlay ditolak");
    }
  }
}
