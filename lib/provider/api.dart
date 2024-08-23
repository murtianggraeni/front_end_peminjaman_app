// api.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

  Future<http.Response> peminjaman(Map<String, dynamic> data, machine) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");
    try {
      final response =
          await http.post(Uri.parse('$URL_API/user/$machine/peminjaman'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $getToken',
              },
              body: jsonEncode(data));
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<http.Response> countData() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");
    try {
      Uri url = Uri.parse('$URL_API/user/counts');
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
      print('Error during fetchData: $e');
      throw e;
    }
  }

  Future<http.Response> PeminjamanUserAllforAdmin(type) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");
    try {
      Uri url = Uri.parse('$URL_API/admin/${type}');
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
      print('Error during fetchData: $e');
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
}
