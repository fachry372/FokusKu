import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fokusku/tamandantelur/tamandantelurfokus.dart';
import 'package:fokusku/tamandantelur/tamanteluristirahat.dart';
import 'package:fokusku/timer/timer.dart';
import 'package:google_fonts/google_fonts.dart';


class Sesifokus extends StatefulWidget {
  final TimerService timerService;

  const Sesifokus({super.key, required this.timerService});

  

  @override
  State<Sesifokus> createState() => _SesifokusState();
}

class _SesifokusState extends State<Sesifokus> {
  late TimerService timer;
  bool rewardShown = false;


  void showRewardDialog(BuildContext context, TimerService timer) {
  int babak = (timer.step + 1) ~/ 2;

  // Tentukan fase reward berdasarkan babak
  int rewardPhase = timer.getMaxPhase(babak);

  // Ambil gambar
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
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
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
          "Kamu telah menyelesaikan Babak $babak",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 20),

        // GAMBAR REWARD
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

            timer.tunggureward = false;
            timer.step++;
            timer.startNextStep();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF52B755),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: Text(
            "Lanjut Istirahat",
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
  void initState() {
    super.initState();
    timer = widget.timerService;
    timer.startPomodoro(); 
  }

  @override
  void dispose() {
    timer.stop(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEFD9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
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
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xffDDE4C7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Babak ${(timer.step + 1) ~/ 2} / ${timer.babak}",
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

                         // CEK: waktunya habis + ini babak terakhir + belum ditampilkan sebelumnya
                        if (timer.seconds == 0 && timer.isLastBabak && !rewardShown) {
                          rewardShown = true;
                          Future.microtask(() {
                            if (!mounted) return;
                             showRewardDialog(context, timer);
                          });
                        }

                        return timer.isFocus
                            ? TamandantelurFokus(
                                remainingseconds: timer.seconds,
                                totalseconds: timer.focusSeconds,
                                babak: (timer.step + 1) ~/ 2,
                                timerService: timer,
                                
                              )
                            : 
                            const TamanDanTelurIstirahat();
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
                    onPressed: () {
                      timer.stop();
                      Navigator.pop(context);
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
                            fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
