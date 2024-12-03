// // status_page.dart

// import 'dart:async'; // Tambahkan ini untuk menggunakan Timer
// import 'package:build_app/controller/sensor_controller.dart';
// import 'package:build_app/controller/extendPeminjaman_controller.dart';
// import 'package:build_app/services/notification_services.dart';
// import 'package:build_app/controller/notification_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart';
// import 'package:intl/intl.dart';
// import 'package:ming_cute_icons/ming_cute_icons.dart';
// import 'package:build_app/controller/peminjamanUserAll_controller.dart';
// import 'package:build_app/models/peminjamanUserAll_model.dart';
// import 'package:build_app/page/main/custom_main_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // Fungsi helper untuk warna status
// Color dapatkanWarnaStatus(String status) {
//   switch (status) {
//     case 'Disetujui':
//       return Colors.green.shade100;
//     case 'Diproses':
//       return Colors.orange.shade100;
//     case 'Ditolak':
//       return Colors.red.shade100;
//     default:
//       return Colors.grey.shade300;
//   }
// }

// // Fungsi helper untuk warna teks status
// Color dapatkanWarnaTeksStatus(String status) {
//   switch (status) {
//     case 'Disetujui':
//       return Colors.green[800]!;
//     case 'Diproses':
//       return Colors.orange[800]!;
//     case 'Ditolak':
//       return Colors.red[800]!;
//     default:
//       return Colors.grey[800]!;
//   }
// }

// // Fungsi untuk mendapatkan gambar mesin
// String getImageForMachine(String namaMesin) {
//   switch (namaMesin) {
//     case 'CNC Milling':
//       return "assets/images/foto_cnc.png";
//     case '3D Printing':
//       return 'assets/images/foto_3dp.png';
//     case 'Laser Cutting':
//       return 'assets/images/foto_lasercut.png';
//     default:
//       return "assets/images/default_machine.png";
//   }
// }

// // Fungsi agar bagian search bar dan filter bar tidak ikut scroll
// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   _SliverAppBarDelegate({
//     required this.minHeight,
//     required this.maxHeight,
//     required this.child,
//   });

//   final double minHeight;
//   final double maxHeight;
//   final Widget child;

//   @override
//   double get minExtent => minHeight;
//   @override
//   double get maxExtent => maxHeight;

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return SizedBox.expand(child: child);
//   }

//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//     return maxHeight != oldDelegate.maxHeight ||
//         minHeight != oldDelegate.minHeight ||
//         child != oldDelegate.child;
//   }
// }

// class statusPageCopy extends StatefulWidget {
//   const statusPageCopy({Key? key}) : super(key: key);

//   @override
//   State<statusPageCopy> createState() => _statusPageCopyState();
// }

// class _statusPageCopyState extends State<statusPageCopy> {
//   final PeminjamanUserAllController controller =
//       Get.put(PeminjamanUserAllController());
//   final SensorController sensorController = Get.put(SensorController());
//   final ExtendPeminjamanController extendController =
//       Get.put(ExtendPeminjamanController());
//   final NotificationController notificationController =
//       Get.put(NotificationController());
//   final NotificationService _notificationService =
//       Get.find<NotificationService>();

//   Timer? _periodicTimer;
//   bool _disposed = false;

//   // Tambahkan ini untuk melacak tombol yang sudah ditekan
//   Set<String> activatedButtons = {};

//   // untuk melacak apakah perpanjangan sudah dilakukan
//   Set<String> hasExtended = {};

//   // untuk melacak dialog yang sudah muncul
//   Set<String> hasShownDialog = {};

//   // Fungsi untuk memuat status tombol dari SharedPreferences
//   Future<void> _loadActivatedButtons() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       activatedButtons = prefs.getStringList('activatedButtons')?.toSet() ?? {};
//     });
//   }

//   // Fungsi untuk menyimpan status tombol ke SharedPreferences
//   Future<void> _saveActivatedButtons() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList('activatedButtons', activatedButtons.toList());
//   }

//   // Fungsi untuk memuat status dialog dari SharedPreferences
//   Future<void> _loadHasShownDialog() async {
//     final prefs = await SharedPreferences.getInstance();
//     hasShownDialog = prefs.getStringList('hasShownDialog')?.toSet() ?? {};
//   }

//   // Fungsi untuk menyimpan status dialog ke SharedPreferences
//   Future<void> _saveHasShownDialog() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList('hasShownDialog', hasShownDialog.toList());
//   }

//   // Tambahkan fungsi untuk menyimpan status perpanjangan
//   Future<void> _saveHasExtended() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList('hasExtended', hasExtended.toList());
//   }

//   // Tambahkan fungsi untuk memuat status perpanjangan
//   Future<void> _loadHasExtended() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       hasExtended = prefs.getStringList('hasExtended')?.toSet() ?? {};
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadActivatedButtons();
//     _loadHasShownDialog();
//     _loadHasExtended();

//     // Periodic timer untuk mengecek waktu tersisa setiap 1 menit
//     _periodicTimer = Timer.periodic(Duration(minutes: 1), (timer) {
//       if (_disposed) return;

