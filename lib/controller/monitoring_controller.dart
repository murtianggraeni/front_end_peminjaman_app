import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:build_app/provider/api.dart';
import 'package:build_app/models/monitoring_model.dart';
import 'package:build_app/enums/machine_type.dart';

class MonitoringController extends GetxController {
  final ApiController apiController = ApiController();

  // Rx<MachineType> untuk memantau tipe mesin saat ini
  Rx<MachineType> currentMachineType;

  MonitoringController(MachineType initialMachineType)
      : currentMachineType = initialMachineType.obs;

  final Rx<MonitoringData> data = MonitoringData(
    totalDurationToday: '',
    totalDurationAll: '',
    userCountToday: 0,
    userCountAll: 0,
    userDetails: [],
  ).obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  void onMachineSelected(MachineType machineType) {
    currentMachineType.value = machineType;
    fetchMonitoringData();
  }

  @override
  void onInit() {
    super.onInit();
    fetchMonitoringData();
  }

  Future<void> fetchMonitoringData() async {
    try {
      isLoading.value = true;
      error.value = '';

      final http.Response response = await apiController
          .getMonitoringData(currentMachineType.value.toApiString());

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData['success'] == true && jsonData['data'] != null) {
          data.value = MonitoringData.fromJson(jsonData['data']);
        } else {
          throw Exception('Invalid data format from API');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
