import 'package:build_app/page/main/custom_main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/mingcute.dart';
import 'package:intl/intl.dart';

// Kelas untuk menyimpan detail form yang telah diisi
class FormSubmission {
  final String jenisMesin;
  final DateTime tanggalPengajuan;
  final TimeOfDay waktuMulai;
  final TimeOfDay waktuAkhir;
  final String status;

  FormSubmission({
    required this.jenisMesin,
    required this.tanggalPengajuan,
    required this.waktuMulai,
    required this.waktuAkhir,
    required this.status,
  });

  // Menghitung total waktu peminjaman dalam jam
  double hitungTotalWaktuPeminjaman() {
    final start = DateTime(
      tanggalPengajuan.year,
      tanggalPengajuan.month,
      tanggalPengajuan.day,
      waktuMulai.hour,
      waktuMulai.minute,
    );
    final end = DateTime(
      tanggalPengajuan.year,
      tanggalPengajuan.month,
      tanggalPengajuan.day,
      waktuAkhir.hour,
      waktuAkhir.minute,
    );
    return end.difference(start).inHours.toDouble() +
        (end.difference(start).inMinutes.remainder(60) / 60);
  }
}

class accountPage extends StatefulWidget {
  const accountPage({super.key});

  @override
  State<accountPage> createState() => _accountPageState();
}

// untuk mendapatkan warna berdasarkan status
Color dapatkanWarnaStatus(String status) {
  switch (status) {
    case 'diproses':
      return Colors.orange.shade100;
    case 'diterima':
      return const Color(0XFFBEF4CF);
    case 'ditolak':
      return Colors.red.shade100;

    default:
      return Colors.grey.shade300;
  }
}

// Untuk menentukan warna teks berdasarkan status
Color dapatkanWarnaTeksStatus(String status) {
  switch (status) {
    case 'diproses':
      return Colors.orange[800]!;
    case 'diterima':
      return const Color(0xFF129128);
    case 'ditolak':
      return Colors.red[800]!;
    default:
      return Colors.grey[800]!;
  }
}

class _accountPageState extends State<accountPage> {
  // Contoh data form submission
  FormSubmission submission = FormSubmission(
    jenisMesin: "Laser Cutting",
    tanggalPengajuan: DateTime.now(),
    waktuMulai: TimeOfDay(hour: 9, minute: 0),
    waktuAkhir: TimeOfDay(hour: 17, minute: 0),
    status: "diterima",
  );

  // Fungsi untuk menghandle penekanan tombol
  void _handleButtonPress() {
    final DateTime currentDateTime = DateTime.now();
    final bool isApproved = submission.status == 'diterima';
    final bool isWithinTime = currentDateTime.isAfter(DateTime(
      submission.tanggalPengajuan.year,
      submission.tanggalPengajuan.month,
      submission.tanggalPengajuan.day,
      submission.waktuMulai.hour,
      submission.waktuAkhir.minute,
    ));

    if (isApproved && isWithinTime) {
      //Logika untuk memulai peminjaman
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Peminjaman Dimulai"),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Logika untuk menunjukkan peringatan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Peminjaman belum dapat dimulai"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return customScaffoldPage(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 36.0,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22.0),
                  topRight: Radius.circular(22.0),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 24.0,
                    ),
                    Center(
                      child: Text(
                        'Status Peminjaman',
                        style: GoogleFonts.inter(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),

                    // --- header --
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // --- Searchbar ---
                        Expanded(
                          flex: 5,
                          child: searchbar(),
                        ),

                        SizedBox(
                          width: 8.0,
                        ),
                        // --- Filter ---
                        Expanded(
                          flex: 3,
                          child: filterbar(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          width: constraints.maxWidth,
                          height: 140.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFE3E3E3),
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 8.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Iconify(
                                          Mingcute.schedule_line,
                                          size: 30.0,
                                        ),
                                        const SizedBox(
                                          width: 12.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Keperluan Peminjaman",
                                              style: GoogleFonts.inter(
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              DateFormat('dd MMM yyy').format(
                                                submission.tanggalPengajuan,
                                              ),
                                              style: GoogleFonts.inter(
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0XFF6B6B6B),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 56.0,
                                      height: 17.0,
                                      decoration: BoxDecoration(
                                        color: dapatkanWarnaStatus(
                                            submission.status),
                                        borderRadius:
                                            BorderRadius.circular(3.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          submission.status,
                                          style: GoogleFonts.inter(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                            color: dapatkanWarnaTeksStatus(
                                                submission.status),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 1.0,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE3E3E3),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 35.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFCED9DF),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Image.asset(
                                          "assets/images/foto_lasercut.png",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 3.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Peminjaman Mesin",
                                            style: GoogleFonts.inter(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Laser Cutting",
                                            style: GoogleFonts.inter(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFF5C5C5C),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Total Jam Peminjaman",
                                          style: GoogleFonts.inter(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF5C5C5C),
                                          ),
                                        ),
                                        Text(
                                          "10 jam",
                                          style: GoogleFonts.inter(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF1E1E1E),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(90.0, 17.0),
                                        backgroundColor:
                                            const Color(0xFF00A95B),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5.0,
                                          horizontal: 7.0,
                                        ),
                                      ),
                                      child: Text(
                                        "Mulai Peminjaman",
                                        style: GoogleFonts.inter(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Kelas Filter ---
class filterbar extends StatefulWidget {
  const filterbar({
    super.key,
  });

  @override
  State<filterbar> createState() => _filterbarState();
}

class _filterbarState extends State<filterbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40.0,
        // width: 90.0,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: const Color(0xFFDDDEE3),
          ),
        ),
        child: TextField(
          readOnly: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Filter",
            hintStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: const Color(0xFF999999),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            prefixIcon: const Iconify(
              Bx.bx_slider_alt,
              color: Color(0xFF09244B),
            ),
          ),
          onTap: () {},
        ));
  }
}

// --- Kelas Searchbar ---
class searchbar extends StatefulWidget {
  const searchbar({
    super.key,
  });

  @override
  State<searchbar> createState() => _searchbarState();
}

class _searchbarState extends State<searchbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // width: 235.0,
        height: 40.0,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
          border: Border.all(
            color: const Color(0xFFDDDEE3),
          ),
        ),
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Cari Keperluan",
            hintStyle: GoogleFonts.inter(
              //fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF999999),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            prefixIcon: const Iconify(
              Mingcute.search_line,

              color: Color(0xFF09244B),
              //size: 18.0,
            ),
          ),
          onChanged: (value) {},
        ));
  }
}