//       final now = DateTime.now();
//       controller.filteredPeminjaman.forEach((peminjaman) {
//         if (activatedButtons.contains(peminjaman.id)) {
//           // Only check active peminjaman
//           final endTime = peminjaman.akhirPeminjamanTime;
//           if (endTime != null && now.isBefore(endTime)) {
//             final timeToEnd = endTime.difference(now);
//             // Kirim notifikasi 5 menit sebelum berakhir
//             if (timeToEnd.inMinutes <= 5 &&
//                 !hasShownDialog.contains(peminjaman.id) &&
//                 !hasExtended.contains(peminjaman.id)) {
//               _sendNotification(peminjaman);
//             }
//             // Only show dialog if we're within 3 minutes of end time
//             if (timeToEnd.inMinutes <= 3) {
//               checkAndShowExtensionDialog(peminjaman);
//             }
//           }
//         }
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _disposed = true; // Set disposed flag
//     _periodicTimer?.cancel(); // Cancel the timer
//     super.dispose();
//   }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _loadActivatedButtons();
//   //   _loadHasShownDialog();
//   //   _loadHasExtended();

//   //   // Timer untuk cek waktu tersisa setiap 1 menit
//   //   Timer.periodic(Duration(minutes: 1), (timer) {
//   //     final now = DateTime.now();

//   //     // Periksa setiap peminjaman yang aktif (isStarted == true)
//   //     controller.filteredPeminjaman.forEach((peminjaman) {
//   //       if (peminjaman.isStarted) {
//   //         // Cek apakah peminjaman sudah dimulai
//   //         final endTime = peminjaman.akhirPeminjamanTime;
//   //         if (endTime != null && now.isBefore(endTime)) {
//   //           checkAndShowExtensionDialog(peminjaman);
//   //         }
//   //       }
//   //     });
//   //   });
//   // }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _loadActivatedButtons();
//   //   _loadHasShownDialog();

//   //   // Timer untuk mengecek status setiap 1 menit
//   //   Timer.periodic(Duration(minutes: 1), (timer) {
//   //     if (!mounted) return;

//   //     final now = DateTime.now();

//   //     // Periksa setiap peminjaman yang aktif
//   //     controller.filteredPeminjaman.forEach((peminjaman) {
//   //       // Hanya cek peminjaman yang aktif
//   //       if (activatedButtons.contains(peminjaman.id)) {
//   //         final endTime = peminjaman.akhirPeminjamanTime;
//   //         if (endTime != null) {
//   //           final timeToEnd = endTime.difference(now);

//   //           // Jika waktu sudah habis
//   //           if (now.isAfter(endTime)) {
//   //             setState(() {
//   //               activatedButtons.remove(peminjaman.id);
//   //               _saveActivatedButtons();
//   //             });
//   //           }
//   //           // Jika mendekati waktu berakhir dan belum pernah menampilkan dialog
//   //           else if (timeToEnd.inMinutes <= 3 &&
//   //               !hasShownDialog.contains(peminjaman.id)) {
//   //             showExtensionDialog(peminjaman.id);
//   //             hasShownDialog.add(peminjaman.id);
//   //             _saveHasShownDialog();
//   //           }
//   //         }
//   //       }
//   //     });
//   //   });
//   // }

//   // Fungsi untuk membedakan button Peminjaman
//   Color _getButtonColor(Datum peminjaman) {
//     final now = DateTime.now();

//     if (peminjaman.status == Status.Diproses) return Colors.grey;
//     if (peminjaman.status != Status.Disetujui) return Colors.grey;

//     // Cek status aktif terlebih dahulu
//     if (sensorController.buttonStateMap[peminjaman.id] == true ||
//         peminjaman.isStarted ||
//         activatedButtons.contains(peminjaman.id)) {
//       // Hanya ubah ke grey jika sudah expired
//       if (peminjaman.akhirPeminjamanTime != null &&
//           now.isAfter(peminjaman.akhirPeminjamanTime!)) {
//         return Colors.grey;
//       }
//       return Colors.blue; // Tetap biru jika aktif dan belum expired
//     }

//     return const Color(0xFF00A95B);
//   }

//   // Color _getButtonColor(Datum peminjaman) {
//   //   final now = DateTime.now();
//   //   if (peminjaman.status == Status.Diproses) return Colors.grey;
//   //   if (peminjaman.status != Status.Disetujui) return Colors.grey;

//   //       // Cek waktu akhir terlebih dahulu
//   //   if (peminjaman.akhirPeminjamanTime != null &&
//   //       now.isAfter(peminjaman.akhirPeminjamanTime!)) {
//   //       // Hapus dari activated buttons jika masih ada
//   //       if (activatedButtons.contains(peminjaman.id)) {
//   //           WidgetsBinding.instance.addPostFrameCallback((_) {
//   //               setState(() {
//   //                   activatedButtons.remove(peminjaman.id);
//   //                   _saveActivatedButtons();
//   //               });
//   //           });
//   //       }
//   //       return Colors.grey;
//   //   }

//   //   // Jika peminjaman sudah dimulai, kembalikan warna biru (aktif)
//   //   if (sensorController.buttonStateMap[peminjaman.id] == true ||
//   //       peminjaman.isStarted ||
//   //       activatedButtons.contains(peminjaman.id)) {
//   //     return Colors.blue; // Tombol untuk peminjaman yang sedang aktif
//   //   }

//   //   DateTime? awalPeminjamanDate = peminjaman.awalPeminjamanTime;
//   //   DateTime? akhirPeminjamanDate = peminjaman.akhirPeminjamanTime;
//   //   if (awalPeminjamanDate == null || akhirPeminjamanDate == null) {
//   //     return Colors.grey;
//   //   }
//   //   // if (awalPeminjamanDate == null || akhirPeminjamanDate == null)
//   //   //   return Colors.grey;

