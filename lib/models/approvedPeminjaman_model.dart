// To parse this JSON data, do
//
//     final approvedPeminjaman = approvedPeminjamanFromJson(jsonString);

import 'dart:convert';

ApprovedPeminjaman approvedPeminjamanFromJson(String str) => ApprovedPeminjaman.fromJson(json.decode(str));

String approvedPeminjamanToJson(ApprovedPeminjaman data) => json.encode(data.toJson());

class ApprovedPeminjaman {
    bool success;
    List<Datum> data;

    ApprovedPeminjaman({
        required this.success,
        required this.data,
    });

    factory ApprovedPeminjaman.fromJson(Map<String, dynamic> json) => ApprovedPeminjaman(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String id;
    String namaMesin;
    String tanggalPeminjaman;
    String awalPeminjaman;
    String akhirPeminjaman;
    String namaPemohon;

    Datum({
        required this.id,
        required this.namaMesin,
        required this.tanggalPeminjaman,
        required this.awalPeminjaman,
        required this.akhirPeminjaman,
        required this.namaPemohon,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        namaMesin: json["nama_mesin"],
        tanggalPeminjaman: json["tanggal_peminjaman"],
        awalPeminjaman: json["awal_peminjaman"],
        akhirPeminjaman: json["akhir_peminjaman"],
        namaPemohon: json["nama_pemohon"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama_mesin": namaMesin,
        "tanggal_peminjaman": tanggalPeminjaman,
        "awal_peminjaman": awalPeminjaman,
        "akhir_peminjaman": akhirPeminjaman,
        "nama_pemohon": namaPemohon,
    };
}