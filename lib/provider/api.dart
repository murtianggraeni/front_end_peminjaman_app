import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiController {
  static const String URL_API = "https://kh8ppwzx-3000.asse.devtunnels.ms";

  Future<http.Response> register(Map<String, dynamic> data) async {
    try {
      final response = await http.post(Uri.parse('$URL_API/user/register'),
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
      final response = await http.post(Uri.parse('$URL_API/user/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data));
      return response;
    } catch (e) {
      throw e;
    }
  }
}
