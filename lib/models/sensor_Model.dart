// sensor_model.dart

class SensorData {
  bool button;

  SensorData({required this.button});

  Map<String, dynamic> toJson() {
    return {
      "button": button,
    };
  }
}


// To parse this JSON data, do
//
//     final sensorModel = sensorModelFromJson(jsonString);

// import 'dart:convert';

// SensorModel sensorModelFromJson(String str) => SensorModel.fromJson(json.decode(str));

// String sensorModelToJson(SensorModel data) => json.encode(data.toJson());

// class SensorModel {
//     bool success;
//     int statusCode;
//     String message;
//     Data data;

//     SensorModel({
//         required this.success,
//         required this.statusCode,
//         required this.message,
//         required this.data,
//     });

//     factory SensorModel.fromJson(Map<String, dynamic> json) => SensorModel(
//         success: json["success"],
//         statusCode: json["statusCode"],
//         message: json["message"],
//         data: Data.fromJson(json["data"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "success": success,
//         "statusCode": statusCode,
//         "message": message,
//         "data": data.toJson(),
//     };
// }

// class Data {
//     bool button;
//     String id;
//     DateTime waktu;
//     int v;

//     Data({
//         required this.button,
//         required this.id,
//         required this.waktu,
//         required this.v,
//     });

//     factory Data.fromJson(Map<String, dynamic> json) => Data(
//         button: json["button"],
//         id: json["_id"],
//         waktu: DateTime.parse(json["waktu"]),
//         v: json["__v"],
//     );

//     Map<String, dynamic> toJson() => {
//         "button": button,
//         "_id": id,
//         "waktu": waktu.toIso8601String(),
//         "__v": v,
//     };
// }