//   //   // final now = DateTime.now();
//   //   if (now.isBefore(awalPeminjamanDate) || now.isAfter(akhirPeminjamanDate)) {
//   //     return Colors.grey;
//   //   }

//   //   // if (now.isBefore(awalPeminjamanDate)) return Colors.grey;
//   //   // if (now.isAfter(akhirPeminjamanDate)) return Colors.grey;

//   //   // if (activatedButtons.contains(peminjaman.id)) return Colors.blue;

//   //   return const Color(0xFF00A95B); // Hijau
//   // }

//   // Fungsi untuk mengetahui teks dalam button Peminjaman
//   String _getButtonText(Datum peminjaman) {
//     if (peminjaman.status == Status.Diproses) return "Belum Tersedia";
//     if (peminjaman.status != Status.Disetujui) return "Tidak Tersedia";

//     // Jika peminjaman sudah dimulai, ubah teksnya menjadi "Peminjaman Aktif"
//     if (sensorController.buttonStateMap[peminjaman.id] == true ||
//         peminjaman.isStarted ||
//         activatedButtons.contains(peminjaman.id)) {
//       // Cek jika sudah expired untuk peminjaman yang aktif
//       final now = DateTime.now();
//       if (peminjaman.akhirPeminjamanTime != null &&
//           now.isAfter(peminjaman.akhirPeminjamanTime!)) {
//         // Hapus dari activated buttons
//         if (activatedButtons.contains(peminjaman.id)) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             setState(() {
//               activatedButtons.remove(peminjaman.id);
//             });
//             _saveActivatedButtons();
//           });
//         }
//         return "Tidak Tersedia";
//       }
//       return "Peminjaman Aktif";
//     }

//     DateTime? awalPeminjamanDate = peminjaman.awalPeminjamanTime;
//     DateTime? akhirPeminjamanDate = peminjaman.akhirPeminjamanTime;
//     if (awalPeminjamanDate == null || akhirPeminjamanDate == null) {
//       return "Tidak Tersedia";
//     }

//     final now = DateTime.now();
//     if (now.isBefore(awalPeminjamanDate)) {
//       return "Mulai Peminjaman";
//     }
//     if (now.isAfter(akhirPeminjamanDate)) {
//       return "Tidak Tersedia";
//     }

//     return "Mulai Peminjaman";
//   }
//   // String _getButtonText(Datum peminjaman) {
//   //   if (peminjaman.status == Status.Diproses) return "Belum Tersedia";
//   //   if (peminjaman.status != Status.Disetujui) return "Tidak Tersedia";

//   //   // Jika peminjaman sudah dimulai, ubah teksnya menjadi "Peminjaman Aktif"
//   //   if (sensorController.buttonStateMap[peminjaman.id] == true ||
//   //       peminjaman.isStarted ||
//   //       activatedButtons.contains(peminjaman.id)) {
//   //     return "Peminjaman Aktif";
//   //   }

//   //   DateTime? awalPeminjamanDate = peminjaman.awalPeminjamanTime;
//   //   DateTime? akhirPeminjamanDate = peminjaman.akhirPeminjamanTime;
//   //   if (awalPeminjamanDate == null || akhirPeminjamanDate == null) {
//   //     return "Tidak Tersedia";
//   //   }

//   //   final now = DateTime.now();
//   //   if (now.isBefore(awalPeminjamanDate)) {
//   //     return "Mulai Peminjaman";
//   //   }
//   //   if (now.isAfter(akhirPeminjamanDate)) {
//   //     return "Tidak Tersedia";
//   //   }

//   //   // if (now.isBefore(awalPeminjamanDate)) return "Mulai Peminjaman";
//   //   // if (now.isAfter(akhirPeminjamanDate)) return "Tidak Tersedia";

//   //   // if (activatedButtons.contains(peminjaman.id)) return "Peminjaman Aktif";

//   //   return "Mulai Peminjaman";
//   // }

//   void _sendNotification(Datum peminjaman) async {
//     if (_disposed) return;

//     try {
//       await notificationController.checkPeminjaman(peminjaman.id);
//       if (!_disposed) {
//         setState(() {
//           hasShownDialog.add(peminjaman.id);
//         });
//         await _saveHasShownDialog();
//       }
//     } catch (e) {
//       if (!_disposed) {
//         Get.snackbar(
//           'Notification Error',
//           'Failed to send notification: ${e.toString()}',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.red[100],
//           colorText: Colors.red[900],
//           duration: Duration(seconds: 3),
//         );
//       }
//     }
//   }

//   // Fungsi untuk button peminjaman
//   bool _canActivateButton(Datum peminjaman) {
//     if (peminjaman.status != Status.Disetujui) {
//       return false;
//     }

//     // Jika peminjaman sudah dimulai, tombol tetap nonaktif
//     if (peminjaman.isStarted) {
//       return false;
//     }

//     if (activatedButtons.contains(peminjaman.id)) {
//       return false;
//     }

//     DateTime? awalPeminjamanDate = peminjaman.awalPeminjamanTime;
//     DateTime? akhirPeminjamanDate = peminjaman.akhirPeminjamanTime;

//     if (awalPeminjamanDate == null || akhirPeminjamanDate == null) {
//       return false;
//     }

//     final now = DateTime.now();
//     bool canActivate =
//         now.isAfter(awalPeminjamanDate) && now.isBefore(akhirPeminjamanDate);
//     return canActivate;
//   }

