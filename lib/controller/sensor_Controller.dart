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

// Methode 2: sensor_controller.dart

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../models/sensor_Model.dart';

class SensorController extends GetxController {
  var isLoading = false.obs;
  var buttonState = false.obs;
  Timer? _timer;

  // Method ini menerima `espAddress` sebagai parameter
  Future<void> toggleButton(String espAddress) async {
    isLoading(true);
    print(
        "Sending request to $espAddress with button state: ${buttonState.value}");

    try {
      var sensorData = SensorData(button: buttonState.value);
      var response = await http.post(
        Uri.parse(espAddress), // Menggunakan `espAddress` dinamis
        headers: {"Content-Type": "application/json"},
        body: json.encode(sensorData.toJson()),
      );

      if (response.statusCode == 201) {
        print(
            "Button state uploaded successfully! Current state: ${buttonState.value}");
      } else {
        print(
            "Failed to upload button state. Status code: ${response.statusCode}. Response body: ${response.body}");
      }
    } catch (e) {
      print("Error occurred while toggling button: $e");
    } finally {
      isLoading(false);
      print("Finished request to $espAddress");
    }
  }

  void turnOnWithTimeout(String espAddress) {
    buttonState(true);
    print("Button state set to ON. Initiating toggleButton call.");
    toggleButton(espAddress);

    // Matikan relay setelah 10 detik
    _timer?.cancel(); // Jika ada timer sebelumnya, batalkan
    _timer = Timer(Duration(seconds: 10), () {
      print("10 seconds passed. Turning off button.");
      buttonState(false);
      toggleButton(espAddress);
    });
  }

  @override
  void onClose() {
    print("SensorController is being closed. Cancelling timer if exists.");
    _timer?.cancel(); // Batalkan timer jika controller ditutup
    super.onClose();
  }
}
