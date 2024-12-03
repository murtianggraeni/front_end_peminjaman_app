// SensorController.dart

import 'package:build_app/provider/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:build_app/services/logger.dart';

class SensorController extends GetxController {
  var isLoading = false.obs; // Untuk melacak loading status
  var buttonStateMap = <String, bool>{}.obs; // Untuk melacak status tiap tombol berdasarkan ID

  final ApiController apiController = ApiController();

    // Fungsi untuk menambahkan timestamp ke log
  void logWithTimestamp(String message) {
    final now = DateTime.now();
    final formattedTime = '${now.day.toString().padLeft(2, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.year} ${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    print('[$formattedTime] : $message');
  }


  // Method untuk memulai peminjaman dengan mengirimkan request ke backend
  // Future<void> startRental(String peminjamanId, String type) async {
  //   isLoading(true); // Set loading menjadi true ketika permintaan dimulai
  //   try {
  //     var response = await apiController.startRental(peminjamanId, type);

  //     if (response.statusCode == 200) {
  //       print("Relay berhasil diaktifkan");
  //       buttonState(true); // Indikasi bahwa tombol telah ON
  //     } else {
  //       print("Gagal mengaktifkan relay. Status code: ${response.statusCode}");
  //       print("Response body: ${response.body}");
  //     }
  //   } catch (e) {
  //     print("Error saat mengirim permintaan ke backend: $e");
  //   } finally {
  //     isLoading(
  //         false); // Set loading kembali ke false setelah permintaan selesai
  //   }
  // }

  // Method untuk memulai peminjaman dengan mengirimkan request ke backend
  Future<void> startRental(String peminjamanId, String type) async {
    isLoading(
        true); // Set isLoading menjadi true untuk menandai proses berlangsung
    int attempts = 0;
    const maxAttempts = 3;
    const delayBetweenAttempts = Duration(seconds: 2);

    while (attempts < maxAttempts) {
      try {
        var response = await apiController.startRental(peminjamanId, type);

        if (response.statusCode == 200) {
          logWithTimestamp("Relay berhasil diaktifkan untuk peminjaman: ${peminjamanId}");
          LoggerService.debug("Relay berhasil diaktifkan untuk peminjaman: ${peminjamanId}");
          // buttonState(true); // Hanya ubah status jika respons berhasil
          buttonStateMap[peminjamanId] = true;  // Set state untuk peminjaman ini
          isLoading(false); // Set isLoading menjadi false ketika selesai
          return; // Keluar dari loop karena sukses
        } else if (response.statusCode == 429) {
          // Jika ada rate limit, coba lagi setelah delay
          attempts++;
          if (attempts < maxAttempts) {
            await Future.delayed(delayBetweenAttempts);
            continue; // Lanjut ke percobaan berikutnya
          }
        } else {
          // Jika ada error lain selain rate limit
          logWithTimestamp(
              "Gagal mengaktifkan relay. Status code: ${response.statusCode}");
          logWithTimestamp("Response body: ${response.body}");
          LoggerService.error(
              "Gagal mengaktifkan relay. Status code: ${response.statusCode}");
          LoggerService.error("Response body: ${response.body}");
          break; // Keluar dari loop karena gagal
        }
      } catch (e) {
        logWithTimestamp("Error saat mengirim permintaan ke backend: $e");
        LoggerService.error("Error saat mengirim permintaan ke backend: $e");
        break; // Keluar dari loop karena exception
      }
    }

    // Jika sampai sini berarti semua percobaan gagal
    isLoading(false); // Pastikan isLoading direset
    // buttonState(false); // Biarkan tombol bisa ditekan lagi setelah gagal
    buttonStateMap[peminjamanId] = false;  // Set state untuk peminjaman ini

    // Tampilkan pesan error ke pengguna
    Get.snackbar(
      "Gagal Memulai Peminjaman",
      "Terjadi kesalahan saat mencoba memulai peminjaman. Silakan coba lagi nanti.",
      snackPosition: SnackPosition.TOP,
    );
  }

  // Method yang dipanggil saat pengguna menekan tombol dari UI (statusPage.dart)
  void turnOnButtonFromFrontend(String peminjamanId, String type) {
    if (buttonStateMap[peminjamanId] == true) {
      logWithTimestamp("Tombol sudah diaktifkan, tidak perlu lagi.");
      LoggerService.debug("Tombol sudah diaktifkan, tidak perlu lagi.");
      return;
    }

    // Panggil method untuk memulai rental (ON)
    startRental(peminjamanId, type);
  }

