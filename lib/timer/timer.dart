import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fokusku/notif/foreground_service.dart';
import 'package:fokusku/notif/notif.dart';



class TimerService extends ChangeNotifier {
  int _remainingSeconds = 0;
  Timer? _timer;

  DateTime? _endTime;
  Timer? _ticker;

 
  // int focusSeconds = 1500; 
  // int breakSeconds = 300;  
  // int longBreakSeconds = 900; 
  // int babak = 4; 

  int focusSeconds = 20; 
  int breakSeconds = 20;  
  int longBreakSeconds = 20; 
  int babak = 1; 

  bool isFocus = true;

  int step = 1;

  int get seconds => _remainingSeconds;

  bool get isLastBabak {
  int currentBabak = (step + 1) ~/ 2;
  return currentBabak == babak;
}

 int getMinPhase(int babak) {
  switch (babak) {
    case 1: return 0;
    case 2: return 2;
    case 3: return 3;
    case 4: return 4;
    default: return 0;
  }
}

int getMaxPhase(int babak) {
  switch (babak) {
    case 1: return 1;
    case 2: return 2;
    case 3: return 3;
    case 4: return 5;
    default: return 0;
  }
}

bool tunggureward = false;
bool get isLongBreakFinished => !isFocus && _remainingSeconds == 0;

 

//   String get currentSessionLabel {
//   return isFocus ? "Waktu Fokus" : "Waktu Istirahat";
// }

String get currentSessionLabel {
  if (!sesiFokusAktif) return "Sesi belum dimulai";

  return isFocus ? "Waktu Fokus" : "Waktu Istirahat";
}



String get nextSessionLabel {
  if (step < babak * 2 - 1) {
    if (isFocus) {
      return "Selanjutnya: Istirahat pendek";
    } else {
      return "Selanjutnya: Waktu fokus";
    }
  } else if (step == babak * 2 - 1) {
    return "Selanjutnya: Istirahat panjang";
  } else {
    return "Selesai semua sesi";
  }
}

  String get formattedTime {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  String get initialFocusTime {
    final m = focusSeconds ~/ 60;
    return "${m.toString().padLeft(2,'0')}:00";
  }

bool sesiFokusAktif = false;


  void startPomodoro() {
    sesiFokusAktif = true;
    step = 1;
    startNextStep();
  }

  

  void startNextStep() {
   
    if (step <= babak * 2 - 1) {
      if (step % 2 == 1) {
        startFocus();
      } else {
        startShortBreak();
      }
    } 
    
    else {
      startLongBreak();
    }
  }

 void startFocus() {
  if (!sesiFokusAktif) return; 
  isFocus = true;

  ForegroundService.start(focusSeconds);
  Notif.showFocusNotification();

  start(
    seconds: focusSeconds,
    onFinished: () {
      step++;
      startNextStep();
    },
  );
}



  void startShortBreak() {
      if (!sesiFokusAktif) return;

    isFocus = false;

  

    start(
      seconds: breakSeconds,
      onFinished: () {
        step++;
        startNextStep();
      },
    );
  }

 

  void startLongBreak() {
  if (!sesiFokusAktif) return;

  isFocus = false;

  start(
    seconds: longBreakSeconds,
    onFinished: () {
      
      if (!sesiFokusAktif) return;

      tunggureward = true;
      Notif.showSessionFinishedNotification();
      Notif.cancelFocusNotification();

      ForegroundService.stop();
      notifyListeners();
      stop();
    },
  );
}



void start({required int seconds, VoidCallback? onFinished}) {
  _endTime = DateTime.now().add(Duration(seconds: seconds));
  _ticker?.cancel();

  _ticker = Timer.periodic(const Duration(milliseconds: 500), (_) {
  final diffMs = _endTime!.difference(DateTime.now()).inMilliseconds;
  final diff = (diffMs / 1000).ceil();

  if (diff > 0) {
    _remainingSeconds = diff;
    notifyListeners();
  } else {
    _remainingSeconds = 0;
    _ticker?.cancel();
    notifyListeners();
    onFinished?.call();
  }
});

}
  void stop() {
    _ticker?.cancel();
    notifyListeners();
  }

  void reset() {
    stop();
    _remainingSeconds = focusSeconds;
    notifyListeners();
  }

  
  void updateTimers({
    required int focusMinutes,
    required int breakMinutes,
    required int longBreakMinutes,
    required int babakCount,
  }) {
    focusSeconds = focusMinutes * 60;
    breakSeconds = breakMinutes * 60;
    longBreakSeconds = longBreakMinutes * 60;
    babak = babakCount;

    reset();
  }

 void terminateSession() {
  _timer?.cancel();
  _remainingSeconds = focusSeconds;
  step = 0;
  sesiFokusAktif = false;
  tunggureward = false;
  notifyListeners();
}



  

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}