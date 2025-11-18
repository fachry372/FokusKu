import 'package:flutter/material.dart';
import 'package:fokusku/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class Kirimlink extends StatefulWidget {
  const Kirimlink({super.key});

  @override
  State<Kirimlink> createState() => _KirimlinkState();
}



class _KirimlinkState extends State<Kirimlink> {

  final authservice = AuthService();

  final _emailController = TextEditingController();
  
 
  bool isenabled = false;

 @override
  void initState () {
    super.initState();
    
    _emailController.addListener(checkform);
    
  }

  void checkform () {
    setState(() {
      isenabled = _emailController.text.isNotEmpty ;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEFD9),
      body: SafeArea(
       
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 8),
              child: IconButton(onPressed: (){
                Navigator.pop(context);
              }, 
              icon: Icon(Icons.arrow_back,size: 30,)),
            ),

            const SizedBox(height: 24,),

           Padding(
             padding: const EdgeInsets.only(left: 41 ,right: 10),
             child: Text("Lupa Kata Sandi ?", style:  GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold)),
           ),

          const SizedBox(height: 5,),
          Padding(padding: EdgeInsetsGeometry.only(left: 41 ,right: 20),
          child: Text("Masukkan alamat email yang terdaftar. Kami akan mengirimkan tautan untuk mereset kata sandi Anda.",
          style: GoogleFonts.inter(fontSize: 14,color: Color(0xff606C60)),),
          ),

          const SizedBox(height: 25,),

           
          Padding(padding: EdgeInsets.only(left: 41.0,right: 44.0),
          
          child: 
          SizedBox(
            height: 60,
            width: 400,
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              
              decoration: InputDecoration(
                hintText: "Masukkan Email Anda",
                filled: true,
                fillColor: Color(0xffffffff),
               
                 hintStyle: GoogleFonts.inter(fontSize: 16,color: Color.fromARGB(255, 165, 165, 165)),
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

          const SizedBox(height: 37,),

           Padding(
             padding: const EdgeInsets.only(left: 41, right: 44),
             child: ElevatedButton(onPressed: isenabled  ? () {}: null, 
             style: ElevatedButton.styleFrom(
              backgroundColor: isenabled ? Color(0xFF52B755):Color(0xFFA2B9A3),
             
              fixedSize: const Size(280, 51),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
              )
             
                       ),
                       child: Text("Kirim",style: GoogleFonts.inter(fontSize: 24,textStyle: TextStyle(color: Color(0xffffffff))), 
                       ),
                       
             ),
           ),

          ],

        ),
        
      ),
    );
  }
}