//   // Fungsi untuk menghitung durasi peminjaman dalam jam dan menit
//   String calculateDuration(Datum peminjaman) {
//     if (peminjaman.awalPeminjamanTime == null ||
//         peminjaman.akhirPeminjamanTime == null) {
//       return 'Waktu tidak valid';
//     }

//     Duration duration = peminjaman.akhirPeminjamanTime!
//         .difference(peminjaman.awalPeminjamanTime!);
//     int hours = duration.inHours;
//     int minutes = duration.inMinutes.remainder(60);

//     if (hours == 0) {
//       return '$minutes menit';
//     } else if (minutes == 0) {
//       return '$hours jam';
//     } else {
//       return '$hours jam $minutes menit';
//     }
//   }

//   // Fungsi untuk memperpanjang waktu peminjaman
//   void showExtensionDialog(String peminjamanId) {
//     // Cari data peminjaman berdasarkan ID
//     final peminjaman = controller.filteredPeminjaman.firstWhere(
//       (p) => p.id == peminjamanId,
//       orElse: () => throw Exception('Peminjaman tidak ditemukan'),
//     );

//     Get.dialog(
//       AlertDialog(
//         title: Text(
//           'Perpanjang Peminjamanan?',
//           style: GoogleFonts.inter(fontWeight: FontWeight.bold),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Informasi Mesin
//             Row(
//               children: [
//                 Container(
//                   width: 35.0,
//                   height: 35.0,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFCED9DF),
//                     borderRadius: BorderRadius.circular(4.0),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(3.0),
//                     child: Image.asset(
//                       getImageForMachine(peminjaman.namaMesin),
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8.0),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       peminjaman.namaMesin,
//                       style: GoogleFonts.inter(
//                         fontSize: 14.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'Berakhir: ${DateFormat('HH:mm').format(peminjaman.akhirPeminjamanTime!)}',
//                       style: GoogleFonts.inter(
//                         fontSize: 12.0,
//                         color: const Color(0xFF5C5C5C),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Text(
//               'Pilih durasi perpanjangan:',
//               style: GoogleFonts.inter(
//                 fontSize: 12.0,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: Text(
//               '15 Menit',
//               style: GoogleFonts.inter(fontWeight: FontWeight.w400),
//             ),
//             onPressed: () {
//               if (_disposed) return; // Check if disposed before updating state
//               Navigator.of(Get.context!).pop();

//               extendController.extendPeminjaman(peminjamanId, 15).then((_) {
//                 if (!_disposed) {
//                   // Check if disposed before setState
//                   setState(() {
//                     hasExtended.add(peminjamanId);
//                   });
//                   _saveHasExtended();

//                   Get.snackbar(
//                     'Sukses',
//                     'Peminjaman ${peminjaman.namaMesin} berhasil diperpanjang 15 menit',
//                     snackPosition: SnackPosition.TOP,
//                     backgroundColor: Colors.green[100],
//                     colorText: Colors.green[800],
//                   );
//                 }
//               }).catchError((error) {
//                 if (!_disposed) {
//                   // Check if disposed before showing error
//                   Get.snackbar(
//                     'Gagal',
//                     error.toString(),
//                     snackPosition: SnackPosition.TOP,
//                     backgroundColor: Colors.red[100],
//                     colorText: Colors.red[800],
//                   );
//                 }
//               });
//             },
//           ),
//           TextButton(
//             child: Text(
//               '30 Menit',
//               style: GoogleFonts.inter(fontWeight: FontWeight.w400),
//             ),
//             onPressed: () {
//               if (_disposed) return; // Check if disposed before updating state
//               Navigator.of(Get.context!).pop();

//               extendController.extendPeminjaman(peminjamanId, 30).then((_) {
//                 if (!_disposed) {
//                   // Check if disposed before setState
//                   setState(() {
//                     hasExtended.add(peminjamanId);
//                   });
//                   _saveHasExtended();

//                   Get.snackbar(
//                     'Sukses',
//                     'Peminjaman ${peminjaman.namaMesin} berhasil diperpanjang 30 menit',
//                     snackPosition: SnackPosition.TOP,
//                     backgroundColor: Colors.green[100],
//                     colorText: Colors.green[800],
//                   );
//                 }
//               }).catchError((error) {
//                 if (!_disposed) {
//                   // Check if disposed before showing error
//                   Get.snackbar(
//                     'Gagal',
//                     error.toString(),
//                     snackPosition: SnackPosition.TOP,
//                     backgroundColor: Colors.red[100],
//                     colorText: Colors.red[800],
//                   );
//                 }
//               });
//             },
//           ),
//           // Similar changes for 30 Menit button...
//           TextButton(
//             child: Text(
//               'Batal',
//               style: GoogleFonts.inter(fontWeight: FontWeight.w300),
//             ),
//             onPressed: () {
//               if (!_disposed) {
//                 // Check if disposed before popping
//                 Navigator.of(Get.context!).pop();
//               }
//             },
//           ),
//         ],
//       ),
//       barrierDismissible: false,
//     );
//   }
//   // void showExtensionDialog(String peminjamanId) {
//   //   // if (!mounted) return; // Cek jika dialog sudah terbuka

//   //   Get.dialog(
//   //     AlertDialog(
//   //       title: const Text('Perpanjang Peminjaman?'),
//   //       content: const Text('Pilih waktu perpanjangan:'),
//   //       actions: <Widget>[
//   //         TextButton(
//   //             child: const Text('15 Menit'),
//   //             onPressed: () {
//   //               // 1. Tutup dialog perpanjangan
//   //               Get.back();

