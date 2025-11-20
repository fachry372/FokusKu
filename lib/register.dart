import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'auth/auth_service.dart';


class Register extends StatefulWidget {
  const Register({super.key});



  @override
  State<Register> createState() => _RegisterScreenState();
  
}

class _RegisterScreenState extends State<Register> {
   final _formKey = GlobalKey<FormState>();
   final authservice = AuthService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasipasswordController = TextEditingController();
 

    void signUp() async {
      if (!mounted) return;

      setState(() =>  isLoading = true);

    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final konfirmasi = _konfirmasipasswordController.text;

    if (password != konfirmasi) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kata sandi tidak cocok!")));
      return;
    }

    try {
      await  authservice.signUpWithEmailPassword(name,email, password,);

       if (!mounted) return;

    
    Navigator.pushReplacementNamed(context, "/home");
    } 

    catch (e) {
      if (!mounted) return;

       String errorMessage;

  if (e.toString().contains("User already registered")) {
    errorMessage = "Pendaftaran gagal ,Akun sudah ada.";
  } else  if (e.toString().contains("Unable to validate email address")) {
    errorMessage = "Format Email tidak valid .";
  }
  else {
    errorMessage = "Terjadi kesalahan, coba lagi nanti.";
  }

        ScaffoldMessenger.of(context).clearSnackBars();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage),));
       
    }finally{
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
  
  bool isLoading = false;
  bool isenabled = false;

 @override
  void initState () {
    super.initState();
    _nameController.addListener(checkform);
    _emailController.addListener(checkform);
    _passwordController.addListener(checkform);
    _konfirmasipasswordController.addListener(checkform);
  }

  void checkform () {
    setState(() {
      isenabled = _nameController.text.isNotEmpty && _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty && _konfirmasipasswordController.text.isNotEmpty;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEFD9),
     
      body: SafeArea(
        child:
         SingleChildScrollView(
        
        child: 
        Form(
          
          key: _formKey,

          child: 
        Column(
        
        children: [
          const SizedBox(height: 16.0),

          Center(
            child: Image.asset("assets/images/logo.png",height: 141,width: 141,),
          ),
          
          const SizedBox(height: 16.0),
          Text("Daftar",style: GoogleFonts.inter(fontSize: 32,fontWeight: FontWeight.bold),),

          const SizedBox(height: 16.0),

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 43.0),
              child: Text("Username:",style: GoogleFonts.inter(fontSize: 18),textAlign: TextAlign.left,),
            ),
            
          ),

          const SizedBox(height: 5.0),

          SizedBox(
             
             width: 400,
            child: Padding(padding: EdgeInsets.only(left: 44.0,right: 44.0),
            
            child: 
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              maxLength: 20,
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

                final text = value ?? "";

                if (text.trim().isEmpty) {
          return "Username tidak boleh kosong";
                }
                
                if (text.length > 20) {
          return "Username maksimal 20 karakter";
                }
                return null;
              },
            ),
            ),
          ),
          const SizedBox(height: 10.0),
          
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 43.0),
              child: Text("Email:",style: GoogleFonts.inter(fontSize: 18),textAlign: TextAlign.left,),
            ),
            
          ),

          const SizedBox(height: 5.0),

          SizedBox(
            
            width: 400,
            child: Padding(padding: EdgeInsets.only(left: 44.0,right: 44.0),
            
            child: 
            TextFormField(
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
                if (!value.contains("@gmail.com") ) {
          return "Email Harus mengandung @gmail.com";
          
                }
               
                return null;
              },
            ),
            ),
          ),
          const SizedBox(height: 10.0),
            Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 43.0),
              child: Text("Kata sandi :",style: GoogleFonts.inter(fontSize: 18),textAlign: TextAlign.left,),
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

          const SizedBox(height: 10.0),
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
          const SizedBox(height: 16.0,),

           ElevatedButton(
            onPressed: isenabled && !isLoading ? () {if (_formKey.currentState!.validate()
            ) {
              signUp();
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
            "Daftar",
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
                  text: 'Sudah punya akun ? ', 
                  
                  ),
                  WidgetSpan(child: SizedBox(width: 10,)),
                TextSpan(
                  text: 'Masuk',
                  style: GoogleFonts.inter(fontSize: 14,color: Color(0xff52B755),
                                  
                  ),
                  recognizer: TapGestureRecognizer()
                  ..onTap = () {
                   Navigator.pushReplacementNamed(context, "/Masuk");
                  },
                ),
              ],
              ),
              ),
            ),
            
          ),

          const SizedBox(height: 20,)

        ],

        
      ),
        )
      )
      )
    );
  }
}