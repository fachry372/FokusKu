import 'package:flutter/material.dart';
import 'package:fokusku/timer/timer.dart';

class TamandantelurFokus extends StatelessWidget {

  final TimerService timerService;

TamandantelurFokus({
  super.key,
  required this.remainingseconds,
  required this.totalseconds,
  required this.babak,
  required this.timerService,
});

  
  final int remainingseconds;
  final int totalseconds;
  final int babak;

  

  

  final List<String> pertumbuhanayam = [
    "assets/images/Telur.png",
    "assets/images/Telur retak.png",
    "assets/images/Menetas.png",
    "assets/images/Anak ayam.png",
    "assets/images/Ayam pra-dewasa.png",
    "assets/images/Ayam dewasa.png",
  ];

  final List<Size> ukurangambar = [
    Size(61, 80),
    Size(61, 80),
    Size(61, 80),
    Size(61, 80),
    Size(61, 80),
    Size(80, 135),
  ];

  final List<Offset> posisiGambar = [
    Offset(0, -45),
    Offset(0, -45),
    Offset(0, -45),
    Offset(0, -45),
    Offset(0, -45),
    Offset(0, -55), 
  ];





int hitungFaseAyam(double progress, int babak) {
  int min = timerService.getMinPhase(babak);
  int max = timerService.getMaxPhase(babak);

  int fase = (progress * (max - min )).round() + min;
  return fase.clamp(min, max);
}




  @override
  Widget build(BuildContext context) {
   double progress = (1 - (remainingseconds / totalseconds)).clamp(0.0, 0.9999);

  int fase = hitungFaseAyam(progress, babak);

    return SizedBox(
                      height: 284.97,
                      width: 356,
                      child: Stack(
                        alignment: 
                        Alignment.center,
                        children: [
                          Positioned(child: Image.asset("assets/images/rumput.png",
                          fit: BoxFit.contain,
                          ),
                          
                          ),
                          Positioned(
                            child: Transform.translate(offset: posisiGambar[fase],
                            child: AnimatedSwitcher(duration: const Duration(milliseconds: 500),
                            child: Image.asset(pertumbuhanayam[fase],
                            key: ValueKey<String>(pertumbuhanayam[fase]),
                          fit: BoxFit.contain,
                          height: ukurangambar[fase].height,
                          width: ukurangambar[fase].width,
                            )
                          ),
                          ),
                          )
                        ],
                        
                      ),                     
                     );
  }
}