import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fokusku/auth/riwayatkoleksi.dart';
import 'package:fokusku/notif/foreground_service.dart';
import 'package:fokusku/notif/notif.dart';
import 'package:fokusku/tamandantelur/tamandantelurfokus.dart';
import 'package:fokusku/tamandantelur/tamanteluristirahat.dart';
import 'package:fokusku/timer/timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class Sesifokus extends StatefulWidget {
  final TimerService timerService;

  const Sesifokus({super.key, required this.timerService});

  @override
  State<Sesifokus> createState() => _SesifokusState();
}

class _SesifokusState extends State<Sesifokus> with WidgetsBindingObserver {
  late TimerService timer;
  bool rewardShown = false;
  bool sessionCompleted = false;
  DateTime? sessionStartTime;

  static const MethodChannel _channel = MethodChannel('focus_session');
   bool _focusSessionActive = false;

  @override
void initState() {
  super.initState();

  WidgetsBinding.instance.addObserver(this);

  _channel.invokeMethod('setFocusActive', true); 

  _channel.setMethodCallHandler((call) async {
    if (call.method == 'user_left_app') {
      _onUserLeftApp();
    }
  });
  timer = widget.timerService;

  timer.reset();
  sessionStartTime = DateTime.now();
  sessionCompleted = false;
  rewardShown = false;


  timer.startPomodoro();
  _focusSessionActive = true;

  timer.addListener(_checkReward);
}


  @override
  void dispose() {
      _channel.invokeMethod('setFocusActive', false); 
  _channel.setMethodCallHandler(null);
    _focusSessionActive = false; 
    WidgetsBinding.instance.removeObserver(this);

    timer.removeListener(_checkReward);
    timer.stop();
 

    super.dispose();
  }


Future<void> _endFocusSession({bool selesai = false}) async {
  if (!_focusSessionActive) return;

  _focusSessionActive = false;

  try {
    await _channel.invokeMethod('setFocusActive', false);
  } catch (_) {}

  timer.terminateSession();
  await ForegroundService.stop();
  Notif.cancelFocusNotification();
  sessionCompleted = true;

  if (selesai) {
    await simpantimer();
  }
}


void _onUserLeftApp() async {
  if (!mounted) return;
  if (!_focusSessionActive) return;
  if (sessionCompleted) return;

 Notif.showFocusEndedNotification();
  await _endFocusSession();
 

  if (mounted) {
    Navigator.pushReplacementNamed(context, '/home');
  }
}


  Future<void> simpantimer() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    await Supabase.instance.client.from('timer').insert({
      'user_id': user.id,

      'started_at': sessionStartTime?.toIso8601String(),
      'ended_at': DateTime.now().toIso8601String(),

      'durasi_fokus': timer.focusSeconds ~/ 60,
      'durasi_istirahat': timer.breakSeconds ~/ 60,
      'durasi_istirahat_panjang': timer.longBreakSeconds ~/ 60,
      'jumlah_sesi': timer.babak,
      'selesai': true,
    });
  }

  void _checkReward() {
  if (!timer.sesiFokusAktif) return;
  if (!timer.tunggureward || rewardShown || !mounted) return;

  rewardShown = true;

  int babak = (timer.step + 1) ~/ 2;
  int rewardPhase = timer.getMaxPhase(babak);

  final dummyAyam = TamandantelurFokus(
    remainingseconds: 0,
    totalseconds: 1,
    babak: babak,
    timerService: timer,
  );

  
  SchedulerBinding.instance.addPostFrameCallback((_) async {
    if (!mounted) return;

    
    showRewardDialog(context, timer);

    sessionCompleted = true;

    await simpantimer();

    timer.tunggureward = false;
    Notif.cancelFocusNotification();
    await ForegroundService.stop();

    await RewardService.save(
      menitFokus: ((timer.focusSeconds ~/ 60) * timer.babak),
      faseAyam: rewardPhase,
      rewardImage: dummyAyam.pertumbuhanayam[rewardPhase].split("/").last,
    );
  });
}

  Future<bool> _konfirmasikeluar() async {
    if (timer.isLongBreakFinished) {
      return true;
    }
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFE6F2E6),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),

          title: Center(
            child: Text(
              "Yakin Menyerah?",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: const Color(0xFF182E19),
              ),
            ),
          ),

          content: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              "Kalau kamu menyerah sekarang, sesi fokus akan berhenti. ",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF4E574E),
                height: 1.4,
              ),
            ),
          ),

          actionsPadding: const EdgeInsets.all(20),

          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 100, 88, 88),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      "Menyerah",
                      style: GoogleFonts.inter(
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF52B755),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      "Lanjut",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void showRewardDialog(BuildContext context, TimerService timer) {
    int babak = (timer.step + 1) ~/ 2;

    int rewardPhase = timer.getMaxPhase(babak);

    String rewardImage = TamandantelurFokus(
      remainingseconds: 0,
      totalseconds: 1,
      babak: babak,
      timerService: timer,
    ).pertumbuhanayam[rewardPhase];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFE6F2E6),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),

        title: Center(
          child: Text(
            "Selamat!",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Kamu telah menyelesaikan sesi $babak",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
            ),

            const SizedBox(height: 20),

            Image.asset(
              rewardImage,
              width: 140,
              height: 140,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),
          ],
        ),

        actionsPadding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),

        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                timer.stop();

                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }

                Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF52B755),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                "Selesai",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        bool keluar = await _konfirmasikeluar();

          if (keluar) {
     _endFocusSession();
      SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.pop(context);
    });
  }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEAEFD9),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () async {
  bool keluar = await _konfirmasikeluar();
  if (keluar) {
     _endFocusSession();
         SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.pop(context);
    });
  }
},

                    icon: SvgPicture.asset(
                      "assets/icons/close.svg",
                      height: 33,
                      width: 33,
                    ),
                  ),
                  const SizedBox(height: 56),

                  Center(
                    child: AnimatedBuilder(
                      animation: timer,
                      builder: (_, __) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              timer.currentSessionLabel,
                              style: GoogleFonts.inter(
                                fontSize: 27,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff182E19),
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              timer.nextSessionLabel,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff6A756A),
                              ),
                            ),

                            const SizedBox(height: 6),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffDDE4C7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Sesi ${(timer.step + 1) ~/ 2} / ${timer.babak}",
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff4E574E),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),
                  Center(
                    child: AnimatedBuilder(
                      animation: timer,
                      builder: (_, __) {
                        return timer.isFocus
                            ? TamandantelurFokus(
                                remainingseconds: timer.seconds,
                                totalseconds: timer.focusSeconds,
                                babak: (timer.step + 1) ~/ 2,
                                timerService: timer,
                              )
                            : const TamanDanTelurIstirahat();
                      },
                    ),
                  ),
                  const SizedBox(height: 0),
                  Center(
                    child: AnimatedBuilder(
                      animation: timer,
                      builder: (_, __) {
                        return Text(
                          timer.formattedTime,
                          style: GoogleFonts.roboto(
                            fontSize: 70,
                            fontWeight: FontWeight.w400,
                            height: 0.8,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: ElevatedButton(
                     onPressed: () async {
  bool keluar = await _konfirmasikeluar();
  if (keluar) {
    
     _endFocusSession();
      SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.pop(context);
    });
  }
},


                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffB77227),
                        fixedSize: const Size(162, 33),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Menyerah",
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}