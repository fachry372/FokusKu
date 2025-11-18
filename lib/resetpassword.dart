import 'package:flutter/material.dart';
import 'package:fokusku/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';



class Resetpassword extends StatefulWidget {
  const Resetpassword({super.key});



  @override
  State<Resetpassword> createState() => _ResetpasswordScreenState();
  
}

class _ResetpasswordScreenState extends State<Resetpassword> {

 final authservice = AuthService();

  TextEditingController email = TextEditingController();
  TextEditingController katasandi = TextEditingController();
  TextEditingController kkatasandi = TextEditingController();





  bool isenabled = false;

 @override
  void initState () {
    super.initState();
    
    email.addListener(checkform);
    katasandi.addListener(checkform);
    kkatasandi.addListener(checkform);
  }

  void checkform () {
    setState(() {
      isenabled = email.text.isNotEmpty && katasandi.text.isNotEmpty && kkatasandi.text.isNotEmpty;
    });
  }

  


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
          Text("Reset Kata Sandi",style: GoogleFonts.inter(fontSize: 32,fontWeight: FontWeight.bold),),

          const SizedBox(height: 42.0),
          
         
          
            Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 43.0),
              child: Text("Kata sandi baru:",style: GoogleFonts.inter(fontSize: 18),textAlign: TextAlign.left,),
            ),
            
          ),

          const SizedBox(height: 5.0),

          SizedBox(
            height: 50,
            width: 400,
            child: Padding(padding: EdgeInsets.only(left: 44.0,right: 44.0),
            
            child: 
            TextField(
              controller: katasandi,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffffffff),
                
                 hintStyle: GoogleFonts.inter(color: Color.fromARGB(255, 165, 165, 165)),
                border: OutlineInputBorder(
                  
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 148, 150, 147)),
                  borderRadius: BorderRadius.circular(15)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 68, 161, 68)),
                  borderRadius: BorderRadius.circular(15)
                ),
            
              ),
              cursorColor: Color.fromARGB(255, 68, 161, 68),
            ),
            ),
          ),

          const SizedBox(height: 15.0),
            Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 43.0),
              child: Text("Konfirmasi Kata sandi :",style: GoogleFonts.inter(fontSize: 18),textAlign: TextAlign.left,),
            ),
            
          ),

          const SizedBox(height: 5.0),

          SizedBox(
            height: 50,
            width: 400,
            child: Padding(padding: EdgeInsets.only(left: 44.0,right: 44.0),
            
            child: 
            TextField(
              controller: kkatasandi,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffffffff),
                
               
                border: OutlineInputBorder(
                  
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 148, 150, 147)),
                  borderRadius: BorderRadius.circular(15)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 68, 161, 68)),
                  borderRadius: BorderRadius.circular(15)
                ),
            
              ),
              cursorColor: Color.fromARGB(255, 68, 161, 68),
            ),
            ),
          ),
          const SizedBox(height: 41.0,),

          ElevatedButton(
  onPressed: isenabled
      ? () {} : null,
  style: ElevatedButton.styleFrom(
    backgroundColor: isenabled ? Color(0xFF52B755) : Color(0xFFA2B9A3),
    fixedSize: const Size(280, 51),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
  ),
  child: Text(
    "Reset",
    style: GoogleFonts.inter(
      fontSize: 24,
      color: Color(0xffffffff),
    ),
  ),
),

        ],

        
      ),
        )
      
    );
  }
}