//   //               // 3. Proses perpanjangan
//   //               extendController.extendPeminjaman(peminjamanId, 5).then((_) {

//   //                 setState(() {
//   //                   hasExtended.add(peminjamanId);
//   //                 });
//   //                 _saveHasExtended();
//   //                 // Tampilkan snackbar sukses
//   //                 Get.snackbar(
//   //                   'Sukses',
//   //                   extendController.successMessage.value,
//   //                   snackPosition: SnackPosition.TOP,
//   //                   backgroundColor: Colors.green[100],
//   //                   colorText: Colors.green[800],
//   //                 );
//   //               }).catchError((error) {
//   //                 Get.snackbar(
//   //                   'Gagal',
//   //                   error.toString(),
//   //                   snackPosition: SnackPosition.TOP,
//   //                   backgroundColor: Colors.red[100],
//   //                   colorText: Colors.red[800],
//   //                 );
//   //               });
//   //             }),
//   //         TextButton(
//   //           child: const Text('30 Menit'),
//   //           onPressed: () {
//   //             // 1. Tutup dialog perpanjangan
//   //             Get.back();
//   //             // 3. Proses perpanjangan
//   //             extendController.extendPeminjaman(peminjamanId, 30).then((_) {

//   //               setState(() {
//   //                 hasExtended.add(peminjamanId);
//   //               });
//   //               _saveHasExtended();
//   //               // Tampilkan snackbar sukses
//   //               Get.snackbar(
//   //                 'Sukses',
//   //                 extendController.successMessage.value,
//   //                 snackPosition: SnackPosition.TOP,
//   //                 backgroundColor: Colors.green[100],
//   //                 colorText: Colors.green[800],
//   //               );
//   //             }).catchError((error) {
//   //               Get.snackbar(
//   //                 'Gagal',
//   //                 error.toString(),
//   //                 snackPosition: SnackPosition.TOP,
//   //                 backgroundColor: Colors.red[100],
//   //                 colorText: Colors.red[800],
//   //               );
//   //             });
//   //           },
//   //         ),
//   //         TextButton(
//   //           child: const Text('Tidak'),
//   //           onPressed: () {
//   //             Get.back();
//   //           },
//   //         ),
//   //       ],
//   //     ),
//   //     barrierDismissible: false,
//   //   );
//   // }

//   // Menampilkan tombol perpanjangan 10 menit sebelum peminjaman berakhir
//   // void checkAndShowExtensionDialog(Datum peminjaman) {
//   //   final endTime = peminjaman.akhirPeminjamanTime;
//   //   if (endTime != null) {
//   //     final tenMinutesBefore = endTime.subtract(const Duration(minutes: 10));
//   //     final now = DateTime.now();
//   //     if (now.isAfter(tenMinutesBefore) && now.isBefore(endTime)) {
//   //       showExtensionDialog(peminjaman.id);
//   //     }
//   //   }
//   // }

//   // Fungsi untuk menampilkan dialog perpanjangan hanya sekali
//   // void checkAndShowExtensionDialog(Datum peminjaman) {
//   //   final endTime = peminjaman.akhirPeminjamanTime;
//   //   if (endTime != null) {
//   //     final tenMinutesBefore = endTime.subtract(const Duration(minutes: 3));
//   //     final now = DateTime.now();

//   //     if (now.isAfter(tenMinutesBefore) &&
//   //         now.isBefore(endTime) &&
//   //         !hasShownDialog.contains(peminjaman.id)) {
//   //       showExtensionDialog(peminjaman.id);
//   //       hasShownDialog.add(peminjaman.id);
//   //       _saveHasShownDialog();
//   //     }
//   //   }
//   // }

// // Update checkAndShowExtensionDialog to be more strict about when to show:
//   void checkAndShowExtensionDialog(Datum peminjaman) {
//     if (_disposed) return;

//     final endTime = peminjaman.akhirPeminjamanTime;
//     if (endTime != null) {
//       final threeMinutesBefore = endTime.subtract(Duration(minutes: 3));
//       final twoMinutesBefore = endTime.subtract(Duration(minutes: 2));
//       final now = DateTime.now();

//       // Add stricter conditions:
//       bool shouldShowDialog = now
//               .isAfter(threeMinutesBefore) && // Within last 3 minutes
//           now.isBefore(endTime) && // Before end time
//           now.isBefore(twoMinutesBefore) && // Ensure more than 2 minutes left
//           activatedButtons.contains(peminjaman.id) && // Peminjaman is active
//           !hasShownDialog.contains(peminjaman.id) && // Dialog hasn't been shown
//           !hasExtended.contains(peminjaman.id) && // Haven't extended yet
//           !Get.isDialogOpen!; // No dialog is currently open

//       if (shouldShowDialog) {
//         showExtensionDialog(peminjaman.id);
//         hasShownDialog.add(peminjaman.id);
//         _saveHasShownDialog();
//       }
//     }
//   }

//   // void checkAndShowExtensionDialog(Datum peminjaman) {
//   //   final endTime = peminjaman.akhirPeminjamanTime;
//   //   if (endTime != null) {
//   //     final tenMinutesBefore = endTime.subtract(const Duration(minutes: 3));
//   //     final now = DateTime.now();

