// status_page.dart

import 'dart:async'; // Tambahkan ini untuk menggunakan Timer
import 'package:build_app/controller/sensor_controller.dart';
import 'package:build_app/controller/extendPeminjaman_controller.dart';
import 'package:build_app/services/notification_services.dart';
import 'package:build_app/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:build_app/controller/peminjamanUserAll_controller.dart';
import 'package:build_app/models/peminjamanUserAll_model.dart';
import 'package:build_app/page/main/custom_main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:build_app/services/logger.dart';

// Fungsi helper untuk warna status
Color dapatkanWarnaStatus(String status) {
  switch (status) {
    case 'Disetujui':
      return Colors.green.shade100;
    case 'Diproses':
      return Colors.orange.shade100;
    case 'Ditolak':
      return Colors.red.shade100;
    default:
      return Colors.grey.shade300;
  }
}

// Fungsi helper untuk warna teks status
Color dapatkanWarnaTeksStatus(String status) {
  switch (status) {
    case 'Disetujui':
      return Colors.green[800]!;
    case 'Diproses':
      return Colors.orange[800]!;
    case 'Ditolak':
      return Colors.red[800]!;
    default:
      return Colors.grey[800]!;
  }
}

// Fungsi untuk mendapatkan gambar mesin
String getImageForMachine(String namaMesin) {
  switch (namaMesin) {
    case 'CNC Milling':
      return "assets/images/foto_cnc.png";
    case '3D Printing':
      return 'assets/images/foto_3dp.png';
    case 'Laser Cutting':
      return 'assets/images/foto_lasercut.png';
    default:
      return "assets/images/default_machine.png";
  }
}

// Fungsi agar bagian search bar dan filter bar tidak ikut scroll
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class statusPage extends StatefulWidget {
  const statusPage({Key? key}) : super(key: key);

  @override
  State<statusPage> createState() => _statusPageState();
}

class _statusPageState extends State<statusPage> with WidgetsBindingObserver {
  final PeminjamanUserAllController controller =
      Get.put(PeminjamanUserAllController());
  final SensorController sensorController = Get.put(SensorController());
  final ExtendPeminjamanController extendController =
      Get.put(ExtendPeminjamanController());
  final NotificationController notificationController =
      Get.put(NotificationController());
  late final NotificationService _notificationService;
  // final NotificationService _notificationService =
  //     Get.find<NotificationService>();

  Timer? _periodicTimer;
  bool _disposed = false;

  // Tambahkan ini untuk melacak tombol yang sudah ditekan
  Set<String> activatedButtons = {};

  // untuk melacak apakah perpanjangan sudah dilakukan
  Set<String> hasExtended = {};

  // untuk melacak dialog yang sudah muncul
  Set<String> hasShownDialog = {};

  Set<String> hasShownNotification = {};

  Set<String> pendingExtensionDialogs = {};

  // Tambahkan variable state baru untuk tracking notifikasi
  final Map<String, bool> _notificationScheduled = {};

  final Map<String, Timer> _notificationTimers = {};

  final RxString userRole = ''.obs;

  // Fungsi untuk memuat status tombol dari SharedPreferences
  Future<void> _loadActivatedButtons() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      activatedButtons = prefs.getStringList('activatedButtons')?.toSet() ?? {};
    });
  }

  // Fungsi untuk menyimpan status tombol ke SharedPreferences
  Future<void> _saveActivatedButtons() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('activatedButtons', activatedButtons.toList());
  }

  // Fungsi untuk memuat status dialog dari SharedPreferences
  Future<void> _loadHasShownDialog() async {
    final prefs = await SharedPreferences.getInstance();
    hasShownDialog = prefs.getStringList('hasShownDialog')?.toSet() ?? {};
  }

  // Fungsi untuk menyimpan status dialog ke SharedPreferences
  Future<void> _saveHasShownDialog() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('hasShownDialog', hasShownDialog.toList());
  }

  // Tambahkan fungsi untuk menyimpan status perpanjangan
  Future<void> _saveHasExtended() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('hasExtended', hasExtended.toList());
  }

  // Tambahkan fungsi untuk memuat status perpanjangan
  Future<void> _loadHasExtended() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      hasExtended = prefs.getStringList('hasExtended')?.toSet() ?? {};
    });
  }

  // Tambahkan fungsi load dan save untuk hasShownNotification
  Future<void> _loadHasShownNotification() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      hasShownNotification =
          prefs.getStringList('hasShownNotification')?.toSet() ?? {};
    });
    print('Loaded hasShownNotification: $hasShownNotification');
  }

  Future<void> _saveHasShownNotification() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'hasShownNotification', hasShownNotification.toList());
    print('Saved hasShownNotification: $hasShownNotification');
  }

  // Fungsi untuk menyimpan pending dialogs
  Future<void> _savePendingDialogs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'pendingExtensionDialogs', pendingExtensionDialogs.toList());
    print('Saved pending dialogs: $pendingExtensionDialogs'); // untuk debug
  }

