// import 'dart:async';
// import 'dart:convert';
// import 'package:build_app/models/count_model.dart';
// import 'package:build_app/provider/api.dart';
// import 'package:get/get.dart';

// class CountController extends GetxController {
//   final ApiController apiController = ApiController();
//   var counts = Counts(
//       success: false,
//       message: '',
//       data: Data(
//         id: '',
//         v: 0,
//         disetujuiCnc: 0,
//         ditolakCnc: 0,
//         menungguCnc: 0,
//         disetujuiLaser: 0,
//         ditolakLaser: 0,
//         menungguLaser: 0,
//         disetujuiPrinting: 0,
//         ditolakPrinting: 0,
//         menungguPrinting: 0,
//       )).obs;

//   final _sensorStreamController = StreamController<Counts>.broadcast();
//   Stream<Counts> get sensorStream => _sensorStreamController.stream;

//   @override
//   void onInit() {
//     super.onInit();
//     Timer.periodic(Duration(seconds: 1), (timer) {
//       countsStatus();
//     });
//   }

//   Future<void> countsStatus() async {
//     try {
//       final response = await apiController.countData();
//       if (response.statusCode == 200) {
//         final dynamic responseData = json.decode(response.body);

//         if (responseData is Map<String, dynamic>) {
//           final Counts singleSensor = Counts.fromJson(responseData);
//           counts.value = singleSensor;
//           print('Response Data Status Success');
//           _sensorStreamController.add(singleSensor);
//         } else {
//           print('Invalid sensor update type: ${responseData.runtimeType}');
//         }
//       } else {
//         throw Exception(
//           'Gagal mengambil data. Status code: ${response.statusCode}',
//         );
//       }
//     } catch (e) {
//       print('Error fetchData: $e');
//     }
//   }

//   @override
//   void onClose() {
//     _sensorStreamController.close();
//     super.onClose();
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:build_app/models/count_model.dart';
import 'package:build_app/provider/api.dart';
import 'package:get/get.dart';

class CountController extends GetxController {
  final ApiController apiController = ApiController();
  var counts = Counts(
      success: false,
      message: '',
      data: Data(
        id: '',
        v: 0,
        disetujuiCnc: 0,
        ditolakCnc: 0,
        menungguCnc: 0,
        disetujuiLaser: 0,
        ditolakLaser: 0,
        menungguLaser: 0,
        disetujuiPrinting: 0,
        ditolakPrinting: 0,
        menungguPrinting: 0,
      )).obs;

  final _sensorStreamController = StreamController<Counts>.broadcast();
  Stream<Counts> get sensorStream => _sensorStreamController.stream;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Ubah interval menjadi setiap 30 detik
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      countsStatus();
    });
    // Panggil countsStatus segera saat controller diinisialisasi
    countsStatus();
  }

  Future<void> countsStatus() async {
    try {
      final response = await apiController.countData();
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic>) {
          final Counts singleSensor = Counts.fromJson(responseData);
          counts.value = singleSensor;
          print(
              'Data count berhasil diperbarui: ${singleSensor.data.toJson()}');
          _sensorStreamController.add(singleSensor);
        } else {
          print('Invalid response data type: ${responseData.runtimeType}');
        }
      } else {
        throw Exception(
          'Gagal mengambil data. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching count data: $e');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    _sensorStreamController.close();
    super.onClose();
  }

  // Tambahkan metode untuk memaksa pembaruan
  void forceUpdate() {
    countsStatus();
  }
}
