import 'dart:io';

import 'package:build_app/provider/api.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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

  final ApiController apiController = ApiController();

  // Use RxList for reactive state
  // RxList<String> pickedFileNames = <String>[].obs;
  // RxString fileNames = ''.obs; // Reactive variable for file names as string
  Rx<PlatformFile?> pickedFile = Rx<PlatformFile?>(null);
  RxString fileNames = ''.obs;
  Rx<File?> selectedFile = Rx<File?>(null);

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
    pickedFile.value = null;
    fileNames.value = '';
    // fileNames.value = ''; // Clear file names
    // pickedFileNames.clear(); // Clear file list
  }

  // Updated pickFile method
  // Future<void> pickFile() async {
  //   FilePickerResult? result =
  //       await FilePicker.platform.pickFiles(allowMultiple: true);

  //   if (result != null) {
  //     if (GetPlatform.isWeb) {
  //       pickedFileNames.value = result.files.map((file) => file.name).toList();
  //     } else {
  //       pickedFileNames.value =
  //           result.paths.map((path) => path!.split('/').last).toList();
  //     }
  //     // Join filenames into a single string
  //     fileNames.value = pickedFileNames.join(", ");
  //   } else {
  //     Get.snackbar('Cancelled', 'No file selected');
  //   }
  // }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'docx'],
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        // Check file size (in bytes)
        if (file.size > 2 * 1024 * 1024) {
          // 2 MB limit
          Get.snackbar('Error', 'File size exceeds 2 MB limit');
          return;
        }

        // Handle web platform
        if (kIsWeb) {
          // Use bytes property since path is not available on web
          pickedFile.value = file;
          fileNames.value = file.name;
          print(
              "Picked file (web): ${file.name}, size: ${file.bytes?.length} bytes");
        }
        // Handle mobile platforms
        else {
          if (file.path != null) {
            pickedFile.value = file;
            fileNames.value = file.name;
            print(
                "Picked file: ${file.name}, path: ${file.path}, size: ${file.size} bytes");
          } else {
            Get.snackbar('Error', 'Unable to access file path');
          }
        }
      } else {
        // User canceled the picker
        Get.snackbar('Info', 'File selection canceled');
      }
    } catch (e) {
      Get.snackbar('Error', 'File picking failed: ${e.toString()}');
    }
  }

  //Peminjaman CNC Database
  // Future<bool> peminjamanCncButton() async {
  //   Map<String, dynamic> body = {
  //     'email': emailC.text,
  //     'nama_pemohon': namaC.text,
  //     'tanggal_peminjaman': tanggalC.text,
  //     'awal_peminjaman': awalC.text,
  //     'akhir_peminjaman': akhirC.text,
  //     'jumlah': jumlahC.text,
  //     'jurusan': jurusanC.text,
  //     'detail_keperluan': detailKeperluanC.text,
  //     'program_studi': prodiC.text,
  //     'kategori': kategoriC.text,
  //     'desain_benda': fileNames.value // Use the fileNames string for display
  //   };

  //   try {
  //     final response = await apiController.peminjaman(body, "cnc");
  //     if (response.statusCode == 201) {
  //       Get.snackbar(
  //         'Sukses',
  //         'Peminjaman berhasil dibuat',
  //       );
  //       // Reset form after success
  //       resetFormFields(); // Reset the form
  //       return true;
  //     } else {
  //       Get.snackbar(
  //         'Error',
  //         'Gagal membuat peminjaman',
  //       );
  //       print(response.body);
  //       return false;
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //     return false;
  //   }
  // }

  Future<bool> peminjamanCncButton() async {
    if (pickedFile.value == null) {
      Get.snackbar('Error', 'Please select a design file');
      return false;
    }
    print(
        "Sending file: ${pickedFile.value!.name} with type: ${pickedFile.value!.extension}");

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
    };

    try {
      List<int> fileBytes;
      if (kIsWeb) {
        fileBytes = pickedFile.value!.bytes!;
      } else {
        fileBytes = await File(pickedFile.value!.path!).readAsBytes();
      }

      // Print file size and extension for debugging
      print("File size: ${fileBytes.length} bytes");
      print("File extension: ${pickedFile.value!.extension}");

      final response = await apiController.peminjaman(
          body, "cnc", fileBytes, pickedFile.value!.name);

      if (response.statusCode == 201) {
        Get.snackbar('Sukses', 'Peminjaman berhasil dibuat');
        resetFormFields();
        return true;
      } else {
        Get.snackbar('Error', 'Gagal membuat peminjaman: ${response.body}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: ${e.toString()}');
      return false;
    }
  }

  //Peminjaman Laser Cutting Database
  // Future<bool> peminjamanLaserButton() async {
  //   Map<String, dynamic> body = {
  //     'email': emailC.text,
  //     'nama_pemohon': namaC.text,
  //     'tanggal_peminjaman': tanggalC.text,
  //     'awal_peminjaman': awalC.text,
  //     'akhir_peminjaman': akhirC.text,
  //     'jumlah': jumlahC.text,
  //     'jurusan': jurusanC.text,
  //     'detail_keperluan': detailKeperluanC.text,
  //     'program_studi': prodiC.text,
  //     'kategori': kategoriC.text,
  //     'desain_benda': fileNames.value // Use the fileNames string for display
  //   };

  //   try {
  //     final response = await apiController.peminjaman(body, "laser");
  //     if (response.statusCode == 201) {
  //       Get.snackbar(
  //         'Sukses',
  //         'Peminjaman berhasil dibuat',
  //       );
  //       // Reset form after success
  //       resetFormFields(); // Reset the form
  //       return true;
  //     } else {
  //       Get.snackbar(
  //         'Error',
  //         'Gagal membuat peminjaman',
  //       );
  //       print(response.body);
  //       return false;
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //     return false;
  //   }
  // }

  Future<bool> peminjamanLaserButton() async {
    if (pickedFile.value == null) {
      Get.snackbar('Error', 'Please select a design file');
      return false;
    }

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
    };

    try {
      List<int> fileBytes;
      if (kIsWeb) {
        fileBytes = pickedFile.value!.bytes!;
      } else {
        fileBytes = await File(pickedFile.value!.path!).readAsBytes();
      }

      final response = await apiController.peminjaman(
          body, "laser", fileBytes, pickedFile.value!.name);

      if (response.statusCode == 201) {
        Get.snackbar('Sukses', 'Peminjaman berhasil dibuat');
        resetFormFields();
        return true;
      } else {
        Get.snackbar('Error', 'Gagal membuat peminjaman: ${response.body}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: ${e.toString()}');
      return false;
    }
  }

  //Peminjaman 3D Printing Database -integration
  // Future<bool> peminjamanPrintingButton() async {
  //   Map<String, dynamic> body = {
  //     'email': emailC.text,
  //     'nama_pemohon': namaC.text,
  //     'tanggal_peminjaman': tanggalC.text,
  //     'awal_peminjaman': awalC.text,
  //     'akhir_peminjaman': akhirC.text,
  //     'jumlah': jumlahC.text,
  //     'jurusan': jurusanC.text,
  //     'detail_keperluan': detailKeperluanC.text,
  //     'program_studi': prodiC.text,
  //     'kategori': kategoriC.text,
  //     'desain_benda': fileNames.value // Use the fileNames string for display
  //   };

  //   try {
  //     final response = await apiController.peminjaman(body, "printing");
  //     if (response.statusCode == 201) {
  //       Get.snackbar(
  //         'Sukses',
  //         'Peminjaman berhasil dibuat',
  //       );
  //       // Reset form after success
  //       resetFormFields(); // Reset the form
  //       return true;
  //     } else {
  //       Get.snackbar(
  //         'Error',
  //         'Gagal membuat peminjaman',
  //       );
  //       print(response.body);
  //       return false;
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //     return false;
  //   }
  // }

  Future<bool> peminjamanPrintingButton() async {
    if (pickedFile.value == null) {
      Get.snackbar('Error', 'Please select a design file');
      return false;
    }

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
    };

    try {
      List<int> fileBytes;
      if (kIsWeb) {
        fileBytes = pickedFile.value!.bytes!;
      } else {
        fileBytes = await File(pickedFile.value!.path!).readAsBytes();
      }

      final response = await apiController.peminjaman(
          body, "printing", fileBytes, pickedFile.value!.name);

      if (response.statusCode == 201) {
        Get.snackbar('Sukses', 'Peminjaman berhasil dibuat');
        resetFormFields();
        return true;
      } else {
        Get.snackbar('Error', 'Gagal membuat peminjaman: ${response.body}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: ${e.toString()}');
      return false;
    }
  }
}
