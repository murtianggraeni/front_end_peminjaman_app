// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:calendar_view/calendar_view.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:build_app/controller/approvedPeminjaman_controller.dart';
// import 'package:build_app/models/approvedPeminjaman_model.dart';

// // ... other imports ...

// class mainPageUser extends StatefulWidget {
//   mainPageUser({Key? key}) : super(key: key);

//   @override
//   State<mainPageUser> createState() => _mainPageUserState();
// }

// class _mainPageUserState extends State<mainPageUser> {
//   final CountController countC = Get.put(CountController());
//   final UserController _userController = Get.put(UserController());
//   final ApprovedPeminjamanController approvedPeminjamanController =
//       Get.put(ApprovedPeminjamanController());

//   EventController eventController = EventController();

//   @override
//   void initState() {
//     super.initState();
//     approvedPeminjamanController.fetchApprovedPeminjaman().then((_) {
//       _loadEvents();
//     });
//   }

//   void _loadEvents() {
//     if (approvedPeminjamanController.approvedPeminjaman.value != null) {
//       for (var peminjaman in approvedPeminjamanController.approvedPeminjaman.value!.data) {
//         DateTime startTime = DateTime.parse(peminjaman.tanggalPeminjaman + " " + peminjaman.awalPeminjaman);
//         DateTime endTime = DateTime.parse(peminjaman.tanggalPeminjaman + " " + peminjaman.akhirPeminjaman);
        
//         eventController.add(CalendarEventData(
//           title: peminjaman.namaMesin,
//           description: peminjaman.namaPemohon,
//           startTime: startTime,
//           endTime: endTime,
//           color: _getColorForMachine(peminjaman.namaMesin),
//         ));
//       }
//     }
//   }

//   Color _getColorForMachine(String namaMesin) {
//     switch (namaMesin) {
//       case "CNC Milling":
//         return Colors.blue;
//       case "Laser Cutting":
//         return Colors.red;
//       case "3D Printing":
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return customScaffoldPage(
//       body: Column(
//         children: [
//           // ... other widgets ...

//           Expanded(
//             flex: 6,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 19),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(22.0),
//                   topRight: Radius.circular(22.0),
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // ... other widgets ...

//                     const SizedBox(height: 35.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Jadwal Peminjaman",
//                           style: GoogleFonts.inter(
//                             fontSize: 14.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                         Text(
//                           "View All",
//                           style: GoogleFonts.inter(
//                               fontSize: 14.0,
//                               fontWeight: FontWeight.bold,
//                               color: const Color(0xFF3D8FEF)),
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: 13.0),
//                     Container(
//                       height: 400,
//                       decoration: BoxDecoration(
//                         color: pageModeScheme.onPrimary,
//                         shape: BoxShape.rectangle,
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(20.0),
//                           topRight: Radius.circular(20.0),
//                         ),
//                       ),
//                       child: Obx(() {
//                         if (approvedPeminjamanController.isLoading.value) {
//                           return Center(child: CircularProgressIndicator());
//                         } else {
//                           return WeekView(
//                             controller: eventController,
//                             showLiveTimeLineInAllDays: true,
//                             width: 400,
//                             eventTileBuilder: (date, events, boundary, start, end) {
//                               return Container(
//                                 decoration: BoxDecoration(
//                                   color: events[0].color.withOpacity(0.8),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     events[0].title,
//                                     style: TextStyle(color: Colors.white, fontSize: 12),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               );
//                             },
//                             onEventTap: (events, date) {
//                               _showPeminjamanDetails(events[0]);
//                             },
//                           );
//                         }
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showPeminjamanDetails(CalendarEventData event) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Detail Peminjaman'),
//         content: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Mesin: ${event.title}'),
//             Text('Pemohon: ${event.description}'),
//             Text('Mulai: ${event.startTime.toString()}'),
//             Text('Selesai: ${event.endTime.toString()}'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             child: Text('Tutup'),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:build_app/controller/count_controller.dart';
// import 'package:build_app/controller/user_controller.dart';
// import 'package:build_app/controller/approvedPeminjaman_controller.dart';
// import 'package:build_app/models/approvedPeminjaman_model.dart';
// import 'package:build_app/models/count_model.dart';
// import 'package:build_app/page/home/form_peminjaman/form_penggunaan_printing.dart';
// import 'package:build_app/page/home/form_peminjaman/form_penggunaan_cnc.dart';
// import 'package:build_app/page/home/form_peminjaman/form_penggunaan_lasercut.dart';
// import 'package:build_app/page/main/custom_main_page.dart';
// import 'package:build_app/page/main/user/widget_user/custom_dashboard_choose.dart';
// import 'package:build_app/page/home/informasi_page/widget/custom_dashboard_informasi_peminjaman.dart';
// import 'package:build_app/page/main/user/widget_user/custom_dashboard_peminjaman.dart';
// import 'package:build_app/routes/route_name.dart';
// import 'package:build_app/theme/theme.dart';
// import 'package:calendar_view/calendar_view.dart';
// import 'package:card_swiper/card_swiper.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:table_calendar/table_calendar.dart';

