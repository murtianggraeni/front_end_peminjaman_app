//monitoring_penggunaan_Cnc.dart

// library backend
import 'package:build_app/models/monitoring_model.dart';
import 'package:build_app/controller/monitoring_controller.dart';
import 'package:build_app/enums/machine_type.dart';
// library frontend
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

class monitoringPenggunaanCnc extends StatelessWidget {
  monitoringPenggunaanCnc({Key? key}) : super(key: key);

  final MonitoringController _controller =
      Get.put(MonitoringController(MachineType.CNC), tag: 'cnc');

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
                    _buildDateRow(),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      "Monitoring Penggunaan Mesin CNC Milling",
                      style: GoogleFonts.inter(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF113159).withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Obx(
                      () => _controller.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Column(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                            borderRadius:
                                                BorderRadius.circular(9.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 8.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: 38.0,
                                                          width: 38.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: const Color(
                                                                0xFFFFFFFF),
                                                            border: Border.all(
                                                              color: const Color(
                                                                  0XFFDADBDF),
                                                            ),
                                                          ),
                                                          child: const Icon(
                                                            Symbols
                                                                .avg_time_rounded,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 7.0,
                                                        ),
                                                        Text(
                                                          _controller.data.value
                                                              .totalDurationToday,
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 16.5,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: const Color(
                                                                0xFF000019),
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
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color:
                                                            Color(0xFFCEE7E1),
                                                      ),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(1.0),
                                                        child: Iconify(
                                                          Ic.outline_trending_up,
                                                          color:
                                                              Color(0xFF009457),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  "Penggunaan Mesin Hari Ini",
                                                  style: GoogleFonts.inter(
                                                    fontSize: 9.0,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        const Color(0xFF202636)
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
                                            borderRadius:
                                                BorderRadius.circular(9.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 8.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: 38.0,
                                                          width: 38.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: const Color(
                                                                0xFFFFFFFF),
                                                            border: Border.all(
                                                              color: const Color(
                                                                  0XFFDADBDF),
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
                                                          "${_controller.data.value.userCountToday}",
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 16.5,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: const Color(
                                                                0xFF000019),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 3.0,
                                                        ),
                                                        Text(
                                                          "pengguna",
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: const Color(
                                                                0xFF000019),
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
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color:
                                                            Color(0xFFCEE7E1),
                                                      ),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(1.0),
                                                        child: Iconify(
                                                          Ic.outline_trending_up,
                                                          color:
                                                              Color(0xFF009457),
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
                                                    color:
                                                        const Color(0xFF202636)
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
                                            borderRadius:
                                                BorderRadius.circular(9.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 8.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: 38.0,
                                                      width: 38.0,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: const Color(
                                                            0xFFFFFFFF),
                                                        border: Border.all(
                                                          color: const Color(
                                                              0XFFDADBDF),
                                                        ),
                                                      ),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(7.0),
                                                        child: Iconify(
                                                          AntDesign
                                                              .field_time_outlined,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 7.0,
                                                    ),
                                                    Text(
                                                      _controller.data.value
                                                          .totalDurationAll,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 16.5,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xFF000019),
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
                                                    color:
                                                        const Color(0xFF202636)
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
                                            borderRadius:
                                                BorderRadius.circular(9.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 8.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: 38.0,
                                                      width: 38.0,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: const Color(
                                                            0xFFFFFFFF),
                                                        border: Border.all(
                                                          color: const Color(
                                                              0XFFDADBDF),
                                                        ),
                                                      ),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(7.0),
                                                        child: Iconify(
                                                          La.users,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 7.0,
                                                    ),
                                                    Text(
                                                      "${_controller.data.value.userCountAll}",
                                                      style: GoogleFonts.inter(
                                                        fontSize: 16.5,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xFF000019),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 3.0,
                                                    ),
                                                    Text(
                                                      "pengguna",
                                                      style: GoogleFonts.inter(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xFF000019),
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
                                                    color: Color(0xFF202636)
                                                        .withOpacity(0.6),
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
                                      450, // Tambahkan batasan tinggi agar tabel dapat di-scroll
                                  child: Scrollbar(
                                    child: DataTable2(
                                      columnSpacing: 12,
                                      horizontalMargin: 12,
                                      minWidth: 450,
                                      columns: const [
                                        DataColumn2(
                                          label: Text('Nama',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          size: ColumnSize.M,
                                        ),
                                        DataColumn2(
                                          label: Text('Kategori',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          size: ColumnSize.M,
                                        ),
                                        DataColumn2(
                                          label: Text('Detail Keperluan',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          size: ColumnSize.L,
                                        ),
                                        DataColumn2(
                                          label: Text('Durasi',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          size: ColumnSize.S,
                                        ),
                                      ],
                                      rows: _controller.data.value.userDetails
                                          .map((user) => DataRow(cells: [
                                                DataCell(Text(user.nama)),
                                                DataCell(Text(user.kategori)),
                                                DataCell(
                                                    Text(user.detailKeperluan)),
                                                DataCell(Text(user.durasi)),
                                              ]))
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ],
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

Widget _buildDateRow() {
  return Row(
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
  );
}
