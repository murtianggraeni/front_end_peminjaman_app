// api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ApiController {
  // static const String URL_API = "https://kh8ppwzx-3000.asse.devtunnels.ms";
  // static const String URL_API = "https://d4ts3cxh-5000.asse.devtunnels.ms";
  // static const String URL_API = "https://kh8ppwzx-5000.asse.devtunnels.ms";
  static const String URL_API = "https://kh8ppwzx-3000.asse.devtunnels.ms";

  Future<http.Response> register(Map<String, dynamic> data) async {
    try {
      final response = await http.post(Uri.parse('$URL_API/auth/register'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data));
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<http.Response> login(Map<String, dynamic> data) async {
    try {
      final response = await http.post(Uri.parse('$URL_API/auth/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data));
      return response;
    } catch (e) {
      throw e;
    }
  }

Future<http.Response> logout() async {
  final SharedPreferences shared = await SharedPreferences.getInstance();
  String? getToken = shared.getString("accessToken");
  print('Attempting to logout. Token exists: ${getToken != null}');
  
  try {
    if (getToken == null) {
      print('No token found, considering as already logged out');
      return http.Response('{"success":true,"message":"Logged out successfully"}', 200);
    }
    
    print('Sending logout request to server');
    final response = await http.post(
      Uri.parse('$URL_API/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $getToken',
      },
    );
    
    print('Logout API response status: ${response.statusCode}');
    print('Logout API response body: ${response.body}');
    
    if (response.statusCode == 200) {
      print('Successful logout, removing token from local storage');
      await shared.remove("accessToken");
    }
    return response;
  } catch (e) {
    print('Error during logout API call: $e');
    throw e;
  }
}

  // Future<http.Response> peminjaman(Map<String, dynamic> data, machine) async {
  //   final SharedPreferences shared = await SharedPreferences.getInstance();
  //   String? getToken = shared.getString("accessToken");
  //   try {
  //     final response =
  //         await http.post(Uri.parse('$URL_API/user/$machine/peminjaman'),
  //             headers: {
  //               'Content-Type': 'application/json',
  //               'Authorization': 'Bearer $getToken',
  //             },
  //             body: jsonEncode(data));
  //     return response;
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  Future<http.Response> peminjaman(Map<String, dynamic> data, String machine,
      List<int> fileBytes, String fileName) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");

    var request = http.MultipartRequest(
        'POST', Uri.parse('$URL_API/user/$machine/peminjaman'));
    request.headers.addAll({
      'Authorization': 'Bearer $getToken',
    });
    request.fields
        .addAll(data.map((key, value) => MapEntry(key, value.toString())));
    request.files.add(http.MultipartFile.fromBytes(
      'desain_benda',
      fileBytes,
      filename: fileName,
      contentType: MediaType('application', 'octet-stream'),
    ));

    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  // Future<http.Response> countData() async {
  //   final SharedPreferences shared = await SharedPreferences.getInstance();
  //   String? getToken = shared.getString("accessToken");
  //   try {
  //     Uri url = Uri.parse('$URL_API/user/counts');
  //     final response = await http.get(url, headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $getToken',
  //     });
  //     if (response.statusCode == 200) {
  //       return response;
  //     } else {
  //       throw Exception(
  //           'Failed to fetch data CountData. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error during fetchData: $e');
  //     throw e;
  //   }
  // }

  Future<http.Response> countData() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");

    try {
      Uri url = Uri.parse('$URL_API/user/counts');
      print('Requesting URL: $url'); // Log URL

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $getToken',
      });

      print('Response status code: ${response.statusCode}'); // Log status code
      print('Response body: ${response.body}'); // Log response body

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return response;
        } else {
          throw Exception('Response body kosong');
        }
      } else {
        throw Exception(
            'Gagal mengambil data CountData. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during fetchData: $e');
      throw e;
    }
  }

  Future<http.Response> PeminjamanUserAll() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");
    try {
      Uri url = Uri.parse('$URL_API/user/peminjamanAll');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $getToken',
      });
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during fetchData PeminjamanUserAll: $e');
      throw e;
    }
  }

  // Fungsi untuk memperpanjang waktu peminjaman
  Future<http.Response> extendRentalTime(
      String peminjamanId, DateTime newEndTime) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");

    try {
      Uri url = Uri.parse('$URL_API/user/peminjaman/$peminjamanId/extend');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $getToken',
      };
      final body = jsonEncode({"newEndTime": newEndTime.toIso8601String()});

      final response = await http.put(url, headers: headers, body: body);
      return response;
    } catch (e) {
      print('Error during extendRentalTime: $e');
      throw e;
    }
  }

  Future<http.Response> PeminjamanUserAllforAdmin(type) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");
    try {
      Uri url = Uri.parse('$URL_API/admin/${type}');
      print('Request URL: $url');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $getToken',
      });
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during fetchData PeminjamanUserAllforAdmin: $e');
      throw e;
    }
  }

  Future<http.Response> ButtonDisetujui(type, peminjamanId) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");
    try {
      Uri url = Uri.parse('$URL_API/admin/$type/$peminjamanId/disetujui');
      final headers = {'Authorization': 'Bearer $getToken'};
      return http.put(url, headers: headers);
    } catch (e) {
      print('Error Button Disetujui: $e');
      throw e;
    }
  }

  Future<http.Response> ButtonDitolak(
      Map<String, dynamic> data, type, peminjamanId) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");
    try {
      Uri url = Uri.parse('$URL_API/admin/$type/$peminjamanId/ditolak');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $getToken',
      };
      final body = jsonEncode(data);
      return http.put(url, headers: headers, body: body);
    } catch (e) {
      print('Error Button Disetujui: $e');
      throw e;
    }
  }

  Future<http.Response> getPeminjamanById(
      String type, String peminjamanId) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");
    try {
      Uri url = Uri.parse('$URL_API/admin/$type/$peminjamanId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $getToken',
        },
      );
      print('getPeminjamanById Response: ${response.body}'); // Untuk debugging
      return response;
    } catch (e) {
      print('Error in getPeminjamanById: $e');
      throw e;
    }
  }

  Future<http.Response> deletePeminjamanById(
      String type, String peminjamanId) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");
    try {
      Uri url = Uri.parse('$URL_API/admin/$type/$peminjamanId');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $getToken',
        },
      );
      return response; // Mengembalikan response
    } catch (e) {
      print('Error during deletePeminjamanById: $e');
      throw e; // Jika ada error, lempar errornya.
    }
  }

  Future<http.Response> getMonitoringData(String type) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");
    try {
      Uri url = Uri.parse('$URL_API/admin/$type/monitoring');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $getToken',
        },
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to fetch monitoring data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during fetchMonitoringData: $e');
      throw e;
    }
  }

  Future<http.Response> getApprovedPeminjaman() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");
    try {
      Uri url = Uri.parse('$URL_API/user/approved-peminjaman');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $getToken',
        },
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to fetch approved peminjaman data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during fetchApprovedPeminjaman: $e');
      throw e;
    }
  }
}
