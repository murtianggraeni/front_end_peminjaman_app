// api.dart
import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:build_app/services/logger.dart';

class ApiController {
  // static const String URL_API = "https://kh8ppwzx-3000.asse.devtunnels.ms";
  // static const String URL_API = "https://d4ts3cxh-5000.asse.devtunnels.ms";
  // static const String URL_API = "https://kh8ppwzx-5000.asse.devtunnels.ms";
  // static const String URL_API = "https://kh8ppwzx-3000.asse.devtunnels.ms";
  static const String URL_API = "https://kh8ppwzx-5000.asse.devtunnels.ms";

  // Fungsi untuk menambahkan timestamp ke log
  void logWithTimestamp(String message) {
    final now = DateTime.now();
    final formattedTime = '${now.day.toString().padLeft(2, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.year} ${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    print('[$formattedTime] : $message');
  }

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

  Future<http.Response> verifyCode(Map<String, dynamic> data) async {
    try {
      final response = await http.post(Uri.parse('$URL_API/auth/verify-email'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data));
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<http.Response> resendCode(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$URL_API/auth/resend-code'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      throw e;
    }
  }

  // Future<http.Response> login(Map<String, dynamic> data) async {
  //   try {
  //     final response = await http.post(Uri.parse('$URL_API/auth/login'),
  //         headers: {
  //           'Content-Type': 'application/json',
  //         },
  //         body: jsonEncode(data));
  //     return response;
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  Future<http.Response> login(Map<String, dynamic> data) async {
    try {
      // Dapatkan FCM token
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      // Tambahkan FCM token ke data login jika tersedia
      if (fcmToken != null) {
        data['fcmToken'] = fcmToken;
      }

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

  Future<http.Response> updateFcmToken(String fcmToken) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");

    try {
      Uri url = Uri.parse('$URL_API/auth/update-fcm-token');
      logWithTimestamp('Updating FCM token');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $getToken',
        },
        body: jsonEncode({
          'fcmToken': fcmToken,
        }),
      );

      if (response.statusCode == 200) {
        logWithTimestamp('FCM token updated successfully');
      } else {
        logWithTimestamp('Failed to update FCM token: ${response.statusCode}');
      }

      return response;
    } catch (e) {
      logWithTimestamp('Error updating FCM token: $e');
      throw e;
    }
  }

  // Update fungsi logout untuk membersihkan FCM token
  Future<http.Response> logout(String email) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");

    try {
      if (getToken == null) {
        logWithTimestamp('No token found, considering as already logged out');
        return http.Response(
            '{"success":true,"message":"Already logged out"}', 200);
      }

      logWithTimestamp('Logging out user: $email');

      final response = await http.post(
        Uri.parse('$URL_API/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $getToken',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        // Hapus token dari SharedPreferences
        await shared.remove("accessToken");
        logWithTimestamp('Logout successful, tokens cleared');

        // Reset FCM token jika perlu
        try {
          await FirebaseMessaging.instance.deleteToken();
          logWithTimestamp('FCM token deleted');
        } catch (e) {
          logWithTimestamp('Error deleting FCM token: $e');
        }
      }

      return response;
    } catch (e) {
      logWithTimestamp('Logout error: $e');
      throw e;
    }
  }

  // Future<http.Response> logout(String email) async {
  //   final SharedPreferences shared = await SharedPreferences.getInstance();
  //   String? getToken = shared.getString("accessToken");
  //   logWithTimestamp('Attempting to logout. Token exists: ${getToken != null}');

  //   try {
  //     if (getToken == null) {
  //       logWithTimestamp('No token found, considering as already logged out');
  //       return http.Response(
  //           '{"success":true,"message":"Logged out successfully"}', 200);
  //     }

  //     logWithTimestamp('Sending logout request to server with email: $email');
  //     final response = await http.post(
  //       Uri.parse('$URL_API/auth/logout'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $getToken',
  //       },
  //       body: json.encode({
  //         'email': email, // Pastikan email dikirim di body dalam format JSON
  //       }),
  //     );

  //     logWithTimestamp('Logout API response status: ${response.statusCode}');
  //     logWithTimestamp('Logout API response body: ${response.body}');

  //     // Periksa apakah respons body tidak kosong sebelum mencoba mem-parsing JSON
  //     if (response.body.isNotEmpty) {
  //       final responseBody = json.decode(response.body);

  //       if (response.statusCode == 200) {
  //         logWithTimestamp(
  //             'Successful logout, removing token from local storage');
  //         await shared.remove("accessToken");
  //       }
  //       return response;
  //     } else {
  //       // Handle kasus di mana respons kosong
  //       logWithTimestamp('Empty response body');
  //       throw FormatException("Empty response body");
  //     }
  //   } catch (e) {
  //     logWithTimestamp('Error during logout API call: $e');
  //     throw e;
  //   }
  // }

