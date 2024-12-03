import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:build_app/provider/api.dart';
import 'package:build_app/models/monitoring_model.dart';
import 'package:build_app/enums/machine_type.dart';

class MonitoringController extends GetxController {
  final ApiController apiController = ApiController();
  final Rx<MachineType> currentMachineType;
  Timer? _refreshTimer;

  // Polling interval - bisa disesuaikan
  static const Duration refreshInterval = Duration(seconds: 20);

  MonitoringController(MachineType initialMachineType)
      : currentMachineType = initialMachineType.obs;

  final Rx<MonitoringData> data = MonitoringData.empty().obs;
  final RxBool isLoading = true.obs;
  final RxBool isConnected = false.obs;
  final RxString error = ''.obs;
  final RxBool isRefreshing = false.obs;

  void logWithTimestamp(String message) {
    final now = DateTime.now();
    final formattedTime = '${now.day.toString().padLeft(2, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.year} ${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    print('[$formattedTime] : $message');
  }

  @override
  void onInit() {
    super.onInit();
    fetchMonitoringData();
    startAutoRefresh();
  }

  @override
  void onClose() {
    stopAutoRefresh();
    super.onClose();
  }

  void startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(refreshInterval, (timer) {
      if (!isRefreshing.value) {
        refreshData();
      }
    });
  }

  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<void> fetchMonitoringData() async {
    try {
      isLoading.value = true;
      error.value = '';

      logWithTimestamp(
          'Fetching monitoring data for: ${currentMachineType.value.toApiString()}');

      final response = await apiController
          .getMonitoringData(currentMachineType.value.toApiString());

      logWithTimestamp('Response status: ${response.statusCode}');
      logWithTimestamp('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          data.value = MonitoringData.fromJson(jsonData);
          isConnected.value = true;
          logWithTimestamp('Data loaded successfully');
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      logWithTimestamp('Error in fetchMonitoringData: $e');
      error.value = e.toString();
      isConnected.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    if (!isLoading.value && !isRefreshing.value) {
      try {
        isRefreshing.value = true;
        error.value = '';

        logWithTimestamp(
            'Refreshing data for: ${currentMachineType.value.toApiString()}');

        final response = await apiController
            .getMonitoringData(currentMachineType.value.toApiString());

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonData = json.decode(response.body);
          if (jsonData['success'] == true) {
            data.value = MonitoringData.fromJson(jsonData);
            isConnected.value = true;
            logWithTimestamp('Data refreshed successfully');
          } else {
            throw Exception('API returned success: false');
          }
        } else {
          throw Exception('Failed to refresh data: ${response.statusCode}');
        }
      } catch (e) {
        logWithTimestamp('Error in refreshData: $e');
        error.value = e.toString();
        isConnected.value = false;
      } finally {
        isRefreshing.value = false;
      }
    }
  }
}

// class MonitoringController extends GetxController {
//   final ApiController apiController = ApiController();

//   // Rx<MachineType> untuk memantau tipe mesin saat ini
//   Rx<MachineType> currentMachineType;

//   MonitoringController(MachineType initialMachineType)
//       : currentMachineType = initialMachineType.obs;

//   final Rx<MonitoringData> data = MonitoringData(
//     totalDurationToday: '',
//     totalDurationAll: '',
//     userCountToday: 0,
//     userCountAll: 0,
//     userDetails: [],
//   ).obs;
//   final RxBool isLoading = true.obs;
//   final RxString error = ''.obs;

//   void onMachineSelected(MachineType machineType) {
//     currentMachineType.value = machineType;
//     fetchMonitoringData();
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     fetchMonitoringData();
//   }

//   Future<void> fetchMonitoringData() async {
//     try {
//       isLoading.value = true;
//       error.value = '';

//       final http.Response response = await apiController
//           .getMonitoringData(currentMachineType.value.toApiString());

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> jsonData = json.decode(response.body);
//         if (jsonData['success'] == true && jsonData['data'] != null) {
//           data.value = MonitoringData.fromJson(jsonData['data']);
//         } else {
//           throw Exception('Invalid data format from API');
//         }
//       } else {
//         throw Exception('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       error.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
