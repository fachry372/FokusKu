import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fokusku/timer/timer.dart'; 
import 'package:fokusku/halaman/sesifokus.dart';
import 'package:fokusku/tamandantelur/tamantelur.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  void _showTimerSettingsDialog(BuildContext context) {
    final timerService = Provider.of<TimerService>(context, listen: false);

    
    final TextEditingController focusController =
        TextEditingController(text: (timerService.focusSeconds ~/ 60).toString());
    final TextEditingController breakController =
        TextEditingController(text: (timerService.breakSeconds ~/ 60).toString());
    final TextEditingController longBreakController =
        TextEditingController(text: (timerService.longBreakSeconds ~/ 60).toString());
    final TextEditingController babakController =
        TextEditingController(text: timerService.babak.toString());


    final formKey = GlobalKey<FormState>();

    

showDialog(
  context: context,
  builder: (context) => AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    backgroundColor: const Color(0xFFE6F2E6), 
    contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
    title: Center(
      child: Text(
        "Atur Timer",
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 18, 
          color: Colors.black, 
        ),
      ),
    ),
    content: SingleChildScrollView( child:  Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Durasi fokus (menit) :",
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
              if (numVal < 1 || numVal > 60) return "Durasi 1 hingga 60 menit.";
              return null;
            },
          ),
          const SizedBox(height: 15),
          
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
            enabled: false,
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
              if (numVal < 1 || numVal > 5) return "Durasi 5 menit.";
              return null;
            },
          ),
          const SizedBox(height: 15),
Align(
  alignment: Alignment.centerLeft,
  child: Text(
    "Durasi istirahat panjang (menit):",
    style: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
  ),
),
const SizedBox(height: 5),
TextFormField(
  controller: longBreakController,
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
      borderRadius: BorderRadius.circular(15),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 68, 161, 68)),
      borderRadius: BorderRadius.circular(15),
    ),
    errorMaxLines: 2,
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "Durasi istirahat panjang tidak boleh kosong";
    }
    final numVal = int.tryParse(value);
    if (numVal == null) return "Harus berupa angka";
    if (numVal < 15 || numVal > 30) return "Durasi 15 hingga 30 menit.";
    return null;
  },
),
const SizedBox(height: 15),
Align(
  alignment: Alignment.centerLeft,
  child: Text(
    "Jumlah babak :",
    style: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
  ),
),
const SizedBox(height: 5),
TextFormField(
  controller: babakController,
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
      borderRadius: BorderRadius.circular(15),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 68, 161, 68)),
      borderRadius: BorderRadius.circular(15),
    ),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "Jumlah babak tidak boleh kosong";
    }
    final numVal = int.tryParse(value);
    if (numVal == null) return "Harus berupa angka";
    if (numVal < 1 || numVal > 4) return "Babak 1 hingga 4.";
    return null;
  },
),
      
        ],
      ),
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
      int newLongBreak = int.parse(longBreakController.text);
      int newRounds = int.parse(babakController.text);

      timerService.updateTimers(
        focusMinutes: newFocus,
        breakMinutes: newBreak,
        longBreakMinutes: newLongBreak,
        babakCount: newRounds,
      );

      Navigator.pop(context);
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
                const SizedBox(height: 86),
                Text(
                  "Mulai Fokus!",
                  style: GoogleFonts.inter(
                    fontSize: 25,
                    color: Color(0xff182E19),
                  ),
                ),
                const SizedBox(height: 30),
                const Center(child: Tamantelur()),
                const SizedBox(height: 0),
              
              Container( 
                height: 153 ,
                width: 234,
                decoration: BoxDecoration(
                  color: Color(0xffE3E9CF),
                  borderRadius: BorderRadius.circular(30),
                  
                ),
                       
                child: 
                GestureDetector(
                  onTap: () => _showTimerSettingsDialog(context),
                  
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        timerService.initialFocusTime,
                        style: GoogleFonts.inter(
                          fontSize: 70,
                          fontWeight: FontWeight.w400,
                          height: 0.8,
                          
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Istirahat: ${(timerService.breakSeconds ~/ 60).toString().padLeft(2, '0')}:00",
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: const Color.fromARGB(220, 49, 49, 49),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Text("Tap untuk ubah",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: const Color.fromARGB(220, 49, 49, 49),
                      ),)
                    ],
                  ),
                ),
              ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    timerService.reset();
                    timerService.startPomodoro();
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
