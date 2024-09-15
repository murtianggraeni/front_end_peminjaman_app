import 'package:build_app/controller/count_controller.dart';
import 'package:build_app/controller/user_controller.dart';
import 'package:build_app/controller/approvedPeminjaman_controller.dart';
import 'package:build_app/models/count_model.dart';
import 'package:build_app/page/home/form_peminjaman/form_penggunaan_printing.dart';
import 'package:build_app/page/home/form_peminjaman/form_penggunaan_cnc.dart';
import 'package:build_app/page/home/form_peminjaman/form_penggunaan_lasercut.dart';
import 'package:build_app/page/main/custom_main_page.dart';
import 'package:build_app/page/main/user/widget_user/custom_dashboard_choose.dart';
import 'package:build_app/page/home/informasi_page/widget/custom_dashboard_informasi_peminjaman.dart';
import 'package:build_app/page/main/user/widget_user/custom_dashboard_peminjaman.dart';
import 'package:build_app/routes/route_name.dart';
import 'package:build_app/theme/theme.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class mainPageUser extends StatefulWidget {
  mainPageUser({Key? key}) : super(key: key);

  @override
  State<mainPageUser> createState() => _mainPageUserState();
}

class _mainPageUserState extends State<mainPageUser> {
  final CountController countC = Get.put(CountController());
  final UserController _userController = Get.put(UserController());
  final ApprovedPeminjamanController approvedPeminjamanController =
      Get.put(ApprovedPeminjamanController());

  // Kelas untuk informasi peminjaman
  Widget carouselCard(dashboardInformasiPeminjaman data) {
    return dashboardInformasiPeminjaman(
      namaMesin: data.namaMesin,
      dataAcc: data.dataAcc,
      dataTidakAcc: data.dataTidakAcc,
      dataDiproses: data.dataDiproses,
      alamatInformasiLanjutan: data.alamatInformasiLanjutan,
    );
  }

  // Data penyimpanan informasi peminjaman
  Widget carouselView(Counts counts, int index) {
    if (index == 0) {
      return carouselCard(dashboardInformasiPeminjaman(
        namaMesin: "CNC Milling",
        dataAcc: "${counts.data.disetujuiCnc} Data",
        dataTidakAcc: "${counts.data.ditolakCnc} Data",
        dataDiproses: "${counts.data.menungguCnc} Data",
        alamatInformasiLanjutan: RouteName.halaman_informasi_cnc,
      ));
    } else if (index == 1) {
      return carouselCard(dashboardInformasiPeminjaman(
        namaMesin: "Laser Cutting",
        dataAcc: "${counts.data.disetujuiLaser} Data",
        dataTidakAcc: "${counts.data.ditolakLaser} Data",
        dataDiproses: "${counts.data.menungguLaser} Data",
        alamatInformasiLanjutan: RouteName.halaman_informasi_lasercut,
      ));
    } else {
      return carouselCard(dashboardInformasiPeminjaman(
        namaMesin: "3D Printing",
        dataAcc: "${counts.data.disetujuiPrinting} Data",
        dataTidakAcc: "${counts.data.ditolakPrinting} Data",
        dataDiproses: "${counts.data.menungguPrinting} Data",
        alamatInformasiLanjutan: RouteName.halaman_informasi_printing,
      ));
    }
  }

  // Data mesin untuk peminjaman pada ButtonPeminjaman
  final List<Map<String, dynamic>> listMesin = [
    {
      "objekDipilih": "Memilih CNC Milling",
      "merekMesin": "MTU 200 M",
      "namaMesin": "CNC Milling",
      "namaLab": "Lab. Elektro Mekanik",
      "gambarMesin": "assets/images/foto_cnc.png",
      "leftImage": 23.0,
      "topImage": 4.0,
      "topArrow": 2.0,
      "page": formPenggunaanCnc(),
    },
    {
      "objekDipilih": "Memilih Laser Cutting",
      "merekMesin": "TQL-1390",
      "namaMesin": "Laser Cutting",
      "namaLab": "Lab. Elektro Mekanik",
      "gambarMesin": "assets/images/foto_lasercut.png",
      "leftImage": 3.0,
      "topImage": 18.0,
      "topArrow": 11.0,
      "page": formPenggunaanLasercut(),
    },
    {
      "objekDipilih": "Memilih 3D Printing",
      "merekMesin": "Anycubic 4Max Pro",
      "namaMesin": "3D Printing",
      "namaLab": "Lab. PLC & HMI",
      "gambarMesin": "assets/images/foto_3dp.png",
      "leftImage": 6.0,
      "topImage": 9.0,
      "topArrow": 4.5,
      "page": formPenggunaanPrinting(),
    },
  ];

