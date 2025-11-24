import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fokusku/tamandantelur/tamandantelurfokus.dart';
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

  @override
  void initState() {
    super.initState();
    timer = widget.timerService;
    timer.startMainTimer(); // mulai timer fokus sesuai durasi di service
  }

  @override
  void dispose() {
    timer.stop(); // hentikan timer saat keluar halaman
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEFD9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
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
                const SizedBox(height: 127),
                Center(
                  child: AnimatedBuilder(
                    animation: timer,
                    builder: (_, __) {
                      return TamandantelurFokus(
                        remainingseconds: timer.seconds,
                        totalseconds: timer.focusSeconds,
                      );
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
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff182E19),
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
