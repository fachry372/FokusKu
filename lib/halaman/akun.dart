import 'package:flutter/material.dart';
import 'package:fokusku/auth/akun_service.dart';
import 'package:fokusku/auth/auth_service.dart';
import 'package:fokusku/halaman/akun/about.dart';
import 'package:fokusku/halaman/akun/settingakun.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Akun extends StatefulWidget {
  const Akun({super.key});

  @override
  State<Akun> createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  final authservice = AuthService();
  final akunService = AkunService();
  User? user = Supabase.instance.client.auth.currentUser;
  String? userId;
  
  String namaUser = "";
  String emailUser = "";
  String? imageUrl;

  int totalFokus = 0;
  int rataRataFokus = 0;   
  int totalHewan = 0;


  @override
  void initState() {
    super.initState();
    checkLogin();
     }

   
  void checkLogin() {
    if (user == null) {
      // kalau tidak login, arahkan ke halaman Masuk
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, "/Masuk");
      });
      return;
    }

    // Jika login, simpan userId dan load data
    userId = user!.id;
    loadUserData();
  }

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

  Future<void> showLogoutPopup(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: const Color(0xFFE6F2E6),
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 10),

        title: Center(
          child: Text(
            "Konfirmasi Keluar",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: const Color(0xFF182E19),
            ),
          ),
        ),

        content: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            "Apakah kamu yakin ingin keluar ?",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF4E574E),
            ),
          ),
        ),

        actionsPadding: const EdgeInsets.all(20),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 100, 88, 88),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Batal",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff871A1D), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Keluar",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );

  if (result == true) {
    logout();
  }
}




 void loadUserData() async {
  if (userId == null) return;

  final data = await akunService.getCompleteUserData(userId!);
  final total = await akunService.getTotalWaktuFokus(userId!);
  final rata = await akunService.getRataRataPerHari(userId!);
  final hewan = await akunService.getTotalHewan(userId!);

 
  final storage = Supabase.instance.client.storage.from('image');
  final path = "profile_$userId.jpg";

  String? finalImageUrl;

  try {
    
    await storage.download(path);
    
   
    final directUrl = storage.getPublicUrl(path);
    finalImageUrl = "$directUrl?v=${DateTime.now().millisecondsSinceEpoch}";
  } catch (e) {
    
    finalImageUrl = null;
  }

  if (mounted) {
    setState(() {
      namaUser = data?['nama'] ?? "";
      emailUser = data?['email'] ?? "";

      totalFokus = total;
      rataRataFokus = rata.round();
      totalHewan = hewan;

      imageUrl = finalImageUrl; 
    });
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
              const SizedBox(height: 30),
              Text(
                "Akun",
                style: GoogleFonts.inter(
                  color: teks,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),

              
             CircleAvatar(
                             backgroundColor: Colors.transparent,
                              radius: 50,
                              backgroundImage:
                                  imageUrl != null && imageUrl!.isNotEmpty
                                  ? NetworkImage(imageUrl!)
                                  : const AssetImage("assets/images/logo.png")
                                        as ImageProvider,
                            ),

              const SizedBox(height: 10),

              Text(
                namaUser.isEmpty ? "Memuat..." : namaUser,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: teks, 
                ),
              ),

              const SizedBox(height: 4),

              Text(
                emailUser.isEmpty ? "Memuat..." : emailUser,
                style: const TextStyle(
                  fontSize: 16,
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
                    style: GoogleFonts.inter(
                      color: teks,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        svgPath: "assets/icons/timer.svg",
                        title: "$totalFokus Menit",
                        subtitle: "Total waktu fokus",
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _buildSummaryCard(
                        svgPath: "assets/icons/Pets.svg",
                        title: "$totalHewan Hewan",
                        subtitle: "Total hewan",
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _buildSummaryCard(
                        svgPath: "assets/icons/chart.svg",
                        title: "$rataRataFokus Menit/Hari",
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
                    style: GoogleFonts.inter(
                      color: teks,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

            
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15,),
                child: Container(
                  
                  width: 375,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        title: "Pengaturan Akun",
                        leadingSvg: "assets/icons/akun.svg",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Settingakun()),
                        ).then((_) {
                            loadUserData(); 
                          }),
                        
                      ),
                      _buildMenuItem(
                        title: "Tentang Kami",
                        leadingSvg: "assets/icons/about.svg",
                        isLast: true,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => About()),
                        ),
                      ),
                     
                    ],
                  ),
                ),
                
              ),
              const SizedBox(height: 25,),
              Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: SizedBox(
                width: 375,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    showLogoutPopup(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Color(0xff871A1D),  
                    elevation: 0,                 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Keluar",
                    style: GoogleFonts.inter(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
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

  
  Widget _buildSummaryCard({
    required String svgPath,
    required String title,
    required String subtitle,
  }) {
    return Container(
      height: 108,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          SvgPicture.asset(svgPath, height: 35,color: Color(0xff73A373),),
          const SizedBox(height: 5),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xff182E19),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xff919891),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required VoidCallback onTap,
    String? leadingSvg, 
    bool isRed = false,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                ),
        ),
        child: Row(
          children: [
            // ==== ICON KIRI (SVG) ====
            if (leadingSvg != null) ...[
              SvgPicture.asset(
                leadingSvg,
                height: 27,
                colorFilter: ColorFilter.mode(
                  isRed ? Color(0xff821111) : Color(0xff606C60),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 12),
            ],

            // ==== TEXT ====
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isRed ? Color(0xff821111) : Color(0xff606C60),
                fontWeight: FontWeight.normal,
              ),
            ),

            const Spacer(),

            // ==== ICON ARROW KANAN (SVG) ====
            SvgPicture.asset(
              "assets/icons/arrow.svg",
              height: 16,
              colorFilter: ColorFilter.mode(Color(0xff73A373), BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}