  @override
  void initState() {
    super.initState();
    print('Initializing mainPageUser');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      approvedPeminjamanController.fetchApprovedPeminjaman();
    });
  }

  // Parsing Time Strings
  TimeOfDay _parseTimeString(String timeString) {
    try {
      // Assuming timeString is in format "h:mm:ss a" (e.g., "2:00:00 PM")
      print('Parsing time string: $timeString');
      final parts = timeString.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      if (timeString.toLowerCase().contains('pm') && hour != 12) {
        hour += 12;
      } else if (timeString.toLowerCase().contains('am') && hour == 12) {
        hour = 0;
      }
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      print('Error parsing time string: $e');
      return TimeOfDay(hour: 0, minute: 0);
    }
  }

  // Fungsi untuk mendapatkan warna berdasarkan mesin
  Color _getColorForMachine(String namaMesin) {
    print('Getting color for machine: $namaMesin');
    switch (namaMesin.toLowerCase()) {
      case "cnc milling":
      case "cnc":
        print('Returning blue for CNC');
        return Colors.blue;
      case "laser cutting":
      case "laser":
        print('Returning red for Laser Cutting');
        return Colors.red;
      case "3d printing":
      case "printing":
        print('Returning green for 3D Printing');
        return Colors.green;
      default:
        print('Returning grey for unknown machine: $namaMesin');
        return Colors.grey;
    }
  }

  // Source for Calendar Appointments
  CalendarDataSource _getCalendarDataSource() {
    print('Getting calendar data source');
    List<Appointment> appointments = [];
    if (approvedPeminjamanController.approvedPeminjaman.value != null) {
      print('Approved peminjaman data available');
      for (var peminjaman
          in approvedPeminjamanController.approvedPeminjaman.value!.data) {
        print('Processing peminjaman: ${peminjaman.toJson()}');
        try {
          DateTime tanggal =
              DateFormat("yyyy-MM-dd").parse(peminjaman.tanggalPeminjaman);

          TimeOfDay awalTime = _parseTimeString(peminjaman.awalPeminjaman);
          TimeOfDay akhirTime = _parseTimeString(peminjaman.akhirPeminjaman);

          DateTime startTime = DateTime(tanggal.year, tanggal.month,
              tanggal.day, awalTime.hour, awalTime.minute);
          DateTime endTime = DateTime(tanggal.year, tanggal.month, tanggal.day,
              akhirTime.hour, akhirTime.minute);

          Color appointmentColor = _getColorForMachine(peminjaman.namaMesin);
          print(
              'Appointment: ${peminjaman.namaMesin} from $startTime to $endTime with color $appointmentColor');

          appointments.add(Appointment(
            startTime: startTime,
            endTime: endTime,
            subject: peminjaman.namaMesin,
            color: appointmentColor,
            notes: peminjaman.namaPemohon,
          ));
        } catch (e) {
          print('Error processing peminjaman: $e');
        }
      }
    } else {
      print('No approved peminjaman data available');
    }
    print('Created ${appointments.length} appointments');
    return _AppointmentDataSource(appointments);
  }

  @override
  Widget build(BuildContext context) {
    _userController.checkLoggedIn();

    return customScaffoldPage(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => Text(
                            "Hi, ${_userController.username.value}",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Selamat datang kembali!",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
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
                      child: StreamBuilder<Counts>(
                        stream: countC.sensorStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.data.id.isEmpty) {
                            return Center(
                              child: Text('No data available'),
                            );
                          } else {
                            Counts counts = snapshot.data!;
                            return Swiper(
                              outer: true,
                              itemCount: 3,
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
                                return carouselView(counts, index);
                              },
                            );
                          }
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
                    SizedBox(
                      height: 250, // Sesuaikan tinggi sesuai kebutuhan
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // itemCount: 1000000, // Jumlah besar untuk simulasi infinite scroll
                        itemBuilder: (context, index) {
                          final mesin = listMesin[index % listMesin.length];
                          return Padding(
                            padding: const EdgeInsets.only(right: 11.0),
                            child: buttonPeminjaman(
                              page: mesin["page"],
                              objekDipilih: mesin["objekDipilih"],
                              merekMesin: mesin["merekMesin"],
                              namaMesin: mesin["namaMesin"],
                              namaLab: mesin["namaLab"],
                              gambarMesin: mesin["gambarMesin"],
                              leftImage: mesin["leftImage"],
                              topImage: mesin["topImage"],
                              topArrow: mesin["topArrow"],
                            ),
                          );
                        },
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
                      height: 600,
                      child: Obx(() {
                        if (approvedPeminjamanController.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return SfCalendar(
                            view: CalendarView.week,
                            dataSource: _getCalendarDataSource(),
                            timeSlotViewSettings: TimeSlotViewSettings(
                              startHour: 7,
                              endHour: 18,
                              nonWorkingDays: <int>[
                                DateTime.saturday,
                                DateTime.sunday
                              ],
                              timeFormat: 'HH:mm',
                              timeInterval: Duration(minutes: 60),
                            ),
                            appointmentBuilder: appointmentBuilder,
                            headerStyle: CalendarHeaderStyle(
                              textStyle: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800]),
                            ),
                            viewHeaderStyle: ViewHeaderStyle(
                              dayTextStyle: GoogleFonts.inter(
                                  color: Colors.blue[800],
                                  fontWeight: FontWeight.bold),
                              dateTextStyle: GoogleFonts.inter(
                                  color: Colors.blue[800],
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: (CalendarTapDetails details) {
                              if (details.targetElement ==
                                  CalendarElement.appointment) {
                                _showEventDetails(details.appointments!.first);
                              }
                            },
                          );
                        }
                      }),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final Appointment appointment = details.appointments.first;
    return Container(
      decoration: BoxDecoration(
        color: appointment.color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          appointment.subject,
          style: GoogleFonts.inter(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  void _showEventDetails(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Peminjaman',
            style: TextStyle(color: Colors.blue[800])),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  Icon(Icons.precision_manufacturing, color: appointment.color),
              title: Text('Mesin: ${appointment.subject}'),
              titleTextStyle: GoogleFonts.inter(),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.grey),
              title: Text('Pemohon: ${appointment.notes}'),
              titleTextStyle: GoogleFonts.inter(),
            ),
            ListTile(
              leading:
                  const Icon(Icons.access_time_filled, color: Colors.green),
              title: Text(
                  'Mulai: ${DateFormat('dd MMM yyyy, HH:mm').format(appointment.startTime)}'),
              titleTextStyle: GoogleFonts.inter(),
            ),
            ListTile(
              leading: const Icon(Icons.access_time_filled, color: Colors.red),
              title: Text(
                  'Selesai: ${DateFormat('dd MMM yyyy, HH:mm').format(appointment.endTime)}'),
              titleTextStyle: GoogleFonts.inter(),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Tutup'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
