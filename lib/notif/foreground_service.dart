import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class ForegroundService {
  
  static void init() {
    
    FlutterForegroundTask.initCommunicationPort();

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'focus_foreground_channel',
        channelName: 'Sesi Fokus',
        channelDescription: 'Menjaga sesi fokus tetap berjalan',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }


  static Future<void> start() async {
    if (await FlutterForegroundTask.isRunningService) return;

    await FlutterForegroundTask.startService(
      serviceId: 1001,
      notificationTitle: 'Sesi Fokus',
      notificationText: 'Timer fokus sedang berjalan',
      callback: startCallback,
    );
  }

 
  static Future<void> stop() async {
    if (!await FlutterForegroundTask.isRunningService) return;
    await FlutterForegroundTask.stopService();
  }
}


@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(_EmptyTaskHandler());
}


class _EmptyTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // Tidak dipakai
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout ) async {
    
  }
}
