import 'dart:convert';

import 'package:build_app/provider/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:build_app/controller/user_controller.dart';
// import 'package:http/http.dart';
// import '../models/sensor_Model.dart';
// import 'user_controller.dart';
// import '../routes/route_name.dart';
// import 'package:build_app/controller/user_controller.dart';

// -- Metode 1 --
// class LoginController extends GetxController {
//   TextEditingController passwordC = TextEditingController();
//   TextEditingController emailC = TextEditingController();

//   final ApiController apiController = ApiController();
//   // final UserController userController = Get.put(UserController());

//   Future<void> loginWithEmail() async {
//     try {
//       Map<String, dynamic> body = {
//         'email': emailC.text,
//         'password': passwordC.text,
//       };
//       final response = await apiController.login(body);
//       final jsonResponse = jsonDecode(response.body);
//       if (response.statusCode == 201) {
//         if (jsonResponse['success'] == true) {
//           // User loggedInUser = User.fromJson(jsonResponse['data']);
//           // userController.setUser(loggedInUser);
//           final userData = jsonResponse['data'];
//           final accessToken = userData['accessToken'];
//           final userName = userData['userName'];
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           await prefs.setString('accessToken', accessToken);
//           await prefs.setString('userName', userName);
//           print('usename: ${userName}');
//           print('token: ${accessToken}');
//           emailC.clear();
//           passwordC.clear();
//           Get.snackbar('Success', jsonResponse['message'],
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: Colors.green,
//               colorText: Colors.white);
//           print("register berhasil");
//           Get.offAllNamed(RouteName.custom_buttom_nav);
//         } else {
//           throw (jsonResponse['message'] ?? "Login gagal");
//         }
//       } else {
//         throw (jsonResponse['message']);
//       }
//     } catch (e) {
//       Get.back();
//       Get.snackbar('Failed', e.toString(),
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//     }
//   }
// }

class LoginController extends GetxController {

  final UserController userController = Get.find<UserController>();

  TextEditingController passwordC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  final ApiController apiController = ApiController();

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

  Future<bool> loginWithEmail() async {
    try {
      Map<String, dynamic> body = {
        'email': emailC.text,
        'password': passwordC.text,
      };
      final response = await apiController.login(body);
      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 201 && jsonResponse['success'] == true) {
        final userData = jsonResponse['data'];
        final accessToken = userData['accessToken'];
        final userName = userData['userName'];
        final userEmail = emailC.text;

        // Simpan email ke userController
        userController.email.value = userEmail;

        final userRole = userData['userRole']; // Tangkap role dari respons

        // Tambahkan log untuk memeriksa nilai role
        logWithTimestamp('Role yang diterima dari backend: $userRole');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        await prefs.setString('userName', userName);
        await prefs.setString('email', userEmail);

        await prefs.setString('role', userRole); // Store role
        logWithTimestamp('username: $userName');
        logWithTimestamp('token: $accessToken');
        logWithTimestamp(
            'role: $userRole'); // Print role to check if it is received correctly

        emailC.clear();
        passwordC.clear();
        Get.snackbar('Success', jsonResponse['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        logWithTimestamp("Login berhasil");
        return true;
      } else {
        throw (jsonResponse['message'] ?? "Login gagal");
      }
    } catch (e) {
      Get.snackbar('Failed', e.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return false;
    }
  }
}
