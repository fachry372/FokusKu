import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fokusku/timer/timer.dart'; // TimerService
import 'package:fokusku/halaman/sesifokus.dart';
import 'package:fokusku/tamandantelur/tamantelur.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  void _showTimerSettingsDialog(BuildContext context) {
    final timerService = Provider.of<TimerService>(context, listen: false);

    // Konsisten: deklarasi controller hanya sekali
    final TextEditingController focusController =
        TextEditingController(text: (timerService.focusSeconds ~/ 60).toString());
    final TextEditingController breakController =
        TextEditingController(text: (timerService.breakSeconds ~/ 60).toString());

    final formKey = GlobalKey<FormState>();

showDialog(
  context: context,
  builder: (context) => AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    backgroundColor: const Color(0xFFE6F2E6), // hijau muda
    contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
    title: Center(
      child: Text(
        "Atur Timer",
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 18, // lebih kecil
          color: Colors.black, // default warna teks
        ),
      ),
    ),
    content: Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fokus Timer
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Durasi fokus (menit):",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: focusController,
            keyboardType: TextInputType.number,
            cursorColor: const Color(0xFF52B755),
            style: GoogleFonts.inter(fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 148, 150, 147)),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 68, 161, 68)),
                  borderRadius: BorderRadius.circular(15)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Durasi fokus tidak boleh kosong";
              }
              final numVal = int.tryParse(value);
              if (numVal == null) return "Harus berupa angka";
              if (numVal < 1 || numVal > 120) return "Durasi 1 hingga 120 menit";
              return null;
            },
          ),
          const SizedBox(height: 15),
          // Break Timer
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Durasi istirahat (menit):",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: breakController,
            keyboardType: TextInputType.number,
            cursorColor: const Color(0xFF52B755),
            style: GoogleFonts.inter(fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 148, 150, 147)),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 68, 161, 68)),
                  borderRadius: BorderRadius.circular(15)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Durasi istirahat tidak boleh kosong";
              }
              final numVal = int.tryParse(value);
              if (numVal == null) return "Harus berupa angka";
              if (numVal < 1 || numVal > 120) return "Durasi 1 hingga 120 menit";
              return null;
            },
          ),
        ],
      ),
    ),
    actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          "Batal",
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
      ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            int newFocus = int.parse(focusController.text);
            int newBreak = int.parse(breakController.text);
            timerService.updateTimers(
              focusMinutes: newFocus,
              breakMinutes: newBreak,
            );
            Navigator.pop(context); // tutup dialog utama
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF52B755),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "Simpan",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    ],
  ),
);


  }

  @override
  Widget build(BuildContext context) {
    final timerService = Provider.of<TimerService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEAEFD9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 106),
                Text(
                  "Mulai Fokus!",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    color: Color(0xff182E19),
                  ),
                ),
                const SizedBox(height: 40),
                const Center(child: Tamantelur()),
                const SizedBox(height: 0),
                // Tampilan timer fokus dan break
                GestureDetector(
                  onTap: () => _showTimerSettingsDialog(context),
                  child: Column(
                    children: [
                      Text(
                        timerService.initialFocusTime,
                        style: GoogleFonts.roboto(
                          fontSize: 70,
                          fontWeight: FontWeight.w300,
                          height: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Istirahat: ${(timerService.breakSeconds ~/ 60).toString().padLeft(2, '0')}:00",
                        style: GoogleFonts.roboto(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff5E695E),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    timerService.reset();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Sesifokus(timerService: timerService),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff52B755),
                    fixedSize: const Size(162, 33),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Mulai",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
