// To parse this JSON data, do
//
//     final detailPeminjaman = detailPeminjamanFromJson(jsonString);

import 'dart:convert';
import 'package:intl/intl.dart';

DetailPeminjaman detailPeminjamanFromJson(String str) =>
    DetailPeminjaman.fromJson(json.decode(str));

String detailPeminjamanToJson(DetailPeminjaman data) =>
    json.encode(data.toJson());

class DetailPeminjaman {
  bool success;
  int statusCode;
  Data data;

  DetailPeminjaman({
    required this.success,
    required this.statusCode,
    required this.data,
  });

  factory DetailPeminjaman.fromJson(Map<String, dynamic> json) =>
      DetailPeminjaman(
        success: json["success"],
        statusCode: json["statusCode"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "statusCode": statusCode,
        "data": data.toJson(),
      };
}

class Data {
  String id;
  String namaMesin;
  String alamatEsp;
  String email;
  String namaPemohon;
  String tanggalPeminjaman;
  String awalPeminjaman;
  String akhirPeminjaman;
  int jumlah;
  String jurusan;
  String programStudi;
  String kategori;
  String detailKeperluan;
  String desainBenda;
  String status;
  DateTime waktu;
  bool isStarted;
  String tipePengguna;
  String nomorIdentitas;
  String? asalInstansi;

