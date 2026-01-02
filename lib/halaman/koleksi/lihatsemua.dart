import 'package:flutter/material.dart';
import 'package:fokusku/auth/riwayatkoleksi.dart';
import 'package:google_fonts/google_fonts.dart';

class Lihatsemua extends StatefulWidget {
  const Lihatsemua({super.key});

  @override
  State<Lihatsemua> createState() => _LihatsemuaState();
}

class _LihatsemuaState extends State<Lihatsemua> {
  bool loading = true;

  List<Map<String, dynamic>> koleksi = [];
  List<int> availableYears = [];
  int? selectedYear;

  // tahun -> bulan -> list koleksi
  Map<int, Map<int, List<Map<String, dynamic>>>> groupedByYearMonth = {};

  static const Color cardBorderColor = Color.fromARGB(255, 117, 211, 140);
  static const Color primaryTextColor = Color(0xff182E19);
  static const Color backgroundColor = Color(0xFFEAEFD9);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Tahun dari 2025 → sekarang
  List<int> generateYears({int startYear = 2025}) {
    final currentYear = DateTime.now().year;
    return List.generate(
      currentYear - startYear + 1,
      (index) => startYear + index,
    );
  }

  Future<void> loadData() async {
    final data = await RewardService.getKoleksi();

    final Map<int, Map<int, List<Map<String, dynamic>>>> temp = {};

    for (final item in data) {
      final dt = DateTime.parse(item['created_at']);
      final year = dt.year;
      final month = dt.month;

      temp.putIfAbsent(year, () => {});
      temp[year]!.putIfAbsent(month, () => []);
      temp[year]![month]!.add(item);
    }

    setState(() {
      koleksi = data;
      groupedByYearMonth = temp;
      availableYears = generateYears(startYear: 2025);
      selectedYear ??= availableYears.isNotEmpty ? availableYears.first : null;
      loading = false;
    });
  }

  String monthName(int month) {
    const months = [
      "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    return months[month - 1];
  }

  String formatTanggal(DateTime dt) =>
      "${dt.day.toString().padLeft(2, '0')}-"
      "${dt.month.toString().padLeft(2, '0')}-"
      "${dt.year}";

  String formatHari(DateTime dt) {
    const hari = [
      "Senin", "Selasa", "Rabu",
      "Kamis", "Jumat", "Sabtu", "Minggu"
    ];
    return hari[dt.weekday - 1];
  }

  Widget _buildCollectionCard(Map<String, dynamic> item) {
    final createdAt = DateTime.parse(item['created_at']);
    final rewardImage = item['reward_image'];
    final jumlahSesi = item['jumlah_sesi'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: cardBorderColor),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            formatTanggal(createdAt),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Image.asset(
            'assets/images/$rewardImage',
            width: 110,
            height: 110,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          Text(
            "$jumlahSesi sesi fokus",
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formatHari(createdAt),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pilihTahun() async {
    final year = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: availableYears.map((year) {
            final isSelected = year == selectedYear;
            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor:
                  isSelected ? cardBorderColor.withOpacity(0.2) : null,
              title: Text(
                "Tahun $year",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: primaryTextColor,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: primaryTextColor)
                  : null,
              onTap: () => Navigator.pop(context, year),
            );
          }).toList(),
        );
      },
    );

    if (year != null) {
      setState(() => selectedYear = year);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentYearMonths =
        selectedYear != null ? groupedByYearMonth[selectedYear!] ?? {} : {};

  final int totalKoleksi = currentYearMonths.values
    .cast<List<Map<String, dynamic>>>()
    .fold<int>(
      0,
      (prev, list) => prev + list.length,
    );


    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Koleksi Saya",
          style: GoogleFonts.inter(
            color: const Color(0xff293329),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF28AD49),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selector Tahun
                  GestureDetector(
                    onTap: _pilihTahun,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: cardBorderColor),
                      ),
                      child: Row(
                        children: [
                          Text(
                            selectedYear != null
                                ? "Tahun $selectedYear"
                                : "Pilih Tahun",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: primaryTextColor,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: primaryTextColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Total koleksi: $totalKoleksi",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: currentYearMonths.isEmpty
                        ? Center(
                            child: Text(
                              "Belum ada koleksi",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        : ListView(
                            children:
                                currentYearMonths.entries.map((monthEntry) {
                              final month = monthEntry.key;
                              final items = monthEntry.value;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    monthName(month),
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: items.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 0.7,
                                    ),
                                    itemBuilder: (_, index) =>
                                        _buildCollectionCard(items[index]),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            }).toList(),
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
