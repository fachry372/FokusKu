import 'package:flutter/material.dart';


class FocusOverlay extends StatelessWidget {
  const FocusOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.5), 
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/logo.png", 
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF52B755),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 30,
                ),
              ),
              child: const Text(
                "Kembali ke Aplikasi",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
