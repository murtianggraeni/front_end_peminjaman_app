// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:build_app/provider/api.dart';
import 'package:get/get.dart';
import '../models/peminjamanUserAll_model.dart';

class PeminjamanUserAllController extends GetxController {
  final ApiController apiController = ApiController();
  RxList<Datum> peminjaman = <Datum>[].obs;
  List<Datum> get filteredPeminjaman => _applyFiltersAndSearch();
  var status = false.obs;

  final _sensorStreamController = StreamController<List<Datum>>.broadcast();
  Stream<List<Datum>> get sensorStream => _sensorStreamController.stream;

  // Filter State
  var selectedStatus = 'Semua'.obs;
  var selectedMachineType = 'Semua'.obs;
  var searchQuery = ''.obs;

  List<Datum> _applyFiltersAndSearch() {
    return peminjaman.where((p) {
      bool matchStatus = selectedStatus.value == 'Semua' ||
          p.status.toString().split('.').last == selectedStatus.value;
      bool matchMachine = selectedMachineType.value == 'Semua' ||
          p.namaMesin == selectedMachineType.value;
      bool matchSearch = searchQuery.isEmpty ||
          p.namaPemohon.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.namaMesin.toLowerCase().contains(searchQuery.toLowerCase());
      return matchStatus && matchMachine && matchSearch;
    }).toList();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    update(); // Memicu pembaruan UI
  }

  void setFilters({String? status, String? machineType}) {
    if (status != null) selectedStatus.value = status;
    if (machineType != null) selectedMachineType.value = machineType;
    update(); // Memicu pembaruan UI
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
    Timer.periodic(Duration(seconds: 1), (timer) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    try {
      final response = await apiController.PeminjamanUserAll();

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        print('Response Data Type: ${responseData.runtimeType}');

        if (responseData is Map<String, dynamic> &&
            responseData['data'] is List) {
          peminjaman.assignAll(
            responseData['data']
                .map<Datum>((data) => Datum.fromJson(data))
                .toList(),
          );

          // Logging untuk mengecek nilai setelah konversi
          for (var data in peminjaman) {
            print('Peminjaman ID: ${data.id}');
            print('Nama Pemohon: ${data.namaPemohon}');
            print('Nama Mesin: ${data.namaMesin}');
            print('Tanggal Peminjaman (raw): ${data.tanggalPeminjaman}');
            print('Tanggal Peminjaman (formatted): ${data.formattedTanggalPeminjaman}');
            print('Akhir Peminjaman (time): ${data.akhirPeminjamanTime}');
            print('Awal Peminjaman (raw): ${data.awalPeminjaman}');
            print('Awal Peminjaman (formatted): ${data.formattedAwalPeminjaman}');
            print('Awal Peminjaman (time): ${data.awalPeminjamanTime}');
            print('Akhir Peminjaman (raw): ${data.akhirPeminjaman}');
            print('Akhir Peminjaman (formatted): ${data.formattedAkhirPeminjaman}');
            print('Akhir Peminjaman (time): ${data.akhirPeminjamanTime}');
            print('Status: ${data.status}');
            print('Esp: ${data.alamatEsp}');
          }

          // Urutkan data berdasarkan waktu terbaru
          peminjaman.sort((a, b) => b.waktu.compareTo(a.waktu));

          // print(peminjaman.first.namaPemohon);
          _sensorStreamController.add(peminjaman.toList());
          update();
          // applyFiltersAndSearch();
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
}

  // void applyFiltersAndSearch() {
  //   filteredPeminjaman.value = peminjaman.where((p) {
  //     // bool matchStatus = selectedStatus.value == 'Semua' || p.status == selectedStatus.value;
  //     bool matchStatus = selectedStatus.value == 'Semua' ||
  //         p.status.toString().split('.').last == selectedStatus.value;
  //     print("Status: ${p.status}, Selected: ${selectedStatus.value}");
  //     bool matchMachine = selectedMachineType.value == 'Semua' ||
  //         p.namaMesin == selectedMachineType.value;
  //     bool matchSearch = searchQuery.isEmpty ||
  //         p.namaPemohon.toLowerCase().contains(searchQuery.toLowerCase()) ||
  //         p.namaMesin.toLowerCase().contains(searchQuery.toLowerCase());
  //     print(
  //         "Matching item: ${p.namaPemohon} | Status: $matchStatus | Machine: $matchMachine | Search: $matchSearch");
  //     return matchStatus && matchMachine && matchSearch;
  //   }).toList();
  //   print("Filtered results count: ${filteredPeminjaman.length}");
  //   peminjaman.assignAll(filteredPeminjaman);
  // }

  // void setSearchQuery(String query) {
  //   searchQuery.value = query;
  //   applyFiltersAndSearch();
  // }

  // void setFilters({String? status, String? machineType}) {
  //   if (status != null) selectedStatus.value = status;
  //   if (machineType != null) selectedMachineType.value = machineType;
  //   applyFiltersAndSearch();
  // }