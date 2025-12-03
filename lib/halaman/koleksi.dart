import 'package:flutter/material.dart';
import 'package:fokusku/auth/riwayatkoleksi.dart';
import 'package:google_fonts/google_fonts.dart';


class Koleksi extends StatefulWidget {
  const Koleksi({super.key});

  @override
  State<Koleksi> createState() => _KoleksiState();
}

class _KoleksiState extends State<Koleksi> {
  bool isDailySelected = true; 

 List<Map<String, dynamic>> koleksi = [];
bool loading = true;

@override
void initState() {
  super.initState();
  loadKoleksi();
}

Future<void> loadKoleksi() async {
  final data = await RewardService.getKoleksi();
  setState(() {
    koleksi = data;
    loading = false;
  });
}

String formatTitle(String fileName) {
  String name = fileName.replaceAll(".png", "").replaceAll(".jpg", "");

  if (name.startsWith("fase")) {
    final angka = name.replaceAll("fase", "");
    return "Ayam Fase $angka";
  }

  return name;
}



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final cardWidth = (screenWidth - 25 - 25 - 15) / 2;
    final cardWidth = 154.0;
    const cardHeight = 234.0;

    const cardBorderColor = Color.fromARGB(255, 117, 211, 140);
    const primaryTextColor = Color(0xff182E19);
    const accentColor = Color(0xFF28AD49);

