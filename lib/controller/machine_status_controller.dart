// lib/controllers/machine_status_controller.dart
import 'dart:async';

import 'package:get/get.dart';
import 'dart:convert';
import '../models/machine_status_model.dart';
import 'package:build_app/provider/api.dart';

class MachineStatusController extends GetxController {
  final ApiController _apiController = ApiController();

  final Rx<MachineStatus?> cncStatus = Rx<MachineStatus?>(null);
  final Rx<MachineStatus?> laserStatus = Rx<MachineStatus?>(null);
  final Rx<MachineStatus?> printingStatus = Rx<MachineStatus?>(null);

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  Timer? _refreshTimer;

  // @override
  // void onInit() {
  //   super.onInit();
  //   startAutoRefresh();
  // }

  // @override
  // void onClose() {
  //   stopAutoRefresh();
  //   super.onClose();
  // }

  // void startAutoRefresh() {
  //   fetchAllMachineStatus(); // Fetch pertama kali
  //   _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
  //     fetchAllMachineStatus();
  //   });
  // }

  // void stopAutoRefresh() {
  //   _refreshTimer?.cancel();
  //   _refreshTimer = null;
  // } // Tambahkan Timer

  @override
  void onInit() {
    super.onInit();
    fetchAllMachineStatus();
    // Setup periodic refresh
    // ever(isLoading, (_) {
    //   Future.delayed(
    //     const Duration(seconds: 30),
    //     () => fetchAllMachineStatus(),
    //   );
    // });
    // Setup periodic refresh dengan Timer
    _startPeriodicRefresh();
  }

  @override
  void onClose() {
    _refreshTimer?.cancel(); // Jangan lupa cancel timer
    super.onClose();
  }

  void _startPeriodicRefresh() {
    // Refresh setiap 5 detik
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      fetchAllMachineStatus();
    });
  }

  Future<void> fetchAllMachineStatus() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Fetch semua status mesin secara parallel
      final responses = await Future.wait([
        _apiController.getMachineStatus('cnc'),
        _apiController.getMachineStatus('laser'),
        _apiController.getMachineStatus('printing'),
      ]);

      // Parse responses
      // Parse responses - perhatikan perubahan di sini
      if (responses[0].statusCode == 200) {
        final data = json.decode(responses[0].body);
        cncStatus.value = MachineStatus.fromJson(data);
      }

      if (responses[1].statusCode == 200) {
        final data = json.decode(responses[1].body);
        laserStatus.value = MachineStatus.fromJson(data);
      }

      if (responses[2].statusCode == 200) {
        final data = json.decode(responses[2].body);
        printingStatus.value = MachineStatus.fromJson(data);
      }

      // if (responses[0].statusCode == 200) {
      //   final cncData = json.decode(responses[0].body)['data'];
      //   cncStatus.value = MachineStatus.fromJson(cncData);
      // }

      // if (responses[1].statusCode == 200) {
      //   final laserData = json.decode(responses[1].body)['data'];
      //   laserStatus.value = MachineStatus.fromJson(laserData);
      // }

      // if (responses[2].statusCode == 200) {
      //   final printingData = json.decode(responses[2].body)['data'];
      //   printingStatus.value = MachineStatus.fromJson(printingData);
      // }
    } catch (e) {
      error.value = 'Gagal mengambil status mesin: $e';
    } finally {
      isLoading.value = false;
    }
  }

  MachineStatus? getStatusByType(String type) {
    switch (type.toLowerCase()) {
      case 'cnc':
        return cncStatus.value;
      case 'laser':
        return laserStatus.value;
      case 'printing':
        return printingStatus.value;
      default:
        return null;
    }
  }
}