// class mainPageUser extends StatefulWidget {
//   mainPageUser({Key? key}) : super(key: key);

//   @override
//   State<mainPageUser> createState() => _mainPageUserState();
// }

// class _mainPageUserState extends State<mainPageUser> {
//   final CountController countC = Get.put(CountController());
//   final UserController _userController = Get.put(UserController());
//   final ApprovedPeminjamanController approvedPeminjamanController =
//       Get.put(ApprovedPeminjamanController());

//   EventController eventController = EventController();

//   @override
//   void initState() {
//     super.initState();
//     approvedPeminjamanController.fetchApprovedPeminjaman().then((_) {
//       _loadEvents();
//     });
//   }

//   void _loadEvents() {
//     if (approvedPeminjamanController.approvedPeminjaman.value != null) {
//       for (var peminjaman
//           in approvedPeminjamanController.approvedPeminjaman.value!.data) {
//         try {
//           DateTime date =
//               DateFormat("yyyy-MM-dd").parse(peminjaman.tanggalPeminjaman);
//           DateTime startTime = DateFormat("yyyy-MM-dd HH:mm").parse(
//               "${peminjaman.tanggalPeminjaman} ${peminjaman.awalPeminjaman}");
//           DateTime endTime = DateFormat("yyyy-MM-dd HH:mm").parse(
//               "${peminjaman.tanggalPeminjaman} ${peminjaman.akhirPeminjaman}");

//           eventController.add(CalendarEventData(
//             date: date,
//             title: peminjaman.namaMesin,
//             description: peminjaman.namaPemohon,
//             startTime: startTime,
//             endTime: endTime,
//             color: _getColorForMachine(peminjaman.namaMesin),
//           ));
//         } catch (e) {
//           print('Error adding event: $e');
//         }
//       }
//     }
//   }

//   Color _getColorForMachine(String namaMesin) {
//     switch (namaMesin) {
//       case "CNC Milling":
//         return Colors.blue;
//       case "Laser Cutting":
//         return Colors.red;
//       case "3D Printing":
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     _userController.checkLoggedIn();

