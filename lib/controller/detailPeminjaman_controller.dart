import 'dart:convert';

import 'package:build_app/models/detailPeminjaman_model.dart';
import 'package:build_app/provider/api.dart';
import 'package:get/get.dart';

class DetailPeminjamanController extends GetxController {
  final ApiController apiController = ApiController();

  // Observable untuk menyimpan status loading
  var isLoading = false.obs;

  // Observable untuk menyimpan data detail peminjaman
  var detailPeminjaman = DetailPeminjaman(
    success: false,
    statusCode: 0,
    data: Data(
      id: '',
      namaMesin: '',
      alamatEsp: '',
      email: '',
      namaPemohon: '',
      tanggalPeminjaman: '',
      awalPeminjaman: '',
      akhirPeminjaman: '',
      jumlah: 0,
      jurusan: '',
      programStudi: '',
      kategori: '',
      detailKeperluan: '',
      desainBenda: '',
      status: '',
      waktu: DateTime.now(),
      isStarted: false,
      tipePengguna: '',
      nomorIdentitas: '',
      asalInstansi: '',
    ),
  ).obs;

  // Fungsi untuk mendapatkan detail peminjaman berdasarkan ID
  Future<void> getPeminjamanDetail(String peminjamanId) async {
    try {
      isLoading.value = true;

      print('Requesting peminjaman detail for ID: $peminjamanId');
      final response = await apiController.getPeminjamanDetail(peminjamanId);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final responseData = json.decode(response.body);
          print('Response Data Type: ${responseData.runtimeType}');

          if (responseData['success'] == true) {
            final data = detailPeminjamanFromJson(response.body);
            detailPeminjaman.value = data;

            print('Detail loaded successfully:');
            print('Tanggal: ${data.data.tanggalPeminjaman}');
            print('Awal: ${data.data.awalPeminjaman}');
            print('Akhir: ${data.data.akhirPeminjaman}');
          } else {
            throw Exception(responseData['message'] ?? 'Unknown error');
          }
        } catch (e) {
          print('Error parsing response: $e');
          throw Exception('Failed to parse peminjaman details');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Peminjaman tidak ditemukan');
      } else {
        throw Exception('Failed to load peminjaman: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting peminjaman detail: $e');
      throw e;
    } finally {
      isLoading.value = false;
    }
  }
  // Future<void> getPeminjamanDetail(String peminjamanId) async {
  //   try {
  //     isLoading.value = true; // Set loading state to true
  //     final response = await apiController.getPeminjamanDetail(peminjamanId);

  //     if (response.statusCode == 200) {
  //       final data = detailPeminjamanFromJson(response.body);
  //       detailPeminjaman.value = data;

  //       // Log data tanggalPeminjaman yang diterima dari API
  //       print('Tanggal Peminjaman dari API: ${detailPeminjaman.value.data.tanggalPeminjaman}');
  //       print('Awal Peminjaman dari API: ${detailPeminjaman.value.data.awalPeminjaman}');

  //       isLoading.value = false;
  //     } else {
  //       print('Gagal mendapatkan detail peminjaman: ${response.statusCode}');
  //       isLoading.value = false; // Pastikan isLoading direset
  //     }
  //   } catch (e) {
  //     print('Error saat mengambil detail peminjaman: $e');
  //     isLoading.value = false; // Pastikan isLoading direset
  //   }
  // }

  // Tambahkan fungsi ini untuk memeriksa apakah peminjaman tersedia atau tidak
  bool isPeminjamanAvailable() {
    return detailPeminjaman.value.data.status == "Disetujui" &&
        !detailPeminjaman.value.data.isStarted;
  }
}
