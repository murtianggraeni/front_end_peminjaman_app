import 'package:build_app/provider/api.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';

class PeminjamanController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController tanggalC = TextEditingController();
  TextEditingController awalC = TextEditingController();
  TextEditingController akhirC = TextEditingController();
  TextEditingController jumlahC = TextEditingController();
  TextEditingController jurusanC = TextEditingController();
  TextEditingController detailKeperluanC = TextEditingController();
  TextEditingController prodiC = TextEditingController();
  TextEditingController kategoriC = TextEditingController();

  // Use RxList for reactive state
  RxList<String> pickedFileNames = <String>[].obs;
  RxString fileNames = ''.obs; // Reactive variable for file names as string

  // Fungsi untuk mereset seluruh field dan state
  void resetFormFields() {
    emailC.clear();
    namaC.clear();
    tanggalC.clear();
    awalC.clear();
    akhirC.clear();
    jumlahC.clear();
    jurusanC.clear();
    detailKeperluanC.clear();
    prodiC.clear();
    kategoriC.clear();
    fileNames.value = ''; // Clear file names
    pickedFileNames.clear(); // Clear file list
  }

  // Updated pickFile method
  Future<void> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      if (GetPlatform.isWeb) {
        pickedFileNames.value = result.files.map((file) => file.name).toList();
      } else {
        pickedFileNames.value =
            result.paths.map((path) => path!.split('/').last).toList();
      }
      // Join filenames into a single string
      fileNames.value = pickedFileNames.join(", ");
    } else {
      Get.snackbar('Cancelled', 'No file selected');
    }
  }

  final ApiController apiController = ApiController();

  //Peminjaman CNC Database
  Future<bool> peminjamanCncButton() async {
    Map<String, dynamic> body = {
      'email': emailC.text,
      'nama_pemohon': namaC.text,
      'tanggal_peminjaman': tanggalC.text,
      'awal_peminjaman': awalC.text,
      'akhir_peminjaman': akhirC.text,
      'jumlah': jumlahC.text,
      'jurusan': jurusanC.text,
      'detail_keperluan': detailKeperluanC.text,
      'program_studi': prodiC.text,
      'kategori': kategoriC.text,
      'desain_benda': fileNames.value // Use the fileNames string for display
    };

    try {
      final response = await apiController.peminjaman(body, "cnc");
      if (response.statusCode == 201) {
        Get.snackbar(
          'Sukses',
          'Peminjaman berhasil dibuat',
        );
        // Reset form after success
        resetFormFields(); // Reset the form
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Gagal membuat peminjaman',
        );
        print(response.body);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }

  //Peminjaman Laser Cutting Database
  Future<bool> peminjamanLaserButton() async {
    Map<String, dynamic> body = {
      'email': emailC.text,
      'nama_pemohon': namaC.text,
      'tanggal_peminjaman': tanggalC.text,
      'awal_peminjaman': awalC.text,
      'akhir_peminjaman': akhirC.text,
      'jumlah': jumlahC.text,
      'jurusan': jurusanC.text,
      'detail_keperluan': detailKeperluanC.text,
      'program_studi': prodiC.text,
      'kategori': kategoriC.text,
      'desain_benda': fileNames.value // Use the fileNames string for display
    };

    try {
      final response = await apiController.peminjaman(body, "laser");
      if (response.statusCode == 201) {
        Get.snackbar(
          'Sukses',
          'Peminjaman berhasil dibuat',
        );
        // Reset form after success
        resetFormFields(); // Reset the form
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Gagal membuat peminjaman',
        );
        print(response.body);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }

  //Peminjaman 3D Printing Database -integration
  Future<bool> peminjamanPrintingButton() async {
    Map<String, dynamic> body = {
      'email': emailC.text,
      'nama_pemohon': namaC.text,
      'tanggal_peminjaman': tanggalC.text,
      'awal_peminjaman': awalC.text,
      'akhir_peminjaman': akhirC.text,
      'jumlah': jumlahC.text,
      'jurusan': jurusanC.text,
      'detail_keperluan': detailKeperluanC.text,
      'program_studi': prodiC.text,
      'kategori': kategoriC.text,
      'desain_benda': fileNames.value // Use the fileNames string for display
    };

    try {
      final response = await apiController.peminjaman(body, "printing");
      if (response.statusCode == 201) {
        Get.snackbar(
          'Sukses',
          'Peminjaman berhasil dibuat',
        );
        // Reset form after success
        resetFormFields(); // Reset the form
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Gagal membuat peminjaman',
        );
        print(response.body);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }
}