  // Method untuk memulai peminjaman dengan mengirimkan request ke backend
  // Future<void> startRental(String peminjamanId, String type) async {
  //   isLoading(true);
  //   int attempts = 0;
  //   const maxAttempts = 3;
  //   const delayBetweenAttempts = Duration(seconds: 2);

  //   while (attempts < maxAttempts) {
  //     try {
  //       var response = await apiController.startRental(peminjamanId, type);

  //       if (response.statusCode == 200) {
  //         print("Relay berhasil diaktifkan");
  //         buttonState(true);
  //         isLoading(false);
  //         return; // Berhasil, keluar dari loop
  //       } else if (response.statusCode == 429) {
  //         // Rate limit, tunggu sebelum mencoba lagi
  //         attempts++;
  //         if (attempts < maxAttempts) {
  //           await Future.delayed(delayBetweenAttempts);
  //           continue; // Lanjut ke percobaan berikutnya
  //         }
  //       } else {
  //         // Error lain
  //         print(
  //             "Gagal mengaktifkan relay. Status code: ${response.statusCode}");
  //         print("Response body: ${response.body}");
  //         break; // Keluar dari loop untuk error non-429
  //       }
  //     } catch (e) {
  //       print("Error saat mengirim permintaan ke backend: $e");
  //       break; // Keluar dari loop untuk error exception
  //     }
  //   }

  //   // Jika sampai sini, berarti semua percobaan gagal
  //   isLoading(false);
  //   Get.snackbar(
  //     "Gagal Memulai Peminjaman",
  //     "Terjadi kesalahan saat mencoba memulai peminjaman. Silakan coba lagi nanti.",
  //     snackPosition: SnackPosition.TOP,
  //   );
  // }

  // // Method yang dipanggil saat pengguna menekan tombol dari UI (statusPage.dart)
  // void turnOnButtonFromFrontend(String peminjamanId, String type) {
  //   if (buttonState.value == true) {
  //     print("Tombol sudah diaktifkan, tidak perlu lagi.");
  //     return;
  //   }

  //   // Panggil method untuk memulai rental (ON)
  //   startRental(peminjamanId, type);
  // }
}
// final ApiController _apiController = ApiController();

// class SensorController extends GetxController {
//   var isLoading = false.obs;
//   var buttonState = false.obs;
//   Timer? _timer;
//   Timer? _notificationTimer;
//   Timer? _countdownTimer;
//   var countdownValue = 20.obs; // Durasi 20 detik untuk dialog perpanjangan

//   // Method ini menerima alamatEsp sebagai parameter
//   Future<void> toggleButton(String alamatEsp,
//       {bool? newState, DateTime? newEndTime}) async {
//     isLoading(true);
//     print(
//         "Sending request to $alamatEsp with button state: ${buttonState.value}");

//     try {
//       var sensorData = {
//         "button": buttonState.value,
//         "newEndTime": newEndTime?.toIso8601String(),
//       };
//       var response = await http.post(
//         Uri.parse(alamatEsp),
//         headers: {"Content-Type": "application/json"},
//         body: json.encode(sensorData),
//       );

//       if (response.statusCode == 201) {
//         print(
//             "Button state uploaded successfully! Current state: ${buttonState.value}");
//       } else {
//         print(
//             "Failed to upload button state. Status code: ${response.statusCode}. Response body: ${response.body}");
//       }
//     } catch (e) {
//       print("Error occurred while toggling button: $e");
//     } finally {
//       isLoading(false);
//       print("Finished request to $alamatEsp");
//     }
//   }

//   void turnOnWithTimeout(String alamatEsp, DateTime akhirPeminjaman,
//       String peminjamanId, Function onTimeout) {
//     if (buttonState.value == true) {
//       print("Button has already been activated. Skipping toggle.");
//       return;
//     }

//     buttonState(true);
//     print(
//         "Button state set to ON for ESP Address: $alamatEsp. Initiating toggleButton call.");
//     toggleButton(alamatEsp);

//     final now = DateTime.now();
//     final remainingTime = akhirPeminjaman.difference(now);
//     print("Remaining time until end of rental for $alamatEsp: $remainingTime");

//     if (remainingTime > Duration(minutes: 10)) {
//       _notificationTimer = Timer(remainingTime - Duration(minutes: 10), () {
//         print(
//             "10 minutes before rental ends for $alamatEsp. Sending notification.");
//         showNotification("Peminjaman akan habis dalam 10 menit",
//             "Pastikan mesin berada dalam posisi home.");
//         _showExtendRentalDialog(alamatEsp, akhirPeminjaman, peminjamanId);
//       });
//     }