//     return customScaffoldPage(
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Obx(
//                           () => Text(
//                             "Hi, ${_userController.username.value}",
//                             style: GoogleFonts.inter(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 22,
//                                 color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       "Selamat datang kembali!",
//                       style: GoogleFonts.inter(
//                         fontWeight: FontWeight.w400,
//                         fontSize: 15,
//                         color: const Color(0xFFE2E2E2),
//                       ),
//                     )
//                   ],
//                 ),
//                 Container(
//                   height: 48,
//                   width: 48,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(12.0),
//                     ),
//                     color: Color(0xFFDFE7EF),
//                   ),
//                   child: const Icon(
//                     Icons.notifications_active_sharp,
//                     size: 24,
//                     color: Color(0xFF1D5973),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           const SizedBox(height: 71),
//           Expanded(
//             flex: 6,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 19),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(22.0),
//                   topRight: Radius.circular(22.0),
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Row(
//                       children: [
//                         buttonPilihMesin(
//                           pilihanMesin: "Mesin CNC dipilih",
//                           namaMesin: "CNC",
//                           ukuranLebar: 48.0,
//                           ukuranTinggi: 24.0,
//                         ),
//                         SizedBox(
//                           width: 8.0,
//                         ),
//                         buttonPilihMesin(
//                           pilihanMesin: "Mesin Laser Cut dipilih",
//                           namaMesin: "Laser Cutting",
//                           ukuranLebar: 95.0,
//                           ukuranTinggi: 24.0,
//                         ),
//                         SizedBox(width: 8.0),
//                         buttonPilihMesin(
//                           pilihanMesin: "Mesin 3D Printing dipilih",
//                           namaMesin: "3D Printing",
//                           ukuranLebar: 81.0,
//                           ukuranTinggi: 24.0,
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 19.0,
//                     ),
//                     Text(
//                       "Informasi Peminjaman",
//                       style: GoogleFonts.inter(
//                         fontSize: 14.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10.0),
//                     SizedBox(
//                       height: 210.0,
//                       width: MediaQuery.of(context).size.width,
//                       child: StreamBuilder<Counts>(
//                         stream: countC.sensorStream,
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           } else if (snapshot.hasError) {
//                             return Center(
//                                 child: Text('Error: ${snapshot.error}'));
//                           } else if (!snapshot.hasData ||
//                               snapshot.data!.data.id.isEmpty) {
//                             return Center(
//                               child: Text('No data available'),
//                             );
//                           } else {
//                             Counts counts = snapshot.data!;
//                             return Swiper(
//                               outer: true,
//                               itemCount: 3,
//                               viewportFraction: 0.85,
//                               scale: 0.9,
//                               physics: const BouncingScrollPhysics(),
//                               pagination: SwiperPagination(
//                                 builder: DotSwiperPaginationBuilder(
//                                   color: pageModeScheme.onSecondary,
//                                   activeColor: pageModeScheme.primary,
//                                   activeSize: 10,
//                                 ),
//                               ),
//                               itemBuilder: (context, index) {
//                                 return carouselView(counts, index);
//                               },
//                             );
//                           }
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 10.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Form Peminjaman",
//                           style: GoogleFonts.inter(
//                             fontSize: 14.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             print(
//                               "Tap View All",
//                             );
//                           },
//                           child: Text(
//                             'View All',
//                             style: GoogleFonts.inter(
//                               fontSize: 14.0,
//                               fontWeight: FontWeight.w600,
//                               color: const Color(0xFF3D8FEF),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: 10.0),
//                     SizedBox(
//                       height: 250, 
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemBuilder: (context, index) {
//                           final mesin = listMesin[index % listMesin.length];
//                           return Padding(
//                             padding: const EdgeInsets.only(right: 11.0),
//                             child: buttonPeminjaman(
//                               page: mesin["page"],
//                               objekDipilih: mesin["objekDipilih"],
//                               merekMesin: mesin["merekMesin"],
//                               namaMesin: mesin["namaMesin"],
//                               namaLab: mesin["namaLab"],
//                               gambarMesin: mesin["gambarMesin"],
//                               leftImage: mesin["leftImage"],
//                               topImage: mesin["topImage"],
//                               topArrow: mesin["topArrow"],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 35.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Jadwal Peminjaman",
//                           style: GoogleFonts.inter(
//                             fontSize: 14.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                         Text(
//                           "View All",
//                           style: GoogleFonts.inter(
//                               fontSize: 14.0,
//                               fontWeight: FontWeight.bold,
//                               color: const Color(0xFF3D8FEF)),
//                         )
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 13.0,
//                     ),
//                     Container(
//                       height: 600,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             spreadRadius: 5,
//                             blurRadius: 7,
//                             offset: Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Obx(() {
//                         if (approvedPeminjamanController.isLoading.value) {
//                           return Center(child: CircularProgressIndicator());
//                         } else {
//                           return WeekView(
//                             controller: eventController,
//                             eventTileBuilder:
//                                 (date, events, boundary, start, end) {
//                               return Container(
//                                 decoration: BoxDecoration(
//                                   color: events[0].color.withOpacity(0.8),
//                                   borderRadius: BorderRadius.circular(8),
//                                   border: Border.all(
//                                       color: Colors.white, width: 1.5),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     events[0].title,
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               );
//                             },
//                             onEventTap: (events, date) =>
//                                 _showEventDetails(events[0]),
//                             initialDay: DateTime.now(),
//                             weekDays: const [
//                               WeekDays.monday,
//                               WeekDays.tuesday,
//                               WeekDays.wednesday,
//                               WeekDays.thursday,
//                               WeekDays.friday
//                             ],
//                             weekDayBuilder: (date) {
//                               return Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.blue.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     DateFormat('EEE').format(date),
//                                     style: TextStyle(
//                                         color: Colors.blue[800],
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               );
//                             },
//                             showLiveTimeLineInAllDays: true,
//                             minDay: DateTime(2024, 1, 1),
//                             maxDay: DateTime(2024, 12, 31),
//                             startHour: 8,
//                             endHour: 18,
//                             hourIndicatorSettings: HourIndicatorSettings(
//                               height: 40,
//                               color: Colors.grey[300]!,
//                             ),
//                             timeLineBuilder: (date) => Text(
//                               DateFormat('ha').format(date).toLowerCase(),
//                               style: TextStyle(
//                                   fontSize: 12, color: Colors.grey[600]),
//                             ),
//                             liveTimeIndicatorSettings:
//                                 LiveTimeIndicatorSettings(
//                               color: Colors.red,
//                               height: 3,
//                             ),
//                           );
//                         }
//                       }),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showEventDetails(CalendarEventData event) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Detail Peminjaman',
//             style: TextStyle(color: Colors.blue[800])),
//         content: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Icon(Icons.precision_manufacturing, color: event.color),
//               title: Text('Mesin: ${event.title}'),
//             ),
//             ListTile(
//               leading: Icon(Icons.person, color: Colors.grey),
//               title: Text('Pemohon: ${event.description}'),
//             ),
//             ListTile(
//               leading: Icon(Icons.access_time, color: Colors.green),
//               title: Text(
//                   'Mulai: ${DateFormat('dd MMM yyyy, HH:mm').format(event.startTime)}'),
//             ),
//             ListTile(
//               leading: Icon(Icons.access_time_filled, color: Colors.red),
//               title: Text(
//                   'Selesai: ${DateFormat('dd MMM yyyy, HH:mm').format(event.endTime)}'),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             child: Text('Tutup'),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:syncfusion_flutter_calendar/calendar.dart';
// // ... other imports ...

// class _mainPageUserState extends State<mainPageUser> {
//   // ... existing code ...

//   @override
//   Widget build(BuildContext context) {
//     // ... existing code ...

//     return customScaffoldPage(
//       body: Column(
//         children: [
//           // ... existing code ...

//           Expanded(
//             flex: 6,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 19),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(22.0),
//                   topRight: Radius.circular(22.0),
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // ... existing code ...

//                     const SizedBox(height: 35.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Jadwal Peminjaman",
//                           style: GoogleFonts.inter(
//                             fontSize: 14.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                         Text(
//                           "View All",
//                           style: GoogleFonts.inter(
//                             fontSize: 14.0,
//                             fontWeight: FontWeight.bold,
//                             color: const Color(0xFF3D8FEF)
//                           ),
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: 13.0),
//                     Container(
//                       height: 600,
//                       child: Obx(() {
//                         if (approvedPeminjamanController.isLoading.value) {
//                           return Center(child: CircularProgressIndicator());
//                         } else {
//                           return SfCalendar(
//                             view: CalendarView.week,
//                             dataSource: _getCalendarDataSource(),
//                             timeSlotViewSettings: TimeSlotViewSettings(
//                               startHour: 7,
//                               endHour: 18,
//                               nonWorkingDays: <int>[DateTime.saturday, DateTime.sunday],
//                               timeFormat: 'HH:mm',
//                               timeInterval: Duration(minutes: 60),
//                             ),
//                             appointmentBuilder: appointmentBuilder,
//                             headerStyle: CalendarHeaderStyle(
//                               textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[800]),
//                             ),
//                             viewHeaderStyle: ViewHeaderStyle(
//                               dayTextStyle: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold),
//                               dateTextStyle: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold),
//                             ),
//                             onTap: (CalendarTapDetails details) {
//                               if (details.targetElement == CalendarElement.appointment) {
//                                 _showEventDetails(details.appointments!.first);
//                               }
//                             },
//                           );
//                         }
//                       }),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   CalendarDataSource _getCalendarDataSource() {
//     List<Appointment> appointments = [];
//     if (approvedPeminjamanController.approvedPeminjaman.value != null) {
//       for (var peminjaman in approvedPeminjamanController.approvedPeminjaman.value!.data) {
//         DateTime startTime = DateFormat("yyyy-MM-dd HH:mm").parse("${peminjaman.tanggalPeminjaman} ${peminjaman.awalPeminjaman}");
//         DateTime endTime = DateFormat("yyyy-MM-dd HH:mm").parse("${peminjaman.tanggalPeminjaman} ${peminjaman.akhirPeminjaman}");
//         appointments.add(Appointment(
//           startTime: startTime,
//           endTime: endTime,
//           subject: peminjaman.namaMesin,
//           color: _getColorForMachine(peminjaman.namaMesin),
//           notes: peminjaman.namaPemohon,
//         ));
//       }
//     }
//     return _AppointmentDataSource(appointments);
//   }

