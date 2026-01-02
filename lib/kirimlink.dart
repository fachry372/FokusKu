import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fokusku/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class Kirimlink extends StatefulWidget {
  const Kirimlink({super.key});

  @override
  State<Kirimlink> createState() => _KirimlinkState();
}

class _KirimlinkState extends State<Kirimlink> {
  final _formKey = GlobalKey<FormState>();
  final authservice = AuthService();

  final _emailController = TextEditingController();

  bool isLoading = false;
  bool isenabled = false;

  int remainingSeconds = 0;
  Timer? countdownTimer;

  void startCountdown(int seconds) {
    setState(() => remainingSeconds = seconds);

    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds <= 1) {
        timer.cancel();
        setState(() => remainingSeconds = 0);
      } else {
        setState(() => remainingSeconds--);
      }
    });
  }

  void kirim() async {
  if (!mounted) return;

  setState(() => isLoading = true);
  final email = _emailController.text.trim();

  try {
    
    final terdaftar = await authservice.cekEmailTerdaftar(email);

    if (!terdaftar) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email yang kamu masukkan tidak terdaftar"),
        ),
      );
      return;
    }

    await authservice.sendResetPasswordLink(email);
    if (!mounted) return;

    startCountdown(60);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Link reset password berhasil dikirim! Cek email Anda.",
        ),
      ),
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Terjadi kesalahan: $e")),
    );
  } finally {
    if (mounted) {
      setState(() => isLoading = false);
    }
  }
}


  @override
  void initState() {
    super.initState();

    _emailController.addListener(checkform);
  }

  void checkform() {
    setState(() {
      isenabled = _emailController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEFD9),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 8),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, size: 30),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.only(left: 41, right: 10),
                    child: Text(
                      "Lupa Kata Sandi?",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 41, right: 20),
                    child: Text(
                      "Masukkan alamat email yang terdaftar. Kami akan mengirimkan tautan untuk mereset kata sandi Anda.",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Color(0xff606C60),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 41, right: 20),
                    child: Text(
                      "Email :",
                      style: GoogleFonts.inter(fontSize: 18),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Padding(
                    padding: EdgeInsets.only(left: 41.0, right: 41.0),

                    child: Column(
                      children: [
                        SizedBox(
                          width: 400,
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xffffffff),
                              hintStyle: GoogleFonts.inter(
                                color: Color.fromARGB(255, 165, 165, 165),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 148, 150, 147),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 68, 161, 68),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            cursorColor: Color.fromARGB(255, 68, 161, 68),

                            validator: (value) {
                              final text = value?.trim() ?? "";

                              
                              if (text.isEmpty) {
                                return "Email tidak boleh kosong";
                              }

                              
                              if (!text.endsWith("@gmail.com")) {
                                return "Email harus mengandung @gmail.com";
                              }

                            
                              final emailRegex = RegExp(
                                r'^[a-zA-Z0-9._%+-]+@gmail\.com$',
                              );
                              if (!emailRegex.hasMatch(text)) {
                                return "Format email tidak valid";
                              }

                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 37),

                  Center(
                    child: ElevatedButton(
                      onPressed:
                          (isenabled && !isLoading && remainingSeconds == 0)
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                kirim();
                              }
                            }
                          : null,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: (isenabled && remainingSeconds == 0)
                            ? Color(0xFF52B755)
                            : Color(0xFFA2B9A3),

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
                              remainingSeconds > 0
                                  ? "Kirim (${remainingSeconds}s)"
                                  : "Kirim",
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                color: Color(0xffffffff),
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 41, right: 20),
                    child: Text(
                      "Jika pesan tidak muncul, coba periksa folder Spam.",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Color(0xff606C60),
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
