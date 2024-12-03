import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:build_app/provider/api.dart';
import 'package:build_app/controller/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutController extends GetxController {
  final ApiController apiController = ApiController();
  final UserController userController = Get.find<UserController>();

  void logWithTimestamp(String message) {
    final now = DateTime.now();
    final formattedTime = '${now.day.toString().padLeft(2, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.year} ${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    print('[$formattedTime] : $message');
  }

  Future<bool> logout() async {
    try {
      final String userEmail = userController.email.value;
      logWithTimestamp('Email for logout: $userEmail');

      if (userEmail.isEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        userController.email.value = prefs.getString('email') ?? '';
        throw 'Email not available for logout';
      }

      final response = await apiController.logout(userEmail);

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final responseBody = json.decode(response.body);
        if (responseBody['success'] == true) {
          await userController.logout();
          Get.snackbar(
            'Success',
            responseBody['message'] ?? 'Logged out successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          return true; // Pengembalian berhasil
        }
      } else if (response.statusCode == 400) {
        logWithTimestamp("Logout failed: Bad request (status code 400)");
        Get.snackbar(
          'Logout Failed',
          'Bad request. Please check your data.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false; // Pengembalian jika status code 400
      } else {
        logWithTimestamp("Logout failed: Unexpected response");
        throw Exception('Logout failed due to unexpected response');
      }
    } catch (e) {
      logWithTimestamp('Error during logout: $e');
      Get.snackbar(
        'Failed',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false; // Pengembalian pada kondisi catch (error)
    }
    return false; // Tambahkan pengembalian default jika semua kondisi gagal
  }
}


// class LogoutController extends GetxController {
//   final ApiController apiController = ApiController();
//   final UserController userController = Get.find<UserController>();

//   Future<bool> logout() async {
//     try {
//       print('Attempting to logout');
//       final response = await apiController.logout();
//       print('Logout API response status: ${response.statusCode}');
//       print('Logout API response body: ${response.body}');
      
//       final responseBody = json.decode(response.body);
      
//       if (response.statusCode == 200 && responseBody['success'] == true) {
//         print('Logout successful, clearing user data');
//         await userController.logout();
//         Get.snackbar(
//           'Success', 
//           responseBody['message'] ?? 'Logged out successfully',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.green,
//           colorText: Colors.white
//         );
//         return true;
//       } else if (response.statusCode == 401 || response.statusCode == 403) {
//         print('Token invalid or expired, clearing user data anyway');
//         await userController.logout();
//         Get.snackbar(
//           'Session Expired', 
//           'Your session has expired. Please login again.',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.orange,
//           colorText: Colors.white
//         );
//         return true;
//       } else {
//         throw (responseBody['message'] ?? 'Logout failed');
//       }
//     } catch (e) {
//       print('Error during logout: $e');
//       Get.snackbar(
//         'Failed', 
//         e.toString(),
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white
//       );
//       return false;
//     }
//   }
// }