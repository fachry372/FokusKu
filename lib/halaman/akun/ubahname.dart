import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Ubahname extends StatefulWidget {
  const Ubahname({super.key});

  @override
  State<Ubahname> createState() => _UbahnameState();
}

class _UbahnameState extends State<Ubahname> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  bool isEnabled = false;
  bool isLoading = false;

  // Contoh fungsi update username
  Future<void> updateName() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2)); // simulasi API

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Username berhasil diperbarui")),
    );
  }

  @override
void initState() {
  super.initState();

  _nameController.addListener(() {
    final text = _nameController.text.trim();

    setState(() {
      isEnabled = text.isNotEmpty;   // true kalau tidak kosong
    });
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEFD9),
      appBar: AppBar(
        title: Text(
          "Ubah Username",
          style: GoogleFonts.inter(
            color: const Color(0xff293329),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 33),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  Text(
                    "Silakan masukkan username baru yang ingin Anda gunakan pada kolom di bawah ini.",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xff606C60),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Username:",
                      style: GoogleFonts.inter(fontSize: 18),
                    ),
                  ),

                  const SizedBox(height: 6),

                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    maxLength: 20,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: GoogleFonts.inter(
                          color: const Color.fromARGB(255, 165, 165, 165)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 148, 150, 147)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 68, 161, 68)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    cursorColor: const Color.fromARGB(255, 68, 161, 68),
                  
                    validator: (value) {
                      final text = value?.trim() ?? "";
                  
                      if (text.isEmpty) {
                        return "Username tidak boleh kosong";
                      }
                  
                      if (text.length > 20) {
                        return "Username maksimal 20 karakter";
                      }
                  
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: isEnabled && !isLoading
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              updateName();
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEnabled
                          ? const Color(0xFF52B755)
                          : const Color(0xFFA2B9A3),
                      fixedSize: const Size(280, 51),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            "Simpan",
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
