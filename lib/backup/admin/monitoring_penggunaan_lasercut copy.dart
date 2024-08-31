import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/la.dart';

import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:intl/intl.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

class monitoringPenggunaanLasercut extends StatefulWidget {
  const monitoringPenggunaanLasercut({super.key});

  @override
  State<monitoringPenggunaanLasercut> createState() =>
      _monitoringPenggunaanLasercutState();
}

class _monitoringPenggunaanLasercutState
    extends State<monitoringPenggunaanLasercut> {
  final List<Map<String, dynamic>> _userData = [
    {
      "nama": "Raihan Sar Isyraf",
      "penggunaan": "laser cutting",
      "durasi": "10:50:00"
    },
    {
      "nama": "Rudi",
      "penggunaan": "Laser Cutting akrilik 5mm",
      "durasi": "01:00:00"
    },
    {
      "nama": "Bagas Poetra Aditama",
      "penggunaan": "mesin laser cutting",
      "durasi": "12:00:00"
    },
    {
      "nama": "Fadhil Muhammad Afif",
      "penggunaan": "Laser Cutting",
      "durasi": "00:40:00"
    },
    {
      "nama": "Rachmat Syaiful Mujab",
      "penggunaan": "Tugas Akhir",
      "durasi": "17:20:00"
    },
    {
      "nama": "Ihsan Alfarisi",
      "penggunaan": "Mesin Laser Cutting",
      "durasi": "00:30:00"
    },
    {
      "nama": "Rafi Ahmad Ramadan",
      "penggunaan": "Tugas Akhir",
      "durasi": "00:15:00"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 25.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/calendar.png',
                          height: 24.0,
                          width: 24.0,
                        ),
                        const SizedBox(
                          width: 6.0,
                        ),
                        Text(
                          DateFormat('EEE, \ndd MMM yyyy').format(
                            DateTime.now(),
                          ),
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF202636).withOpacity(0.6),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      "Monitoring Penggunaan Mesin",
                      style: GoogleFonts.inter(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF113159).withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // --- RATA - RATA PENGGUNAAN MESIN ---
                            Container(
                              width: 162,
                              height: 74.0,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                border: Border.all(
                                  color: const Color(0xFFEAEBEE),
                                ),
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
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
                                          children: [
                                            Container(
                                              height: 38.0,
                                              width: 38.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: const Color(0xFFFFFFFF),
                                                border: Border.all(
                                                  color:
                                                      const Color(0XFFDADBDF),
                                                ),
                                              ),
                                              child: const Icon(
                                                Symbols.avg_time_rounded,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 7.0,
                                            ),
                                            Text(
                                              "1j 30m 0s",
                                              style: GoogleFonts.inter(
                                                fontSize: 16.5,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF000019),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 7.0,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 10.0,
                                          height: 10.0,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFCEE7E1),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(1.0),
                                            child: Iconify(
                                              Ic.outline_trending_up,
                                              color: Color(0xFF009457),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "Rata-rata penggunaan mesin",
                                      style: GoogleFonts.inter(
                                        fontSize: 9.0,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF202636)
                                            .withOpacity(0.6),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 11.0,
                            ),
                            // --- PENGGUNA MESIN PER-HARI INI ---
                            Container(
                              width: 162,
                              height: 74.0,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                border: Border.all(
                                  color: const Color(0xFFEAEBEE),
                                ),
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
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
                                          children: [
                                            Container(
                                              height: 38.0,
                                              width: 38.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: const Color(0xFFFFFFFF),
                                                border: Border.all(
                                                  color:
                                                      const Color(0XFFDADBDF),
                                                ),
                                              ),
                                              child: const Icon(
                                                MingCuteIcons
                                                    .mgc_user_info_fill,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 7.0,
                                            ),
                                            Text(
                                              "4",
                                              style: GoogleFonts.inter(
                                                fontSize: 16.5,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF000019),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 3.0,
                                            ),
                                            Text(
                                              "pengguna",
                                              style: GoogleFonts.inter(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF000019),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 7.0,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 10.0,
                                          height: 10.0,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFCEE7E1),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(1.0),
                                            child: Iconify(
                                              Ic.outline_trending_up,
                                              color: Color(0xFF009457),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "Pengguna Mesin Per-hari Ini",
                                      style: GoogleFonts.inter(
                                        fontSize: 9.0,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF202636)
                                            .withOpacity(0.6),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 11.0,
                        ),
                        Row(
                          children: [
                            // --- TOTAL PENGGUNAAN MESIN ---
                            Container(
                              width: 162,
                              height: 74.0,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                border: Border.all(
                                  color: const Color(0xFFEAEBEE),
                                ),
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 8.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 38.0,
                                          width: 38.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(0xFFFFFFFF),
                                            border: Border.all(
                                              color: const Color(0XFFDADBDF),
                                            ),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(7.0),
                                            child: Iconify(
                                              AntDesign.field_time_outlined,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 7.0,
                                        ),
                                        Text(
                                          "10j 30m 0s",
                                          style: GoogleFonts.inter(
                                            fontSize: 16.5,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF000019),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 7.0,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "Total Penggunaan Mesin",
                                      style: GoogleFonts.inter(
                                        fontSize: 9.0,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF202636)
                                            .withOpacity(0.6),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 11.0,
                            ),
                            // --- KESELURUHAN PENGGUNA MESIN ---
                            Container(
                              width: 162.0,
                              height: 74.0,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                border: Border.all(
                                  color: const Color(0xFFEAEBEE),
                                ),
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 8.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 38.0,
                                          width: 38.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(0xFFFFFFFF),
                                            border: Border.all(
                                              color: const Color(0XFFDADBDF),
                                            ),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(7.0),
                                            child: Iconify(
                                              La.users,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 7.0,
                                        ),
                                        Text(
                                          "30",
                                          style: GoogleFonts.inter(
                                            fontSize: 16.5,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF000019),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 3.0,
                                        ),
                                        Text(
                                          "pengguna",
                                          style: GoogleFonts.inter(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF000019),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 7.0,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "Keseluruhan Pengguna Mesin",
                                      style: GoogleFonts.inter(
                                        fontSize: 9.0,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Color(0xFF202636).withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height:
                          300, // Tambahkan batasan tinggi agar tabel dapat di-scroll
                      child: Scrollbar(
                        child: DataTable2(
                          columnSpacing: 12,
                          horizontalMargin: 12,
                          minWidth: 450,
                          columns: const [
                            DataColumn2(
                              label: Text('Nama',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              size: ColumnSize.L,
                            ),
                            DataColumn(
                              label: Text('Penggunaan',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text('Durasi',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                          rows: _userData
                              .map((user) => DataRow(cells: [
                                    DataCell(Text(user['nama'])),
                                    DataCell(Text(user['penggunaan'])),
                                    DataCell(Text(user['durasi'])),
                                  ]))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
