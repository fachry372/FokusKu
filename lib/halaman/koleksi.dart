import 'package:flutter/material.dart';
import 'package:fokusku/auth/riwayatkoleksi.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

class Koleksi extends StatefulWidget {
  const Koleksi({super.key});

  @override
  State<Koleksi> createState() => _KoleksiState();
}

class _KoleksiState extends State<Koleksi> {
  // State koleksi (card)
  List<Map<String, dynamic>> koleksi = [];
  bool loadingKoleksi = true;

  // Chart state
  List<int> dailyHourMinutes = List.filled(24, 0); // menit per jam (0..23)
  List<int> dailyBuckets5 = List.filled(5, 0); // jika kamu butuh total per segmen 5 slot
  List<int> weeklyFocus = List.filled(7, 0); // Sen..Min

  bool loadingDailyChart = true;
  bool loadingWeeklyChart = true;

  // UI constants
  static const Color cardBorderColor = Color.fromARGB(255, 117, 211, 140);
  static const Color primaryTextColor = Color(0xff182E19);
  static const Color accentColor = Color(0xFF28AD49);

  @override
  void initState() {
    super.initState();
    loadKoleksi();
    loadAllFocus();
  }

  // ------------------- Koleksi (card) -------------------
  Future<void> loadKoleksi() async {
    try {
      final data = await RewardService.getKoleksi();
      setState(() {
        koleksi = data;
        loadingKoleksi = false;
      });
    } catch (e) {
      // tetap set false agar UI tidak macet
      setState(() {
        koleksi = [];
        loadingKoleksi = false;
      });
    }
  }

  Future<void> loadAllFocus() async {
    await loadFocus(daily: true);
    await loadFocus(daily: false);
  }

  Future<void> loadFocus({bool daily = false}) async {
  if (daily) {
    setState(() => loadingDailyChart = true);
  } else {
    setState(() => loadingWeeklyChart = true);
  }

  final data = await getFocusData(daily: daily);

  if (daily) {
    // Reset
    dailyHourMinutes = List.filled(24, 0);

    // Masukkan menit per jam (logika bar chart lama)
    for (var item in data) {
  if (item['created_at'] is DateTime) {
    int hour = (item['created_at'] as DateTime).hour;
    int dur = (item['durasi_fokus'] as num).toInt();

    while (dur > 0 && hour < 24) {
      int spaceLeft = 60 - dailyHourMinutes[hour];
      if (dur <= spaceLeft) {
        dailyHourMinutes[hour] += dur;
        dur = 0;
      } else {
        dailyHourMinutes[hour] += spaceLeft;
        dur -= spaceLeft;
        hour += 1; // pindah ke jam berikutnya
      }
    }
  }
}


    setState(() => loadingDailyChart = false);
  } else {
    // Mingguan
    weeklyFocus = List.filled(7, 0);

    for (var item in data) {
      final dt = item['created_at'];
      final dur = item['durasi_fokus'] ?? 0;
      final intDur = (dur is int) ? dur : (dur as num).toInt();



      if (dt is DateTime) {
        final dayIndex = (dt.weekday - 1); // Senin = 0
        weeklyFocus[dayIndex] += intDur;
      }
    }

    setState(() => loadingWeeklyChart = false);
  }
}


