import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notif {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );

    const initSettings = InitializationSettings(
      android: androidInit,
    );

    await _notifications.initialize(initSettings);
  }
  static const int focusNotificationId = 1;

  static Future<void> showFocusNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'focus_channel', 
      'Focus Timer',
      channelDescription: 'Notifikasi sesi fokus',
      importance: Importance.high,
      priority: Priority.low,
      ongoing: true, 
      autoCancel: false, 
      showWhen: false,
    );

    await _notifications.show(
       focusNotificationId,  
      'Sesi Fokus',
      'Sedang berjalan',
      const NotificationDetails(android: androidDetails),
    );
  }

  static Future<void> showFocusEndedNotification() async {
  const androidDetails = AndroidNotificationDetails(
    'focus_channel',          
    'Focus Timer',           
    channelDescription: 'Notifikasi sesi fokus',
    importance: Importance.high,
    priority: Priority.high,
    ongoing: false,           
    autoCancel: true,         
    showWhen: true,
  );

  await _notifications.show(
     focusNotificationId, 
    'Sesi Fokus Berakhir',
    'Sesi fokus kamu dihentikan karena keluar aplikasi',
    const NotificationDetails(android: androidDetails),
  );
}


  static Future<void> cancelFocusNotification() async {
    await _notifications.cancel(1);
  }

  static Future<void> showReminderNotification() async {
  const androidDetails = AndroidNotificationDetails(
    'break_reminder',
    'Pengingat Fokus',
    importance: Importance.high,
    priority: Priority.high,
  );

  await _notifications.show(
    focusNotificationId,
    'Waktu hampir habis',
    'Kembali ke aplikasi agar sesi fokus tidak terlewat',
    const NotificationDetails(android: androidDetails),
  );
}

static Future<void> showSessionFinishedNotification() async {
  await _notifications.show(
    focusNotificationId,
    'Sesi Fokus Selesai 🎉',
    'Buka aplikasi untuk melihat reward kamu',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'session_done',
        'Sesi Fokus',
        importance: Importance.high,
      ),
    ),
  );
}


static Future<void> showShortBreakNotification() async {
    await _notifications.cancel(focusNotificationId);

    const androidDetails = AndroidNotificationDetails(
      'break_channel',
      'Istirahat',
      channelDescription: 'Notifikasi istirahat',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: false,
      autoCancel: true,
      showWhen: true,
    );

    await _notifications.show(
      focusNotificationId,
      'Istirahat Pendek',
      'Gunakan waktu ini untuk rileks sebentar',
      const NotificationDetails(android: androidDetails),
    );
  }


static Future<void> showLongBreakNotification() async {
   await _notifications.cancel(focusNotificationId);

  const androidDetails = AndroidNotificationDetails(
    'long_break_channel',
    'Istirahat Panjang',
    channelDescription: 'Notifikasi istirahat panjang',
    importance: Importance.high,
    priority: Priority.high,
    ongoing: false,
    autoCancel: true,
    showWhen: true,
  );

  await _notifications.show(
    focusNotificationId,
    'Istirahat Panjang ',
    'Waktunya istirahat lebih lama, nikmati!',
    const NotificationDetails(android: androidDetails),
  );
}

}