  // Future<http.Response> logout() async {
  //   final SharedPreferences shared = await SharedPreferences.getInstance();
  //   String? getToken = shared.getString("accessToken");
  //   print('Attempting to logout. Token exists: ${getToken != null}');

  //   try {
  //     if (getToken == null) {
  //       print('No token found, considering as already logged out');
  //       return http.Response(
  //           '{"success":true,"message":"Logged out successfully"}', 200);
  //     }

  //     print('Sending logout request to server');
  //     final response = await http.post(
  //       Uri.parse('$URL_API/auth/logout'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $getToken',
  //       },
  //     );

  //     print('Logout API response status: ${response.statusCode}');
  //     print('Logout API response body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       print('Successful logout, removing token from local storage');
  //       await shared.remove("accessToken");
  //     }
  //     return response;
  //   } catch (e) {
  //     print('Error during logout API call: $e');
  //     throw e;
  //   }
  // }

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
      logWithTimestamp('Requesting URL: $url'); // Log URL

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $getToken',
      });

      logWithTimestamp(
          'Response status code: ${response.statusCode}'); // Log status code
      logWithTimestamp('Response body: ${response.body}'); // Log response body

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
      logWithTimestamp('Error during fetchData: $e');
      throw e;
    }
  }

  // Future<http.Response> PeminjamanUserAll() async {
  //   final SharedPreferences shared = await SharedPreferences.getInstance();
  //   String? getToken = shared.getString("accessToken");
  //   try {
  //     Uri url = Uri.parse('$URL_API/user/peminjamanAll');
  //     final response = await http.get(url, headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $getToken',
  //     });
  //     if (response.statusCode == 200) {
  //       return response;
  //     } else {
  //       throw Exception(
  //           'Failed to fetch data. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error during fetchData PeminjamanUserAll: $e');
  //     throw e;
  //   }
  // }

  Future<http.Response> PeminjamanUserAll() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");

    if (getToken == null) {
      throw Exception('No access token found');
    }

    try {
      Uri url = Uri.parse('$URL_API/user/peminjamanAll');
      logWithTimestamp('Requesting URL: $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $getToken',
        },
      ).timeout(Duration(seconds: 10)); // Add timeout

      logWithTimestamp('Response status: ${response.statusCode}');
      logWithTimestamp('Response body: ${response.body}');
      LoggerService.debug(
          'Response status peminjaman semuanya: ${response.statusCode}');
      LoggerService.debug(
          'Response body peminjaman semuanya:: ${response.body}');

      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint tidak ditemukan atau data kosong');
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } on TimeoutException catch (_) {
      throw TimeoutException('Request timeout');
    } on SocketException catch (_) {
      throw Exception('No internet connection');
    } catch (e) {
      logWithTimestamp('Error during fetchData PeminjamanUserAll: $e');
      throw e;
    }
  }

  // Fungsi untuk memperpanjang waktu peminjaman
  // Future<http.Response> extendRentalTime(
  //     String peminjamanId, DateTime newEndTime) async {
  //   final SharedPreferences shared = await SharedPreferences.getInstance();
  //   String? getToken = shared.getString("accessToken");

  //   try {
  //     Uri url = Uri.parse('$URL_API/user/peminjaman/$peminjamanId/extend');
  //     final headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $getToken',
  //     };
  //     final body = jsonEncode({"newEndTime": newEndTime.toIso8601String()});

  //     final response = await http.put(url, headers: headers, body: body);
  //     return response;
  //   } catch (e) {
  //     print('Error during extendRentalTime: $e');
  //     throw e;
  //   }
  // }

  // Fungsi untuk memperpanjang waktu peminjaman
  Future<http.Response> extendRentalTime(
      String peminjamanId, DateTime newEndTime, String type) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");

    if (getToken == null) {
      throw Exception('No access token found');
    }

    try {
      Uri url = Uri.parse('$URL_API/user/peminjaman/$peminjamanId/extend');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $getToken',
      };

      // Format date to ISO8601 without milliseconds
      final formattedDate = newEndTime.toIso8601String().split('.')[0];

      final body = jsonEncode({"newEndTime": formattedDate, "type": type});

      logWithTimestamp('Extending peminjaman $peminjamanId');
      logWithTimestamp('New end time: $formattedDate');
      logWithTimestamp('Request URL: $url');
      logWithTimestamp('Request Headers: $headers');
      logWithTimestamp('Request Body: $body');
      LoggerService.debug('Extending peminjaman $peminjamanId');
      LoggerService.debug('New end time: $formattedDate');
      LoggerService.debug('Request URL: $url');
      LoggerService.debug('Request Headers: $headers');
      LoggerService.debug('Request Body: $body');

      final response = await http
          .put(
            url,
            headers: headers,
            body: body,
          )
          .timeout(Duration(seconds: 10));

      logWithTimestamp('Response Status: ${response.statusCode}');
      logWithTimestamp('Response Body: ${response.body}');
      LoggerService.debug(
          'Response status perpanjangan peminjaman: ${response.statusCode}');
      LoggerService.debug(
          'Response body perpanjangan peminjaman: ${response.body}');

      return response;
    } catch (e) {
      logWithTimestamp('Error in extendRentalTime: $e');
      throw e;
    }
  }
  // Future<http.Response> extendRentalTime(
  //     String peminjamanId, DateTime newEndTime) async {
  //   final SharedPreferences shared = await SharedPreferences.getInstance();
  //   String? getToken = shared.getString("accessToken");

  //   try {
  //     Uri url = Uri.parse('$URL_API/user/peminjaman/$peminjamanId/extend');
  //     final headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $getToken',
  //     };
  //     final body = jsonEncode(
  //         {"newEndTime": newEndTime.toIso8601String().split('.')[0]});

  //     final response = await http.put(url, headers: headers, body: body);
  //     return response;
  //   } catch (e) {
  //     logWithTimestamp('Error during extendRentalTime: $e');
  //     throw e;
  //   }
  // }

  // Future<http.Response> PeminjamanUserAllforAdmin(type) async {
  //   final SharedPreferences shared = await SharedPreferences.getInstance();
  //   String? getToken = shared.getString("accessToken");
  //   try {
  //     Uri url = Uri.parse('$URL_API/admin/${type}');
  //     print('Request URL: $url');
  //     final response = await http.get(url, headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $getToken',
  //     });
  //     if (response.statusCode == 200) {
  //       return response;
  //     } else {
  //       throw Exception(
  //           'Failed to fetch data. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error during fetchData PeminjamanUserAllforAdmin: $e');
  //     throw e;
  //   }
  // }

  Future<http.Response> PeminjamanUserAllforAdmin(String type) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");

    if (getToken == null) {
      throw Exception('No access token found');
    }

    try {
      Uri url = Uri.parse('$URL_API/admin/$type');
      logWithTimestamp('Request URL: $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $getToken',
        },
      ).timeout(Duration(seconds: 30)); // Add a timeout

      logWithTimestamp('Response status code: ${response.statusCode}');
      logWithTimestamp('Response body: ${response.body}');
      LoggerService.debug(
          'Response status peminjaman untuk Admin: ${response.statusCode}');
      LoggerService.debug(
          'Response body peminjaman untuk Admin: ${response.body}');

      if (response.statusCode == 200) {
        return response;
      } else {
        throw HttpException(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      logWithTimestamp('Request timed out for PeminjamanUserAllforAdmin');
      throw TimeoutException('The request timed out');
    } on SocketException catch (e) {
      logWithTimestamp('No Internet connection for PeminjamanUserAllforAdmin: $e');
      throw SocketException('No Internet connection');
    } catch (e) {
      logWithTimestamp('Error during fetchData PeminjamanUserAllforAdmin: $e');
      throw Exception('Failed to fetch data for PeminjamanUserAllforAdmin: $e');
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
      logWithTimestamp('Error Button Disetujui: $e');
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
      logWithTimestamp('Error Button Disetujui: $e');
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
      logWithTimestamp(
          'getPeminjamanById Response: ${response.body}'); // Untuk debugging
      return response;
    } catch (e) {
      logWithTimestamp('Error in getPeminjamanById: $e');
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
      logWithTimestamp('Error during deletePeminjamanById: $e');
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
      LoggerService.debug('Response status: ${response.statusCode}');
      LoggerService.debug('Response body: ${response.body}');
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to fetch monitoring data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      logWithTimestamp('Error during fetchMonitoringData: $e');
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
      logWithTimestamp('Error during fetchApprovedPeminjaman: $e');
      throw e;
    }
  }

  // Tambahkan fungsi untuk memulai peminjaman dari sensor
  Future<http.Response> startRental(String peminjamanId, String type) async {
    try {
      final response = await http.post(
        Uri.parse('$URL_API/sensor/startRental'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "peminjamanId": peminjamanId,
          "type": type,
        }),
      );
      return response;
    } catch (e) {
      logWithTimestamp('Error during startRental API call: $e');
      throw e;
    }
  }

  // Fungsi untuk mendapatkan detail peminjaman berdasarkan ID
  Future<http.Response> getPeminjamanDetail(String peminjamanId) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");

    try {
      if (getToken == null) {
        throw Exception('No access token found');
      }

      Uri url = Uri.parse('$URL_API/user/peminjaman/$peminjamanId');

      logWithTimestamp('Getting peminjaman detail:');
      logWithTimestamp('URL: $url');
      logWithTimestamp('PeminjamanID: $peminjamanId');
      logWithTimestamp(
          'Token (first 20 chars): ${getToken.substring(0, 20)}...');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $getToken',
        },
      ).timeout(Duration(seconds: 10));

      logWithTimestamp('Response status: ${response.statusCode}');
      logWithTimestamp('Response body: ${response.body}');
      LoggerService.debug('Response status: ${response.statusCode}');
      LoggerService.debug('Response body: ${response.body}');

      if (response.statusCode == 401) {
        throw Exception('Unauthorized - Please login again');
      }

      return response;
    } catch (e) {
      logWithTimestamp('Error in getPeminjamanDetail: $e');
      throw e;
    }
  }

  // Future<http.Response> getPeminjamanDetail(String peminjamanId) async {
  //   final SharedPreferences shared = await SharedPreferences.getInstance();
  //   String? getToken = shared.getString("accessToken");

  //   try {
  //     Uri url = Uri.parse('$URL_API/user/peminjaman/$peminjamanId');
  //     final headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $getToken',
  //     };

  //     final response = await http.get(url, headers: headers);
  //     return response;
  //   } catch (e) {
  //     logWithTimestamp('Error during getPeminjamanDetail: $e');
  //     throw e;
  //   }
  // }

  Future<http.Response> getLatestCurrent(String type) async {
    try {
      final uri = Uri.parse('$URL_API/sensor/$type/current');
      logWithTimestamp("Requesting URL: $uri");

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 5));

      return response;
    } on SocketException catch (e) {
      throw SocketException('Network error: ${e.message}');
    } on TimeoutException {
      throw TimeoutException('Request timed out');
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<http.Response> checkPeminjamanNotification(String peminjamanId) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");

    try {
      Uri url =
          Uri.parse('$URL_API/notifications/check-peminjaman/$peminjamanId');
      logWithTimestamp('Requesting notification check: $url');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $getToken',
        },
      );

      logWithTimestamp('Notification check response: ${response.statusCode}');
      LoggerService.debug(
          'Notification check response: ${response.statusCode}');
      LoggerService.debug('Notification check response body: ${response.body}');
      return response;
    } catch (e) {
      logWithTimestamp('Error checking notification: $e');
      throw e;
    }
  }

  Future<http.Response> getAdminNotifications(
      {int page = 1, int limit = 20}) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");

    try {
      Uri url =
          Uri.parse('$URL_API/notifications/admin?page=$page&limit=$limit');
      logWithTimestamp('Requesting admin notifications');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $getToken',
        },
      );

      if (response.statusCode == 200) {
        logWithTimestamp('Successfully retrieved admin notifications');
      } else {
        logWithTimestamp(
            'Failed to get admin notifications: ${response.statusCode}');
      }

      return response;
    } catch (e) {
      logWithTimestamp('Error getting admin notifications: $e');
      throw e;
    }
  }

  // Endpoint untuk menandai notifikasi sebagai telah dibaca
  Future<http.Response> markAdminNotificationAsRead(
      String notificationId) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");

    try {
      Uri url = Uri.parse('$URL_API/notifications/admin/$notificationId/read');
      logWithTimestamp('Marking notification as read');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $getToken',
        },
      );

      if (response.statusCode == 200) {
        logWithTimestamp('Successfully marked notification as read');
      } else {
        logWithTimestamp(
            'Failed to mark notification as read: ${response.statusCode}');
      }

      return response;
    } catch (e) {
      logWithTimestamp('Error marking notification as read: $e');
      throw e;
    }
  }

  Future<http.Response> sendStatusNotification({
    required String peminjamanId,
    required String status,
    required String namaMesin,
    String? alasan,
  }) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");

    try {
      Uri url = Uri.parse('$URL_API/notifications/status');
      logWithTimestamp('Sending status notification');

      final Map<String, dynamic> body = {
        'peminjamanId': peminjamanId,
        'status': status,
        'namaMesin': namaMesin,
        if (alasan != null) 'alasan': alasan,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $getToken',
        },
        body: jsonEncode(body),
      );

      logWithTimestamp('Status notification response: ${response.statusCode}');
      return response;
    } catch (e) {
      logWithTimestamp('Error sending status notification: $e');
      throw e;
    }
  }

  // api.dart
  Future<http.Response> getMachineStatus(String type) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? getToken = shared.getString("accessToken");

    try {
      Uri url = Uri.parse('$URL_API/status/machine-status/$type');
      logWithTimestamp('Requesting machine status for type: $type');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $getToken',
        },
      ).timeout(Duration(seconds: 10));

      logWithTimestamp('Response status: ${response.statusCode}');
      logWithTimestamp('Response body: ${response.body}');

      return response;
    } catch (e) {
      logWithTimestamp('Error fetching machine status: $e');
      throw e;
    }
  }
}
