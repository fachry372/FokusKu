import 'package:flutter/material.dart';
import 'package:fokusku/auth/auth_gate.dart';
import 'package:fokusku/izinoverlay/permission_guard.dart';
import 'dart:async';
import 'package:fokusku/izinoverlay/permission_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _initSplash();
  }

  Future<void> _initSplash() async {
    await Future.delayed(const Duration(seconds: 2));

    final granted = await PermissionGuard.allGranted();

    if (!mounted) return;

    if (!granted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const PermissionScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AuthGate(),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color:Color.fromARGB(255, 224, 235, 188),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png', 
              width: 150,
            ),
            const SizedBox(height: 20),
            const Text(
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