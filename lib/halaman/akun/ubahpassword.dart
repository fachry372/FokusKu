import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Ubahpassword extends StatefulWidget {
  const Ubahpassword({super.key});

  @override
  State<Ubahpassword> createState() => _UbahpasswordState();
}

class _UbahpasswordState extends State<Ubahpassword> {
  final _formKey = GlobalKey<FormState>();


  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
final TextEditingController _confirmPasswordController = TextEditingController();


  bool isEnabled = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(checkFields);
    _newPasswordController.addListener(checkFields);
_confirmPasswordController.addListener(checkFields);

  }

@override
void dispose() {
 
  _passwordController.dispose();
  _newPasswordController.dispose();
  _confirmPasswordController.dispose();
  super.dispose();
}

  void checkFields() {
    setState(() {
      isEnabled = _passwordController.text.isNotEmpty && _newPasswordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty;
          
    });
  }

  Future<void> updatePassword() async {
    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // simulasi API

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Email berhasil diperbarui")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color(0xFFEAEFD9),
     appBar: AppBar(
      title: Text("Ubah Kata Sandi",style: GoogleFonts.inter(color: Color(0xff293329),fontSize: 20 ,fontWeight: FontWeight.w500),),
      centerTitle: true,
     ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
  Text(
    "Untuk mengganti kata sandi , silakan masukkan kata sandi lama Anda , lalu buat kata sandi baru pada kolom di bawah ini.",
    style: GoogleFonts.inter(
      fontSize: 14,
      color: const Color(0xff606C60),
    ),
  ),

  const SizedBox(height: 20),

  
  Text("Kata sandi lama:", style: GoogleFonts.inter(fontSize: 18)),
  const SizedBox(height: 6),

  TextFormField(
    controller: _passwordController,
    obscureText: true,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
          border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 148, 150, 147)),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 68, 161, 68)),
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    cursorColor: const Color.fromARGB(255, 68, 161, 68),

    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Kata sandi lama tidak boleh kosong";
      }
      return null;
    },
  ),

  const SizedBox(height: 20),


  Text("Kata sandi baru:", style: GoogleFonts.inter(fontSize: 18)),
  const SizedBox(height: 6),

  TextFormField(
    controller: _newPasswordController,
    obscureText: true,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
    
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 148, 150, 147)),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 68, 161, 68)),
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    cursorColor: const Color.fromARGB(255, 68, 161, 68),

    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Kata sandi baru tidak boleh kosong";
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

  const SizedBox(height: 20),

  
  Text("Konfirmasi kata sandi baru:", style: GoogleFonts.inter(fontSize: 18)),
  const SizedBox(height: 6),

  TextFormField(
    controller: _confirmPasswordController,
    obscureText: true,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
          border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 148, 150, 147)),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 68, 161, 68)),
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    cursorColor: const Color.fromARGB(255, 68, 161, 68),

    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Konfirmasi kata sandi tidak boleh kosong";
      }
      if (value != _newPasswordController.text) {
        return "Konfirmasi kata sandi tidak cocok";
      }
      return null;
    },
  ),

  const SizedBox(height: 32),

  // Tombol Simpan
  Center(
    child: ElevatedButton(
      onPressed: isEnabled && !isLoading
          ? () {
              if (_formKey.currentState!.validate()) {
                updatePassword();
              }
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled
            ? const Color(0xFF52B755)
            : const Color(0xFFA2B9A3),
        fixedSize: const Size(280, 51),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          : Text(
              "Simpan",
              style: GoogleFonts.inter(
                  fontSize: 24, color: Colors.white),
            ),
    ),
  ),
]

              ),
            ),
          ),
        ),
      ),
    );
  }
}