import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Ubahemail extends StatefulWidget {
  const Ubahemail({super.key});

  @override
  State<Ubahemail> createState() => _UbahemailState();
}

class _UbahemailState extends State<Ubahemail> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isEnabled = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Listener: aktifkan tombol jika kedua field terisi
    _emailController.addListener(checkFields);
    _passwordController.addListener(checkFields);
  }

  void checkFields() {
    setState(() {
      isEnabled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  Future<void> updateEmail() async {
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
        title: Text(
          "Ubah Email",
          style: GoogleFonts.inter(
              color: const Color(0xff293329),
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
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
                    "Untuk mengganti email, silakan masukkan email baru dan kata sandi Anda pada kolom di bawah ini.",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xff606C60),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text("Email:", style: GoogleFonts.inter(fontSize: 18)),

                  const SizedBox(height: 6),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    
                      hintStyle: GoogleFonts.inter(
                          color: const Color.fromARGB(255, 165, 165, 165)),
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
                        return "Email tidak boleh kosong";
                      }
                      if (!value.contains("@gmail.com")) {
                        return "Email harus mengandung @gmail.com";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  Text("Kata sandi:", style: GoogleFonts.inter(fontSize: 18)),

                  const SizedBox(height: 6),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      
                      hintStyle: GoogleFonts.inter(
                          color: const Color.fromARGB(255, 165, 165, 165)),
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
                      errorMaxLines: 2,
                    ),
                    cursorColor: const Color.fromARGB(255, 68, 161, 68),

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

                  const SizedBox(height: 32),

                  Center(
                    child: ElevatedButton(
                      onPressed: isEnabled && !isLoading
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                updateEmail();
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
