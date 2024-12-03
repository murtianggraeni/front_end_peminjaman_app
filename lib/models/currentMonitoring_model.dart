// To parse this JSON data, do
//
//     final currentMonitoring = currentMonitoringFromJson(jsonString);

import 'dart:convert';

CurrentMonitoring currentMonitoringFromJson(String str) => CurrentMonitoring.fromJson(json.decode(str));

String currentMonitoringToJson(CurrentMonitoring data) => json.encode(data.toJson());

class CurrentMonitoring {
    bool success;
    int statusCode;
    Data data;

    CurrentMonitoring({
        required this.success,
        required this.statusCode,
        required this.data,
    });

    factory CurrentMonitoring.fromJson(Map<String, dynamic> json) => CurrentMonitoring(
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
    double current;
    DateTime waktu;

    Data({
        required this.current,
        required this.waktu,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        current: json["current"]?.toDouble() ?? 0.0,
        waktu: DateTime.parse(json["waktu"]),
    );

    Map<String, dynamic> toJson() => {
        "current": current,
        "waktu": waktu.toIso8601String(),
    };
}
