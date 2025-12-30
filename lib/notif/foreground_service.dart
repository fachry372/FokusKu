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
        eventAction: ForegroundTaskEventAction.repeat(1000),
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  static Future<void> start(int seconds) async {
    if (await FlutterForegroundTask.isRunningService) return;

 
    await FlutterForegroundTask.saveData(
      key: 'seconds',
      value: seconds,
    );

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
  int remainingSeconds = 0;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    
    final data = await FlutterForegroundTask.getData(key: 'seconds');
    remainingSeconds = (data as int?) ?? 0;
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    if (remainingSeconds > 0) {
      remainingSeconds--;

      FlutterForegroundTask.sendDataToMain({
        'remaining': remainingSeconds,
      });
    } else {
      FlutterForegroundTask.sendDataToMain({
        'finished': true,
      });

     
      FlutterForegroundTask.stopService();
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}
}
