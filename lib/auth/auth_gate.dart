import 'package:flutter/material.dart';
import 'package:fokusku/halaman/navbar.dart';
import 'package:fokusku/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        
       
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        
        if (!snapshot.hasData) {
          return const LoginScreen();
        }


        final session = snapshot.data!.session;

        
        if (session != null) {
          return const Navbar();
        }

       
        return const LoginScreen();
      },
    );
  }
}
