import 'package:permission_handler/permission_handler.dart';

Future<bool> permintaanizin() async {
  final status = await Permission.systemAlertWindow.status;

  if (status.isGranted) {
    print("Izin overlay sudah diberikan");
    return true;
  } else {
    final result = await Permission.systemAlertWindow.request();
    if (result.isGranted) {
      print("Izin overlay diberikan");
      return true;
    } else {
      print("Izin overlay ditolak");
      return false;
    }
  }
}