  Data({
    required this.id,
    required this.namaMesin,
    required this.alamatEsp,
    required this.email,
    required this.namaPemohon,
    required this.tanggalPeminjaman,
    required this.awalPeminjaman,
    required this.akhirPeminjaman,
    required this.jumlah,
    required this.jurusan,
    required this.programStudi,
    required this.kategori,
    required this.detailKeperluan,
    required this.desainBenda,
    required this.status,
    required this.waktu,
    required this.isStarted,
    required this.tipePengguna,
    required this.nomorIdentitas,
    this.asalInstansi,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        namaMesin: json["nama_mesin"],
        alamatEsp: json["alamat_esp"],
        email: json["email"],
        namaPemohon: json["nama_pemohon"],
        tanggalPeminjaman: json["tanggal_peminjaman"],
        awalPeminjaman: json["awal_peminjaman"],
        akhirPeminjaman: json["akhir_peminjaman"],
        jumlah: json["jumlah"],
        jurusan: json["jurusan"],
        programStudi: json["program_studi"],
        kategori: json["kategori"],
        detailKeperluan: json["detail_keperluan"],
        desainBenda: json["desain_benda"],
        status: json["status"],
        waktu: DateTime.parse(json["waktu"]),
        isStarted: json["isStarted"],
        tipePengguna: json["tipe_pengguna"],
        nomorIdentitas: json["nomor_identitas"],
        asalInstansi: json["asal_instansi"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_mesin": namaMesin,
        "alamat_esp": alamatEsp,
        "email": email,
        "nama_pemohon": namaPemohon,
        "tanggal_peminjaman": tanggalPeminjaman,
        "awal_peminjaman": awalPeminjaman,
        "akhir_peminjaman": akhirPeminjaman,
        "jumlah": jumlah,
        "jurusan": jurusan,
        "program_studi": programStudi,
        "kategori": kategori,
        "detail_keperluan": detailKeperluan,
        "desain_benda": desainBenda,
        "status": status,
        "waktu": waktu.toIso8601String(),
        "isStarted": isStarted,
        "tipePengguna": tipePengguna,
        "nomorIdentitas": nomorIdentitas,
        "asalInstansi": asalInstansi,
      };

  // Tambahkan getter untuk mendapatkan tanggal yang diformat
  String get formattedWaktu {
    return DateFormat('dd MMM yyyy').format(waktu);
  }

  // Getter untuk mem-parse tanggal peminjaman
  DateTime? get tanggalPeminjamanDate {
    try {
      // Coba beberapa format tanggal yang mungkin
      final formats = [
        "EEE, d MMM yyyy",
        "EEE, dd MMM yyyy",
        "d MMM yyyy",
        "dd MMM yyyy",
        "yyyy-MM-dd",
      ];

      for (var format in formats) {
        try {
          return DateFormat(format).parse(tanggalPeminjaman);
        } catch (_) {
          // Lanjut ke format berikutnya jika gagal
        }
      }

      // Jika semua format gagal, coba parsing manual
      final parts = tanggalPeminjaman.split(' ');
      if (parts.length >= 4) {
        final day = int.tryParse(parts[1]);
        final month = _parseMonth(parts[2]);
        final year = int.tryParse(parts[3]);
        if (day != null && month != null && year != null) {
          return DateTime(year, month, day);
        }
      }

      throw FormatException(
          "Tidak dapat mem-parse tanggal: $tanggalPeminjaman");
    } catch (e) {
      print("Error parsing tanggalPeminjaman: $e");
      return null;
    }
  }

  // Fungsi helper untuk mem-parse nama bulan
  int? _parseMonth(String month) {
    const months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12
    };
    return months[month.substring(0, 3)];
  }

  // Getter untuk mem-parse waktu awal peminjaman
  DateTime? get awalPeminjamanTime {
    try {
      final date = tanggalPeminjamanDate;
      if (date == null) {
        print('Failed to parse tanggal peminjaman');
        return null;
      }

      // Handle jika format waktu adalah ISO8601
      if (awalPeminjaman.contains('T')) {
        return DateTime.parse(awalPeminjaman);
      }

      final timeParts = awalPeminjaman.toLowerCase().split(':');
      if (timeParts.length < 2) {
        print('Invalid time format: $awalPeminjaman');
        return null;
      }

      // Parse hours and minutes
      final hourPart = timeParts[0].trim();
      final minutePart = timeParts[1].split(' ')[0].trim();

      int hours = int.parse(hourPart);
      int minutes = int.parse(minutePart);

      // Handle AM/PM
      final isAM = awalPeminjaman.toLowerCase().contains('am');
      final isPM = awalPeminjaman.toLowerCase().contains('pm');

      if (isPM && hours != 12) hours += 12;
      if (isAM && hours == 12) hours = 0;

      print('Parsed time components:');
      print('Hours: $hours');
      print('Minutes: $minutes');
      print('Date components: ${date.year}-${date.month}-${date.day}');

      return DateTime(date.year, date.month, date.day, hours, minutes);
    } catch (e) {
      print('Error parsing akhirPeminjaman: $e');
      print('Raw akhirPeminjaman value: $awalPeminjaman');
      return null;
    }
  }
  // DateTime? get awalPeminjamanTime {
  //   try {
  //     final date = tanggalPeminjamanDate;
  //     if (date == null) return null;

  //     final timeParts = awalPeminjaman.toLowerCase().split(':');
  //     if (timeParts.length < 2) return null;

  //     int hours = int.parse(timeParts[0]);
  //     int minutes = int.parse(timeParts[1].split(' ')[0]);

  //     if (awalPeminjaman.toLowerCase().contains('pm') && hours != 12) {
  //       hours += 12;
  //     } else if (awalPeminjaman.toLowerCase().contains('am') && hours == 12) {
  //       hours = 0;
  //     }

  //     return DateTime(date.year, date.month, date.day, hours, minutes);
  //   } catch (e) {
  //     print("Error parsing awalPeminjaman: $e");
  //     return null;
  //   }
  // }

  // Getter untuk mem-parse waktu akhir peminjaman
  DateTime? get akhirPeminjamanTime {
    try {
      final date = tanggalPeminjamanDate;
      if (date == null) {
        print('Failed to parse tanggal peminjaman');
        return null;
      }

      // Handle jika format waktu adalah ISO8601
      if (akhirPeminjaman.contains('T')) {
        return DateTime.parse(akhirPeminjaman);
      }

      final timeParts = akhirPeminjaman.toLowerCase().split(':');
      if (timeParts.length < 2) {
        print('Invalid time format: $akhirPeminjaman');
        return null;
      }

      // Parse hours and minutes
      final hourPart = timeParts[0].trim();
      final minutePart = timeParts[1].split(' ')[0].trim();

      int hours = int.parse(hourPart);
      int minutes = int.parse(minutePart);

      // Handle AM/PM
      final isAM = akhirPeminjaman.toLowerCase().contains('am');
      final isPM = akhirPeminjaman.toLowerCase().contains('pm');

      if (isPM && hours != 12) hours += 12;
      if (isAM && hours == 12) hours = 0;

      print('Parsed time components:');
      print('Hours: $hours');
      print('Minutes: $minutes');
      print('Date components: ${date.year}-${date.month}-${date.day}');

      return DateTime(date.year, date.month, date.day, hours, minutes);
    } catch (e) {
      print('Error parsing akhirPeminjaman: $e');
      print('Raw akhirPeminjaman value: $akhirPeminjaman');
      return null;
    }
  }
  // DateTime? get akhirPeminjamanTime {
  //   try {
  //     final date = tanggalPeminjamanDate;
  //     if (date == null) return null;

  //     final timeParts = akhirPeminjaman.toLowerCase().split(':');
  //     if (timeParts.length < 2) return null;

  //     int hours = int.parse(timeParts[0]);
  //     int minutes = int.parse(timeParts[1].split(' ')[0]);

  //     if (akhirPeminjaman.toLowerCase().contains('pm') && hours != 12) {
  //       hours += 12;
  //     } else if (akhirPeminjaman.toLowerCase().contains('am') && hours == 12) {
  //       hours = 0;
  //     }

  //     return DateTime(date.year, date.month, date.day, hours, minutes);
  //   } catch (e) {
  //     print("Error parsing akhirPeminjaman: $e");
  //     return null;
  //   }
  // }

  // Getter untuk mendapatkan tanggal peminjaman yang diformat
  String get formattedTanggalPeminjaman {
    final date = tanggalPeminjamanDate;
    return date != null
        ? DateFormat('EEE, dd MMM yyyy').format(date)
        : tanggalPeminjaman;
  }

  // Getter untuk mendapatkan awal peminjaman yang diformat
  String get formattedAwalPeminjaman {
    final time = awalPeminjamanTime;
    return time != null ? DateFormat('hh:mm a').format(time) : awalPeminjaman;
  }

  // Getter untuk mendapatkan akhir peminjaman yang diformat
  String get formattedAkhirPeminjaman {
    final time = akhirPeminjamanTime;
    return time != null ? DateFormat('hh:mm a').format(time) : akhirPeminjaman;
  }
}
