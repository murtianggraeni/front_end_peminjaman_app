// lib/models/machine_status_model.dart
import 'package:intl/intl.dart';

class MachineStatus {
  final String id;
  final String namaMesin;
  final bool isStarted;
  final UserPeminjaman? currentUser;

  MachineStatus({
    required this.id,
    required this.namaMesin,
    required this.isStarted,
    this.currentUser,
  });

  factory MachineStatus.fromJson(Map<String, dynamic> json) {
    // Mengambil data dan machineInfo dari response
    final data = json['data'] ?? {};
    final machineInfo = data['machineInfo'] ?? {};

    return MachineStatus(
      id: machineInfo['currentUser']?['id'] ?? '',
      namaMesin: machineInfo['type'] ?? '',
      isStarted: data['isStarted'] ?? false,
      currentUser: machineInfo['currentUser'] != null
          ? UserPeminjaman.fromJson(machineInfo['currentUser'])
          : null,
    );
  }
}

//   factory MachineStatus.fromJson(Map<String, dynamic> json) {
//     return MachineStatus(
//       id: json['id'] ?? '',
//       namaMesin: json['nama_mesin'] ?? '',
//       isStarted: json['isStarted'] ?? false,
//       currentUser: json['currentUser'] != null
//           ? UserPeminjaman.fromJson(json['currentUser'])
//           : null,
//     );
//   }
// }

class UserPeminjaman {
  final String namaPemohon;
  final String tanggalPeminjaman;
  final String awalPeminjaman;
  final String akhirPeminjaman;
  final String tipePengguna;

  UserPeminjaman({
    required this.namaPemohon,
    required this.tanggalPeminjaman,
    required this.awalPeminjaman,
    required this.akhirPeminjaman,
    required this.tipePengguna,
  });

  factory UserPeminjaman.fromJson(Map<String, dynamic> json) {
    return UserPeminjaman(
      namaPemohon: json['nama_pemohon'] ?? '',
      tanggalPeminjaman: json['tanggal_peminjaman'] ?? '',
      awalPeminjaman: json['awal_peminjaman'] ?? '',
      akhirPeminjaman: json['akhir_peminjaman'] ?? '',
      tipePengguna: json['tipe_pengguna'] ?? '',
    );
  }

  // Fungsi untuk mengonversi tanggal dengan format seperti "Minggu, 1 Des 2024"
  String convertToDateFormat(String date) {
    try {
      // Mengatur locale ke Bahasa Indonesia
      final DateFormat inputFormat =
          DateFormat('EEE, d MMM yyyy', 'id_ID'); // Format input
      final DateFormat outputFormat =
          DateFormat('EEEE, d MMMM yyyy', 'id_ID'); // Format output
      DateTime dateTime = inputFormat.parse(date); // Parsing string ke DateTime
      return outputFormat
          .format(dateTime); // Mengonversi ke format yang diinginkan
    } catch (e) {
      return date; // Jika terjadi error, kembalikan tanggal asli
    }
  }

  // Fungsi untuk mengonversi waktu ke format 24 jam
  String convertTo24HourFormat(String time) {
    try {
      final DateFormat inputFormat = DateFormat('hh:mm:ss a'); // Format 12 jam
      final DateFormat outputFormat = DateFormat('HH:mm'); // Format 24 jam
      DateTime dateTime = inputFormat.parse(time); // Parsing string ke DateTime
      return outputFormat.format(dateTime); // Mengonversi ke format 24 jam
    } catch (e) {
      return time; // Jika terjadi error, kembalikan waktu asli
    }
  }
}