//   //     if (now.isAfter(tenMinutesBefore) &&
//   //         now.isBefore(endTime) &&
//   //         !hasShownDialog.contains(peminjaman.id) &&
//   //         !hasExtended.contains(peminjaman.id)) {
//   //       // Cek apakah dialog sudah ditampilkan
//   //       if (Get.isDialogOpen != true) {
//   //         showExtensionDialog(peminjaman.id);
//   //         hasShownDialog.add(peminjaman.id);
//   //         _saveHasShownDialog();
//   //       }
//   //     }
//   //   }
//   // }

//   // Fungsi filter dialog
//   void _showFilterDialog() {
//     final filterOpts = filterOptions();
//     String localSelectedStatus = controller.selectedStatus.value;
//     String localSelectedMachineType = controller.selectedMachineType.value;

//     Get.dialog(
//       StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//           return AlertDialog(
//             title: Text(
//               "Filter Peminjaman",
//               style: GoogleFonts.inter(fontWeight: FontWeight.bold),
//             ),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Status',
//                     style: GoogleFonts.inter(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   DropdownButton<String>(
//                     value: localSelectedStatus,
//                     isExpanded: true,
//                     items: filterOpts.statusOptions.map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       if (newValue != null) {
//                         setState(() {
//                           localSelectedStatus = newValue;
//                         });
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 16.0),
//                   Text(
//                     'Jenis Mesin',
//                     style: GoogleFonts.inter(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   DropdownButton<String>(
//                     value: localSelectedMachineType,
//                     isExpanded: true,
//                     items: filterOpts.machineTypes.map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       if (newValue != null) {
//                         setState(() {
//                           localSelectedMachineType = newValue;
//                         });
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Get.back(),
//                 child: Text(
//                   "Batal",
//                   style: GoogleFonts.inter(),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   controller.setFilters(
//                     status: localSelectedStatus,
//                     machineType: localSelectedMachineType,
//                   );
//                   Get.back();
//                 },
//                 child: Text(
//                   "Terapkan",
//                   style: GoogleFonts.inter(color: Colors.black),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 232, 225, 247),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4.0),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildFilterSection(String title, String selectedValue,
//       List<String> options, Function(String) onChanged) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: GoogleFonts.inter(
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         DropdownButton<String>(
//           value: selectedValue,
//           isExpanded: true,
//           items: options.map((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//           onChanged: (String? newValue) {
//             if (newValue != null) {
//               onChanged(newValue);
//             }
//           },
//         ),
//         const SizedBox(height: 16.0),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return customScaffoldPage(
//       body: Column(
//         children: [
//           const SizedBox(height: 36.0), // Spasi atas
//           Expanded(
//             child: Container(
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(22.0),
//                   topRight: Radius.circular(22.0),
//                 ),
//                 color: Colors.white,
//               ),
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(22.0),
//                   topRight: Radius.circular(22.0),
//                 ),
//                 child: CustomScrollView(
//                   slivers: [
//                     // Header
//                     SliverPersistentHeader(
//                       pinned: true,
//                       delegate: _SliverAppBarDelegate(
//                         minHeight: 120.0,
//                         maxHeight: 120.0,
//                         child: Container(
//                           color: Colors.white,
//                           padding:
//                               const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 10.0),
//                           child: Column(
//                             children: [
//                               Text(
//                                 'Status Peminjaman',
//                                 style: GoogleFonts.inter(
//                                     fontSize: 18.0,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 15.0),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                     flex: 5,
//                                     child: searchbar(
//                                       onSearch: (value) {
//                                         controller.setSearchQuery(value);
//                                       },
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8.0),
//                                   Expanded(
//                                     flex: 3,
//                                     child:
//                                         filterbar(onPressed: _showFilterDialog),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     // Daftar Peminjaman
//                     SliverPadding(
//                       padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
//                       sliver:
//                           //Obx
//                           GetBuilder<PeminjamanUserAllController>(
//                         builder: (controller) {
//                           // if (controller.peminjaman.isEmpty)
//                           final filteredPeminjaman =
//                               controller.filteredPeminjaman;
//                           //if (controller.filteredPeminjaman.isEmpty)
//                           if (filteredPeminjaman.isEmpty) {
//                             return SliverFillRemaining(
//                               child: Center(
//                                 child: Text(
//                                   'Tidak ada data peminjaman',
//                                   style: GoogleFonts.inter(
//                                       fontSize: 16.0,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                             );
//                           }
//                           return SliverList(
//                             delegate: SliverChildBuilderDelegate(
//                               (context, index) {
//                                 // final peminjaman = controller.peminjaman[index];
//                                 //final peminjaman = controller.filteredPeminjaman[index];
//                                 final peminjaman = filteredPeminjaman[index];
//                                 return Padding(
//                                   padding: const EdgeInsets.only(bottom: 10.0),
//                                   child: Container(
//                                     width: MediaQuery.of(context).size.width,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       border: Border.all(
//                                         color: const Color(0xFFE3E3E3),
//                                       ),
//                                       borderRadius: BorderRadius.circular(8.0),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(10.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           // Baris atas: Keperluan Peminjaman dan Status
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   const Icon(
//                                                       MingCuteIcons
//                                                           .mgc_schedule_line,
//                                                       size: 30.0),
//                                                   const SizedBox(width: 9.0),
//                                                   Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         "Keperluan Peminjaman",
//                                                         style:
//                                                             GoogleFonts.inter(
//                                                                 fontSize: 10.0,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold),
//                                                       ),
//                                                       Text(
//                                                         "Diajukan: ${peminjaman.formattedWaktu}",
//                                                         //"Diajukan: ${DateFormat('dd MMM yyyy').format(peminjaman.waktu)}",
//                                                         style:
//                                                             GoogleFonts.inter(
//                                                           fontSize: 10.0,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color: const Color(
//                                                               0XFF6B6B6B),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                               Container(
//                                                 width: 58.0,
//                                                 height: 19.0,
//                                                 // padding: const EdgeInsets.symmetric(
//                                                 //     horizontal: 3, vertical: 3),
//                                                 decoration: BoxDecoration(
//                                                   color: dapatkanWarnaStatus(
//                                                       peminjaman.status.name),
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           3.0),
//                                                 ),
//                                                 child: Center(
//                                                   child: Text(
//                                                     peminjaman.status.name,
//                                                     style: GoogleFonts.inter(
//                                                       fontSize: 10.0,
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                       color:
//                                                           dapatkanWarnaTeksStatus(
//                                                               peminjaman
//                                                                   .status.name),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           const Divider(
//                                             color: Color(0xFFE3E3E3),
//                                           ),
//                                           // Informasi Mesin
//                                           Row(
//                                             children: [
//                                               Container(
//                                                 width: 35.0,
//                                                 height: 35.0,
//                                                 decoration: BoxDecoration(
//                                                   color:
//                                                       const Color(0xFFCED9DF),
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           4.0),
//                                                 ),
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(3.0),
//                                                   child: Image.asset(
//                                                     getImageForMachine(
//                                                         peminjaman.namaMesin),
//                                                     fit: BoxFit.contain,
//                                                   ),
//                                                 ),
//                                               ),
//                                               const SizedBox(width: 12.0),
//                                               Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     "Peminjaman Mesin",
//                                                     style: GoogleFonts.inter(
//                                                         fontSize: 14.0,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   ),
//                                                   Text(
//                                                     peminjaman.namaMesin,
//                                                     style: GoogleFonts.inter(
//                                                       fontSize: 13.0,
//                                                       color: const Color(
//                                                           0xFF5C5C5C),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 8.0),
//                                           // Baris bawah: Total Jam dan Tombol
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     "Total Durasi Peminjaman",
//                                                     style: GoogleFonts.inter(
//                                                       fontSize: 10.0,
//                                                       color: const Color(
//                                                           0xFF5C5C5C),
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     calculateDuration(
//                                                         peminjaman),
//                                                     style: GoogleFonts.inter(
//                                                       fontSize: 12.0,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       color: const Color(
//                                                           0xFF1E1E1E),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               ElevatedButton(
//                                                 onPressed: _canActivateButton(
//                                                         peminjaman)
//                                                     ? () async {
//                                                         if (!activatedButtons
//                                                             .contains(peminjaman
//                                                                 .id)) {
//                                                           setState(() {
//                                                             activatedButtons
//                                                                 .add(peminjaman
//                                                                     .id);
//                                                           });
//                                                           await _saveActivatedButtons(); // Simpan status tombol

//                                                           // Aktifkan relay untuk memulai peminjaman
//                                                           sensorController
//                                                               .turnOnButtonFromFrontend(
//                                                             peminjaman
//                                                                 .id, // ID peminjaman
//                                                             peminjaman.namaMesin
//                                                                 .toLowerCase(), // Tipe mesin
//                                                           );

//                                                           // Cek apakah perlu perpanjangan waktu
//                                                           checkAndShowExtensionDialog(
//                                                               peminjaman);

//                                                           // Tampilkan snackbar sebagai konfirmasi bahwa peminjaman telah dimulai
//                                                           Get.snackbar(
//                                                             "Peminjaman Dimulai",
//                                                             "Mesin ${peminjaman.namaMesin} telah diaktifkan.",
//                                                             snackPosition:
//                                                                 SnackPosition
//                                                                     .TOP,
//                                                             duration: Duration(
//                                                                 seconds: 3),
//                                                           );
//                                                           // Timer untuk mematikan tombol secara otomatis ketika waktu peminjaman habis
//                                                           DateTime?
//                                                               akhirPeminjamanDate =
//                                                               peminjaman
//                                                                   .akhirPeminjamanTime;
//                                                           if (akhirPeminjamanDate !=
//                                                               null) {
//                                                             final now =
//                                                                 DateTime.now();
//                                                             if (akhirPeminjamanDate
//                                                                 .isAfter(now)) {
//                                                               final notificationTime =
//                                                                   akhirPeminjamanDate
//                                                                       .subtract(Duration(
//                                                                           minutes:
//                                                                               5));
//                                                               if (now.isBefore(
//                                                                   notificationTime)) {
//                                                                 Timer(
//                                                                     notificationTime
//                                                                         .difference(
//                                                                             now),
//                                                                     () {
//                                                                   if (!_disposed) {
//                                                                     _sendNotification(
//                                                                         peminjaman);
//                                                                   }
//                                                                 });
//                                                               }
//                                                               final durationUntilEnd =
//                                                                   akhirPeminjamanDate
//                                                                       .difference(
//                                                                           now);
//                                                               Timer(
//                                                                   durationUntilEnd,
//                                                                   () {
//                                                                 if (!_disposed) {
//                                                                   // Check if widget is still mounted
//                                                                   setState(() {
//                                                                     activatedButtons
//                                                                         .remove(
//                                                                             peminjaman.id); // Nonaktifkan tombol
//                                                                   });
//                                                                   _saveActivatedButtons(); // Simpan status setelah tombol dinonaktifkan
//                                                                   controller
//                                                                       .update(); // Perbarui tampilan UI
//                                                                 }
//                                                               });
//                                                             }
//                                                           }
//                                                         } else {
//                                                           // Jika tombol sudah aktif, tampilkan pesan
//                                                           Get.snackbar(
//                                                             "Peminjaman Sudah Aktif",
//                                                             "Mesin ${peminjaman.namaMesin} sudah diaktifkan sebelumnya.",
//                                                             snackPosition:
//                                                                 SnackPosition
//                                                                     .TOP,
//                                                             duration: Duration(
//                                                                 seconds: 3),
//                                                           );
//                                                         }
//                                                       }
//                                                     : null,

//                                                 // Timer untuk mematikan tombol secara otomatis ketika waktu peminjaman habis
//                                                 //       DateTime?
//                                                 //           akhirPeminjamanDate =
//                                                 //           peminjaman
//                                                 //               .akhirPeminjamanTime;
//                                                 //       if (akhirPeminjamanDate !=
//                                                 //           null) {
//                                                 //         final now =
//                                                 //             DateTime.now();
//                                                 //         if (akhirPeminjamanDate
//                                                 //             .isAfter(now)) {
//                                                 //           final durationUntilEnd =
//                                                 //               akhirPeminjamanDate
//                                                 //                   .difference(
//                                                 //                       now);
//                                                 //           Timer(
//                                                 //               durationUntilEnd,
//                                                 //               () {
//                                                 //             setState(() {
//                                                 //               activatedButtons.remove(
//                                                 //                   peminjaman
//                                                 //                       .id); // Nonaktifkan tombol
//                                                 //             });
//                                                 //             _saveActivatedButtons(); // Simpan status setelah tombol dinonaktifkan
//                                                 //             controller
//                                                 //                 .update(); // Perbarui tampilan UI
//                                                 //           });
//                                                 //         }
//                                                 //       }
//                                                 //     } else {
//                                                 //       // Jika tombol sudah aktif, tampilkan pesan
//                                                 //       Get.snackbar(
//                                                 //         "Peminjaman Sudah Aktif",
//                                                 //         "Mesin ${peminjaman.namaMesin} sudah diaktifkan sebelumnya.",
//                                                 //         snackPosition:
//                                                 //             SnackPosition
//                                                 //                 .TOP,
//                                                 //         duration: Duration(
//                                                 //             seconds: 3),
//                                                 //       );
//                                                 //     }
//                                                 //   }
//                                                 // : null, // Tombol tidak bisa ditekan jika syarat tidak terpenuhi
//                                                 style: ElevatedButton.styleFrom(
//                                                   minimumSize:
//                                                       const Size(90.0, 17.0),
//                                                   backgroundColor:
//                                                       _getButtonColor(
//                                                           peminjaman),
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             4.0),
//                                                   ),
//                                                   padding: const EdgeInsets
//                                                       .symmetric(
//                                                       horizontal: 7.0,
//                                                       vertical: 5.0),
//                                                 ),
//                                                 child: Text(
//                                                   _getButtonText(peminjaman),
//                                                   style: GoogleFonts.inter(
//                                                     fontSize: 12.0,
//                                                     fontWeight: FontWeight.w800,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                               childCount: filteredPeminjaman.length,
//                             ),
//                           );
//                         },
//                       ),
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
// }

