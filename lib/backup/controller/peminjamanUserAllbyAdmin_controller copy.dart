// import 'dart:async';
import 'dart:convert';

// import 'package:build_app/provider/api.dart';
// import 'package:get/get.dart';
// import '../models/getPeminjamanAllAdmin_model.dart';

// class PeminjamanUserAllbyAdminController extends GetxController {
//   final ApiController apiController = ApiController();
//   RxList<Datum> peminjaman = <Datum>[].obs;
//   var status = false.obs;

//   final _sensorStreamController = StreamController<List<Datum>>.broadcast();
//   Stream<List<Datum>> get sensorStream => _sensorStreamController.stream;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchDataCnc();
//     Timer.periodic(Duration(seconds: 1), (timer) {
//       fetchDataCnc();
//     });
//   }

//   Future<void> fetchDataCnc() async {
//     try {
//       final response = await apiController.PeminjamanUserAllforAdmin("cnc");

//       if (response.statusCode == 200) {
//         final dynamic responseData = json.decode(response.body);

//         print('Response Data Type: ${responseData.runtimeType}');

//         if (responseData is Map<String, dynamic> &&
//             responseData['data'] is List) {
//           peminjaman.assignAll(
//             responseData['data']
//                 .map<Datum>((data) => Datum.fromJson(data))
//                 .toList(),
//           );

//           print("data admin");
//           _sensorStreamController.add(peminjaman.toList());
//           update();
//           // applyFiltersAndSearch();
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
// }
import 'dart:async';
import 'package:build_app/provider/api.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/getPeminjamanAllAdmin_model.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

// Kelas controller untuk mengelola peminjaman user oleh admin
class PeminjamanUserAllbyAdminController extends GetxController {
  final ApiController apiController = ApiController();

  // Variabel observable untuk menyimpan data peminjaman
  RxList<Datum> peminjaman = <Datum>[].obs;

  // Variabel untuk mengatur status, filter, dan pengurutan
  var status = false.obs;
  var statusFilter = 'All'.obs;
  var filter = ''.obs;
  var sortAscending = true.obs;
  var selectedCheckboxes = <String>[].obs;

  // Stream controller untuk membroadcast pembaruan data peminjaman
  final _sensorStreamController = StreamController<List<Datum>>.broadcast();
  Stream<List<Datum>> get sensorStream => _sensorStreamController.stream;

  // Daftar item untuk filter status
  List<String> filterItem = [
    'All',
    'Menunggu',
    'Disetujui',
    'Ditolak',
  ];  
  
  // Metode yang dipanggil saat controller diinisialisasi
  @override
  void onInit() {
    super.onInit();
    fetchDataCnc(); // Ambil data awal
    // Set timer untuk memperbarui data setiap detik
    Timer.periodic(Duration(seconds: 1), (timer) {
      fetchDataCnc();
    });
  }

  // Methode 1 : CNC
  // Future<void> fetchDataCnc() async {
  //   try {
  //     final response = await apiController.PeminjamanUserAllforAdmin("cnc");

  //     if (response.statusCode == 200) {
  //       final dynamic responseData = json.decode(response.body);

  //       if (responseData is Map<String, dynamic> &&
  //           responseData['data'] is List) {
  //         peminjaman.assignAll(
  //           responseData['data']
  //               .map<Datum>((data) => Datum.fromJson(data))
  //               .toList(),
  //         );

  //         _sensorStreamController.add(peminjaman.toList());
  //         update();
  //       } else {
  //         print('Invalid sensor update type: ${responseData.runtimeType}');
  //       }
  //     } else {
  //       throw Exception(
  //         'Gagal mengambil data. Status code: ${response.statusCode}',
  //       );
  //     }
  //   } catch (e) {
  //     print('Error fetchData: $e');
  //   }
  // }

