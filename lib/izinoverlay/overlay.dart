import 'package:flutter/material.dart';


class FocusOverlay extends StatelessWidget {
  const FocusOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, 
      child: Material(
        color: Colors.black.withOpacity(0.75),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/logo.png", width: 120),
              const SizedBox(height: 20),
              const Text(
                "Sedang Fokus 🌱",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 8),
              const Text(
                "Kembali ke aplikasi untuk melanjutkan",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
