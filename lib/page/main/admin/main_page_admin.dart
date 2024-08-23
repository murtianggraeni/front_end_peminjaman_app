import 'package:build_app/controller/count_controller.dart';
import 'package:build_app/controller/user_controller.dart';
import 'package:build_app/models/count_model.dart';
import 'package:build_app/page/main/admin/widget_admin/monitoring_penggunaan_cnc.dart';
import 'package:build_app/page/main/admin/widget_admin/monitoring_penggunaan_lasercut.dart';
import 'package:build_app/page/main/admin/widget_admin/monitoring_penggunaan_printing.dart';
import 'package:build_app/page/main/custom_main_page.dart';
import 'package:build_app/page/main/user/widget_user/custom_dashboard_choose.dart';
import 'package:build_app/page/home/informasi_page/widget/custom_dashboard_informasi_peminjaman.dart';
import 'package:build_app/page/main/user/widget_user/custom_dashboard_peminjaman.dart';
import 'package:build_app/routes/route_name.dart';
import 'package:build_app/theme/theme.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class mainPageAdmin extends StatelessWidget {
  final UserController _userController = Get.put(UserController());
  mainPageAdmin({super.key});

  // final UserController userController = Get.find<UserController>();
  final List<dashboardInformasiPeminjaman> dataList = [
    const dashboardInformasiPeminjaman(
      namaMesin: "CNC Milling",
      dataAcc: "12 Data",
      dataTidakAcc: "01 Data",
      dataDiproses: "24 Data",
      alamatInformasiLanjutan: RouteName.halaman_informasi_cnc,
    ),
    const dashboardInformasiPeminjaman(
      namaMesin: "Laser Cutting",
      dataAcc: "23 Data",
      dataTidakAcc: "11 Data",
      dataDiproses: "08 Data",
      alamatInformasiLanjutan: RouteName.halaman_informasi_lasercut,
    ),
    const dashboardInformasiPeminjaman(
      namaMesin: "3D Printing",
      dataAcc: "09 Data",
      dataTidakAcc: "19 Data",
      dataDiproses: "16 Data",
      alamatInformasiLanjutan: RouteName.halaman_informasi_printing,
    ),
  ];

  Widget carouselView(int index) {
    final dashboardInformasiPeminjaman data = dataList[index];
    return carouselCard(data);
  }

  Widget carouselCard(dashboardInformasiPeminjaman data) {
    return dashboardInformasiPeminjaman(
      namaMesin: data.namaMesin,
      dataAcc: data.dataAcc,
      dataTidakAcc: data.dataTidakAcc,
      dataDiproses: data.dataDiproses,
      alamatInformasiLanjutan: data.alamatInformasiLanjutan,
    );
  }

  @override
  Widget build(BuildContext context) {
    _userController.checkLoggedIn();
    // final UserController _userController = Get.find<UserController>();

    // return Obx(() {
    //   if (_userController.role.isEmpty) {
    //     return Scaffold(
    //       body: Center(child: CircularProgressIndicator()),
    //     );
    //   }

    //   if (_userController.role.value != 'admin') {
    //     return Scaffold(
    //       body: Center(
    //         child: Text(
    //           'Anda tidak memiliki akses ke halaman ini',
    //           style: GoogleFonts.inter(fontSize: 18.0, color: Colors.black),
    //         ),
    //       ),
    //     );
    //   }

    return customScaffoldPage(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 25,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Hi, ",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white),
                        ),
                        Text(
                          '',
                          // userController.user.value.username,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Selamat datang kembali!",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: const Color(0xFFE2E2E2),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 48,
                  width: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                    color: Color(0xFFDFE7EF),
                  ),
                  child: const Icon(
                    Icons.notifications_active_sharp,
                    size: 24,
                    color: Color(0xFF1D5973),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 71),
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 19),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22.0),
                  topRight: Radius.circular(22.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        buttonPilihMesin(
                          pilihanMesin: "Mesin CNC dipilih",
                          namaMesin: "CNC",
                          ukuranLebar: 48.0,
                          ukuranTinggi: 24.0,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        buttonPilihMesin(
                          pilihanMesin: "Mesin Laser Cut dipilih",
                          namaMesin: "Laser Cutting",
                          ukuranLebar: 95.0,
                          ukuranTinggi: 24.0,
                        ),
                        SizedBox(width: 8.0),
                        buttonPilihMesin(
                          pilihanMesin: "Mesin 3D Printing dipilih",
                          namaMesin: "3D Printing",
                          ukuranLebar: 81.0,
                          ukuranTinggi: 24.0,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 19.0,
                    ),
                    Text(
                      "Informasi Peminjaman",
                      style: GoogleFonts.inter(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      height: 210.0,
                      width: MediaQuery.of(context).size.width,
                      child: Swiper(
                        outer: true,
                        itemCount: dataList.length,
                        viewportFraction: 0.85,
                        scale: 0.9,
                        physics: const BouncingScrollPhysics(),
                        pagination: SwiperPagination(
                          builder: DotSwiperPaginationBuilder(
                            color: pageModeScheme.onSecondary,
                            activeColor: pageModeScheme.primary,
                            activeSize: 10,
                          ),
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: const BoxDecoration(),
                            child: carouselView(index),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Form Peminjaman",
                          style: GoogleFonts.inter(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print(
                              "Tap View All",
                            ); // Fungsi yang akan dijalankan saat tombol ditekan
                          },
                          child: Text(
                            'View All',
                            style: GoogleFonts.inter(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF3D8FEF),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    // Tampilan Awal Form Peminjaman
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          buttonPeminjaman(
                            page: monitoringPenggunaanCnc(),
                            objekDipilih: "Memilih CNC Milling",
                            merekMesin: "MTU 200 M",
                            namaMesin: "CNC Milling",
                            namaLab: "Lab. Elektro Mekanik",
                            gambarMesin: "assets/images/foto_cnc.png",
                            leftImage: 23.0,
                            topImage: 4.0,
                            topArrow: 2.0,
                          ),
                          const SizedBox(width: 11.0),
                          buttonPeminjaman(
                            page: monitoringPenggunaanLasercut(),
                            objekDipilih: "Memilih Laser Cutting",
                            merekMesin: "TQL-1390",
                            namaMesin: "Laser Cutting",
                            namaLab: "Lab. Elektro Mekanik",
                            gambarMesin: "assets/images/foto_lasercut.png",
                            leftImage: 3.0,
                            topImage: 18.0,
                            topArrow: 11.0,
                          ),
                          const SizedBox(width: 11.0),
                          buttonPeminjaman(
                            page: monitoringPenggunaanPrinting(),
                            objekDipilih: "Memilih 3D Printing",
                            merekMesin: "Anycubic 4Max Pro",
                            namaMesin: "3D Printing",
                            namaLab: "Lab. PLC & HMI",
                            gambarMesin: "assets/images/foto_3dp.png",
                            leftImage: 6.0,
                            topImage: 9.0,
                            topArrow: 4.5,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Jadwal Peminjaman",
                          style: GoogleFonts.inter(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "View All",
                          style: GoogleFonts.inter(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF3D8FEF)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 13.0,
                    ),
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: pageModeScheme.onPrimary,
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: TableCalendar(
                        focusedDay: DateTime.now(),
                        firstDay: DateTime.utc(2024, 01, 01),
                        lastDay: DateTime.utc(2050, 01, 01),
                        // selectedDayPredicate: (day) {
                        //   return isSameDay(_selectedDay, day);
                        // },
                        // onDaySelected: (selectedDay, focusedDay) {
                        //   setState(() {
                        //     _selectedDay = selectedDay;
                        //     _focusedDay =
                        //         focusedDay; // update `_focusedDay` here as well
                        //   });
                        // },
                        calendarStyle: const CalendarStyle(
                          cellMargin: EdgeInsets.all(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    // });
  }
}
