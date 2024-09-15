// --getPeminjamanAllAdmin_model.dart Metode 2--
import 'dart:convert';

AdminPeminjamanAll adminPeminjamanAllFromJson(String str) =>
    AdminPeminjamanAll.fromJson(json.decode(str));

String adminPeminjamanAllToJson(AdminPeminjamanAll data) =>
    json.encode(data.toJson());

class AdminPeminjamanAll {
  bool success;
  int statusCode;
  List<Datum> data;

  AdminPeminjamanAll({
    required this.success,
    required this.statusCode,
    required this.data,
  });

  factory AdminPeminjamanAll.fromJson(Map<String, dynamic> json) =>
      AdminPeminjamanAll(
        success: json["success"] ?? false,
        statusCode: json["statusCode"] ?? 0,
        data: List<Datum>.from(
            (json["data"] ?? []).map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "statusCode": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String? email;
  String namaPemohon;
  String? tanggalPeminjaman;
  String? awalPeminjaman;
  String? akhirPeminjaman;
  String? jumlah; // Pastikan ini tipe yang benar
  String? programStudi;
  String? kategori;
  String? detailKeperluan;
  String? desainBenda;
  String status;
  String? waktu;

  Datum({
    required this.id,
    required this.namaPemohon,
    required this.status,
    this.email,
    this.tanggalPeminjaman,
    this.awalPeminjaman,
    this.akhirPeminjaman,
    this.jumlah,
    this.programStudi,
    this.kategori,
    this.detailKeperluan,
    this.desainBenda,
    this.waktu,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json['id'] as String? ?? '',
      namaPemohon: json['nama_pemohon'] as String? ?? 'Tidak ada nama',
      status: json['status'] as String? ?? 'Tidak diketahui',
      email: json['email'] as String? ?? 'Tidak ada email',
      tanggalPeminjaman:
          json['tanggal_peminjaman'] as String? ?? 'Tidak diatur',
      awalPeminjaman: json['awal_peminjaman'] as String? ?? 'Tidak diatur',
      akhirPeminjaman: json['akhir_peminjaman'] as String? ?? 'Tidak diatur',
      jumlah: (json['jumlah'] ?? '').toString(),
      programStudi: json['program_studi'] as String? ?? 'Tidak diatur',
      kategori: json['kategori'] as String? ?? 'Tidak diatur',
      detailKeperluan:
          json['detail_keperluan'] as String? ?? 'Tidak ada detail',
      desainBenda: json['desain_benda'] as String? ?? 'Tidak ada desain',
      waktu: json['waktu'] as String? ?? 'Tidak diatur',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nama_pemohon": namaPemohon,
      "status": status,
      "email": email,
      "tanggal_peminjaman": tanggalPeminjaman,
      "awal_peminjaman": awalPeminjaman,
      "akhir_peminjaman": akhirPeminjaman,
      "jumlah": jumlah,
      "program_studi": programStudi,
      "kategori": kategori,
      "detail_keperluan": detailKeperluan,
      "desain_benda": desainBenda,
      "waktu": waktu,
    };
  }

  Datum copyWith({
    String? id,
    String? email,
    String? namaPemohon,
    String? tanggalPeminjaman,
    String? awalPeminjaman,
    String? akhirPeminjaman,
    String? jumlah,
    String? programStudi,
    String? kategori,
    String? detailKeperluan,
    String? desainBenda,
    String? status,
    String? waktu,
  }) {
    return Datum(
      id: id ?? this.id,
      email: email ?? this.email,
      namaPemohon: namaPemohon ?? this.namaPemohon,
      tanggalPeminjaman: tanggalPeminjaman ?? this.tanggalPeminjaman,
      awalPeminjaman: awalPeminjaman ?? this.awalPeminjaman,
      akhirPeminjaman: akhirPeminjaman ?? this.akhirPeminjaman,
      jumlah: jumlah ?? this.jumlah,
      programStudi: programStudi ?? this.programStudi,
      kategori: kategori ?? this.kategori,
      detailKeperluan: detailKeperluan ?? this.detailKeperluan,
      desainBenda: desainBenda ?? this.desainBenda,
      status: status ?? this.status,
      waktu: waktu ?? this.waktu,
    );
  }
}

// To parse this JSON data, do
//
//     final adminPeminjamanAll = adminPeminjamanAllFromJson(jsonString);

// --Metode 1--
// import 'dart:convert';

// AdminPeminjamanAll adminPeminjamanAllFromJson(String str) => AdminPeminjamanAll.fromJson(json.decode(str));

// String adminPeminjamanAllToJson(AdminPeminjamanAll data) => json.encode(data.toJson());

// class AdminPeminjamanAll {
//     bool success;
//     int statusCode;
//     List<Datum> data;

//     AdminPeminjamanAll({
//         required this.success,
//         required this.statusCode,
//         required this.data,
//     });

//     factory AdminPeminjamanAll.fromJson(Map<String, dynamic> json) => AdminPeminjamanAll(
//         success: json["success"],
//         statusCode: json["statusCode"],
//         data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "success": success,
//         "statusCode": statusCode,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//     };
// }

// class Datum {
//     String id;
//     String namaPemohon;
//     String status;

//     Datum({
//         required this.id,
//         required this.namaPemohon,
//         required this.status,
//     });

//     factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["id"],
//         namaPemohon: json["nama_pemohon"],
//         status: json["status"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "nama_pemohon": namaPemohon,
//         "status": status,
//     };
// }
