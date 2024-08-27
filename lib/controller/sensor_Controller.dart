// Methode 1

// sensor_controller.dart

// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
// import '../models/sensor_Model.dart';

// class SensorController extends GetxController {
//   var isLoading = false.obs;
//   var buttonState = false.obs;
//   Timer? _timer;

//   Future<void> toggleButton() async {
//     isLoading(true);

//     // Ganti URL ini dengan URL API POST Anda
//     String url = "https://kh8ppwzx-3000.asse.devtunnels.ms/sensor/cnc/buttonPeminjaman";

//     try {
//       var sensorData = SensorData(button: buttonState.value);
//       var response = await http.post(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: json.encode(sensorData.toJson()),
//       );

//       if (response.statusCode == 201) {
//         print("Button state uploaded successfully!");
//       } else {
//         print(
//             "Failed to upload button state. Status code: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error: $e");
//     } finally {
//       isLoading(false);
//     }
//   }

//   void turnOnWithTimeout() {
//     buttonState(true);
//     toggleButton();

//     // Matikan relay setelah 10 detik
//     _timer?.cancel(); // Jika ada timer sebelumnya, batalkan
//     _timer = Timer(Duration(seconds: 10), () {
//       buttonState(false);
//       toggleButton();
//     });
//   }

//   @override
//   void onClose() {
//     _timer?.cancel(); // Batalkan timer jika controller ditutup
//     super.onClose();
//   }
// }

// ------------------------------------------ //

// Methode 2: sensor_controller.dart

// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
// import '../models/sensor_Model.dart';

// class SensorController extends GetxController {
//   var isLoading = false.obs;
//   var buttonState = false.obs;
//   Timer? _timer;

//   // Method ini menerima `espAddress` sebagai parameter
//   Future<void> toggleButton(String espAddress) async {
//     isLoading(true);
//     print(
//         "Sending request to $espAddress with button state: ${buttonState.value}");

//     try {
//       var sensorData = SensorData(button: buttonState.value);
//       var response = await http.post(
//         Uri.parse(espAddress), // Menggunakan `espAddress` dinamis
//         headers: {"Content-Type": "application/json"},
//         body: json.encode(sensorData.toJson()),
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
//       print("Finished request to $espAddress");
//     }
//   }

//   void turnOnWithTimeout(String espAddress) {
//     buttonState(true);
//     print("Button state set to ON. Initiating toggleButton call.");
//     toggleButton(espAddress);

//     // Matikan relay setelah 10 detik
//     _timer?.cancel(); // Jika ada timer sebelumnya, batalkan
//     _timer = Timer(Duration(seconds: 10), () {
//       print("10 seconds passed. Turning off button.");
//       buttonState(false);
//       toggleButton(espAddress);
//     });
//   }

//   @override
//   void onClose() {
//     print("SensorController is being closed. Cancelling timer if exists.");
//     _timer?.cancel(); // Batalkan timer jika controller ditutup
//     super.onClose();
//   }
// }

// ------------------------------------------ //

// Methode 3: sensor_controller.dart

// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
// import '../models/sensor_Model.dart';

// class SensorController extends GetxController {
//   var isLoading = false.obs;
//   var buttonState = false.obs;
//   Timer? _timer;

//   Future<bool> toggleButton(String espAddress) async {
//     isLoading(true);
//     print("Sending request to $espAddress with button state: ${buttonState.value}");

//     try {
//       var sensorData = SensorData(button: buttonState.value);
//       var response = await http.post(
//         Uri.parse(espAddress),
//         headers: {"Content-Type": "application/json"},
//         body: json.encode(sensorData.toJson()),
//       );

//       if (response.statusCode == 201) {
//         print("Button state changed successfully! Current state: ${buttonState.value}");
//         return true;
//       } else {
//         print("Failed to change button state. Status code: ${response.statusCode}. Response body: ${response.body}");
//         return false;
//       }
//     } catch (e) {
//       print("Error occurred while toggling button: $e");
//       return false;
//     } finally {
//       isLoading(false);
//     }
//   }

//   Future<bool> turnOn(String espAddress) async {
//     buttonState(true);
//     return await toggleButton(espAddress);
//   }

//   Future<bool> turnOff(String espAddress) async {
//     buttonState(false);
//     return await toggleButton(espAddress);
//   }

//   void turnOnWithTimeout(String espAddress, Duration duration) {
//     turnOn(espAddress);
    
