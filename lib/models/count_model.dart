// To parse this JSON data, do
//
//     final counts = countsFromJson(jsonString);

// import 'dart:convert';

// Counts countsFromJson(String str) => Counts.fromJson(json.decode(str));

// String countsToJson(Counts data) => json.encode(data.toJson());

// class Counts {
//     bool success;
//     String message;
//     Data data;

//     Counts({
//         required this.success,
//         required this.message,
//         required this.data,
//     });

//     factory Counts.fromJson(Map<String, dynamic> json) => Counts(
//         success: json["success"],
//         message: json["message"],
//         data: Data.fromJson(json["data"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "success": success,
//         "message": message,
//         "data": data.toJson(),
//     };
// }

// class Data {
//     String id;
//     int v;
//     int disetujuiCnc;
//     int ditolakCnc;
//     int menungguCnc;
//     int disetujuiLaser;
//     int ditolakLaser;
//     int menungguLaser;
//     int disetujuiPrinting;
//     int ditolakPrinting;
//     int menungguPrinting;

//     Data({
//         required this.id,
//         required this.v,
//         required this.disetujuiCnc,
//         required this.ditolakCnc,
//         required this.menungguCnc,
//         required this.disetujuiLaser,
//         required this.ditolakLaser,
//         required this.menungguLaser,
//         required this.disetujuiPrinting,
//         required this.ditolakPrinting,
//         required this.menungguPrinting,
//     });

//     factory Data.fromJson(Map<String, dynamic> json) => Data(
//         id: json["_id"],
//         v: json["__v"],
//         disetujuiCnc: json["disetujui_cnc"],
//         ditolakCnc: json["ditolak_cnc"],
//         menungguCnc: json["menunggu_cnc"],
//         disetujuiLaser: json["disetujui_laser"],
//         ditolakLaser: json["ditolak_laser"],
//         menungguLaser: json["menunggu_laser"],
//         disetujuiPrinting: json["disetujui_printing"],
//         ditolakPrinting: json["ditolak_printing"],
//         menungguPrinting: json["menunggu_printing"],
//     );

//     Map<String, dynamic> toJson() => {
//         "_id": id,
//         "__v": v,
//         "disetujui_cnc": disetujuiCnc,
//         "ditolak_cnc": ditolakCnc,
//         "menunggu_cnc": menungguCnc,
//         "disetujui_laser": disetujuiLaser,
//         "ditolak_laser": ditolakLaser,
//         "menunggu_laser": menungguLaser,
//         "disetujui_printing": disetujuiPrinting,
//         "ditolak_printing": ditolakPrinting,
//         "menunggu_printing": menungguPrinting,
//     };
// }

import 'dart:convert';

Counts countsFromJson(String str) => Counts.fromJson(json.decode(str));

String countsToJson(Counts data) => json.encode(data.toJson());

class Counts {
  bool success;
  String message;
  Data data;

  Counts({
    required this.success,
    required this.message,
    required this.data,
  });

  factory Counts.fromJson(Map<String, dynamic> json) => Counts(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: Data.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String id;
  int v;
  int disetujuiCnc;
  int ditolakCnc;
  int menungguCnc;
  int disetujuiLaser;
  int ditolakLaser;
  int menungguLaser;
  int disetujuiPrinting;
  int ditolakPrinting;
  int menungguPrinting;

  Data({
    required this.id,
    required this.v,
    required this.disetujuiCnc,
    required this.ditolakCnc,
    required this.menungguCnc,
    required this.disetujuiLaser,
    required this.ditolakLaser,
    required this.menungguLaser,
    required this.disetujuiPrinting,
    required this.ditolakPrinting,
    required this.menungguPrinting,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"] ?? "",
        v: json["__v"] ?? 0,
        disetujuiCnc: json["disetujui_cnc"] ?? 0,
        ditolakCnc: json["ditolak_cnc"] ?? 0,
        menungguCnc: json["menunggu_cnc"] ?? 0,
        disetujuiLaser: json["disetujui_laser"] ?? 0,
        ditolakLaser: json["ditolak_laser"] ?? 0,
        menungguLaser: json["menunggu_laser"] ?? 0,
        disetujuiPrinting: json["disetujui_printing"] ?? 0,
        ditolakPrinting: json["ditolak_printing"] ?? 0,
        menungguPrinting: json["menunggu_printing"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "__v": v,
        "disetujui_cnc": disetujuiCnc,
        "ditolak_cnc": ditolakCnc,
        "menunggu_cnc": menungguCnc,
        "disetujui_laser": disetujuiLaser,
        "ditolak_laser": ditolakLaser,
        "menunggu_laser": menungguLaser,
        "disetujui_printing": disetujuiPrinting,
        "ditolak_printing": ditolakPrinting,
        "menunggu_printing": menungguPrinting,
      };
}
