import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEFD9),
    
      body: Center(
        child: SafeArea(
        
            child: Padding(
              padding: const EdgeInsets.only(left: 32,right: 32),
              child: Column(
                children: [
                  const SizedBox(height: 106,),
                      
                  Text("Mulai Fokus!",style: GoogleFonts.inter(fontSize: 20,color: Color(0xff182E19)),),
                   
                   const SizedBox(height: 55,),
              
                   SizedBox(
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
                     ),
                   
                   const SizedBox(height: 0,),

                  Text("25:00",style:  GoogleFonts.roboto(fontSize: 70,fontWeight: FontWeight.w300,color: Color(0xff182E19),height: 0.8),),
                    
                     const SizedBox(height: 25),

                     ElevatedButton(onPressed: () {},
                     style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff52B755),
                      fixedSize: Size(162, 43),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20)
                      )
                     ),
                     child: Text("Mulai",style: GoogleFonts.inter(fontSize: 28,color: Color(0xffffffff)),))
                
                  
                ],
              ),
            ),
            
            ),
      ),

   
      );
   
  }
}
