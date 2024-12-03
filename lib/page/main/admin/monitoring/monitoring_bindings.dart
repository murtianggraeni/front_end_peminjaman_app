import 'package:get/get.dart';
import 'package:build_app/controller/peminjamanUserAllbyAdmin_controller.dart';
import 'package:build_app/controller/monitoring_controller.dart';
import 'package:build_app/enums/machine_type.dart';

class MonitoringBindings implements Bindings {
  @override
  void dependencies() {
    // Inject semua controller yang dibutuhkan dengan tag yang sesuai
    Get.lazyPut<PeminjamanUserAllbyAdminController>(
      () => PeminjamanUserAllbyAdminController(MachineType.CNC),
      tag: 'cnc',
      fenix: true,
    );

    Get.lazyPut<PeminjamanUserAllbyAdminController>(
      () => PeminjamanUserAllbyAdminController(MachineType.LaserCutting),
      tag: 'laser',
      fenix: true,
    );

    Get.lazyPut<PeminjamanUserAllbyAdminController>(
      () => PeminjamanUserAllbyAdminController(MachineType.Printing),
      tag: 'printing',
      fenix: true,
    );
    
    
  }
}