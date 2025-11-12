import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEFD9),
     
      body: SingleChildScrollView(
        child: 
        Column(
        
        children: [
          const SizedBox(height: 94.0),

          Center(
            child: Image.asset("assets/images/logo.png",height: 141,width: 141,),
          ),
          
          const SizedBox(height: 42.0),
          Text("Masuk",style: GoogleFonts.inter(fontSize: 32,fontWeight: FontWeight.bold),),

          const SizedBox(height: 51.0),
          
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 43.0),
              child: Text("Email:",style: GoogleFonts.inter(fontSize: 20),textAlign: TextAlign.left,),
            ),
            
          ),

          const SizedBox(height: 5.0),

          Padding(padding: EdgeInsets.only(left: 44.0,right: 44.0),
          
          child: 
          TextField(
            keyboardType: TextInputType.emailAddress,
            
            decoration: InputDecoration(
              
              hintText: "Masukkan Email Anda",
              border: OutlineInputBorder(
                
                borderRadius: BorderRadius.all(Radius.circular(15)),
              )
            ),
          ),
          ),
          const SizedBox(height: 15.0),
            Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 43.0),
              child: Text("Password:",style: GoogleFonts.inter(fontSize: 20),textAlign: TextAlign.left,),
            ),
            
          ),

          const SizedBox(height: 5.0),

          Padding(padding: EdgeInsets.only(left: 44.0,right: 44.0),
          
          child: 
          TextField(
            keyboardType: TextInputType.visiblePassword,
            
            decoration: InputDecoration(
              
              hintText: "Masukkan Password Anda",
              border: OutlineInputBorder(
                
                borderRadius: BorderRadius.all(Radius.circular(15)),
              )
            ),
          ),
          ),
          const SizedBox(height: 41.0,),

          ElevatedButton(onPressed: () {}, 
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF52B755),
            padding: EdgeInsets.only(left: 45.0,right: 45.0),
            fixedSize: const Size(280, 61),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)
            )

          ),
          child: Text("Masuk",style: GoogleFonts.inter(fontSize: 24,textStyle: TextStyle(color: Color(0xffffffff))), 
          ),
          
           )
          
        ],

        
      ),
        )
      
    );
  }
}