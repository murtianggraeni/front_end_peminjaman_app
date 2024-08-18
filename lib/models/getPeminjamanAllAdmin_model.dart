// To parse this JSON data, do
//
//     final adminPeminjamanAll = adminPeminjamanAllFromJson(jsonString);

import 'dart:convert';

AdminPeminjamanAll adminPeminjamanAllFromJson(String str) => AdminPeminjamanAll.fromJson(json.decode(str));

String adminPeminjamanAllToJson(AdminPeminjamanAll data) => json.encode(data.toJson());

class AdminPeminjamanAll {
    bool success;
    int statusCode;
    List<Datum> data;

    AdminPeminjamanAll({
        required this.success,
        required this.statusCode,
        required this.data,
    });

    factory AdminPeminjamanAll.fromJson(Map<String, dynamic> json) => AdminPeminjamanAll(
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
    String status;

    Datum({
        required this.id,
        required this.namaPemohon,
        required this.status,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        namaPemohon: json["nama_pemohon"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama_pemohon": namaPemohon,
        "status": status,
    };
}
