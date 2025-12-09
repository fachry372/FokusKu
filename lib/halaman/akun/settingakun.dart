import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fokusku/auth/akun_service.dart';
import 'package:fokusku/auth/auth_service.dart';
import 'package:fokusku/halaman/akun/ubahemail.dart';
import 'package:fokusku/halaman/akun/ubahname.dart';
import 'package:fokusku/halaman/akun/ubahpassword.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Settingakun extends StatefulWidget {
  const Settingakun({super.key});

  @override
  State<Settingakun> createState() => _SettingakunState();
}

class _SettingakunState extends State<Settingakun> {
  final authservice = AuthService();
  final akunService = AkunService();
  User? user = Supabase.instance.client.auth.currentUser;
  String? userId;
  
  String namaUser = "";
  String emailUser = "";




  @override
  void initState() {
    super.initState();
    checkLogin();
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

  final data = await akunService.getCompleteUserData(userId!);
  
 


  if (mounted) {
    setState(() {
      namaUser = data?['nama'] ?? "";
      emailUser = data?['email'] ?? "";

      
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: const Color(0xFFEAEFD9),
     appBar: AppBar(
      backgroundColor: Colors.white,
      title: Text("Pengaturan Akun",style: GoogleFonts.inter(color: Color(0xff293329),fontSize: 20 ,fontWeight: FontWeight.w500),),
      centerTitle: true,
     ),
     body: SingleChildScrollView(
       child: SafeArea(child: Center(child: Padding(
         padding: const EdgeInsets.all(20.0),
         child: Column(
          children: [
            const  SizedBox(height: 45,),
       
            // FOTO PROFIL
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage("assets/images/logo.png"),
                ),
       
                const SizedBox(height: 30),
       
       // === CONTAINER MENU PENGATURAN ===
       Container(
         width: double.infinity,
         decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(12),
           boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
           ],
         ),
         child: Column(
           children: [
        // Username
        _buildSettingItem(
          title: "Username",
          value: "$namaUser",
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Ubahname())
          ).then((_) {
           loadUserData(); 
        }),
                        
        ),
       
        // Email
        _buildSettingItem(
          title: "Email",
          value: "$emailUser",
          onTap:  () => Navigator.push(context, MaterialPageRoute(builder: (_) => Ubahemail())
          ).then((_) {
           loadUserData(); 
        }),
        ),
       
        // Ganti Kata Sandi (hanya teks, tidak ada value)
        _buildSettingItem(
          title: "Ubah Kata Sandi",
          onTap:  () => Navigator.push(context, MaterialPageRoute(builder: (_) => Ubahpassword())),
          isLast: true,
        ),
           ],
         ),
       ),
       
       
          ],
         ),
       ),)),
     ),
    );
  }
}

Widget _buildSettingItem({
  required String title,
  String? value,
  required VoidCallback onTap,
  bool isLast = false,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
              ),
      ),
      child: Row(
        children: [
          // Judul
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: const Color(0xff3E4A3E),
              fontWeight: FontWeight.w600
            ),
          ),

          const Spacer(),

          // Value (optional)
          if (value != null)
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xff8A948A),
              ),
            ),

          const SizedBox(width: 5),

          // Arrow SVG
          SvgPicture.asset(
            "assets/icons/arrow.svg",
            height: 16,
            colorFilter: const ColorFilter.mode(
              Color(0xff73A373),
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    ),
  );
}
