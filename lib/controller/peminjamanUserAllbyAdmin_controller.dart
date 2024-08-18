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
import '../models/getPeminjamanAllAdmin_model.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class PeminjamanUserAllbyAdminController extends GetxController {
  final ApiController apiController = ApiController();

  // Variabel dan StreamController
  RxList<Datum> peminjaman = <Datum>[].obs;
  var status = false.obs;
  var statusFilter = 'All'.obs;
  var filter = ''.obs;
  var sortAscending = true.obs;
  var selectedCheckboxes = <String>[].obs;

  final _sensorStreamController = StreamController<List<Datum>>.broadcast();
  Stream<List<Datum>> get sensorStream => _sensorStreamController.stream;

  // Filter items
  List<String> filterItem = [
    'All',
    'Menunggu',
    'Disetujui',
    'Ditolak',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchDataCnc();
    Timer.periodic(Duration(seconds: 1), (timer) {
      fetchDataCnc();
    });
  }

  Future<void> fetchDataCnc() async {
    try {
      final response = await apiController.PeminjamanUserAllforAdmin("cnc");

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> &&
            responseData['data'] is List) {
          peminjaman.assignAll(
            responseData['data']
                .map<Datum>((data) => Datum.fromJson(data))
                .toList(),
          );

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

  // Fungsi untuk menyaring data berdasarkan filter
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

  // Fungsi untuk menyortir data berdasarkan status
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
}