//     _timer?.cancel();
//     _timer = Timer(remainingTime, () {
//       print("Peminjaman has ended for $alamatEsp. Turning off button.");
//       buttonState(false);
//       toggleButton(alamatEsp);
//       onTimeout(); // Panggil callback ketika waktu habis
//     });
//   }

//   // Fungsi untuk memperpanjang waktu peminjaman
//   Future<void> extendRentalTime(
//       String peminjamanId, DateTime newEndTime, String alamatEsp) async {
//     try {
//       var response =
//           await _apiController.extendRentalTime(peminjamanId, newEndTime);

//       if (response.statusCode == 200) {
//         print("Rental time extended successfully.");
//         toggleButton(alamatEsp, newState: true, newEndTime: newEndTime);

//         // Reset timer dengan waktu baru
//         _timer?.cancel();
//         _notificationTimer?.cancel();

//         final remainingTime = newEndTime.difference(DateTime.now());
//         _timer = Timer(remainingTime, () {
//           buttonState(false);
//           toggleButton(alamatEsp, newState: false);
//         });

//         // Set notifikasi baru 10 menit sebelum waktu berakhir yang baru
//         if (remainingTime > Duration(minutes: 10)) {
//           _notificationTimer = Timer(remainingTime - Duration(minutes: 10), () {
//             showNotification("Peminjaman akan habis dalam 10 menit",
//                 "Pastikan mesin berada dalam posisi home.");
//             _showExtendRentalDialog(alamatEsp, newEndTime, peminjamanId);
//           });
//         }

//         Get.snackbar(
//           "Perpanjangan Berhasil",
//           "Waktu peminjaman berhasil diperpanjang hingga ${DateFormat('HH:mm').format(newEndTime)}",
//           snackPosition: SnackPosition.TOP,
//           duration: Duration(seconds: 3),
//         );
//       } else {
//         throw Exception('Failed to extend rental time');
//       }
//     } catch (e) {
//       print("Error occurred while extending rental time: $e");
//       Get.snackbar(
//         "Error",
//         "Terjadi kesalahan saat memperpanjang waktu peminjaman.",
//         snackPosition: SnackPosition.TOP,
//         duration: Duration(seconds: 3),
//       );
//     }
//   }

//   void _showExtendRentalDialog(
//       String alamatEsp, DateTime currentEndTime, String peminjamanId) {
//     countdownValue.value = 20;
//     _startCountdownTimer();

//     Get.dialog(
//       Obx(() => Stack(
//             alignment: Alignment.center,
//             children: [
//               AlertDialog(
//                 title: Text("Perpanjang Peminjaman"),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                         "Waktu peminjaman akan habis dalam 10 menit. Apakah Anda ingin memperpanjang peminjaman?"),
//                     SizedBox(height: 10),
//                     Text(
//                       "Waktu tersisa: ${countdownValue.value} detik",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             _cancelCountdownTimer();
//                             Get.back();
//                             DateTime newEndTime =
//                                 currentEndTime.add(Duration(minutes: 15));
//                             extendRentalTime(
//                                 peminjamanId, newEndTime, alamatEsp);
//                           },
//                           child: Text("15 menit"),
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             _cancelCountdownTimer();
//                             Get.back();
//                             DateTime newEndTime =
//                                 currentEndTime.add(Duration(minutes: 30));
//                             extendRentalTime(
//                                 peminjamanId, newEndTime, alamatEsp);
//                           },
//                           child: Text("30 menit"),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       _cancelCountdownTimer();
//                       Get.back();
//                     },
//                     child: Text("Tidak"),
//                   ),
//                 ],
//               ),
//               Positioned(
//                 child: CircularProgressIndicator(
//                   value: countdownValue.value / 20,
//                   strokeWidth: 6,
//                 ),
//               ),
//             ],
//           )),
//       barrierDismissible: false,
//     ).then((_) => _cancelCountdownTimer());
//   }

//   void _startCountdownTimer() {
//     _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (countdownValue.value > 0) {
//         countdownValue.value--;
//       } else {
//         _cancelCountdownTimer();
//         Get.back();
//       }
//     });
//   }

//   void _cancelCountdownTimer() {
//     _countdownTimer?.cancel();
//   }

//   // Fungsi untuk menampilkan notifikasi (simulasi saja)
//   void showNotification(String title, String message) {
//     print("Notification: $title - $message");
//   }

//   @override
//   void onClose() {
//     print("SensorController is being closed. Cancelling timer if exists.");
//     _timer?.cancel();
//     _notificationTimer?.cancel();
//     _cancelCountdownTimer();
//     super.onClose();
//   }
// }
