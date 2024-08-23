import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../models/sensor_Model.dart';

class SensorController extends GetxController {
  var isLoading = false.obs;
  var buttonState = false.obs;
  Timer? _timer;

  Future<void> toggleButton() async {
    isLoading(true);

    // Ganti URL ini dengan URL API POST Anda
    String url = "https://kh8ppwzx-3000.asse.devtunnels.ms/sensor/cnc/buttonPeminjaman";

    try {
      var sensorData = SensorData(button: buttonState.value);
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(sensorData.toJson()),
      );

      if (response.statusCode == 201) {
        print("Button state uploaded successfully!");
      } else {
        print(
            "Failed to upload button state. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  void turnOnWithTimeout() {
    buttonState(true);
    toggleButton();

    // Matikan relay setelah 10 detik
    _timer?.cancel(); // Jika ada timer sebelumnya, batalkan
    _timer = Timer(Duration(seconds: 10), () {
      buttonState(false);
      toggleButton();
    });
  }

  @override
  void onClose() {
    _timer?.cancel(); // Batalkan timer jika controller ditutup
    super.onClose();
  }
}