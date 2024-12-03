// To parse this JSON data, do
//
// final peminjamanAllUser = peminjamanAllUserFromJson(jsonString);

// peminjamanUserAll_model.dart

import 'dart:convert';
import 'package:intl/intl.dart';

PeminjamanAllUser peminjamanAllUserFromJson(String str) =>
    PeminjamanAllUser.fromJson(json.decode(str));

String peminjamanAllUserToJson(PeminjamanAllUser data) =>
    json.encode(data.toJson());

class PeminjamanAllUser {
  bool success;
  int statusCode;
  List<Datum> data;

  PeminjamanAllUser({
    required this.success,
    required this.statusCode,
    required this.data,
  });

  factory PeminjamanAllUser.fromJson(Map<String, dynamic> json) =>
      PeminjamanAllUser(
        success: json["success"],
        statusCode: json["statusCode"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "statusCode": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String namaPemohon;
  String alamatEsp;
  String namaMesin;
  String tanggalPeminjaman;
  String awalPeminjaman;
  String akhirPeminjaman;
  // DateTime? tanggalPeminjaman;
  // DateTime? awalPeminjaman;
  // DateTime? akhirPeminjaman;
  Status status;
  DateTime waktu;
  bool isStarted;
  String tipePengguna;
  String nomorIdentitas;
  String? asalInstansi;

  Datum({
    required this.id,
    required this.namaPemohon,
    required this.alamatEsp,
    required this.namaMesin,
    required this.tanggalPeminjaman,
    required this.awalPeminjaman,
    required this.akhirPeminjaman,
    required this.status,
    required this.waktu,
    required this.isStarted,
    required this.tipePengguna,
    required this.nomorIdentitas,
    this.asalInstansi,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        namaPemohon: json["nama_pemohon"],
        alamatEsp: json["alamat_esp"] ?? "",
        namaMesin: _fixMachineName(json["nama_mesin"]),
        tanggalPeminjaman: json["tanggal_peminjaman"] ?? "",
        awalPeminjaman: json["awal_peminjaman"] ?? "",
        akhirPeminjaman: json["akhir_peminjaman"] ?? "",
        status: statusValues.map[json["status"]]!,
        waktu:
            DateTime.parse(json["waktu"]).toLocal(), // Konversi ke waktu lokal
        isStarted: json['isStarted'] ?? false,
        tipePengguna: json["tipe_pengguna"],
        nomorIdentitas: json["nomor_identitas"],
        asalInstansi: json["asal_instansi"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_pemohon": namaPemohon,
        "alamat_esp": alamatEsp,
        "nama_mesin": namaMesin,
        "tanggal_peminjaman": tanggalPeminjaman,
        "awal_peminjaman": awalPeminjaman,
        "akhir_peminjaman": akhirPeminjaman,
        "status": statusValues.reverse[status],
        "waktu": waktu,
        'isStarted': isStarted,
        "tipe_pengguna": tipePengguna,
        "nomor_identitas": nomorIdentitas,
        "asal_instansi": asalInstansi,
      };

  // Tambahkan getter untuk mendapatkan tanggal yang diformat
  String get formattedWaktu {
    return DateFormat('dd MMM yyyy').format(waktu);
  }

  // Getter Methode 2
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

  DateTime? get awalPeminjamanTime {
    try {
      final date = tanggalPeminjamanDate;
      if (date == null) return null;

      final timeParts = awalPeminjaman.toLowerCase().split(':');
      if (timeParts.length < 2) return null;

      int hours = int.parse(timeParts[0]);
      int minutes = int.parse(timeParts[1].split(' ')[0]);

      if (awalPeminjaman.toLowerCase().contains('pm') && hours != 12) {
        hours += 12;
      } else if (awalPeminjaman.toLowerCase().contains('am') && hours == 12) {
        hours = 0;
      }

      return DateTime(date.year, date.month, date.day, hours, minutes);
    } catch (e) {
      print("Error parsing awalPeminjaman: $e");
      return null;
    }
  }

  DateTime? get akhirPeminjamanTime {
    try {
      final date = tanggalPeminjamanDate;
      if (date == null) return null;

      final timeParts = akhirPeminjaman.toLowerCase().split(':');
      if (timeParts.length < 2) return null;

      int hours = int.parse(timeParts[0]);
      int minutes = int.parse(timeParts[1].split(' ')[0]);

      if (akhirPeminjaman.toLowerCase().contains('pm') && hours != 12) {
        hours += 12;
      } else if (akhirPeminjaman.toLowerCase().contains('am') && hours == 12) {
        hours = 0;
      }

      return DateTime(date.year, date.month, date.day, hours, minutes);
    } catch (e) {
      print("Error parsing akhirPeminjaman: $e");
      return null;
    }
  }

  String get formattedTanggalPeminjaman {
    final date = tanggalPeminjamanDate;
    return date != null
        ? DateFormat('EEE, dd MMM yyyy').format(date)
        : tanggalPeminjaman;
  }

  String get formattedAwalPeminjaman {
    final time = awalPeminjamanTime;
    return time != null ? DateFormat('hh:mm a').format(time) : awalPeminjaman;
  }

  String get formattedAkhirPeminjaman {
    final time = akhirPeminjamanTime;
    return time != null ? DateFormat('hh:mm a').format(time) : akhirPeminjaman;
  }
}

// Fungsi untuk memperbaiki kapitalisasi nama mesin.
String _fixMachineName(String name) {
  switch (name.toLowerCase()) {
    case 'cnc milling':
      return 'CNC Milling';
    case '3d printing':
      return '3D Printing';
    case 'laser cutting':
      return 'Laser Cutting';
    default:
      return name;
  }
}

enum Status {
  Disetujui,
  Diproses,
  Ditolak,
}

final statusValues = EnumValues({
  "Disetujui": Status.Disetujui,
  "Menunggu": Status.Diproses,
  "Ditolak": Status.Ditolak
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

//   DateTime? get tanggalPeminjamanDate {
//     try {
//       return DateFormat("EEE, dd MMM yyyy").parse(tanggalPeminjaman);
//     } catch (e) {
//       print("Error parsing tanggalPeminjaman: $e");
//       return null;
//     }
//   }

//   DateTime? get awalPeminjamanTime {
//     try {
//       final date = tanggalPeminjamanDate;
//       if (date == null) return null;

//       // Parse time using a custom format
//       final timeParts = awalPeminjaman.toLowerCase().split(':');
//       int hours = int.parse(timeParts[0]);
//       int minutes = int.parse(timeParts[1]);
//       int seconds = int.parse(timeParts[2].split(' ')[0]);

//       if (awalPeminjaman.toLowerCase().contains('pm') && hours != 12) {
//         hours += 12;
//       } else if (awalPeminjaman.toLowerCase().contains('am') && hours == 12) {
//         hours = 0;
//       }

//       return DateTime(
//         date.year,
//         date.month,
//         date.day,
//         hours,
//         minutes,
//         seconds,
//       );
//     } catch (e) {
//       print("Error parsing awalPeminjaman: $e");
//       return null;
//     }
//   }

//   DateTime? get akhirPeminjamanTime {
//     try {
//       final date = tanggalPeminjamanDate;
//       if (date == null) return null;

//       // Parse time using a custom format
//       final timeParts = akhirPeminjaman.toLowerCase().split(':');
//       int hours = int.parse(timeParts[0]);
//       int minutes = int.parse(timeParts[1]);
//       int seconds = int.parse(timeParts[2].split(' ')[0]);

//       if (akhirPeminjaman.toLowerCase().contains('pm') && hours != 12) {
//         hours += 12;
//       } else if (akhirPeminjaman.toLowerCase().contains('am') && hours == 12) {
//         hours = 0;
//       }

//       return DateTime(
//         date.year,
//         date.month,
//         date.day,
//         hours,
//         minutes,
//         seconds,
//       );
//     } catch (e) {
//       print("Error parsing akhirPeminjaman: $e");
//       return null;
//     }
//   }

//   String get formattedTanggalPeminjaman {
//     final date = tanggalPeminjamanDate;
//     return date != null
//         ? DateFormat('EEE, dd MMM yyyy').format(date)
//         : tanggalPeminjaman;
//   }

//   String get formattedAwalPeminjaman {
//     final time = awalPeminjamanTime;
//     return time != null ? DateFormat('hh:mm a').format(time) : awalPeminjaman;
//   }

//   String get formattedAkhirPeminjaman {
//     final time = akhirPeminjamanTime;
//     return time != null ? DateFormat('hh:mm a').format(time) : akhirPeminjaman;
//   }
// }

  // Getter methods -1-
  // DateTime? get tanggalPeminjamanDate {
  //   try {
  //     return DateTime.parse(tanggalPeminjaman);
  //   } catch (e) {
  //     print("Error parsing tanggalPeminjaman: $e");
  //     return null;
  //   }
  // }

  // DateTime? get awalPeminjamanTime {
  //   try {
  //     return DateTime.parse(awalPeminjaman);
  //   } catch (e) {
  //     print("Error parsing awalPeminjaman: $e");
  //     return null;
  //   }
  // }

  // DateTime? get akhirPeminjamanTime {
  //   try {
  //     return DateTime.parse(akhirPeminjaman);
  //   } catch (e) {
  //     print("Error parsing akhirPeminjaman: $e");
  //     return null;
  //   }
  // }

  // String get formattedTanggalPeminjaman {
  //   final date = tanggalPeminjamanDate;
  //   if (date != null) {
  //     return DateFormat('EEE, dd MMM yyyy').format(date);
  //   }
  //   return tanggalPeminjaman; // Return raw string if parsing fails
  // }

  // String get formattedAwalPeminjaman {
  //   final time = awalPeminjamanTime;
  //   if (time != null) {
  //     return DateFormat('hh:mm a').format(time);
  //   }
  //   return awalPeminjaman; // Return raw string if parsing fails
  // }

  // String get formattedAkhirPeminjaman {
  //   final time = akhirPeminjamanTime;
  //   if (time != null) {
  //     return DateFormat('hh:mm a').format(time);
  //   }
  //   return akhirPeminjaman; // Return raw string if parsing fails
  // }


// final namaMesinValues = EnumValues({
//   "Cnc Milling": "CNC Milling",
//   "Laser Cutting": "Laser Cutting",
//   "3D Printing": "3D Printing"
// });

// class Datum {
//   String id;
//   String namaPemohon;
//   String namaMesin;
//   String tanggalPeminjaman;
//   String? awalPeminjaman; // Tambahkan properti ini jika diperlukan
//   String? akhirPeminjaman; // Tambahkan properti ini jika diperlukan
//   Status status;
//   DateTime waktu;
//   String espAddress;

//   Datum({
//     required this.id,
//     required this.namaPemohon,
//     required this.namaMesin,
//     required this.tanggalPeminjaman,
//     this.awalPeminjaman, // Pastikan untuk menginisialisasi properti ini
//     this.akhirPeminjaman, // Pastikan untuk menginisialisasi properti ini
//     required this.status,
//     required this.waktu,
//     required this.espAddress,
//   });

//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["id"],
//         namaPemohon: json["nama_pemohon"],
//         namaMesin: _fixMachineName(json["nama_mesin"]), //json["nama_mesin"],
//         tanggalPeminjaman: json["tanggal_peminjaman"],
//         awalPeminjaman: json["awal_peminjaman"] != null
//             ? DateFormat('yyyy-MM-dd')
//                 .format(DateTime.parse(json["awal_peminjaman"]))
//             : null,
//         akhirPeminjaman: json["akhir_peminjaman"] != null
//             ? DateFormat('yyyy-MM-dd')
//                 .format(DateTime.parse(json["akhir_peminjaman"]))
//             : null,
//         status: statusValues.map[json["status"]]!,
//         waktu: DateTime.parse(json["waktu"]),
//         espAddress:
//             json["espAddress"] ?? "", // Pastikan espAddress dimasukkan di sini
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "nama_pemohon": namaPemohon,
//         "nama_mesin": namaMesin, //Values.reverse[namaMesin],
//         "tanggal_peminjaman": tanggalPeminjaman,
//         "awal_peminjaman": awalPeminjaman, // Pastikan properti ini disertakan
//         "akhir_peminjaman": akhirPeminjaman, // Pastikan properti ini disertakan
//         "status": statusValues.reverse[status],
//         "espAddress": espAddress, // Pastikan espAddress ada di sini
//       };
// }

// DateTime? get tanggalPeminjamanDate {
//   try {
//     return DateFormat("EEE, dd MMM yyyy").parse(tanggalPeminjaman);
//   } catch (e) {
//     print("Error parsing tanggalPeminjaman: $e");
//     return null;
//   }
// }

// DateTime? get awalPeminjamanTime {
//   try {
//     final date = tanggalPeminjamanDate;
//     if (date == null) return null;
//     final time = DateFormat("HH:mm").parse(awalPeminjaman);
//     return DateTime(date.year, date.month, date.day, time.hour, time.minute);
//   } catch (e) {
//     print("Error parsing awalPeminjaman: $e");
//     return null;
//   }
// }

// DateTime? get akhirPeminjamanTime {
//   try {
//     final date = tanggalPeminjamanDate;
//     if (date == null) return null;
//     final time = DateFormat("HH:mm").parse(akhirPeminjaman);
//     return DateTime(date.year, date.month, date.day, time.hour, time.minute);
//   } catch (e) {
//     print("Error parsing akhirPeminjaman: $e");
//     return null;
//   }
// }

// String get formattedTanggalPeminjaman {
//   final date = tanggalPeminjamanDate;
//   return date != null
//       ? DateFormat('EEE, dd MMM yyyy').format(date)
//       : tanggalPeminjaman;
// }

// String get formattedAwalPeminjaman {
//   final time = awalPeminjamanTime;
//   return time != null ? DateFormat('hh:mm a').format(time) : awalPeminjaman;
// }

// String get formattedAkhirPeminjaman {
//   final time = akhirPeminjamanTime;
//   return time != null ? DateFormat('hh:mm a').format(time) : akhirPeminjaman;
// }