  // Methode 2 : CNC
  // Metode untuk mengambil data peminjaman dari API
  Future<void> fetchDataCnc() async {
    try {
      final response = await apiController.PeminjamanUserAllforAdmin("cnc");
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        if (responseData is Map<String, dynamic> &&
            responseData['data'] is List) {
              // Mengkoversi data JSON ke objek Datum
          peminjaman.assignAll(
            responseData['data']
                .map<Datum>((data) => Datum.fromJson(data))
                .toList(),
          );
          // Mengirim pembaruan melalui stream
          _sensorStreamController.add(peminjaman.toList());
          update();
        } else {
          print('Invalid sensor update type: ${responseData.runtimeType}');
        }
      } else {
        throw Exception(
          'Gagal mengambil data. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetchData: $e');
    }
  }

  // Metode untuk menampilkan detail peminjaman
  Future<void> showDetails(BuildContext context, Datum peminjaman) async {
    try {
      final response =
          await apiController.getPeminjamanById('cnc', peminjaman.id);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final detailData = Datum.fromJson(responseData['data']);
          _showDetailDialog(context, detailData);
        } else {
          // Log error response
          print('API Response Error: ${responseData['message']}');
          Get.snackbar('Error',
              'Failed to fetch peminjaman details: ${responseData['message'] ?? 'Unknown error'}');
        }
      } else {
        // Log error status code
        print('API Response Error: Status code ${response.statusCode}');
        Get.snackbar('Error',
            'Failed to fetch peminjaman details: ${response.statusCode}');
      }
    } catch (e) {
      // Log exception details
      print('Error fetching peminjaman details: $e');
      Get.snackbar('Error', 'An error occurred while fetching details');
    }
  }

  // Metode untuk menyaring data berdasarkan filter
  void filterPeminjaman() {
    final List<Datum> filtered = peminjaman.where((peminjaman) {
      bool matchesFilter = peminjaman.namaPemohon
          .toLowerCase()
          .contains(filter.value.toLowerCase());
      bool matchesStatus = statusFilter.value == 'All' ||
          (statusFilter.value == 'Sedang diverifikasi' &&
              peminjaman.status == 'Sedang diverifikasi') ||
          (statusFilter.value == 'Diterima' &&
              peminjaman.status.contains('Diterima')) ||
          (statusFilter.value == 'Ditolak' &&
              peminjaman.status.contains('Ditolak'));
      return matchesFilter && matchesStatus;
    }).toList();

    _sensorStreamController.add(filtered);
  }

  // Fungsi untuk menyortir data berdasarkan tanggal

  // Metode untuk menyortir data berdasarkan status
  void sortStatus() {
    peminjaman.sort(
      (a, b) => sortAscending.value
          ? a.status.compareTo(b.status)
          : b.status.compareTo(a.status),
    );
    sortAscending.value = !sortAscending.value;

    _sensorStreamController.add(peminjaman.toList());
  }

  // Fungsi untuk menghapus data peminjaman
  void deletePeminjaman(String namaPemohon) {
    peminjaman.removeWhere((item) => item.namaPemohon == namaPemohon);
    filterPeminjaman();
    selectedCheckboxes.remove(namaPemohon);
  }

  // Fungsi untuk checkbox pada tabel
  void onSelectedRow(bool selected, Datum peminjaman) {
    if (selected) {
      selectedCheckboxes.add(peminjaman.namaPemohon);
    } else {
      selectedCheckboxes.remove(peminjaman.namaPemohon);
    }
  }

  // Fungsi untuk mendapatkan warna berdasarkan status
  Color getStatusColor(String status) {
    if (status.contains("Disetujui")) {
      return Colors.green.withOpacity(0.2);
    } else if (status.contains("Ditolak")) {
      return Colors.red.withOpacity(0.2);
    } else {
      return Colors.orange.withOpacity(0.2);
    }
  }

  // Fungsi untuk menyetujui peminjaman
  // void approvePeminjaman(Datum peminjaman) async {
  //   String id = peminjaman.id;
  //   await apiController.ButtonDisetujui("cnc", id);
  //   peminjaman.status;
  //   selectedCheckboxes.remove(peminjaman.namaPemohon);
  //   filterPeminjaman();
  // }
  void approvePeminjaman(BuildContext context, Datum peminjaman) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.infoReverse,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2.0),
      ),
      animType: AnimType.topSlide,
      title: 'Konfirmasi',
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      desc: 'Apakah Anda yakin ingin menyetujui permohonan peminjaman ini?',
      descTextStyle: GoogleFonts.inter(
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
      ),
      showCloseIcon: true,
      dismissOnTouchOutside: false,
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        String id = peminjaman.id;
        await apiController.ButtonDisetujui("cnc", id);
        peminjaman.status;
        selectedCheckboxes.remove(peminjaman.namaPemohon);
        filterPeminjaman();
      },
    ).show();
  }

  // Fungsi untuk menolak peminjaman

  // Fungsi untuk mengemukakan alasan penolakan peminjaman
  Future<void> rejectPeminjaman(BuildContext context, Datum peminjaman) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2.0),
      ),
      title: 'Konfirmasi',
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      desc: 'Apakah Anda yakin ingin menolak permohonan peminjaman ini?',
      descTextStyle: GoogleFonts.inter(
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
      ),
      showCloseIcon: true,
      dismissOnTouchOutside: false,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        alasanRejectPeminjaman(context, peminjaman);
      },
    ).show();
  }

  // Fungsi untuk mengemukakan alasan penolakan peminjaman
  void alasanRejectPeminjaman(BuildContext context, Datum peminjaman) {
    TextEditingController alasanController = TextEditingController();

    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Alasan Peminjaman Ditolak',
                style: GoogleFonts.inter(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Material(
              color: Colors.blueGrey.withAlpha(40),
              child: TextFormField(
                controller: alasanController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Masukkan alasan penolakan",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14.0,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(
                    4.0,
                    4.0,
                    4.0,
                    4.0,
                  ),
                ),
                minLines: 2,
                maxLines: 4,
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                ),
                onPressed: () async {
                  if (alasanController.text.isNotEmpty) {
                    String id = peminjaman.id;
                    Map<String, dynamic> data = {
                      'alasan': alasanController.text,
                    };
                    await apiController.ButtonDitolak(data, "cnc", id);
                    peminjaman.status = "Ditolak";
                    print(peminjaman.status);
                    selectedCheckboxes.remove(peminjaman.namaPemohon);
                    filterPeminjaman();
                    Navigator.of(context).pop(); // Tutup dialog alasan
                    Get.snackbar("Berhasil", "Peminjaman berhasil ditolak");
                  } else {
                    Get.snackbar("Peringatan", "Alasan penolakan harus diisi!");
                  }
                },
                child: Text(
                  'Oke',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).show();
  }

  // Fungsi untuk menampilkan detail peminjaman
  void _showDetailDialog(BuildContext context, Datum detailData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Detail Peminjaman - ${detailData.namaPemohon}"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Email: ${detailData.email ?? 'Tidak tersedia'}"),
                Text(
                    "Tanggal Peminjaman: ${_formatDate(detailData.tanggalPeminjaman)}"),
                Text(
                    "Waktu Awal: ${detailData.awalPeminjaman ?? 'Tidak tersedia'}"), // Ganti waktuAwal
                Text(
                    "Waktu Akhir: ${detailData.akhirPeminjaman ?? 'Tidak tersedia'}"), // Ganti waktuAkhir
                Text(
                    "Jumlah/Satuan: ${detailData.jumlah ?? 'Tidak tersedia'}"), // Ganti jumlahSatuan
                Text(
                    "Keperluan: ${detailData.detailKeperluan ?? 'Tidak tersedia'}"), // Ganti keperluan
                Text(
                    "Desain Benda: ${detailData.desainBenda ?? 'Tidak tersedia'}"),
                Text("Status: ${detailData.status}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'Tidak tersedia';

    try {
      // Mencoba untuk mengubah String menjadi DateTime
      DateTime date = DateFormat("EEE, dd MMM yyyy").parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      // Jika tidak berhasil di-parse, kembalikan 'Tidak tersedia'
      return 'Tidak tersedia';
    }
  }
}
