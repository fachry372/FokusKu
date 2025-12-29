import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fokusku/notif/foreground_service.dart';
import 'package:fokusku/notif/notif.dart';



class TimerService extends ChangeNotifier {
  int _remainingSeconds;

  TimerService() : _remainingSeconds = 1500;

  int _sessionId = 0;
  Timer? _timer;

 
  int focusSeconds = 1500; 
  int breakSeconds = 300;  
  int longBreakSeconds = 900; 
  int babak = 4; 
  

  // int focusSeconds = 20; 
  // int breakSeconds = 20;  
  // int longBreakSeconds = 20; 
  // int babak = 1; 


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
      if (sesiFokusAktif) return;

    sesiFokusAktif = true;
    step = 1;
    startNextStep();
  }

  

  void startNextStep() {
     if (!sesiFokusAktif) return;
   
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
  _timer?.cancel();

  _sessionId++; 
  final int currentSession = _sessionId;

  _remainingSeconds = seconds;
  notifyListeners();

  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (currentSession != _sessionId || !sesiFokusAktif) {
      timer.cancel();
      return;
    }

    if (_remainingSeconds > 0) {
      _remainingSeconds--;
      notifyListeners();
    } else {
      timer.cancel();
      onFinished?.call();
    }
  });
}


 void stop() {
  _timer?.cancel();
  _timer = null;
  notifyListeners();
}



  void reset() {
  _sessionId++;
  _timer?.cancel();
  _timer = null;

  step = 1;
  isFocus = true;
  sesiFokusAktif = false;
  tunggureward = false;
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

  void _killSession() {
 
  _timer?.cancel();
  _timer = null;

  ForegroundService.stop();
  Notif.cancelFocusNotification();
}


void terminateSession() {
  _killSession();

  sesiFokusAktif = false;
  tunggureward = false;
  isFocus = true;
  step = 0;

  _remainingSeconds = focusSeconds;

  notifyListeners();
}



  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}