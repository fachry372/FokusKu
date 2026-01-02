import 'package:flutter/material.dart';
import 'package:fokusku/auth/auth_gate.dart';
import 'package:fokusku/notif/izinusage.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final sudahIzin = await Izinusage.cekSudahDiizinkan();
    final sudahDitanya = await Izinusage.sudahPernahDitanya();

    if (!sudahIzin && !sudahDitanya) {
      await Izinusage.tandaiSudahDitanya();
      await _showIzinPopup();
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthGate()),
    );
  }

  Future<void> _showIzinPopup() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFE6F2E6),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),

          title: Center(
            child: Text(
              "Perlindungan Sesi Fokus",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Supaya sesi fokusmu tetap berjalan dengan baik, "
                "Fokusku perlu mendeteksi saat kamu membuka aplikasi lain.\n\n"
                "Izin ini tidak wajib dan bisa diubah kapan saja.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14, 
                  height: 1.5,
                  color: const Color(0xFF4E574E),
                ),
              ),
            ],
          ),

          actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Lewati",
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await Izinusage.bukaPengaturan();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF52B755),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Aktifkan",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 235, 188),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/images/logo.png'), width: 150),
            SizedBox(height: 20),
            Text(
              'Selamat Datang',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