//     _timer?.cancel();
//     _timer = Timer(duration, () {
//       print("Peminjaman time ended. Turning off button.");
//       turnOff(espAddress);
//     });
//   }

//   void extendTimeout(String espAddress, Duration extension) {
//     _timer?.cancel();
//     _timer = Timer(extension, () {
//       print("Extended time ended. Turning off button.");
//       turnOff(espAddress);
//     });
//   }

//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }
// }

// --------------------------------- //

// Methode 4: sensorController.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class SensorController extends GetxController {
  var isLoading = false.obs;
  var buttonState = false.obs;
  Timer? _timer;
  Timer? _notificationTimer;

  // Method ini menerima alamatEsp sebagai parameter
  Future<void> toggleButton(String alamatEsp) async {
    isLoading(true);
    print("Sending request to $alamatEsp with button state: ${buttonState.value}");

    try {
      var sensorData = {"button": buttonState.value};
      var response = await http.post(
        Uri.parse(alamatEsp), // Menggunakan alamatEsp dinamis
        headers: {"Content-Type": "application/json"},
        body: json.encode(sensorData),
      );

      if (response.statusCode == 201) {
        print("Button state uploaded successfully! Current state: ${buttonState.value}");
      } else {
        print("Failed to upload button state. Status code: ${response.statusCode}. Response body: ${response.body}");
      }
    } catch (e) {
      print("Error occurred while toggling button: $e");
    } finally {
      isLoading(false);
      print("Finished request to $alamatEsp");
    }
  }

  void turnOnWithTimeout(String alamatEsp, DateTime akhirPeminjaman) {
    buttonState(true);
    print("Button state set to ON for ESP Address: $alamatEsp. Initiating toggleButton call.");
    toggleButton(alamatEsp);

    // Log sisa waktu sebelum peminjaman berakhir
    final now = DateTime.now();
    final remainingTime = akhirPeminjaman.difference(now);
    print("Remaining time until end of rental for $alamatEsp: $remainingTime");

    // Log pengiriman notifikasi 10 menit sebelum peminjaman berakhir
    if (remainingTime > Duration(minutes: 10)) {
      _notificationTimer = Timer(remainingTime - Duration(minutes: 10), () {
        print("10 minutes before rental ends for $alamatEsp. Sending notification.");
        showNotification("Peminjaman akan habis dalam 10 menit", "Pastikan mesin berada dalam posisi home.");
        
        // Tampilkan dialog perpanjangan peminjaman
        _showExtendRentalDialog(alamatEsp, akhirPeminjaman);
      });
    }

    // Timer untuk mematikan mesin setelah peminjaman habis
    _timer?.cancel();
    _timer = Timer(remainingTime, () {
      print("Peminjaman has ended for $alamatEsp. Turning off button.");
      buttonState(false);
      toggleButton(alamatEsp);
    });
  }

  // Fungsi untuk menampilkan notifikasi (simulasi saja)
  void showNotification(String title, String message) {
    // Anda dapat menggunakan plugin notifikasi lokal atau memanfaatkan mekanisme lain sesuai kebutuhan Anda
    print("Notification: $title - $message");
  }

  void _showExtendRentalDialog(String alamatEsp, DateTime currentEndTime) {
    Get.dialog(
      AlertDialog(
        title: Text("Perpanjang Peminjaman"),
        content: Text("Waktu peminjaman akan habis dalam 10 menit. Apakah Anda ingin memperpanjang peminjaman?"),
        actions: [
          TextButton(
            onPressed: () {
              // Jika pengguna tidak ingin memperpanjang
              Get.back();
            },
            child: Text("Tidak"),
          ),
          ElevatedButton(
            onPressed: () {
              // Jika pengguna ingin memperpanjang peminjaman
              Get.back(); // Tutup dialog
              DateTime newEndTime = currentEndTime.add(Duration(minutes: 30)); // Tambah 30 menit
              print("Extending rental time by 30 minutes. New end time: $newEndTime");
              turnOnWithTimeout(alamatEsp, newEndTime); // Restart timer dengan waktu akhir baru
            },
            child: Text("Perpanjang 30 menit"),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    print("SensorController is being closed. Cancelling timer if exists.");
    _timer?.cancel(); // Batalkan timer jika controller ditutup
    _notificationTimer?.cancel(); // Batalkan notifikasi jika controller ditutup
    super.onClose();
  }
}
