import 'package:flutter/material.dart';
import 'package:fokusku/auth/auth_service.dart';

class Akun extends StatefulWidget {
  const Akun({super.key});

  @override
  State<Akun> createState() => _AkunState();
}

class _AkunState extends State<Akun> {
    final authservice = AuthService();

  void logout() async {
    try {
      await authservice.signOut();

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, "/Masuk");
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal logout: $e")));
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEFD9),
      appBar: AppBar(
        title: Center(child: Text("Akun"),),
         actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      body: SafeArea(child: Column(children:
       [

      ],)),
      
    );
  }
}
