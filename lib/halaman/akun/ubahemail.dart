import 'package:flutter/material.dart';
import 'package:fokusku/auth/akun_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Ubahemail extends StatefulWidget {
  const Ubahemail({super.key});

  @override
  State<Ubahemail> createState() => _UbahemailState();
}

class _UbahemailState extends State<Ubahemail> {
  final _formKey = GlobalKey<FormState>();

  final akunservice = AkunService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  User? user = Supabase.instance.client.auth.currentUser;
  String? userId;
  
  
  String emailUser = "";

  bool isEnabled = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkLogin();
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
  if (!mounted) return;

  setState(() => isLoading = true);

  final newEmail = _emailController.text.trim();
  final password = _passwordController.text.trim();

  try {
    final supabase = Supabase.instance.client;
    final currentUser = supabase.auth.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User tidak ditemukan, silakan login ulang")),
      );
      return;
    }

    // Konfirmasi password
    final signInRes = await supabase.auth.signInWithPassword(
      email: currentUser.email!,
      password: password,
    );

    if (signInRes.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password salah!")),
      );
      setState(() => isLoading = false);
      return;
    }

    // Update email di auth
    final updateRes = await supabase.auth.updateUser(
      UserAttributes(email: newEmail),
      );

    if (updateRes.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memperbarui email")),
      );
      setState(() => isLoading = false);
      return;
    }

    // Update juga di tabel users (opsional, untuk UI)
    await supabase.from('users').update({'email': newEmail}).eq('id', currentUser.id);

    // Tampilkan notifikasi verifikasi
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Silakan cek inbox Anda untuk verifikasi email.",
        ),
        duration: Duration(seconds: 5),
      ),
    );

    Navigator.pop(context, true); // kembali ke halaman sebelumnya

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Terjadi kesalahan: $e")),
    );
  } finally {
    if (mounted) setState(() => isLoading = false);
  }
}



  void checkLogin() {
    if (user == null) {
    
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, "/Masuk");
      });
      return;
    }

    
    userId = user!.id;
    loadUserData();
  }


   void loadUserData() async {
  if (userId == null) return;

  final data = await akunservice.getCompleteUserData(userId!);
  
 


  if (mounted) {
    setState(() {
      emailUser = data?['email'] ?? "";
      
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEFD9),

      appBar: AppBar(
        backgroundColor: Colors.white,
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
                      hintText: emailUser,
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
