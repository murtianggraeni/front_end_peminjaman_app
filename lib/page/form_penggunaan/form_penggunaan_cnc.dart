import 'package:build_app/page/form_penggunaan/utility/custom_form_page.dart';
import 'package:build_app/page/form_penggunaan/tab_penggunaan/form_laporan_kerusakan.dart';
import 'package:build_app/page/form_penggunaan/tab_penggunaan/form_peminjaman.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class formPenggunaanCnc extends StatefulWidget {
  const formPenggunaanCnc({super.key});

  @override
  State<formPenggunaanCnc> createState() => _formPenggunaanCncState();
}

class _formPenggunaanCncState extends State<formPenggunaanCnc>
    with SingleTickerProviderStateMixin {
  final _formPenggunaanCnc = GlobalKey<FormState>();
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFF757575), size: 20.0),
        titleTextStyle:
            GoogleFonts.inter(fontSize: 15.5, fontWeight: FontWeight.w500),
        elevation: 0, // agar appbar header tidak meninggalkan shadow
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Form(
            key: _formPenggunaanCnc,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 23.0, vertical: 55.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Form Penggunaan CNC Milling",
                    style: GoogleFonts.inter(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6B7888),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  const customFormPeminjaman(
                    returnText: "Silahkan mengisi email",
                    judul: "Email",
                    hintText: "Contoh: ayu@mhs.polman-bandung.ac.id",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const customFormPeminjaman(
                    returnText: "Silahkan mengisi nama lengkap",
                    judul: "Nama Pemohon",
                    hintText: "contoh: Ayu Asahi",
                  ),
                  Text(
                    "Keperluan",
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF6B7888),
                    ),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Container(
                          // height: 52.0,
                          width: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F1F1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TabBar(
                                    labelColor: Colors.black,
                                    unselectedLabelColor:
                                        const Color(0xFF6B7888),
                                    indicatorColor: Colors.white,
                                    indicatorWeight: 2,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    indicator: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    controller: tabController,
                                    tabs: const [
                                      Tab(
                                        text: 'Peminjaman',
                                      ),
                                      Tab(
                                        text: 'Laporan Kerusakan',
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: TabBarView(
                                controller: tabController,
                                children: const [
                              formPeminjaman(),
                              formLaporanKerusakan(),
                            ])),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

// backup
                  // Text(
                  //   "Keperluan",
                  //   style: GoogleFonts.inter(
                  //     fontSize: 14.0,
                  //     fontWeight: FontWeight.w300,
                  //     color: const Color(0xFF6B7888),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 4.0,
                  // ),
                  // ToggleSwitch(
                  //   minHeight: 52.0,
                  //   minWidth: MediaQuery.of(context).size.width,
                  //   fontSize: 16.0,
                  //   initialLabelIndex: 1,
                  //   activeBgColor: const [Color(0xFFE2E2E2)],
                  //   activeFgColor: Colors.black,
                  //   inactiveBgColor: const Color(0xFFF1F1F1),
                  //   inactiveFgColor: const Color(0XFF6B7888),
                  //   totalSwitches: 2,
                  //   labels: const ['Peminjaman', 'Laporan Kerusakan'],
                  //   onToggle: (index) {
                  //     print('switched to: $index');
                  //   },
                  // ),
                  // const SizedBox(
                  //   height: 11.0,
                  // ),
                  // customFormPeminjaman(
                  //   returnText: "Silahkan mengisi batas peminjaman",
                  //   judul: "Tanggal Peminjaman",
                  //   hintText: DateFormat('d/MM/yy').format(DateTime.now()),
                  //   icon: IconButton(
                  //       onPressed: () {},
                  //       icon: const Icon(MingCute.calendar_month_fill),
                  //       color: const Color(0xFFB9B9B9)),
                  //   keyboardType: TextInputType.datetime,
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: customFormPeminjaman(
                  //         returnText: "Silahkan mengisi batas peminjaman",
                  //         judul: "Awal Peminjaman",
                  //         hintText:
                  //             DateFormat('hh:mm a').format(DateTime.now()),
                  //         icon: IconButton(
                  //             onPressed: () {},
                  //             icon: const Icon(MingCute.time_fill),
                  //             color: const Color(0xFFB9B9B9)),
                  //         keyboardType: TextInputType.datetime,
                  //       ),
                  //     ),
                  //     const SizedBox(
                  //       width: 6.0,
                  //     ),
                  //     Expanded(
                  //       child: customFormPeminjaman(
                  //         returnText: "Silahkan mengisi batas peminjaman",
                  //         judul: "Akhir Peminjaman",
                  //         hintText:
                  //             DateFormat('hh:mm a').format(DateTime.now()),
                  //         icon: IconButton(
                  //           onPressed: () {},
                  //           icon: const Icon(MingCute.time_fill),
                  //           color: const Color(0xFFB9B9B9),
                  //         ),
                  //         keyboardType: TextInputType.datetime,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const customFormPeminjaman(
                  //   returnText:
                  //       "Silahkan mengisi jumlah yang akan dilakukan pemesinan",
                  //   judul: "Jumlah/Satuan",
                  //   hintText: "Contoh: 2 Part",
                  // ),
                  // const customFormPeminjaman(
                  //   returnText:
                  //       "Silahkan mengisi alasan keperluan dengan rinci",
                  //   judul: "Detail Keperluan",
                  //   hintText: "Contoh: untuk memenuhi tugas mata kuliah",
                  // ),