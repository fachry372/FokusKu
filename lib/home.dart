import 'package:flutter/material.dart';
import 'package:fokusku/auth/auth_service.dart'; 

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final authservice = AuthService();
   
  void logout() async {
  try {
    await authservice.signOut();

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, "/Masuk");

  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal logout: $e")),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 201, 193, 169)
              ),
              child: IconButton(onPressed: logout, icon: Icon(Icons.logout)),
              
              ),
            
          
          ],
        
        ),
      ),
    );
  }
}