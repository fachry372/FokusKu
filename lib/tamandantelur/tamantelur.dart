import 'package:flutter/material.dart';

class Tamantelur extends StatefulWidget {
  const Tamantelur({super.key});

  @override
  State<Tamantelur> createState() => _TamantelurState();
}

class _TamantelurState extends State<Tamantelur> {
  
  @override
  Widget build(BuildContext context) {
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
                            top: 60,
                            child: Image.asset("assets/images/telur.png",
                          fit: BoxFit.contain,
                          height: 80,
                          width: 61,
                          
                          ),),
                          
                        ],
                        
                      ),                     
                     );
  }
}