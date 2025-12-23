import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:fokusku/halaman/navbar.dart';
import 'package:fokusku/kirimlink.dart';
import 'package:fokusku/notif/foreground_service.dart';
import 'package:fokusku/notif/notif.dart';
import 'package:fokusku/register.dart';
import 'package:fokusku/resetpassword.dart';
import 'package:fokusku/splashscreen/splashscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fokusku/timer/timer.dart';

import 'login.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtmbXNtZGZhcnBja2puaXRzcm1yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMwOTkyMjMsImV4cCI6MjA3ODY3NTIyM30.cNc5jesGoxMs4_9eyjCDG6Bo-Whol8rPGyKo5Qi7j9g" ,
    url: "https://kfmsmdfarpckjnitsrmr.supabase.co",
  );

   Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final event = data.event;

    if (event == AuthChangeEvent.passwordRecovery) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => const Resetpassword(),
        ),
      );
    }
  });

  initAppLinks();

  
   await Notif.init(); 
    
     ForegroundService.init(); 
    runApp(
    ChangeNotifierProvider(
      create: (_) => TimerService(), 
      child: const MyApp(),
    ),
  );
}

void initAppLinks() {
  AppLinks().uriLinkStream.listen((uri) {
    if (uri.host == "login") {
      navigatorKey.currentState?.pushNamedAndRemoveUntil('/Masuk', (_) => false);

      final ctx = navigatorKey.currentContext;
      if (ctx != null) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text("Email berhasil diperbarui!")),
        );
      }
    }
  });
}




class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      routes: {
        '/Daftar': (context) => Register(),
        '/Masuk' : (context) => LoginScreen(),
        '/reset' : (context) => Resetpassword(),
        '/home'  : (context) => Navbar(),
        '/kirim' : (context) => Kirimlink(),
      },
      home: SplashScreen() ,    
      // home: Navbar(),
    );
  }
}