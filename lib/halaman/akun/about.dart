import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: const Color(0xFFEAEFD9),
     appBar: AppBar(
      title: Text("Tentang Kami",style: GoogleFonts.inter(color: Color(0xff293329),fontSize: 20 ,fontWeight: FontWeight.w500),),
      centerTitle: true,
     ),
       body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PARAGRAF PEMBUKA
                Text(
                  "FokusKu adalah aplikasi timer yang dirancang untuk membantu Anda tetap fokus saat sedang belajar atau bekerja. Kami menciptakan lingkungan yang terstruktur untuk meningkatkan produktivitas Anda.",
                  style: GoogleFonts.inter(
                    color: const Color(0xff606C60),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 20),

                // SECTION: CARA KERJA & HADIAH
                Text(
                  "Cara Kerja & Hadiah",
                  style: GoogleFonts.inter(
                    color: const Color(0xff474E47),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Untuk membuat sesi fokus saat belajar dan bekerja lebih menyenangkan, kami menghadirkan sistem hadiah:",
                  style: GoogleFonts.inter(
                    color: Color(0xff606C60),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                // Bullet + Judul (Hadiah Hewan)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5), // agar bullet sejajar
                        child: Icon(
                          Icons.circle,
                          size: 8,
                        )
                      ),
                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          "Hadiah Hewan :",
                          style: GoogleFonts.inter(
                            color: Color(0xff606C60),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Deskripsi di bawah bullet
                  Padding(
                    padding: const EdgeInsets.only(left: 22), // sejajarkan dengan teks di atas
                    child: Text(
                      "Setiap kali berhasil menyelesaikan satu sesi fokus penuh, Anda "
                      "akan mendapatkan hewan peliharaan virtual untuk dikoleksi.",
                      style: GoogleFonts.inter(
                        color: Color(0xff606C60),
                        fontSize: 13,
                      ),
                    ),
                  ),


                const SizedBox(height: 20),

                // SECTION: Koleksi & Pantau
                Text(
                  "Koleksi & Pantau",
                  style: GoogleFonts.inter(
                    color: const Color(0xff474E47),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                 const SizedBox(height: 8),

                Text(
                  "Selain timer dan hadiah, FokusKu juga menyediakan fitur koleksi dan fitur untuk melacak perkembangan Anda:",
                  style: GoogleFonts.inter(
                    color: Color(0xff606C60),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                 // Bullet + Judul (Hadiah Hewan)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5), // agar bullet sejajar
                        child: Icon(
                          Icons.circle,
                          size: 8,
                        )
                      ),
                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          "Koleksi Hewan :",
                          style: GoogleFonts.inter(
                            color: Color(0xff606C60),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Deskripsi di bawah bullet
                  Padding(
                    padding: const EdgeInsets.only(left: 22), // sejajarkan dengan teks di atas
                    child: Text(
                      "Lihat semua koleksi hewan peliharaan virtual yang telah Anda kumpulkan dari sesi fokus Anda.",
                      style: GoogleFonts.inter(
                        color: Color(0xff606C60),
                        fontSize: 13,
                      ),
                    ),
                  ),

                const SizedBox(height: 8),

                  // Bullet + Judul (Hadiah Hewan)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5), // agar bullet sejajar
                        child: Icon(
                          Icons.circle,
                          size: 8,
                        )
                      ),
                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          "Statistik Fokus :",
                          style: GoogleFonts.inter(
                            color: Color(0xff606C60),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Deskripsi di bawah bullet
                  Padding(
                    padding: const EdgeInsets.only(left: 22), // sejajarkan dengan teks di atas
                    child: Text(
                      "Pantau dan tinjau kinerja Anda melalui statistik fokus harian dan mingguan.",
                      style: GoogleFonts.inter(
                        color: Color(0xff606C60),
                        fontSize: 13,
                      ),
                    ),
                  ),


                const SizedBox(height: 35),

                // FOOTER
                Center(
                  child: Text(
                    "Aset hewan dan taman berasal dari Vecteezy & Freepik.",
                    style: GoogleFonts.inter(
                      color: Color(0xff606C60),
                      fontSize: 11,
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