  Future<List<Map<String, dynamic>>> getFocusData({bool daily = false}) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];

    var query = Supabase.instance.client
        .from('timer')
        .select('durasi_fokus, created_at')
        .eq('user_id', user.id);

    final today = DateTime.now();

    if (daily) {
      final start = DateTime(today.year, today.month, today.day);
      final end = DateTime(today.year, today.month, today.day, 23, 59, 59);
      query = query.gte('created_at', start.toIso8601String()).lte('created_at', end.toIso8601String());
    } else {
      final start = today.subtract(const Duration(days: 6));
      query = query.gte('created_at', start.toIso8601String());
    }

    final response = await query;
   

    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(response);

    
    for (var item in data) {
      if (item['created_at'] != null) {
        try {
          final utcTime = DateTime.parse(item['created_at']);
          final wibTime = utcTime.add(const Duration(hours: 7));
          item['created_at'] = wibTime;
        } catch (_) {
         
        }
      }
    }

    return data;
  }

  
  String formatTitle(String fileName) {
    String name = fileName.replaceAll(".png", "").replaceAll(".jpg", "");
    if (name.startsWith("fase")) {
      final angka = name.replaceAll("fase", "");
      return "Ayam Fase $angka";
    }
    return name;
  }

  Widget _buildCollectionCard(double width, double height, Color primaryTextColor, Color cardBorderColor,
      String rewardImage, String title) {
    return Container(
      height: 210,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: cardBorderColor, width: 1),
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
        border: Border.all(color: cardBorderColor, width: 1),
      ),
      child: Center(
        child: Text(
          "Belum ada koleksi",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildTimeToggle(Color primaryTextColor, Color accentColor) {
    const Color backgroundColor = Colors.white;
    const double toggleHeight = 45;
    const double toggleWidth = 170;

    return Center(
      child: Container(
        height: toggleHeight,
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
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      setState(() => isDailySelected = true);
                      await loadFocus(daily: true);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Harian",
                        style: GoogleFonts.inter(
                          color: isDailySelected ? Colors.white : primaryTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      setState(() => isDailySelected = false);
                      await loadFocus(daily: false);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Mingguan",
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

  // ------------------- Chart builders -------------------

  // bottom label untuk daily (double karena fl_chart API)
  Widget _dailyBottomLabel(double value, TitleMeta meta) {
    const labels = {
      0: "00:00",
      6: "06:00",
      12: "12:00",
      18: "18:00",
      23: "23:00",
    };
    final intVal = value.toInt();
    if (!labels.containsKey(intVal)) return const SizedBox.shrink();
    return Text(labels[intVal]!, style: GoogleFonts.inter(color: primaryTextColor, fontSize: 10));
  }

 
 Widget _buildDailyChart(double screenWidth) {
  final chartWidth = screenWidth - 50;
  final chartHeight = 180.0;

final maxVal = dailyHourMinutes.isEmpty ? 75 : dailyHourMinutes.reduce((a, b) => a > b ? a : b);
final displayMax = maxVal < 75 ? 75.0 : maxVal.toDouble();


  // Jumlah garis horizontal yang diinginkan
  final int steps = 5;
  final double interval = displayMax / steps;

  final groups = List.generate(24, (i) {
    final raw = dailyHourMinutes[i];
    final val = (raw < 0 ? 0 : raw).toDouble();
    final show = val > 0;

    return BarChartGroupData(
      x : i,
      barsSpace: 4.0,
      barRods: [
        BarChartRodData(
          toY: show ? val : 0.0,
          width: 8.0,
          borderRadius: BorderRadius.circular(4),
          color: show ? accentColor : Colors.transparent,
          
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: displayMax,
            color: Colors.transparent,
          ),
        ),
      ],
    );
  });

  return Container(
    width: chartWidth,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Total Fokus Hari Ini : ${dailyHourMinutes.fold(0, (s, e) => s + e)} Menit",
            style: GoogleFonts.inter(
              color: primaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: chartHeight,
          child: BarChart(
           BarChartData(
            alignment: BarChartAlignment.spaceAround,
              minY: 0,
              maxY: displayMax,
              barGroups: groups,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: interval,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.shade300,
                  strokeWidth: 0.4,
                ),
              ),
              extraLinesData: ExtraLinesData(horizontalLines: [
                HorizontalLine(
                  y: 0, // garis bawah
                  color: Colors.grey.shade300,
                  strokeWidth: 0.6,
                ),
                HorizontalLine(
                  y: displayMax, // garis atas
                  color: Colors.grey.shade300,
                  strokeWidth: 0.6,
                ),
              ]),

              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: interval,
                    getTitlesWidget: (v, _) => Text(
                      v.toInt().toString(),
                      style: GoogleFonts.inter(color: primaryTextColor, fontSize: 10),
                    ),
                    reservedSize: 30,
                  ),
                ),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: _dailyBottomLabel,
                    interval: 1.0,
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  tooltipBorderRadius: BorderRadius.circular(10),
                  getTooltipColor: (group) => accentColor,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final val = rod.toY.toInt();
                    if (val == 0) return null;

                    return BarTooltipItem(
                      "${group.x}:00\n${val} menit",
                      TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w600,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

 Widget _weeklyBottomLabel(double value, TitleMeta meta) {
    final labels = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"];
    final idx = value.toInt();
    if (idx < 0 || idx >= labels.length) return const SizedBox.shrink();
    return Text(labels[idx], style: GoogleFonts.inter(color: primaryTextColor, fontSize: 10));
  }


 Widget _buildWeeklyChart(double screenWidth) {
  final chartWidth = screenWidth - 50;
  final chartHeight = 180.0;

   final day = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"];
  
  final maxVal = weeklyFocus.isEmpty ? 75 : weeklyFocus.reduce((a, b) => a > b ? a : b);
  final displayMax = (maxVal < 75) ? 75.0 : maxVal.toDouble();   // <- FIX 1

   final int jumlahangka = 5;
   final interval = displayMax / jumlahangka;
  

  final groups = List.generate(7, (i) {
    final v = weeklyFocus[i].toDouble();
    final show = v > 0;

    return BarChartGroupData(
      x: i,
      barsSpace: 6.0,
      barRods: [
        BarChartRodData(
          toY: show ? v : 0.0,
          width: 14.0,
          borderRadius: BorderRadius.circular(4),
          color: show ? accentColor : Colors.transparent,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: displayMax,
            color: Colors.transparent,
          ),
        ),
      ],
    );
  });

  return Container(
    width: chartWidth,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Total Fokus Minggu Ini : ${weeklyFocus.fold(0, (s, e) => s + e)} Menit",
            style: GoogleFonts.inter(
              color: primaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: chartHeight,
          child: BarChart(
           BarChartData(
  maxY: displayMax,
  minY: 0,
  alignment: BarChartAlignment.spaceAround,
  barGroups: groups,
  gridData: FlGridData(
    show: true,
    drawVerticalLine: false,
   horizontalInterval: interval,
    getDrawingHorizontalLine: (value) => FlLine(
      color: Colors.grey.shade300,
      strokeWidth: 0.4,
    ),
  ),
  extraLinesData: ExtraLinesData(horizontalLines: [
    HorizontalLine(
      y: 0, // garis bawah
      color: Colors.grey.shade300,
      strokeWidth: 0.6,
    ),
    HorizontalLine(
      y: displayMax, // garis atas
      color: Colors.grey.shade300,
      strokeWidth: 0.6,
    ),
  ]),
  
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: interval ,
                    getTitlesWidget: (v, _) => Text(
                      v.toInt().toString(),
                      style: GoogleFonts.inter(color: primaryTextColor, fontSize: 10),
                    ),
                    reservedSize: 30,
                  ),
                ),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: _weeklyBottomLabel,
                    reservedSize: 28,
                    interval: 1.0,             // <- FIX 2
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => accentColor,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final val = rod.toY.toInt();
                    if (val == 0) return null;

                    return BarTooltipItem(
                      "${day[group.x]}\n${val} menit",
                      TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w600,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


  // ------------------- Build entire screen -------------------
  bool isDailySelected = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = 154.0;
    const cardHeight = 234.0;

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
                  style: GoogleFonts.inter(color: primaryTextColor, fontSize: 24, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 2),

                Text(
                  "Lihat semua hewan yang sudah kamu kumpulkan.",
                  style: GoogleFonts.inter(color: primaryTextColor, fontSize: 13, fontWeight: FontWeight.w400),
                ),

                const SizedBox(height: 15),

                // --- Koleksi cards (tidak diubah) ---
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: loadingKoleksi
                        ? Center(
                            child: CircularProgressIndicator(
                              color: accentColor,
                            ),
                          )
                        : Row(
                            children: koleksi.isEmpty
                                ? [buildEmptyCard(cardWidth, cardHeight)]
                                : koleksi.map((item) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
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
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  "Statistik",
                  style: GoogleFonts.inter(color: primaryTextColor, fontSize: 24, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 10),

                _buildTimeToggle(primaryTextColor, accentColor),

                const SizedBox(height: 10),

                // --- Chart area ---
                (loadingDailyChart && isDailySelected) || (loadingWeeklyChart && !isDailySelected)
                    ? Center(child: CircularProgressIndicator(color: accentColor))
                    : isDailySelected
                        ? _buildDailyChart(screenWidth)
                        : _buildWeeklyChart(screenWidth),

               
              ],
            ),
          ),
        ),
      ),
    );
  }
}
