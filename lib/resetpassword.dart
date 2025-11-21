import 'package:flutter/material.dart';
import 'package:fokusku/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';



class Resetpassword extends StatefulWidget {
  const Resetpassword({super.key});



  @override
  State<Resetpassword> createState() => _ResetpasswordScreenState();
  
}

class _ResetpasswordScreenState extends State<Resetpassword> {

 final _formKey = GlobalKey<FormState>();
 final authservice = AuthService();



  final _passwordController = TextEditingController();
  final _konfirmasipasswordController = TextEditingController();




  bool isLoading = false;
  bool isenabled = false;

 void reset() async {
  if (!mounted) return;

  if (_passwordController.text != _konfirmasipasswordController.text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Password tidak sama")));
    return;
  }

  setState(() => isLoading = true);

  final password = _passwordController.text.trim();

  try {
    await authservice.updatePassword(password);

    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password berhasil diubah")),
    );

   
    Navigator.pushReplacementNamed(context, '/Masuk');

  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error: $e")));
  } finally {
    if (mounted) setState(() => isLoading = false);
  }
}


 @override
  void initState () {
    super.initState();
    
   
    _passwordController.addListener(checkform);
    _konfirmasipasswordController.addListener(checkform);
  }

  void checkform () {
    setState(() {
      isenabled = _passwordController.text.isNotEmpty && _konfirmasipasswordController.text.isNotEmpty;
    });
  }

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEFD9),
     
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
           
            width: 400,
            child: Padding(padding: EdgeInsets.only(left: 44.0,right: 44.0),
            
            child: 
            TextFormField(
              controller: _passwordController,
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
                errorMaxLines: 2,
              ),
              cursorColor: Color.fromARGB(255, 68, 161, 68),

               validator: (value) {
                if (value == null || value.isEmpty) {
          return "Kata sandi tidak boleh kosong";
                }
                if (value.contains(" ") || value.contains(".")) {
          return "Kata sandi tidak boleh mengandung spasi atau titik";
          
                }
                if (value.length < 6) {
          return "Kata sandi minimal 6 karakter";
                }
                return null;
              },
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
            
            width: 400,
            child: Padding(padding: EdgeInsets.only(left: 44.0,right: 44.0),
            
            child: 
            TextFormField(
              controller: _konfirmasipasswordController,
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

               validator: (value) {
                if (value == null || value.isEmpty) {
          return "Kata sandi tidak boleh kosong";
                }
                if (value != _passwordController.text) {
          return "Kata sandi tidak cocok";
          
                }
                
                return null;
              },
            ),
            ),
          ),
          const SizedBox(height: 41.0,),

            ElevatedButton(
            onPressed: isenabled && !isLoading ? () {if (_formKey.currentState!.validate()
            ) {
             reset ();
            }} : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isenabled ? Color(0xFF52B755) : Color(0xFFA2B9A3),
              padding: EdgeInsets.only(left: 45.0, right: 45.0),
              fixedSize: const Size(280, 51),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: isLoading
                ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          )
                : Text(
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
      
      )
    );
  }
}