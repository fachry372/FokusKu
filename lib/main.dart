import 'package:flutter/material.dart';
import 'package:fokusku/auth/auth_gate.dart';
import 'package:fokusku/home.dart';
import 'package:fokusku/kirimlink.dart';
import 'package:fokusku/register.dart';
import 'package:fokusku/resetpassword.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login.dart';


void main() async {

  await Supabase.initialize(
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtmbXNtZGZhcnBja2puaXRzcm1yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMwOTkyMjMsImV4cCI6MjA3ODY3NTIyM30.cNc5jesGoxMs4_9eyjCDG6Bo-Whol8rPGyKo5Qi7j9g" ,
    url: "https://kfmsmdfarpckjnitsrmr.supabase.co",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/Daftar': (context) => Register(),
        '/Masuk' : (context) => LoginScreen(),
        '/reset' : (context) => Resetpassword(),
        '/home' : (context) => Home(),
        '/kirim' : (context) => Kirimlink(),
      },
      home: AuthGate() ,
    );
  }
}