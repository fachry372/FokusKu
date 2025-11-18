import 'package:flutter/material.dart';
import 'package:fokusku/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});



  @override
  State<LoginScreen> createState() => _LoginScreenState();
  
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  final authservice = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  

  bool isLoading = false;


void login() async {
  if (!mounted) return;

  setState(() => isLoading = true);

  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();

  try {
    await authservice.signInWithEmailPassword(email, password);

    if (!mounted) return;

    
    Navigator.pushReplacementNamed(context, "/home");
  } catch (e) {
    if (!mounted) return;

      String errorMessage;

  if (e.toString().contains("Invalid login credentials")) {
    errorMessage = "Login gagal ,Email atau kata sandi salah.";
  } else {
    errorMessage = "Terjadi kesalahan, coba lagi nanti.";
  }


    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(errorMessage)));
  } finally {
    if (mounted) {
      setState(() => isLoading = false);
    }
  }
}




  bool isenabled = false;
 
  

 @override

  void initState () {
    super.initState();
    _emailController.addListener(checkform);
    _passwordController.addListener(checkform);
  }

  void checkform () {
    setState(() {
      isenabled = _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEFD9),
     
      body: SingleChildScrollView(
        child: 
        Form(
          key: _formKey,
          child: Column(
          
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
                child: Text("Email:",style: GoogleFonts.inter(fontSize: 18),textAlign: TextAlign.left,),
              ),
              
            ),
          
            const SizedBox(height: 5.0),
          
            Padding(padding: EdgeInsets.only(left: 44.0,right: 44.0),
            
            child: 
            Column(
              children: [
                SizedBox(
                  
                  width: 400,
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
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
                          return "Email tidak boleh kosong";
                    }
                    if (!value.contains("@gmail.com")) {
                          return "Email harus mengandung @gmail.com";
                    }
                    return null;
                     },
                     
                  ),
                  
                ),

              ],
              
            ),
            ),
            const SizedBox(height: 15.0),
              Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 43.0),
                child: Text("Kata sandi :",style: GoogleFonts.inter(fontSize: 18),textAlign: TextAlign.left,),
              ),
              
            ),
          
            const SizedBox(height: 5.0),
          
            Padding(padding: EdgeInsets.only(left: 44.0,right: 44.0),
            
            child: 
            SizedBox(
              
              width: 400,
              child: TextFormField(
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
          
            const SizedBox(height: 15,),
            
             Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 43.0),
                child: RichText(textAlign: TextAlign.right,
                text: TextSpan(style: GoogleFonts.inter(fontSize: 14,color: Color(0xff5E695E)),
                children: [
                  TextSpan(
                    text: 'Lupa kata sandi ?',
                    style: GoogleFonts.inter(fontSize: 14,color:Color(0xff52B755),
                                    
                    ),
                    recognizer: TapGestureRecognizer()
                    ..onTap = () {
                     Navigator.pushNamed(context, "/kirim");
                    },
                  ),
                ],
                ),
                ),
              ),
              
            ),
            const SizedBox(height: 40.0,),
          
           ElevatedButton(
            onPressed: isenabled && !isLoading ? () {if (_formKey.currentState!.validate()
            ) {
              login();
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
            "Masuk",
            style: GoogleFonts.inter(
              fontSize: 24,
              color: Color(0xffffffff),
            ),
          ),
          ),
          
          
             const SizedBox(height: 20,),
            
             Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(),
                child: RichText(textAlign: TextAlign.center,
                text: TextSpan(style: GoogleFonts.inter(fontSize: 14,color: Color(0xff5E695E)),
                children: [
                  const TextSpan(
                    text: 'Belum punya akun ?',
                    ),
                    WidgetSpan(child: SizedBox(width: 10,)),
                  TextSpan(
                    text: 'Daftar',
                    style: GoogleFonts.inter(fontSize: 14,color: Color(0xff52B755),
                                    
                    ),
                    recognizer: TapGestureRecognizer()
                    ..onTap = () {
                     Navigator.pushReplacementNamed(context, "/Daftar");
                    },
                  ),
                ],
                ),
                ),
              ),
              
            ),
          
                 
          ],
          
          
                ),
        ),
        )
      
    );
  }
}