import 'package:flutter/material.dart';
import 'package:fokusku/auth/auth_service.dart';
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
  final authService = AuthService();
  final akunService = AkunService();

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

    _emailController.addListener(_checkFields);
    _passwordController.addListener(_checkFields);
  }

  void _checkFields() {
    setState(() {
      isEnabled =
          _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  void checkLogin() {
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, "/Masuk");
      });
      return;
    }
    userId = user!.id;
    loadUserEmail();
  }

  void loadUserEmail() {
    final authUser = Supabase.instance.client.auth.currentUser;
    if (authUser != null && mounted) {
      setState(() {
        emailUser = authUser.email ?? "";
      });
    }
  }

  Future<bool> updateEmail() async {
  if (!mounted) return false;
  setState(() => isLoading = true);

  final newEmail = _emailController.text.trim().toLowerCase();
  final password = _passwordController.text.trim();

  try {
    final supabase = Supabase.instance.client;
    final currentUser = supabase.auth.currentUser;

    if (currentUser == null || currentUser.email == null) {
      _showError("Sesi login tidak valid. Silakan login ulang.");
      return false;
    }

    final oldEmail = currentUser.email!.toLowerCase();
    if (newEmail == oldEmail) {
      _showError("Email baru tidak boleh sama dengan email lama.");
      return false;
    }

    // Cek email sudah terdaftar
    final isUsed = await authService.cekEmailTerdaftar(newEmail);
    if (isUsed) {
      _showError("Email sudah terdaftar.");
      return false;
    }

    // Re-authenticate
    final reAuth = await supabase.auth.signInWithPassword(
      email: oldEmail,
      password: password,
    );
    if (reAuth.user == null) {
      _showError("Kata sandi salah.");
      return false;
    }

    // Update email dengan link verifikasi
    await supabase.auth.updateUser(
      UserAttributes(email: newEmail),
      emailRedirectTo: "fokusku://login",
    );

    // Pesan Snackbar baru
    _showSuccess(
      "Link verifikasi dikirim ke email lama & baru. Klik kedua link untuk konfirmasi."
    );

    return true;
  } catch (e) {
    _showError("Terjadi kesalahan: $e");
    return false;
  } finally {
    if (mounted) setState(() => isLoading = false);
  }
}


  void logout() async {
    try {
      await authService.signOut();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, "/Masuk");
    } catch (e) {
      if (mounted) _showError("Gagal logout: $e");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 5)));
  }

  Future<bool?> dialogKonfirmasiEmail({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = "Ya",
    String cancelText = "Batal",
    Color confirmColor = const Color(0xFF52B755),
    Color cancelColor = const Color.fromARGB(255, 100, 88, 88),
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFFE6F2E6),
          contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
          title: Center(
            child: Text(title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: const Color(0xFF182E19),
                )),
          ),
          content: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF4E574E)),
            ),
          ),
          actionsPadding: const EdgeInsets.all(20),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cancelColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(cancelText,
                        style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(confirmText,
                        style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEFD9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Ubah Email",
            style: GoogleFonts.inter(color: const Color(0xff293329), fontSize: 20, fontWeight: FontWeight.w500)),
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
                    style: GoogleFonts.inter(fontSize: 14, color: const Color(0xff606C60)),
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
                      hintStyle: GoogleFonts.inter(color: const Color.fromARGB(255, 165, 165, 165)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 148, 150, 147)),
                          borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 68, 161, 68)),
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    cursorColor: const Color.fromARGB(255, 68, 161, 68),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Email tidak boleh kosong";
                      final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                      if (!emailRegex.hasMatch(value)) return "Format email tidak valid";
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
                      hintStyle: GoogleFonts.inter(color: const Color.fromARGB(255, 165, 165, 165)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 148, 150, 147)),
                          borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 68, 161, 68)),
                          borderRadius: BorderRadius.circular(15)),
                      errorMaxLines: 2,
                    ),
                    cursorColor: const Color.fromARGB(255, 68, 161, 68),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Kata sandi tidak boleh kosong";
                      if (value.length < 6) return "Kata sandi minimal 6 karakter";
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: isEnabled && !isLoading
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                bool? konfirmasi = await dialogKonfirmasiEmail(
                                    context: context,
                                    title: "Ubah email ?",
                                    message:
                                        "Anda yakin ingin mengubah email? Anda akan logout setelah ini.");
                                if (konfirmasi == true) {
                                  bool sukses = await updateEmail();
                                  if (sukses) logout();
                                }
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isEnabled ? const Color(0xFF52B755) : const Color(0xFFA2B9A3),
                        fixedSize: const Size(280, 51),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                            )
                          : Text("Ubah", style: GoogleFonts.inter(fontSize: 24, color: Colors.white)),
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