    return Scaffold(
      backgroundColor: const Color(0xFFEAEFD9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

              
                Text(
                  "Koleksi Saya",
                  style: GoogleFonts.inter(
                    color: primaryTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  "Lihat semua hewan yang sudah kamu kumpulkan.",
                  style: GoogleFonts.inter(
                    color: primaryTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                   child: 
                    loading
    ? Center(child: CircularProgressIndicator(
      color: Color(0xff52B755),
    )):
     SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:koleksi.isEmpty ? [buildEmptyCard(cardWidth, cardHeight)] 
              : koleksi.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: _buildCollectionCard(
                    cardWidth,
                    cardHeight,
                    primaryTextColor,
                    cardBorderColor,
                    item['reward_image'],    
                    formatTitle(item['reward_image']),
                  ),
                );
              }).toList(),
            ),
          )

                  ),
                ),

                const SizedBox(height: 15),
 
                
                Text(
                  "Statistik",
                  style: GoogleFonts.inter(
                    color: primaryTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                _buildTimeToggle(primaryTextColor, accentColor),

                const SizedBox(height: 10,),

             isDailySelected
              ? _buildChartContainer(screenWidth, Colors.black, Colors.green)
              : _buildWeeklyChartContainer(screenWidth, Colors.black, Colors.green),

                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollectionCard(
  double width,
  double height,
  Color primaryTextColor,
  Color cardBorderColor,
  String rewardImage,  
  String title,        
) {
  return Container(
    height: 210,
    width: width,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: cardBorderColor,
        width: 1,
      ),
    ),
    child: Column(
      children: [
        const SizedBox(height: 20),

        Image.asset(
          'assets/images/$rewardImage',   
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        ),

        const Spacer(),

        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            title,  
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: primaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildEmptyCard(double width, double height) {
  return Container(
    height: 210,
    width: width,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: const Color.fromARGB(255, 117, 211, 140),
        width: 1,
      ),
    ),
    child: Center(
      child: Text(
        "Belum ada koleksi",
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          color: Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}


 
 Widget _buildTimeToggle(Color primaryTextColor, Color accentColor) {
  const Color backgroundColor = Colors.white;
  const double toggleheight = 45;
  const double toggleWidth = 170;

  return Center(
    child: Container(
      height: toggleheight,
      width: toggleWidth,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            left: isDailySelected ? 0 : toggleWidth / 2 - 3,
            right: isDailySelected ? toggleWidth / 2 - 3 : 0,
            top: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          // ===== 2 Button Full Clickable =====
          Row(
            children: [
              // >>> BUTTON HARI <<<
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => setState(() => isDailySelected = true),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Hari",
                      style: GoogleFonts.inter(
                        color: isDailySelected ? Colors.white : primaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              // >>> BUTTON MINGGU <<<
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => setState(() => isDailySelected = false),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Minggu",
                      style: GoogleFonts.inter(
                        color: !isDailySelected ? Colors.white : primaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildWeeklyChartContainer(
    double screenWidth, Color primaryTextColor, Color accentColor) {
  
  final chartWidth = screenWidth - 50;

  
  List<int> weeklyData = [ 25];

  int maxValue = 25;

  return Container(
    width: chartWidth,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Total Fokus Minggu Ini : ${weeklyData.reduce((a,b) => a + b)} Menit",
            style: GoogleFonts.inter(
              color: primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildYAxisLabels(primaryTextColor),

              Expanded(
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    CustomPaint(
                      painter: GridLinePainter(primaryTextColor),
                      size: Size.infinite,
                    ),

                    // ======== BAR MINGGUAN ========
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: weeklyData.map((value) {
                        return Container(
                          width: 10,
                          height: 150 * (value / maxValue),
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // ======= Label Hari ========
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              "Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"
            ]
                .map((d) => Text(
                      d,
                      style: GoogleFonts.inter(
                        color: primaryTextColor,
                        fontSize: 10,
                      ),
                    ))
                .toList(),
          ),
        )
      ],
    ),
  );
}



  Widget _buildChartContainer(
      double screenWidth, Color primaryTextColor, Color accentColor) {
    final chartWidth = screenWidth - 50;

    return Container(
      width: chartWidth,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Total Waktu Fokus : 25 Menit",
              style: GoogleFonts.inter(
                color: primaryTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildYAxisLabels(primaryTextColor),
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      CustomPaint(
                        painter: GridLinePainter(primaryTextColor),
                        size: Size.infinite,
                      ),
                      Positioned(
                        left: chartWidth / 2 - 20,
                        bottom: 0,
                        child: Container(
                          width: 11,
                          height: 150 * (25 / 25),
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 5),

          _buildXAxisLabels(primaryTextColor, chartWidth),
        ],
      ),
    );
  }

 Widget _buildYAxisLabels(Color primaryTextColor) {
    return Container(
      width: 30,
      padding: const EdgeInsets.only(right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('25', style: GoogleFonts.inter(color: primaryTextColor, fontSize: 10)),
          Text('20', style: GoogleFonts.inter(color: primaryTextColor, fontSize: 10)),
          Text('10', style: GoogleFonts.inter(color: primaryTextColor, fontSize: 10)),
          Text('5', style: GoogleFonts.inter(color: primaryTextColor, fontSize: 10)),
          Text('0', style: GoogleFonts.inter(color: primaryTextColor, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildXAxisLabels(Color primaryTextColor, double chartWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('06:00', style: GoogleFonts.inter(color: primaryTextColor, fontSize: 10)),
          Text('09:00', style: GoogleFonts.inter(color: primaryTextColor, fontSize: 10)),
          Text('12:00', style: GoogleFonts.inter(color: primaryTextColor, fontSize: 10)),
          Text('15:00', style: GoogleFonts.inter(color: primaryTextColor, fontSize: 10)),
          Text('18:00', style: GoogleFonts.inter(color: primaryTextColor, fontSize: 10)),
          Text('23:00', style: GoogleFonts.inter(color: primaryTextColor, fontSize: 10)),
        ],
      ),
    );
  }
}

class GridLinePainter extends CustomPainter {
  final Color color;

  GridLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

   
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      paint,
    );

    final yInterval = size.height / 4;

    for (int i = 1; i <= 4; i++) {
      canvas.drawLine(
        Offset(0, size.height - (yInterval * i)),
        Offset(size.width, size.height - (yInterval * i)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