//   Widget appointmentBuilder(BuildContext context, CalendarAppointmentDetails details) {
//     final Appointment appointment = details.appointments.first;
//     return Container(
//       decoration: BoxDecoration(
//         color: appointment.color.withOpacity(0.8),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Center(
//         child: Text(
//           appointment.subject,
//           style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
//           textAlign: TextAlign.center,
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//     );
//   }

//   void _showEventDetails(Appointment appointment) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Detail Peminjaman', style: TextStyle(color: Colors.blue[800])),
//         content: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Icon(Icons.precision_manufacturing, color: appointment.color),
//               title: Text('Mesin: ${appointment.subject}'),
//             ),
//             ListTile(
//               leading: Icon(Icons.person, color: Colors.grey),
//               title: Text('Pemohon: ${appointment.notes}'),
//             ),
//             ListTile(
//               leading: Icon(Icons.access_time_filled, color: Colors.green),
//               title: Text('Mulai: ${DateFormat('dd MMM yyyy, HH:mm').format(appointment.startTime)}'),
//             ),
//             ListTile(
//               leading: Icon(Icons.access_time_filled, color: Colors.red),
//               title: Text('Selesai: ${DateFormat('dd MMM yyyy, HH:mm').format(appointment.endTime)}'),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             child: Text('Tutup'),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _AppointmentDataSource extends CalendarDataSource {
//   _AppointmentDataSource(List<Appointment> source) {
//     appointments = source;
//   }
// }