// class searchbar extends StatelessWidget {
//   final Function(String) onSearch;

//   const searchbar({Key? key, required this.onSearch}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40.0,
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(4.0),
//         border: Border.all(color: const Color(0xFFDDDEE3)),
//       ),
//       child: TextField(
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: "Cari Keperluan",
//           hintStyle: GoogleFonts.inter(
//             fontWeight: FontWeight.w500,
//             color: const Color(0xFF999999),
//           ),
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
//           prefixIcon: const Icon(
//             MingCuteIcons.mgc_search_2_line,
//             color: Color(0xFF09244B),
//           ),
//         ),
//         onChanged: onSearch,
//       ),
//     );
//   }
// }

// class filterbar extends StatelessWidget {
//   final Function() onPressed;

//   const filterbar({Key? key, required this.onPressed}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40.0,
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(4.0),
//         border: Border.all(color: const Color(0xFFDDDEE3)),
//       ),
//       child: InkWell(
//         onTap: onPressed,
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: 12.0,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 MingCuteIcons.mgc_filter_line,
//                 color: Color(0xFF09244B),
//               ),
//               const SizedBox(
//                 width: 8.0,
//               ),
//               Text(
//                 "Filter",
//                 style: GoogleFonts.inter(
//                   fontWeight: FontWeight.w500,
//                   color: const Color(0xFF09244B),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class filterOptions {
//   final List<String> statusOptions = [
//     'Semua',
//     'Diproses',
//     'Disetujui',
//     'Ditolak',
//     'Selesai'
//   ];
//   final List<String> machineTypes = [
//     'Semua',
//     'CNC Milling',
//     '3D Printing',
//     'Laser Cutting'
//   ];
//   final List<String> timeRanges = [
//     'Semua',
//     'Minggu Ini',
//     'Bulan Ini',
//     '3 Bulan Terakhir'
//   ];
//   final List<String> durationRanges = [
//     'Semua',
//     '< 5 jam',
//     '5 - 10 jam',
//     '> 10 jam'
//   ];
// }