// To parse this JSON data, do
//
//     final peminjamanAllUser = peminjamanAllUserFromJson(jsonString);

import 'dart:convert';

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
  String namaMesin;
  String tanggalPeminjaman;
  Status status;
  DateTime waktu;

  Datum({
    required this.id,
    required this.namaPemohon,
    required this.namaMesin,
    required this.tanggalPeminjaman,
    required this.status,
    required this.waktu,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        namaPemohon: json["nama_pemohon"],
        namaMesin: _fixMachineName(json["nama_mesin"]), //json["nama_mesin"],
        tanggalPeminjaman: json["tanggal_peminjaman"],
        status: statusValues.map[json["status"]]!,
        waktu: DateTime.parse(json["waktu"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_pemohon": namaPemohon,
        "nama_mesin": namaMesin, //Values.reverse[namaMesin],
        "tanggal_peminjaman": tanggalPeminjaman,
        "status": statusValues.reverse[status],
      };
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

// final namaMesinValues = EnumValues({
//   "Cnc Milling": "CNC Milling",
//   "Laser Cutting": "Laser Cutting",
//   "3D Printing": "3D Printing"
// });

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