// Fungsi untuk memuat pending dialogs
  Future<void> _loadPendingDialogs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pendingExtensionDialogs =
          (prefs.getStringList('pendingExtensionDialogs') ?? []).toSet();
    });
    print('Loaded pending dialogs: $pendingExtensionDialogs'); // untuk debug
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _notificationService = Get.find<NotificationService>();

    setState(() {
      hasShownDialog = {};
      hasShownNotification = {};
    });

    _setupInitialState();
    _setupBackgroundCheck();

    // _loadActivatedButtons();
    // _loadHasShownDialog();
    // _loadHasExtended();
    // _loadPendingDialogs();
    // _loadHasShownNotification(); // Tambahkan load hasShownNotification
    // _setupNotificationService();
  }

  Future<void> _setupInitialState() async {
    await _loadActivatedButtons();
    await _loadHasShownDialog();
    await _loadHasExtended();
    await _loadPendingDialogs();
    await _loadHasShownNotification();

    // Load user role
    final prefs = await SharedPreferences.getInstance();
    userRole.value = prefs.getString('user_role') ?? '';

    // Setup notification service with proper channel
    if (userRole.value == 'user') {
      _setupNotificationService();
    }

    for (var peminjaman in controller.filteredPeminjaman) {
      if (activatedButtons.contains(peminjaman.id)) {
        await _checkNotificationStatus(peminjaman.id);
      }
    }

    _periodicTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (_disposed) return;
      _checkActiveBookings();

      final now = DateTime.now();
      controller.filteredPeminjaman.forEach((peminjaman) {
        if (activatedButtons.contains(peminjaman.id)) {
          final endTime = peminjaman.akhirPeminjamanTime;
          if (endTime != null && now.isBefore(endTime)) {
            final timeToEnd = endTime.difference(now);
            // if (timeToEnd.inMinutes <= 5 &&
            //     !hasShownNotification.contains(peminjaman.id) &&
            //     !hasExtended.contains(peminjaman.id)) {
            //   _sendNotification(peminjaman);
            // }
            if (timeToEnd.inMinutes <= 5 &&
                !hasShownNotification.contains(peminjaman.id)) {
              _sendNotification(peminjaman);
            }
            if (timeToEnd.inMinutes <= 3 &&
                !hasShownDialog.contains(peminjaman.id) &&
                !hasExtended.contains(peminjaman.id)) {
              // Tambahkan ke pending dialogs
              setState(() {
                pendingExtensionDialogs.add(peminjaman.id);
              });
              _savePendingDialogs();
              // Coba tampilkan dialog jika aplikasi aktif
              checkAndShowExtensionDialog(peminjaman);
            }
          } else {
            // Reset dan simpan semua state saat peminjaman berakhir
            setState(() {
              activatedButtons.remove(peminjaman.id);
              hasShownDialog.remove(peminjaman.id);
              hasShownNotification.remove(peminjaman.id);
              hasExtended.remove(peminjaman.id);
              pendingExtensionDialogs.remove(peminjaman.id);
            });
            _saveActivatedButtons();
            _saveHasShownDialog();
            _saveHasShownNotification(); // Tambahkan save hasShownNotification
            _saveHasExtended();
            _savePendingDialogs();
          }
        }
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Cek pending dialogs saat aplikasi dibuka kembali
      print('App resumed, checking pending dialogs...');
      _checkMissedNotifications();
      _checkPendingDialogs();
    }
  }

  // Tambahkan method baru ini
  void _setupBackgroundCheck() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      if (_disposed) {
        timer.cancel();
        return;
      }

      final now = DateTime.now();
      controller.filteredPeminjaman.forEach((peminjaman) {
        if (activatedButtons.contains(peminjaman.id) &&
            !hasShownNotification.contains(peminjaman.id)) {
          final endTime = peminjaman.akhirPeminjamanTime;
          if (endTime != null) {
            final timeToEnd = endTime.difference(now);
            if (timeToEnd.inMinutes <= 5 && timeToEnd.inMinutes > 0) {
              _sendNotification(peminjaman);
              LoggerService.debug(
                  "Background check triggered notification for peminjaman: ${peminjaman.id}");
            }
          }
        }
      });
    });
  }

  void _checkActiveBookings() {
    if (_disposed) return;

    final now = DateTime.now();
    LoggerService.debug(
        "=== Checking active bookings at ${now.toString()} ===");

    controller.filteredPeminjaman.forEach((peminjaman) {
      if (!activatedButtons.contains(peminjaman.id)) return;

      final endTime = peminjaman.akhirPeminjamanTime;
      if (endTime == null) return;

      final timeToEnd = endTime.difference(now);
      if (timeToEnd.inMinutes <= 5 &&
          timeToEnd.inMinutes > 0 &&
          !hasShownNotification.contains(peminjaman.id)) {
        _sendNotification(peminjaman);
      }
    });
  }

  // Update method _setupNotificationService
  void _setupNotificationService() {
    controller.filteredPeminjaman.forEach((peminjaman) {
      if (activatedButtons.contains(peminjaman.id) &&
          peminjaman.akhirPeminjamanTime != null) {
        _scheduleNotification(peminjaman);
      }
    });
  }

  // Tambahkan method baru ini
  Future<void> _scheduleNotification(Datum peminjaman) async {
    if (_notificationScheduled[peminjaman.id] == true) {
      LoggerService.debug(
          "Notification already scheduled for peminjaman: ${peminjaman.id}");
      return;
    }

    final endTime = peminjaman.akhirPeminjamanTime!;
    final notificationTime = endTime.subtract(Duration(minutes: 5));
    final now = DateTime.now();

    if (now.isBefore(notificationTime)) {
      _notificationTimers[peminjaman.id]?.cancel();
      _notificationTimers[peminjaman.id] =
          Timer(notificationTime.difference(now), () {
        if (!_disposed) {
          _sendNotification(peminjaman);
          _notificationScheduled[peminjaman.id] = false;
        }
      });
      _notificationScheduled[peminjaman.id] = true;

      LoggerService.debug(
          "Notification scheduled for peminjaman: ${peminjaman.id} at $notificationTime");
    }
  }

  void logWithTimestamp(String message) {
    final now = DateTime.now();
    final formattedTime = '${now.day.toString().padLeft(2, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.year} ${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';

    print('[$formattedTime] $message');
  }

  // Tambahkan fungsi untuk mengecek pending dialogs
  void _checkPendingDialogs() {
    final now = DateTime.now();
    controller.filteredPeminjaman.forEach((peminjaman) {
      if (pendingExtensionDialogs.contains(peminjaman.id) &&
          !hasShownDialog.contains(peminjaman.id) &&
          !hasExtended.contains(peminjaman.id)) {
        final endTime = peminjaman.akhirPeminjamanTime;
        if (endTime != null && now.isBefore(endTime)) {
          final timeToEnd = endTime.difference(now);
          if (timeToEnd.inMinutes <= 3 && timeToEnd.inMinutes > 0) {
            logWithTimestamp(
                'Showing pending dialog for peminjaman: ${peminjaman.id}');
            showExtensionDialog(peminjaman.id, peminjaman.namaMesin, endTime);
          }
        }
      }
    });
  }

  // @override
  // void initState() {
  //   super.initState();

  //   // Bersihkan status dialog saat inisialisasi
  //   setState(() {
  //     hasShownDialog = {};
  //   });

  //   _loadActivatedButtons();
  //   _loadHasShownDialog();
  //   _loadHasExtended();
  //   _setupNotificationService();

  // // Periodic timer untuk mengecek waktu tersisa setiap 1 menit
  // _periodicTimer = Timer.periodic(Duration(minutes: 1), (timer) {
  //   if (_disposed) return;

  //   final now = DateTime.now();
  //   for (var peminjaman in controller.filteredPeminjaman) {
  //     try {
  //       if (!activatedButtons.contains(peminjaman.id)) continue;

  //       final endTime = peminjaman.akhirPeminjamanTime;
  //       if (endTime == null) {
  //         print('Skipping peminjaman ${peminjaman.id}: No valid end time');
  //         continue;
  //       }

  //       if (!now.isBefore(endTime)) {
  //         // Peminjaman has ended
  //         setState(() {
  //           activatedButtons.remove(peminjaman.id);
  //         });
  //         _saveActivatedButtons();
  //         continue;
  //       }

  //       final timeToEnd = endTime.difference(now);
  //       if (timeToEnd.inMinutes <= 5 &&
  //           !hasShownDialog.contains(peminjaman.id) &&
  //           !hasExtended.contains(peminjaman.id)) {
  //         _sendNotification(peminjaman);
  //       }

  //       if (timeToEnd.inMinutes <= 3) {
  //         checkAndShowExtensionDialog(peminjaman);
  //       }
  //     } catch (e) {
  //       print('Error processing peminjaman ${peminjaman.id}: $e');
  //     }
  //   }
  // });
  // Reset hasShownDialog saat aplikasi dimulai
  //   _periodicTimer = Timer.periodic(Duration(seconds: 15), (timer) {
  //     if (_disposed) return;

  //     final now = DateTime.now();
  //     for (var peminjaman in controller.filteredPeminjaman) {
  //       try {
  //         if (!activatedButtons.contains(peminjaman.id)) continue;

  //         final endTime = peminjaman.akhirPeminjamanTime;
  //         if (endTime == null) {
  //           print('Skipping peminjaman ${peminjaman.id}: No valid end time');
  //           continue;
  //         }

  //         if (!now.isBefore(endTime)) {
  //           // Peminjaman sudah selesai
  //           setState(() {
  //             activatedButtons.remove(peminjaman.id);
  //             hasShownDialog.remove(peminjaman.id);
  //             hasExtended.remove(peminjaman.id);
  //           });
  //           _saveActivatedButtons();
  //           _saveHasShownDialog();
  //           _saveHasExtended();
  //           continue;
  //         }

  //         final timeToEnd = endTime.difference(now);
  //         if (timeToEnd.inMinutes <= 5 &&
  //             !hasShownDialog.contains(peminjaman.id) &&
  //             !hasExtended.contains(peminjaman.id)) {
  //           _sendNotification(peminjaman);
  //         }

  //         if (timeToEnd.inMinutes <= 3) {
  //           checkAndShowExtensionDialog(peminjaman);
  //         }
  //       } catch (e) {
  //         print('Error processing peminjaman ${peminjaman.id}: $e');
  //       }
  //     }
  //   });
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposed = true; // Set disposed flag
    _periodicTimer?.cancel(); // Cancel the timer
    _notificationTimers.forEach((_, timer) => timer.cancel());
    _notificationTimers.clear();
    super.dispose();
  }

  // void _setupNotificationService() {
  //   controller.filteredPeminjaman.forEach((peminjaman) {
  //     if (activatedButtons.contains(peminjaman.id) &&
  //         peminjaman.akhirPeminjamanTime != null) {
  //       _notificationService.startPeminjamanCheck(
  //         peminjaman.id,
  //         peminjaman.akhirPeminjamanTime!,
  //         peminjaman.namaMesin,
  //       );
  //     }
  //   });
  // }

  // void _setupNotificationService() {
  //   // Setup callback untuk notification service
  //   _notificationService.onShowExtensionDialog =
  //       (peminjamanId, namaMesin, endTime) {
  //     if (!_disposed) {
  //       // Cek kondisi sebelum menampilkan dialog
  //       final peminjaman = controller.filteredPeminjaman.firstWhere(
  //           (p) => p.id == peminjamanId,
  //           orElse: () => throw Exception('Peminjaman tidak ditemukan'));

  //       if (!hasShownDialog.contains(peminjamanId) &&
  //           !hasExtended.contains(peminjamanId) &&
  //           activatedButtons.contains(peminjamanId)) {
  //         print(
  //             'Menampilkan dialog perpanjangan untuk ${peminjaman.namaMesin}');
  //         showExtensionDialog(peminjamanId, namaMesin, endTime);
  //         setState(() {
  //           hasShownDialog.add(peminjamanId);
  //         });
  //         _saveHasShownDialog();
  //       }
  //     }
  //   };

  //   // Mulai monitoring
  //   controller.filteredPeminjaman.forEach((peminjaman) {
  //     if (activatedButtons.contains(peminjaman.id) &&
  //         peminjaman.akhirPeminjamanTime != null) {
  //       _notificationService.startPeminjamanCheck(peminjaman.id,
  //           peminjaman.akhirPeminjamanTime!, peminjaman.namaMesin,
  //           shouldShowExtension: !hasExtended.contains(peminjaman.id));
  //     }
  //   });
  // }

  // Fungsi untuk membedakan button Peminjaman
  Color _getButtonColor(Datum peminjaman) {
    final now = DateTime.now();
    logWithTimestamp(
        "Menentukan warna tombol untuk Mesin: ${peminjaman.namaMesin}, ID: ${peminjaman.id}, Status: ${peminjaman.status}");
    LoggerService.debug(
        "Menentukan warna tombol untuk peminjaman mesin: ${peminjaman.namaMesin} dengan ID: ${peminjaman.id}, Status: ${peminjaman.status}");

    if (peminjaman.status == Status.Diproses) {
      LoggerService.debug(
          "Peminjaman mesin: ${peminjaman.namaMesin} dengan ID: ${peminjaman.id} - Warna: Abu-abu (Status: Sedang Diproses)");
      return Colors.grey;
    }

    if (peminjaman.status != Status.Disetujui) {
      LoggerService.debug(
          "Peminjaman mesin: ${peminjaman.namaMesin} dengan ID: ${peminjaman.id} - Warna: Abu-abu (Status: ${peminjaman.status})");
      return Colors.grey;
    }

    // Cek status aktif terlebih dahulu
    if (sensorController.buttonStateMap[peminjaman.id] == true ||
        peminjaman.isStarted ||
        activatedButtons.contains(peminjaman.id)) {
      if (peminjaman.akhirPeminjamanTime != null &&
          now.isAfter(peminjaman.akhirPeminjamanTime!)) {
        LoggerService.debug(
            "Peminjaman mesin: ${peminjaman.namaMesin} dengan ID: ${peminjaman.id} - Warna: Abu-abu (Tombol aktif tetapi waktu sudah habis)");
        return Colors.grey;
      }
      LoggerService.debug(
          "Peminjaman mesin: ${peminjaman.namaMesin} dengan ID: ${peminjaman.id} - Warna: Biru (Tombol aktif dan waktu belum habis)");
      return Colors.blue; // Tetap biru jika aktif dan belum expired
    }

    LoggerService.debug(
        "ID: ${peminjaman.id} - Warna: Hijau (Kondisi default)");
    return const Color(0xFF00A95B);
  }
  // Color _getButtonColor(Datum peminjaman) {
  //   final now = DateTime.now();
  //   logWithTimestamp(
  //     "Determining button color for ID: ${peminjaman.id}, Status: ${peminjaman.status}");

  //   if (peminjaman.status == Status.Diproses) return Colors.grey;
  //   if (peminjaman.status != Status.Disetujui) return Colors.grey;

  //   // Cek status aktif terlebih dahulu
  //   if (sensorController.buttonStateMap[peminjaman.id] == true ||
  //       peminjaman.isStarted ||
  //       activatedButtons.contains(peminjaman.id)) {
  //     // Hanya ubah ke grey jika sudah expired
  //     if (peminjaman.akhirPeminjamanTime != null &&
  //         now.isAfter(peminjaman.akhirPeminjamanTime!)) {
  //       return Colors.grey;
  //     }
  //     return Colors.blue; // Tetap biru jika aktif dan belum expired
  //   }

  //   return const Color(0xFF00A95B);
  // }

  // Fungsi untuk mengetahui teks dalam button Peminjaman
  String _getButtonText(Datum peminjaman) {
    if (peminjaman.status == Status.Diproses) return "Belum Tersedia";
    LoggerService.debug(
        "Peminjaman mesin: ${peminjaman.namaMesin} dengan ID Peminjaman: ${peminjaman.id} - Status: Diproses - Button Text: Belum Tersedia");
    if (peminjaman.status != Status.Disetujui) return "Tidak Tersedia";
    LoggerService.debug(
        "Peminjaman mesin: ${peminjaman.namaMesin} dengan ID Peminjaman: ${peminjaman.id} - Status: ${peminjaman.status} - Button Text: Tidak Tersedia");

    // Jika peminjaman sudah dimulai, ubah teksnya menjadi "Peminjaman Aktif"
    if (sensorController.buttonStateMap[peminjaman.id] == true ||
        peminjaman.isStarted ||
        activatedButtons.contains(peminjaman.id)) {
      // Cek jika sudah expired untuk peminjaman yang aktif
      final now = DateTime.now();
      if (peminjaman.akhirPeminjamanTime != null &&
          now.isAfter(peminjaman.akhirPeminjamanTime!)) {
        // Hapus dari activated buttons
        if (activatedButtons.contains(peminjaman.id)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              activatedButtons.remove(peminjaman.id);
            });
            _saveActivatedButtons();
          });
        }
        LoggerService.debug(
            "Peminjaman mesin: ${peminjaman.namaMesin} dengan ID Peminjaman: ${peminjaman.id} - Status: Aktif tetapi expired - Button Text: Tidak Tersedia");
        return "Tidak Tersedia";
      }
      LoggerService.debug(
          "Peminjaman mesin: ${peminjaman.namaMesin} dengan ID Peminjaman: ${peminjaman.id} - Status: Aktif - Button Text: Peminjaman Aktif");
      return "Peminjaman Aktif";
    }

    DateTime? awalPeminjamanDate = peminjaman.awalPeminjamanTime;
    DateTime? akhirPeminjamanDate = peminjaman.akhirPeminjamanTime;
    if (awalPeminjamanDate == null || akhirPeminjamanDate == null) {
      return "Tidak Tersedia";
    }

    final now = DateTime.now();
    if (now.isBefore(awalPeminjamanDate)) {
      LoggerService.debug(
          "Peminjaman mesin: ${peminjaman.namaMesin} dengan ID Peminjaman: ${peminjaman.id} - Status: Belum mulai - Button Text: Mulai Peminjaman");
      return "Mulai Peminjaman";
    }
    if (now.isAfter(akhirPeminjamanDate)) {
      return "Tidak Tersedia";
    }

    LoggerService.debug(
        "Peminjaman mesin: ${peminjaman.namaMesin} dengan ID Peminjaman: ${peminjaman.id} - Status: Valid untuk mulai - Button Text: Mulai Peminjaman");
    return "Mulai Peminjaman";
  }

  // Mengirim Notiifkasi
  void _sendNotification(Datum peminjaman) async {
    if (_disposed) {
      LoggerService.debug(
          "Notification skipped for ${peminjaman.id} - widget disposed");
      return;
    }

    try {
      await notificationController.handlePeminjamanEnding(
        peminjamanId: peminjaman.id,
        namaMesin: peminjaman.namaMesin,
      );

      if (!_disposed) {
        setState(() {
          hasShownNotification.add(peminjaman.id);
        });
        await _saveHasShownNotification();

        // Show confirmation toast
        Get.snackbar(
          'Notifikasi',
          'Peminjaman ${peminjaman.namaMesin} akan berakhir dalam 5 menit',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue[100],
          colorText: Colors.blue[900],
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      LoggerService.error('Error sending notification: $e');

      if (!_disposed) {
        Get.snackbar(
          'Error',
          'Gagal mengirim notifikasi: ${e.toString()}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          duration: Duration(seconds: 3),
        );
      }
    }
  }
  // void _sendNotification(Datum peminjaman) async {
  //   if (_disposed || hasShownNotification.contains(peminjaman.id)) {
  //     LoggerService.debug(
  //         "Skipping notification for ${peminjaman.id} - already shown or disposed");
  //     return;
  //   }

  //   try {
  //     LoggerService.debug(
  //         "Attempting to send notification for peminjaman: ${peminjaman.id}");

  //     // First try local notification
  //     await _notificationService.sendLocalNotification(
  //       title: 'Peminjaman Akan Berakhir',
  //       body: 'Peminjaman ${peminjaman.namaMesin} akan berakhir dalam 5 menit',
  //       data: {
  //         'type': 'peminjaman_ending',
  //         'peminjamanId': peminjaman.id,
  //         'namaMesin': peminjaman.namaMesin,
  //         'timeRemaining': '5',
  //       },
  //       isAdmin: false,
  //     );

  //     // Then try server notification
  //     await _notificationService.sendPeminjamanEndingNotification(
  //       peminjamanId: peminjaman.id,
  //       namaMesin: peminjaman.namaMesin,
  //     );

  //     if (!_disposed) {
  //       setState(() {
  //         hasShownNotification.add(peminjaman.id);
  //       });
  //       await _saveHasShownNotification();

  //       LoggerService.debug(
  //           "Successfully sent notification for peminjaman: ${peminjaman.id}");
  //     }
  //   } catch (e) {
  //     LoggerService.error(
  //         "Failed to send notification for ${peminjaman.id}: $e");

  //     // Try to show at least a local notification as fallback
  //     try {
  //       await _notificationService.sendLocalNotification(
  //         title: 'Peminjaman Akan Berakhir',
  //         body:
  //             'Peminjaman ${peminjaman.namaMesin} akan berakhir dalam 5 menit',
  //         data: {
  //           'type': 'peminjaman_ending',
  //           'peminjamanId': peminjaman.id,
  //           'namaMesin': peminjaman.namaMesin,
  //           'timeRemaining': '5',
  //         },
  //         isAdmin: false,
  //       );
  //     } catch (e) {
  //       LoggerService.error("Failed to send fallback notification: $e");
  //     }

  //     if (!_disposed) {
  //       Get.snackbar(
  //         'Notification Error',
  //         'Gagal mengirim notifikasi: ${e.toString()}',
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.red[100],
  //         colorText: Colors.red[900],
  //         duration: Duration(seconds: 3),
  //       );
  //     }
  //   }
  // }

  Future<void> _checkNotificationStatus(String peminjamanId) async {
    try {
      final notificationStatus =
          await notificationController.checkPeminjaman(peminjamanId);
      if (!notificationStatus && !_disposed) {
        Get.snackbar(
          'Peringatan',
          'Gagal memeriksa status notifikasi',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[900],
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      LoggerService.error('Error checking notification status: $e');
    }
  }

  void _checkMissedNotifications() {
    LoggerService.debug("Checking for missed notifications");
    final now = DateTime.now();
    controller.filteredPeminjaman.forEach((peminjaman) {
      if (activatedButtons.contains(peminjaman.id) &&
          !hasShownNotification.contains(peminjaman.id)) {
        final endTime = peminjaman.akhirPeminjamanTime;
        if (endTime != null) {
          final timeToEnd = endTime.difference(now);
          if (timeToEnd.inMinutes <= 5 && timeToEnd.inMinutes > 0) {
            LoggerService.debug(
                "Found missed notification for peminjaman: ${peminjaman.id}");
            _sendNotification(peminjaman);
          }
        }
      }
    });
  }

  // void _sendNotification(Datum peminjaman) async {
  //   if (_disposed) {
  //     LoggerService.debug(
  //         "Notifikasi untuk ID: ${peminjaman.id} tidak dikirim karena widget sudah di-dispose.");
  //     return;
  //   }

  //   try {
  //     LoggerService.debug(
  //         "Mempersiapkan pengiriman notifikasi untuk ID: ${peminjaman.id}, Mesin: ${peminjaman.namaMesin}");

  //     if (!_disposed) {
  //       setState(() {
  //         hasShownNotification.add(peminjaman.id);
  //       });
  //       await _saveHasShownNotification();
  //       LoggerService.debug(
  //           "Notifikasi ditandai sebagai sudah dikirim untuk ID: ${peminjaman.id}");

  //       await _notificationService.sendPeminjamanEndingNotification(
  //         peminjamanId: peminjaman.id,
  //         namaMesin: peminjaman.namaMesin,
  //       );
  //       LoggerService.debug(
  //           "Notifikasi berhasil dikirim untuk ID: ${peminjaman.id}, Mesin: ${peminjaman.namaMesin}");
  //     }
  //   } catch (e) {
  //     LoggerService.debug(
  //         "Gagal mengirim notifikasi untuk ID: ${peminjaman.id}, Error: ${e.toString()}");

  //     if (!_disposed) {
  //       Get.snackbar(
  //         'Notification Error',
  //         'Gagal mengirim notifikasi: ${e.toString()}',
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.red[100],
  //         colorText: Colors.red[900],
  //         duration: Duration(seconds: 3),
  //       );
  //     }
  //   }
  // }

  // void _sendNotification(Datum peminjaman) async {
  //   if (_disposed) return;

  //   try {
  //     if (!_disposed) {
  //       setState(() {
  //         hasShownNotification.add(peminjaman.id);
  //       });
  //       await _saveHasShownNotification();

  //       await _notificationService.sendPeminjamanEndingNotification(
  //         peminjamanId: peminjaman.id,
  //         namaMesin: peminjaman.namaMesin,
  //       );
  //     }
  //   } catch (e) {
  //     if (!_disposed) {
  //       Get.snackbar(
  //         'Notification Error',
  //         'Failed to send notification: ${e.toString()}',
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.red[100],
  //         colorText: Colors.red[900],
  //         duration: Duration(seconds: 3),
  //       );
  //     }
  //   }
  // }
  // void _sendNotification(Datum peminjaman) async {
  //   if (_disposed) return;

  //   try {
  //     await notificationController.checkPeminjaman(peminjaman.id);
  //     if (!_disposed) {
  //       setState(() {
  //         hasShownNotification.add(peminjaman.id);
  //       });
  //       await _saveHasShownNotification(); // Simpan ke SharedPreferences
  //     }
  //   } catch (e) {
  //     if (!_disposed) {
  //       Get.snackbar(
  //         'Notification Error',
  //         'Failed to send notification: ${e.toString()}',
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.red[100],
  //         colorText: Colors.red[900],
  //         duration: Duration(seconds: 3),
  //       );
  //     }
  //   }
  // }

  // void _sendNotification(Datum peminjaman) async {
  //   if (_disposed) return;

  //   try {
  //     await notificationController.checkPeminjaman(peminjaman.id);
  //     if (!_disposed) {
  //       setState(() {
  //         hasShownDialog.add(peminjaman.id);
  //       });
  //       await _saveHasShownDialog();
  //     }
  //   } catch (e) {
  //     if (!_disposed) {
  //       Get.snackbar(
  //         'Notification Error',
  //         'Failed to send notification: ${e.toString()}',
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.red[100],
  //         colorText: Colors.red[900],
  //         duration: Duration(seconds: 3),
  //       );
  //     }
  //   }
  // }

  Widget _buildWarningItem({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // Perbaikan pada _startPeminjaman method
  Future<void> _startPeminjaman(Datum peminjaman) async {
    try {
      if (!activatedButtons.contains(peminjaman.id)) {
        setState(() {
          activatedButtons.add(peminjaman.id);
        });
        await _saveActivatedButtons();

        // Aktifkan relay tanpa await karena return type void
        sensorController.turnOnButtonFromFrontend(
          peminjaman.id,
          peminjaman.namaMesin.toLowerCase(),
        );

        logWithTimestamp(
            "Relay activated for ID: ${peminjaman.id}, Mesin: ${peminjaman.namaMesin}");
        LoggerService.debug(
            "Relay activated for ID: ${peminjaman.id}, Mesin: ${peminjaman.namaMesin}");

        // Cek apakah perlu perpanjangan waktu
        checkAndShowExtensionDialog(peminjaman);

        // Setup notifikasi
        _notificationService.startPeminjamanCheck(
          peminjaman.id,
          peminjaman.akhirPeminjamanTime!,
          peminjaman.namaMesin,
        );

        logWithTimestamp(
            "Notification setup completed for ID: ${peminjaman.id}, Mesin: ${peminjaman.namaMesin}");
        LoggerService.debug(
            "Notification setup completed for ID: ${peminjaman.id}, Mesin: ${peminjaman.namaMesin}");

        Get.snackbar(
          "Peminjaman Dimulai",
          "Mesin ${peminjaman.namaMesin} telah diaktifkan.",
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
        );

        // Setup timer
        DateTime? akhirPeminjamanDate = peminjaman.akhirPeminjamanTime;
        if (akhirPeminjamanDate != null) {
          final now = DateTime.now();
          if (akhirPeminjamanDate.isAfter(now)) {
            // Timer untuk notifikasi 5 menit sebelum berakhir
            final notificationTime =
                akhirPeminjamanDate.subtract(Duration(minutes: 5));
            if (now.isBefore(notificationTime)) {
              Timer(notificationTime.difference(now), () {
                if (!_disposed) {
                  _sendNotification(peminjaman);
                }
              });
            }

            // Timer untuk akhir peminjaman
            final durationUntilEnd = akhirPeminjamanDate.difference(now);
            Timer(durationUntilEnd, () {
              if (!_disposed) {
                setState(() {
                  activatedButtons.remove(peminjaman.id);
                });
                _saveActivatedButtons();
                controller.update();
              }
            });
          }
        }
        // Sisa kode tetap sama...
      }
    } catch (e) {
      LoggerService.error('Error starting peminjaman: $e');
      Get.snackbar(
        "Error",
        "Terjadi kesalahan saat memulai peminjaman",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: Duration(seconds: 3),
      );
    }
  }

  // Fungsi untuk button peminjaman
  bool _canActivateButton(Datum peminjaman) {
    if (peminjaman.status != Status.Disetujui) {
      LoggerService.debug(
          "ID: ${peminjaman.id} - Button cannot be activated. Reason: Status is not approved (${peminjaman.status}).");
      return false;
    }

    // Jika peminjaman sudah dimulai, tombol tetap nonaktif
    if (peminjaman.isStarted) {
      LoggerService.debug(
          "Peminjaman mesin: ${peminjaman.namaMesin} dengan ID: ${peminjaman.id} - Button cannot be activated. Reason: Peminjaman already started.");
      return false;
    }

    if (activatedButtons.contains(peminjaman.id)) {
      LoggerService.debug(
          "Peminjaman mesin: ${peminjaman.namaMesin} dengan ID: ${peminjaman.id} - Button cannot be activated. Reason: Already in activatedButtons.");
      return false;
    }

    DateTime? awalPeminjamanDate = peminjaman.awalPeminjamanTime;
    DateTime? akhirPeminjamanDate = peminjaman.akhirPeminjamanTime;

    if (awalPeminjamanDate == null || akhirPeminjamanDate == null) {
      return false;
    }

    final now = DateTime.now();
    bool canActivate =
        now.isAfter(awalPeminjamanDate) && now.isBefore(akhirPeminjamanDate);

    if (canActivate) {
      LoggerService.debug(
          "Peminjaman mesin: ${peminjaman.namaMesin} dengan ID: ${peminjaman.id} - Button can be activated. Reason: Current time is within the valid range.");
    } else {
      LoggerService.debug(
          "Peminjaman mesin: ${peminjaman.namaMesin} dengan ID: ${peminjaman.id} - Button cannot be activated. Reason: Current time is outside the valid range.");
    }
    return canActivate;
  }

  // Fungsi untuk menghitung durasi peminjaman dalam jam dan menit
  String calculateDuration(Datum peminjaman) {
    try {
      if (peminjaman.awalPeminjamanTime == null) return 'Waktu tidak valid';

      DateTime endTime;
      // Cek jika sudah diperpanjang
      if (hasExtended.contains(peminjaman.id)) {
        final extendedEndTime = extendController.getNewEndTime(peminjaman.id);
        endTime = extendedEndTime ?? peminjaman.akhirPeminjamanTime!;
      } else {
        endTime = peminjaman.akhirPeminjamanTime!;
      }

      Duration duration = endTime.difference(peminjaman.awalPeminjamanTime!);
      int hours = duration.inHours;
      int minutes = duration.inMinutes.remainder(60);

      if (hours == 0) {
        return '$minutes menit';
      } else if (minutes == 0) {
        return '$hours jam';
      } else {
        return '$hours jam $minutes menit';
      }
    } catch (e) {
      print('Error calculating duration: $e');
      return 'Waktu tidak valid';
    }
  }
  // String calculateDuration(Datum peminjaman) {
  //   if (peminjaman.awalPeminjamanTime == null ||
  //       peminjaman.akhirPeminjamanTime == null) {
  //     return 'Waktu tidak valid';
  //   }

  //   Duration duration = peminjaman.akhirPeminjamanTime!
  //       .difference(peminjaman.awalPeminjamanTime!);
  //   int hours = duration.inHours;
  //   int minutes = duration.inMinutes.remainder(60);

  //   if (hours == 0) {
  //     return '$minutes menit';
  //   } else if (minutes == 0) {
  //     return '$hours jam';
  //   } else {
  //     return '$hours jam $minutes menit';
  //   }
  // }

  // Fungsi untuk memperpanjang waktu peminjaman
  Future<void> showExtensionDialog(
      String peminjamanId, String namaMesin, DateTime endTime) async {
    if (Get.isDialogOpen == true) return;

    Timer? autoCloseTimer;
    bool hasResponded = false;

    try {
      autoCloseTimer = Timer(const Duration(seconds: 30), () {
        if (!hasResponded && Get.isDialogOpen!) {
          Get.back();
          if (!_disposed) {
            setState(() {
              hasShownDialog.add(peminjamanId);
              pendingExtensionDialogs.remove(peminjamanId);
            });
            _saveHasShownDialog();
            _savePendingDialogs();

            Get.snackbar(
              'Informasi',
              'Waktu perpanjangan telah habis',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.orange[100],
              colorText: Colors.orange[900],
              duration: const Duration(seconds: 3),
            );
          }
        }
      });

      void handleDialogClose() {
        hasResponded = true;
        autoCloseTimer?.cancel();
        Get.back();
        if (!_disposed) {
          setState(() {
            hasShownDialog.add(peminjamanId);
            pendingExtensionDialogs.remove(peminjamanId);
          });
          _saveHasShownDialog();
          _savePendingDialogs();
        }
      }

      void handleExtensionChoice(int minutes) {
        hasResponded = true;
        autoCloseTimer?.cancel();
        Get.back();
        _handleExtension(peminjamanId, namaMesin, minutes);
      }

      await Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Perpanjang Peminjaman?',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 30),
                      tween: Tween(begin: 30, end: 0),
                      onEnd: () {
                        if (!hasResponded && Get.isDialogOpen!) {
                          Get.back();
                        }
                      },
                      builder: (context, value, child) => Text(
                        '${value.ceil()}s',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: value <= 5 ? Colors.red : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF1F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        getImageForMachine(namaMesin),
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          namaMesin,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Berakhir: ${DateFormat('HH:mm').format(endTime)}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Pilih durasi perpanjangan:',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => handleExtensionChoice(15),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          foregroundColor: Colors.blue[700],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          '15 Menit',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => handleExtensionChoice(30),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          foregroundColor: Colors.blue[700],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          '30 Menit',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: handleDialogClose,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Batal',
                    style: GoogleFonts.inter(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      LoggerService.error('Error showing extension dialog: $e');
      autoCloseTimer?.cancel();
    } finally {
      autoCloseTimer?.cancel();
    }
  }
  // Future<void> showExtensionDialog(
  //     String peminjamanId, String namaMesin, DateTime endTime) async {
  //   if (Get.isDialogOpen == true) return;

  //   Timer? autoCloseTimer;
  //   bool hasResponded =
  //       false; // Flag untuk mengecek apakah user sudah merespons

  //   try {
  //     // Set timer sebelum menampilkan dialog
  //     autoCloseTimer = Timer(const Duration(seconds: 30), () {
  //       LoggerService.debug('Timer executed after 30 seconds'); // Debug print
  //       if (!hasResponded && Get.isDialogOpen!) {
  //         LoggerService.debug('Closing dialog automatically'); // Debug print
  //         Get.back();
  //         if (!_disposed) {
  //           setState(() {
  //             hasShownDialog.add(peminjamanId);
  //             pendingExtensionDialogs.remove(peminjamanId);
  //           });
  //           _saveHasShownDialog();
  //           _savePendingDialogs();

  //           // Tampilkan snackbar untuk memberi tahu user
  //           Get.snackbar(
  //             'Informasi',
  //             'Waktu perpanjangan telah habis',
  //             snackPosition: SnackPosition.TOP,
  //             backgroundColor: Colors.orange[100],
  //             colorText: Colors.orange[900],
  //             duration: const Duration(seconds: 3),
  //           );
  //         }
  //       }
  //     });

  //     // Fungsi helper untuk menutup dialog dan membersihkan state
  //     void handleDialogClose() {
  //       hasResponded = true;
  //       autoCloseTimer?.cancel();
  //       Get.back();
  //       if (!_disposed) {
  //         setState(() {
  //           hasShownDialog.add(peminjamanId);
  //           pendingExtensionDialogs.remove(peminjamanId);
  //         });
  //         _saveHasShownDialog();
  //         _savePendingDialogs();
  //       }
  //     }

  //     // Fungsi helper untuk menangani perpanjangan
  //     void handleExtensionChoice(int minutes) {
  //       hasResponded = true;
  //       autoCloseTimer?.cancel();
  //       Get.back();
  //       _handleExtension(peminjamanId, namaMesin, minutes);
  //     }

  //     await Get.dialog(
  //       AlertDialog(
  //         title: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               'Perpanjang Peminjaman?',
  //               style: GoogleFonts.inter(fontWeight: FontWeight.bold),
  //             ),
  //             // Timer visual
  //             TweenAnimationBuilder<double>(
  //               duration: const Duration(seconds: 30),
  //               tween: Tween(begin: 30, end: 0),
  //               onEnd: () {
  //                 if (!hasResponded && Get.isDialogOpen!) {
  //                   Get.back();
  //                 }
  //               },
  //               builder: (context, value, child) => Text(
  //                 '${value.ceil()}s',
  //                 style: GoogleFonts.inter(
  //                   fontSize: 12,
  //                   color: value <= 5 ? Colors.red : Colors.grey,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
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
  //                       getImageForMachine(namaMesin),
  //                       fit: BoxFit.contain,
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 8.0),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       namaMesin,
  //                       style: GoogleFonts.inter(
  //                         fontSize: 14.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     Text(
  //                       'Berakhir: ${DateFormat('HH:mm').format(endTime)}',
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
  //         actions: [
  //           TextButton(
  //             child: Text(
  //               '15 Menit',
  //               style: GoogleFonts.inter(fontWeight: FontWeight.w400),
  //             ),
  //             onPressed: () => handleExtensionChoice(15),
  //           ),
  //           TextButton(
  //             child: Text(
  //               '30 Menit',
  //               style: GoogleFonts.inter(fontWeight: FontWeight.w400),
  //             ),
  //             onPressed: () => handleExtensionChoice(30),
  //           ),
  //           TextButton(
  //             child: Text(
  //               'Batal',
  //               style: GoogleFonts.inter(fontWeight: FontWeight.w300),
  //             ),
  //             onPressed: () => handleDialogClose(),
  //           ),
  //         ],
  //       ),
  //       barrierDismissible: false,
  //     );
  //   } catch (e) {
  //     LoggerService.error('Error showing extension dialog: $e');
  //     autoCloseTimer?.cancel();
  //   } finally {
  //     // Pastikan timer dibersihkan
  //     autoCloseTimer?.cancel();
  //   }
  // }
  // Metode 1 yang sebelumnya digunakan
  // Future<void> showExtensionDialog(
  //     String peminjamanId, String namaMesin, DateTime endTime) async {
  //   if (Get.isDialogOpen == true) return;
  //   await Get.dialog(
  //     AlertDialog(
  //       title: Text(
  //         'Perpanjang Peminjaman?',
  //         style: GoogleFonts.inter(fontWeight: FontWeight.bold),
  //       ),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Container(
  //                 width: 35.0,
  //                 height: 35.0,
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFFCED9DF),
  //                   borderRadius: BorderRadius.circular(4.0),
  //                 ),
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(3.0),
  //                   child: Image.asset(
  //                     getImageForMachine(namaMesin),
  //                     fit: BoxFit.contain,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 8.0),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     namaMesin,
  //                     style: GoogleFonts.inter(
  //                       fontSize: 14.0,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   Text(
  //                     'Berakhir: ${DateFormat('HH:mm').format(endTime)}',
  //                     style: GoogleFonts.inter(
  //                       fontSize: 12.0,
  //                       color: const Color(0xFF5C5C5C),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 12),
  //           Text(
  //             'Pilih durasi perpanjangan:',
  //             style: GoogleFonts.inter(
  //               fontSize: 12.0,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           child: Text(
  //             '15 Menit',
  //             style: GoogleFonts.inter(fontWeight: FontWeight.w400),
  //           ),
  //           onPressed: () => _handleExtension(peminjamanId, namaMesin, 15),
  //         ),
  //         TextButton(
  //           child: Text(
  //             '30 Menit',
  //             style: GoogleFonts.inter(fontWeight: FontWeight.w400),
  //           ),
  //           onPressed: () => _handleExtension(peminjamanId, namaMesin, 30),
  //         ),
  //         TextButton(
  //           child: Text(
  //             'Batal',
  //             style: GoogleFonts.inter(fontWeight: FontWeight.w300),
  //           ),
  //           onPressed: () => Get.back(),
  //         ),
  //       ],
  //     ),
  //     barrierDismissible: false,
  //   );
  // }

  // Future<void> showExtensionDialog(
  //     String peminjamanId, String namaMesin, DateTime endTime) {
  //   Get.dialog(
  //     AlertDialog(
  //       title: Text(
  //         'Perpanjang Peminjamanan?',
  //         style: GoogleFonts.inter(fontWeight: FontWeight.bold),
  //       ),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Container(
  //                 width: 35.0,
  //                 height: 35.0,
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFFCED9DF),
  //                   borderRadius: BorderRadius.circular(4.0),
  //                 ),
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(3.0),
  //                   child: Image.asset(
  //                     getImageForMachine(namaMesin),
  //                     fit: BoxFit.contain,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 8.0),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     namaMesin,
  //                     style: GoogleFonts.inter(
  //                       fontSize: 14.0,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   Text(
  //                     'Berakhir: ${DateFormat('HH:mm').format(endTime)}',
  //                     style: GoogleFonts.inter(
  //                       fontSize: 12.0,
  //                       color: const Color(0xFF5C5C5C),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 12),
  //           Text(
  //             'Pilih durasi perpanjangan:',
  //             style: GoogleFonts.inter(
  //               fontSize: 12.0,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           child: Text(
  //             '15 Menit',
  //             style: GoogleFonts.inter(fontWeight: FontWeight.w400),
  //           ),
  //           onPressed: () => _handleExtension(peminjamanId, namaMesin, 15),
  //         ),
  //         TextButton(
  //           child: Text(
  //             '30 Menit',
  //             style: GoogleFonts.inter(fontWeight: FontWeight.w400),
  //           ),
  //           onPressed: () => _handleExtension(peminjamanId, namaMesin, 30),
  //         ),
  //         TextButton(
  //           child: Text(
  //             'Batal',
  //             style: GoogleFonts.inter(fontWeight: FontWeight.w300),
  //           ),
  //           onPressed: () => Get.back(),
  //         ),
  //       ],
  //     ),
  //     barrierDismissible: false,
  //   );
  // }

  void checkAndShowExtensionDialog(Datum peminjaman) {
    if (_disposed) return;

    try {
      final endTime = peminjaman.akhirPeminjamanTime;
      final peminjamanId = peminjaman.id;

      // Debugging
      LoggerService.debug('--- Debugging checkAndShowExtensionDialog ---');
      LoggerService.debug('Peminjaman ID: $peminjamanId');
      LoggerService.debug('End Time: $endTime');
      LoggerService.debug(
          'Activated: ${activatedButtons.contains(peminjamanId)}');
      LoggerService.debug(
          'Has Shown Dialog: ${hasShownDialog.contains(peminjamanId)}');
      LoggerService.debug(
          'Has Extended: ${hasExtended.contains(peminjamanId)}');

      if (endTime == null) return;

      final now = DateTime.now();
      final threeMinutesBefore = endTime.subtract(const Duration(minutes: 3));
      final timeToEnd = endTime.difference(now);

      LoggerService.debug('Current time: $now');
      LoggerService.debug('Three minutes before end: $threeMinutesBefore');
      LoggerService.debug('Remaining minutes: ${timeToEnd.inMinutes}');

      // Cek kondisi dasar
      if (!activatedButtons.contains(peminjamanId) ||
          hasExtended.contains(peminjamanId)) {
        return;
      }

      // Perbaikan logika waktu dan penampilan dialog
      if (now.isAfter(threeMinutesBefore) &&
          timeToEnd.inMinutes <= 3 &&
          timeToEnd.inMinutes > 0 &&
          !hasShownDialog.contains(peminjamanId)) {
        LoggerService.debug(
            'Menampilkan dialog perpanjangan untuk: $peminjamanId');

        // Tampilkan dialog
        showExtensionDialog(peminjamanId, peminjaman.namaMesin, endTime)
            .then((_) {
          if (!_disposed) {
            setState(() {
              hasShownDialog.add(peminjamanId);
              pendingExtensionDialogs.remove(peminjamanId);
            });
            _saveHasShownDialog();
            _savePendingDialogs();
            LoggerService.debug(
                'Dialog selesai ditampilkan untuk ID: $peminjamanId');
          }
        });
      } else {
        LoggerService.debug(
            'Belum waktunya menampilkan dialog atau dialog sudah ditampilkan');
      }
    } catch (e) {
      LoggerService.debug('Error in checkAndShowExtensionDialog: $e');
    }
  }

  // Update handling perpanjangan
  Future<void> _handleExtension(
      String peminjamanId, String namaMesin, int minutes) async {
    try {
      // Tutup dialog setelah user memilih durasi
      Get.back();

      // Kirim permintaan perpanjangan ke backend menggunakan ExtendPeminjamanController
      final success = await extendController.extendPeminjaman(
          peminjamanId, namaMesin, minutes);

      if (!_disposed) {
        if (success) {
          // Ambil waktu akhir peminjaman yang diperbarui dari controller
          final newEndTime = extendController.getNewEndTime(peminjamanId);

          if (newEndTime != null) {
            setState(() {
              // Tandai peminjaman sebagai sudah diperpanjang
              hasExtended.add(peminjamanId);
              pendingExtensionDialogs.remove(peminjamanId);
              hasShownNotification.remove(peminjamanId);
            });

            // Simpan status perpanjangan ke SharedPreferences
            await _saveHasExtended();
            await _savePendingDialogs();
            await _saveHasShownNotification();

            // Perbarui monitoring di NotificationService berdasarkan waktu baru
            _notificationService.startPeminjamanCheck(
              peminjamanId,
              newEndTime,
              namaMesin,
            );

            // Perbarui UI (misalnya durasi peminjaman yang diperpanjang)
            controller.update();

            // Berikan notifikasi sukses kepada pengguna
            Get.snackbar(
              'Peminjaman Diperpanjang',
              'Peminjaman untuk mesin $namaMesin telah diperpanjang $minutes menit.',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green[100],
              colorText: Colors.green[900],
              duration: const Duration(seconds: 3),
            );
          } else {
            // Tampilkan pesan kesalahan jika waktu baru tidak tersedia
            Get.snackbar(
              'Kesalahan',
              'Gagal mendapatkan waktu baru setelah perpanjangan.',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red[100],
              colorText: Colors.red[900],
              duration: const Duration(seconds: 3),
            );
          }
        } else {
          // Tampilkan pesan kesalahan jika perpanjangan gagal
          Get.snackbar(
            'Perpanjangan Gagal',
            'Gagal memperpanjang waktu peminjaman untuk mesin $namaMesin.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red[100],
            colorText: Colors.red[900],
            duration: const Duration(seconds: 3),
          );
        }
      }
    } catch (error) {
      // Tangani kesalahan yang terjadi selama proses
      print('Error in _handleExtension: $error');
      if (!_disposed) {
        Get.snackbar(
          'Kesalahan',
          'Terjadi kesalahan saat memperpanjang peminjaman.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
      }
    }
  }

  // Fungsi filter dialog
  void _showFilterDialog() {
    final filterOpts = filterOptions();
    String localSelectedStatus = controller.selectedStatus.value;
    String localSelectedMachineType = controller.selectedMachineType.value;

    Get.dialog(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(
              "Filter Peminjaman",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  DropdownButton<String>(
                    value: localSelectedStatus,
                    isExpanded: true,
                    items: filterOpts.statusOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          localSelectedStatus = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Jenis Mesin',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  DropdownButton<String>(
                    value: localSelectedMachineType,
                    isExpanded: true,
                    items: filterOpts.machineTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          localSelectedMachineType = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "Batal",
                  style: GoogleFonts.inter(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.setFilters(
                    status: localSelectedStatus,
                    machineType: localSelectedMachineType,
                  );
                  Get.back();
                },
                child: Text(
                  "Terapkan",
                  style: GoogleFonts.inter(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 232, 225, 247),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterSection(String title, String selectedValue,
      List<String> options, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
        DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return customScaffoldPage(
      body: Column(
        children: [
          const SizedBox(height: 36.0), // Spasi atas
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22.0),
                  topRight: Radius.circular(22.0),
                ),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22.0),
                  topRight: Radius.circular(22.0),
                ),
                child: CustomScrollView(
                  slivers: [
                    // Header
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        minHeight: 120.0,
                        maxHeight: 120.0,
                        child: Container(
                          color: Colors.white,
                          padding:
                              const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 10.0),
                          child: Column(
                            children: [
                              Text(
                                'Status Peminjaman',
                                style: GoogleFonts.inter(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 15.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: searchbar(
                                      onSearch: (value) {
                                        controller.setSearchQuery(value);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    flex: 3,
                                    child:
                                        filterbar(onPressed: _showFilterDialog),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Daftar Peminjaman
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
                      sliver:
                          //Obx
                          GetBuilder<PeminjamanUserAllController>(
                        builder: (controller) {
                          // if (controller.peminjaman.isEmpty)
                          final filteredPeminjaman =
                              controller.filteredPeminjaman;
                          //if (controller.filteredPeminjaman.isEmpty)
                          if (filteredPeminjaman.isEmpty) {
                            return SliverFillRemaining(
                              child: Center(
                                child: Text(
                                  'Tidak ada data peminjaman',
                                  style: GoogleFonts.inter(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            );
                          }
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                // final peminjaman = controller.peminjaman[index];
                                //final peminjaman = controller.filteredPeminjaman[index];
                                final peminjaman = filteredPeminjaman[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: const Color(0xFFE3E3E3),
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Baris atas: Keperluan Peminjaman dan Status
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                      MingCuteIcons
                                                          .mgc_schedule_line,
                                                      size: 30.0),
                                                  const SizedBox(width: 9.0),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Keperluan Peminjaman",
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontSize: 10.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      Text(
                                                        "Diajukan: ${peminjaman.formattedWaktu}",
                                                        //"Diajukan: ${DateFormat('dd MMM yyyy').format(peminjaman.waktu)}",
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 10.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: const Color(
                                                              0XFF6B6B6B),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: 58.0,
                                                height: 19.0,
                                                // padding: const EdgeInsets.symmetric(
                                                //     horizontal: 3, vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: dapatkanWarnaStatus(
                                                      peminjaman.status.name),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.0),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    peminjaman.status.name,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          dapatkanWarnaTeksStatus(
                                                              peminjaman
                                                                  .status.name),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            color: Color(0xFFE3E3E3),
                                          ),
                                          // Informasi Mesin
                                          Row(
                                            children: [
                                              Container(
                                                width: 35.0,
                                                height: 35.0,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFCED9DF),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Image.asset(
                                                    getImageForMachine(
                                                        peminjaman.namaMesin),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12.0),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Peminjaman Mesin",
                                                    style: GoogleFonts.inter(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    peminjaman.namaMesin,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 13.0,
                                                      color: const Color(
                                                          0xFF5C5C5C),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8.0),
                                          // Baris bawah: Total Jam dan Tombol
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Total Durasi Peminjaman",
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.0,
                                                      color: const Color(
                                                          0xFF5C5C5C),
                                                    ),
                                                  ),
                                                  Text(
                                                    calculateDuration(
                                                        peminjaman),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: const Color(
                                                          0xFF1E1E1E),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              ElevatedButton(
                                                onPressed:
                                                    _canActivateButton(
                                                            peminjaman)
                                                        ? () {
                                                            // Tampilkan dialog peringatan dengan UI yang lebih ringan
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: Row(
                                                                    children: [
                                                                      Icon(
                                                                        MingCuteIcons
                                                                            .mgc_warning_fill,
                                                                        color: Colors
                                                                            .red[700],
                                                                        size:
                                                                            24,
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              8),
                                                                      Text(
                                                                        'Perhatian!',
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.red[700],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  content:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        // Info mesin
                                                                        Text(
                                                                          'Mesin: ${peminjaman.namaMesin}',
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                15,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          'Waktu: ${DateFormat('HH:mm').format(peminjaman.awalPeminjamanTime!)} - ${DateFormat('HH:mm').format(peminjaman.akhirPeminjamanTime!)}',
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            fontSize:
                                                                                13,
                                                                            color:
                                                                                Colors.grey[700],
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                16),

                                                                        // Informasi penting
                                                                        Text(
                                                                          'Informasi Penting:',
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.red[700],
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                8),

                                                                        // List peringatan yang lebih ringan
                                                                        _buildWarningItem(
                                                                          icon:
                                                                              MingCuteIcons.mgc_time_duration_line,
                                                                          text:
                                                                              'Mesin akan mati otomatis saat waktu habis',
                                                                          color:
                                                                              Colors.red[700]!,
                                                                        ),
                                                                        _buildWarningItem(
                                                                          icon:
                                                                              MingCuteIcons.mgc_notification_line,
                                                                          text:
                                                                              'Notifikasi 5 menit sebelum waktu habis.',
                                                                          color:
                                                                              Colors.blue[700]!,
                                                                        ),
                                                                        _buildWarningItem(
                                                                          icon:
                                                                              MingCuteIcons.mgc_calendar_time_add_line,
                                                                          text:
                                                                              'Dialog perpanjangan muncul 3 menit sebelum berakhir.',
                                                                          color:
                                                                              Colors.green[700]!,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.of(context).pop(),
                                                                      child:
                                                                          Text(
                                                                        'Batal',
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                          color:
                                                                              Colors.grey[700],
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        await _startPeminjaman(
                                                                            peminjaman);
                                                                      },
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.blue[700],
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        'Mulai Peminjaman',
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          }
                                                        : null,
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize:
                                                      const Size(90.0, 17.0),
                                                  backgroundColor:
                                                      _getButtonColor(
                                                          peminjaman),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 7.0,
                                                      vertical: 5.0),
                                                ),
                                                child: Text(
                                                  _getButtonText(peminjaman),
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              // ElevatedButton(
                                              //   onPressed: _canActivateButton(
                                              //           peminjaman)
                                              //       ? () async {
                                              //           if (!activatedButtons
                                              //               .contains(peminjaman
                                              //                   .id)) {
                                              //             setState(() {
                                              //               activatedButtons
                                              //                   .add(peminjaman
                                              //                       .id);
                                              //             });
                                              //             await _saveActivatedButtons(); // Simpan status tombol

                                              //             // Aktifkan relay untuk memulai peminjaman
                                              //             sensorController
                                              //                 .turnOnButtonFromFrontend(
                                              //               peminjaman
                                              //                   .id, // ID peminjaman
                                              //               peminjaman.namaMesin
                                              //                   .toLowerCase(), // Tipe mesin
                                              //             );

                                              //             // Cek apakah perlu perpanjangan waktu
                                              //             checkAndShowExtensionDialog(
                                              //                 peminjaman);

                                              //             // Start notification monitoring
                                              //             _notificationService
                                              //                 .startPeminjamanCheck(
                                              //                     peminjaman.id,
                                              //                     peminjaman
                                              //                         .akhirPeminjamanTime!,
                                              //                     peminjaman
                                              //                         .namaMesin);

                                              //             // Tampilkan snackbar sebagai konfirmasi bahwa peminjaman telah dimulai
                                              //             Get.snackbar(
                                              //               "Peminjaman Dimulai",
                                              //               "Mesin ${peminjaman.namaMesin} telah diaktifkan.",
                                              //               snackPosition:
                                              //                   SnackPosition
                                              //                       .TOP,
                                              //               duration: Duration(
                                              //                   seconds: 3),
                                              //             );
                                              //             // Timer untuk mematikan tombol secara otomatis ketika waktu peminjaman habis
                                              // DateTime?
                                              //     akhirPeminjamanDate =
                                              //     peminjaman
                                              //         .akhirPeminjamanTime;
                                              // if (akhirPeminjamanDate !=
                                              //     null) {
                                              //   final now =
                                              //       DateTime.now();
                                              //   if (akhirPeminjamanDate
                                              //       .isAfter(now)) {
                                              //     final notificationTime =
                                              //         akhirPeminjamanDate
                                              //             .subtract(Duration(
                                              //                 minutes:
                                              //                     5));
                                              //     if (now.isBefore(
                                              //         notificationTime)) {
                                              //       Timer(
                                              //           notificationTime
                                              //               .difference(
                                              //                   now),
                                              //           () {
                                              //         if (!_disposed) {
                                              //           _sendNotification(
                                              //               peminjaman);
                                              //         }
                                              //       });
                                              //     }
                                              //     final durationUntilEnd =
                                              //         akhirPeminjamanDate
                                              //             .difference(
                                              //                 now);
                                              //     Timer(
                                              //         durationUntilEnd,
                                              //         () {
                                              //       if (!_disposed) {
                                              //         // Check if widget is still mounted
                                              //         setState(() {
                                              //           activatedButtons
                                              //               .remove(
                                              //                   peminjaman.id); // Nonaktifkan tombol
                                              //         });
                                              //         _saveActivatedButtons(); // Simpan status setelah tombol dinonaktifkan
                                              //         controller
                                              //             .update(); // Perbarui tampilan UI
                                              //       }
                                              //     });
                                              //   }
                                              // }
                                              //           } else {
                                              //             // Jika tombol sudah aktif, tampilkan pesan
                                              //             Get.snackbar(
                                              //               "Peminjaman Sudah Aktif",
                                              //               "Mesin ${peminjaman.namaMesin} sudah diaktifkan sebelumnya.",
                                              //               snackPosition:
                                              //                   SnackPosition
                                              //                       .TOP,
                                              //               duration: Duration(
                                              //                   seconds: 3),
                                              //             );
                                              //           }
                                              //         }
                                              //       : null,
                                              //   style: ElevatedButton.styleFrom(
                                              //     minimumSize:
                                              //         const Size(90.0, 17.0),
                                              //     backgroundColor:
                                              //         _getButtonColor(
                                              //             peminjaman),
                                              //     shape: RoundedRectangleBorder(
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               4.0),
                                              //     ),
                                              //     padding: const EdgeInsets
                                              //         .symmetric(
                                              //         horizontal: 7.0,
                                              //         vertical: 5.0),
                                              //   ),
                                              //   child: Text(
                                              //     _getButtonText(peminjaman),
                                              //     style: GoogleFonts.inter(
                                              //       fontSize: 12.0,
                                              //       fontWeight: FontWeight.w800,
                                              //       color: Colors.white,
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: filteredPeminjaman.length,
                            ),
                          );
                        },
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
  }
}

class searchbar extends StatelessWidget {
  final Function(String) onSearch;

  const searchbar({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: const Color(0xFFDDDEE3)),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Cari Keperluan",
          hintStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            color: const Color(0xFF999999),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          prefixIcon: const Icon(
            MingCuteIcons.mgc_search_2_line,
            color: Color(0xFF09244B),
          ),
        ),
        onChanged: onSearch,
      ),
    );
  }
}

class filterbar extends StatelessWidget {
  final Function() onPressed;

  const filterbar({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: const Color(0xFFDDDEE3)),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                MingCuteIcons.mgc_filter_line,
                color: Color(0xFF09244B),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                "Filter",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF09244B),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class filterOptions {
  final List<String> statusOptions = [
    'Semua',
    'Diproses',
    'Disetujui',
    'Ditolak',
    'Selesai'
  ];
  final List<String> machineTypes = [
    'Semua',
    'CNC Milling',
    '3D Printing',
    'Laser Cutting'
  ];
  final List<String> timeRanges = [
    'Semua',
    'Minggu Ini',
    'Bulan Ini',
    '3 Bulan Terakhir'
  ];
  final List<String> durationRanges = [
    'Semua',
    '< 5 jam',
    '5 - 10 jam',
    '> 10 jam'
  ];
}
