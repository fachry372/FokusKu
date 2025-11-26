import 'package:flutter/material.dart';

class TamandantelurFokus extends StatelessWidget {
  
  final int remainingseconds;
  final int totalseconds;

   TamandantelurFokus ({
    super.key,
    required this.remainingseconds,
    required this.totalseconds,
  });

  final List<String> pertumbuhanayam = [
    "assets/images/telur.png",
    "assets/images/fase2.png",
    "assets/images/fase3.png",
    "assets/images/fase4.png",
    "assets/images/fase5.png",
    "assets/images/fase6.png",
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


  @override
  Widget build(BuildContext context) {
    double proses = 1 - (remainingseconds / totalseconds);
    int tahap = (proses * 6).clamp(0, 5).toInt();
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
                            child: Transform.translate(offset: posisiGambar[tahap],
                            child: AnimatedSwitcher(duration: const Duration(milliseconds: 500),
                            child: Image.asset(pertumbuhanayam[tahap],
                            key: ValueKey<String>(pertumbuhanayam[tahap]),
                          fit: BoxFit.contain,
                          height: ukurangambar[tahap].height,
                          width: ukurangambar[tahap].width,
                            )
                          ),
                          ),
                          )
                        ],
                        
                      ),                     
                     );
  }
}