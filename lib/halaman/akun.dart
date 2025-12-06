import 'package:flutter/material.dart';
import 'package:fokusku/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class Akun extends StatefulWidget {
  const Akun({super.key});

  @override
  State<Akun> createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  final authservice = AuthService();

   void logout() async {
    try {
      await authservice.signOut();

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, "/Masuk");
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal logout: $e")));
      }
    }
  }

  static const Color teks = Color(0xff182E19);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEFD9),
     
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30,),
              Text("Akun",style: GoogleFonts.inter(color: teks,fontSize: 24,fontWeight: FontWeight.w600),),
              const SizedBox(height: 30),

              // FOTO PROFIL
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/profil.jpg"), 
              ),

              const SizedBox(height: 10),

              const Text(
                "Fachry",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: teks,
                ),
              ),

              const Text(
                "Fachry@gmail.com",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff748274),
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 10),

              Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15.0),
  child: Align(
    alignment: Alignment.centerLeft,
    child: Text(
      "Ringkasan",
      style: GoogleFonts.inter(color: teks,fontSize: 20,fontWeight: FontWeight.w600),
    ),
  ),
),


              const SizedBox(height: 20),
              // === RINGKASAN ===
             Padding(
  padding: const EdgeInsets.only(left: 15.0,right: 15.0),
  child: Row(
    children: [
      Expanded(
        child: _buildSummaryCard(
          icon: Icons.timer,
          title: "25 Menit",
          subtitle: "Total waktu fokus",
        ),
      ),
      const SizedBox(width: 5),

      Expanded(
        child: _buildSummaryCard(
          icon: Icons.pets,
          title: "3 Hewan",
          subtitle: "Total hewan",
        ),
      ),
      const SizedBox(width: 5),

      Expanded(
        child: _buildSummaryCard(
          icon: Icons.bar_chart,
          title: "25 Menit/Hari",
          subtitle: "Rata-rata waktu \nfokus",
        ),
      ),
    ],
  ),
),


              const SizedBox(height: 20),

              Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15.0),
  child: Align(
    alignment: Alignment.centerLeft,
    child: Text(
      "Lainnya",
      style: GoogleFonts.inter(color: teks,fontSize: 20,fontWeight: FontWeight.w600),
    ),
  ),
),


              const SizedBox(height: 20),

              // === LAINNYA ===
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Container(
                  height: 165 ,
                  width: 375 ,
                 
                  decoration: BoxDecoration(
                     color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          title: "Pengaturan Akun",
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          title: "Tentang Kami",
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          title: "Keluar",
                          onTap: () {},
                          isRed: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

     
    );
  }

  // Card Ringkasan
  Widget _buildSummaryCard({required IconData icon, required String title, required String subtitle}) {
    return Container(
      height: 110,
      width: 141,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.green),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 12,fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 10,fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  // Menu item
  Widget _buildMenuItem({required String title, required VoidCallback onTap, bool isRed = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isRed ? Colors.red : Colors.black87,
                fontWeight: isRed ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: isRed ? Colors.red : Colors.black54),
          ],
        ),
      ),
    );
  }
}
