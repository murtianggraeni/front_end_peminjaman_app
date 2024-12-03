// import 'package:build_app/provider/api.dart';
// import 'package:build_app/controller/detailPeminjaman_controller.dart';
// import 'package:get/get.dart';

// class ExtendPeminjamanController extends GetxController {
//   final ApiController apiController = ApiController();
//   final DetailPeminjamanController detailPeminjamanController =
//       DetailPeminjamanController();

//   var isLoading = false.obs;

//   // Fungsi untuk memperpanjang waktu peminjaman
//   Future<void> extendPeminjaman(String peminjamanId, int minutes) async {
//     try {
//       isLoading.value = true;

//       // Pastikan detail peminjaman sudah terisi
//       await detailPeminjamanController.getPeminjamanDetail(peminjamanId);

//       // Ambil existingEndTime dari detail peminjaman
//       final existingEndTime = detailPeminjamanController
//           .detailPeminjaman.value.data.akhirPeminjamanTime;

//       if (existingEndTime != null) {
//         // Hitung waktu akhir peminjaman baru
//         final newEndTime = existingEndTime.add(Duration(minutes: minutes));

//         // Panggil API untuk memperpanjang peminjaman
//         final response =
//             await ApiController().extendRentalTime(peminjamanId, newEndTime);

//         if (response.statusCode == 200) {
//           await detailPeminjamanController.getPeminjamanDetail(peminjamanId);
//           Get.snackbar('Sukses', 'Peminjaman berhasil diperpanjang');
//         } else {
//           Get.snackbar('Gagal', 'Tidak bisa memperpanjang peminjaman');
//         }
//       } else {
//         Get.snackbar('Error', 'Waktu akhir peminjaman tidak ditemukan.');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Terjadi kesalahan saat memperpanjang peminjaman');
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

// Metode 1,
// extend_peminjaman_controller.dart

import 'package:get/get.dart';
import 'package:build_app/provider/api.dart';
import 'package:build_app/controller/detailPeminjaman_controller.dart';
import 'package:build_app/models/detailPeminjaman_model.dart';

class ExtendPeminjamanController extends GetxController {
  final ApiController apiController = ApiController();
  final DetailPeminjamanController detailController = Get.find();
  
  // State Management
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

Future<bool> extendPeminjaman(
    String peminjamanId, 
    String namaMesin, 
    int minutes
  ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get peminjaman details first
      await detailController.getPeminjamanDetail(peminjamanId);
      final peminjaman = detailController.detailPeminjaman.value.data;

      // Basic validation
      if (!_validateExtension(peminjaman)) {
        return false;
      }

      // Calculate new end time
      final currentEndTime = peminjaman.akhirPeminjamanTime!;
      final newEndTime = currentEndTime.add(Duration(minutes: minutes));

      // Tentukan tipe mesin dari peminjaman
      final String type = _getMachineType(namaMesin);

      // Call API
      final response = await apiController.extendRentalTime(
        peminjamanId,
        newEndTime,
        type, // Kirim tipe mesin
      );

      if (response.statusCode == 200) {
        // Refresh peminjaman details
        await detailController.getPeminjamanDetail(peminjamanId);
        
        successMessage.value = 'Peminjaman $namaMesin berhasil diperpanjang $minutes menit';
        return true;
      } else {
        errorMessage.value = 'Gagal memperpanjang peminjaman';
        return false;
      }
    } catch (e) {
      print('Error extending peminjaman: $e');
      errorMessage.value = 'Error: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Helper untuk menentukan tipe mesin
  String _getMachineType(String namaMesin) {
    switch (namaMesin.toLowerCase()) {
      case 'cnc milling':
        return 'cnc';
      case 'laser cutting':
        return 'laser';
      case '3d printing':
        return 'printing';
      default:
        throw Exception('Invalid machine name');
    }
  }


  bool _validateExtension(Data peminjaman) {
    if (peminjaman.status != 'Disetujui') {
      errorMessage.value = 'Peminjaman harus berstatus Disetujui';
      return false;
    }

    if (!peminjaman.isStarted) {
      errorMessage.value = 'Peminjaman belum dimulai';
      return false;
    }

    final now = DateTime.now();
    final endTime = peminjaman.akhirPeminjamanTime;
    
    if (endTime == null || now.isAfter(endTime)) {
      errorMessage.value = 'Waktu peminjaman sudah berakhir';
      return false;
    }

    return true;
  }

  // Helper untuk mendapatkan waktu akhir baru
  DateTime? getNewEndTime(String peminjamanId) {
    try {
      return detailController.detailPeminjaman.value.data.akhirPeminjamanTime;
    } catch (e) {
      print('Error getting new end time: $e');
      return null;
    }
  }
}

// class ExtendPeminjamanController extends GetxController {
//   final ApiController apiController = ApiController();
//   final DetailPeminjamanController detailPeminjamanController =
//       DetailPeminjamanController();

//   var successMessage = ''.obs;
//   // Rx untuk status loading
//   var isLoading = false.obs;

//   // Fungsi untuk memperpanjang waktu peminjaman
//   Future<void> extendPeminjaman(String peminjamanId, int minutes) async {
//     try {
//       isLoading.value = true;

//       // Pastikan detail peminjaman sudah terisi
//       await detailPeminjamanController.getPeminjamanDetail(peminjamanId);

//       // Ambil existingEndTime dari detail peminjaman
//       final existingEndTime = detailPeminjamanController
//           .detailPeminjaman.value.data.akhirPeminjamanTime;

//       // Periksa apakah existingEndTime null atau tidak
//       if (existingEndTime != null) {
//         // Hitung waktu akhir peminjaman baru berdasarkan existingEndTime
//         final newEndTime = existingEndTime.add(Duration(minutes: minutes));
//         print('Memperpanjang waktu peminjaman dengan ID: $peminjamanId');
//         print('Durasi perpanjangan dalam menit: $minutes');
//         print('Waktu akhir peminjaman baru yang dihitung: $newEndTime');

//         // Panggil API untuk memperpanjang peminjaman
//         final response =
//             await ApiController().extendRentalTime(peminjamanId, newEndTime);

//         print('Status code dari API: ${response.statusCode}');
//         print('Response body dari API: ${response.body}');

//         if (response.statusCode == 200) {
//           // Perbarui data peminjaman setelah perpanjangan
//           await detailPeminjamanController.getPeminjamanDetail(peminjamanId);
//           print('Peminjaman berhasil diperpanjang');
//           Get.snackbar('Sukses', 'Peminjaman berhasil diperpanjang');
//           successMessage.value = 'Peminjaman berhasil diperpanjang $minutes menit';
//         } else {
//           print('Gagal memperpanjang peminjaman');
//           Get.snackbar('Gagal', 'Tidak bisa memperpanjang peminjaman');
//           throw Exception('Tidak bisa memperpanjang peminjaman');
//         }
//       } else {
//         print('Waktu akhir peminjaman tidak ditemukan.');
//         Get.snackbar('Error', 'Waktu akhir peminjaman tidak ditemukan.');
//         throw Exception('Waktu akhir peminjaman tidak ditemukan');
//       }
//     } catch (e) {
//       print('Error: $e');
//       Get.snackbar('Error', 'Terjadi kesalahan saat memperpanjang peminjaman');
//       throw e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
