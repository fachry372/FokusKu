import 'package:flutter/material.dart';
import 'package:fokusku/auth/akun_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Ubahname extends StatefulWidget {
  const Ubahname({super.key});

  @override
  State<Ubahname> createState() => _UbahnameState();
}

class _UbahnameState extends State<Ubahname> {
  final _formKey = GlobalKey<FormState>();
  final akunservice = AkunService();
  final TextEditingController _nameController = TextEditingController();

  User? user = Supabase.instance.client.auth.currentUser;
  String? userId;
  
  String namaUser = "";

  bool isEnabled = false;
  bool isLoading = false;

 
  void simpanNamaBaru() async {
  if (!mounted) return;

  setState(() => isLoading = true);

  String newName = _nameController.text.trim();
  String? userId = Supabase.instance.client.auth.currentUser?.id;

  bool success = await akunservice.ubahNama(userId!, newName);

  if (!mounted) return;

  setState(() => isLoading = false);

  ScaffoldMessenger.of(context).clearSnackBars();

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Nama berhasil diubah!")),
    );
    Navigator.pop(context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Gagal mengubah nama.")),
    );
  }
}


  @override
void initState() {
  super.initState();
    checkLogin();
  _nameController.addListener(() {
    final text = _nameController.text.trim();

    setState(() {
      isEnabled = text.isNotEmpty;   // true kalau tidak kosong
    
    });
  });
}

void checkLogin() {
    if (user == null) {
    
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, "/Masuk");
      });
      return;
    }

    
    userId = user!.id;
    loadUserData();
  }


   void loadUserData() async {
  if (userId == null) return;

  final data = await akunservice.getCompleteUserData(userId!);
  
 


  if (mounted) {
    setState(() {
      namaUser = data?['nama'] ?? "";
      
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEFD9),
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                fillColor: Color(0xffffffff),
                hintText: namaUser,
                 hintStyle: GoogleFonts.inter(color: Color.fromARGB(255, 165, 165, 165)),
                border: OutlineInputBorder(
                  
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                 enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 148, 150, 147)),
                  borderRadius: BorderRadius.circular(15)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 68, 161, 68)),
                  borderRadius: BorderRadius.circular(15)
                ),
                errorMaxLines: 2,
              ),
              cursorColor: Color.fromARGB(255, 68, 161, 68),

               validator: (value) {

                final text = value ?? "";

                if (text.trim().isEmpty) {
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
                              simpanNamaBaru();
                              
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
