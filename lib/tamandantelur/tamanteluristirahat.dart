import 'package:flutter/material.dart';

class TamanDanTelurIstirahat extends StatelessWidget {
  const TamanDanTelurIstirahat({super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 284.97,
      width: 356,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: Image.asset(
              "assets/images/rumput.png",
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 25,
            child: Image.asset(
              "assets/images/istirahat.png", 
              height: 135,
              
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
