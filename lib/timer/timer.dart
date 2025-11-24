import 'dart:async';
import 'package:flutter/material.dart';

class TimerService extends ChangeNotifier {
  int _remainingSeconds = 0;
  Timer? _timer;

  // Durasi fokus & break
  int focusSeconds = 1500; // default 25 menit
  int breakSeconds = 300;  // default 5 menit

  int get seconds => _remainingSeconds;

  String get formattedTime {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

    // Format timer untuk Home: selalu durasi awal fokus
  String get initialFocusTime {
    final m = focusSeconds ~/ 60;
    final s = focusSeconds % 60;
    return "${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}";
  }

  /// START TIMER UTAMA
  void startMainTimer() {
    start(
      seconds: focusSeconds,
      onFinished: () {
        // ketika selesai → mulai break
        startBreakTimer();
      },
    );
  }

  /// START TIMER BREAK
  void startBreakTimer() {
    start(
      seconds: breakSeconds,
      onFinished: () {
        // selesai break → bisa diisi logika lain
      },
    );
  }

  void start({int? seconds, VoidCallback? onFinished}) {
    if (seconds != null) _remainingSeconds = seconds;

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        stop();
        if (onFinished != null) onFinished();
      }
    });
  }

  void stop() {
    _timer?.cancel();
    notifyListeners();
  }

  void reset() {
    stop();
    _remainingSeconds = focusSeconds;
    notifyListeners();
  }

 /// UPDATE DURASI FOKUS & BREAK
void updateTimers({required int focusMinutes, required int breakMinutes}) {
  // batasi maksimum 120 menit
  focusMinutes = focusMinutes.clamp(1, 120);
  breakMinutes = breakMinutes.clamp(1, 120);

  focusSeconds = focusMinutes * 60;
  breakSeconds = breakMinutes * 60;

  // Reset timer utama ke durasi baru
  reset();
}
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
