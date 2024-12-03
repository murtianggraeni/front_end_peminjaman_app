import 'dart:convert';

import 'package:build_app/provider/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/route_name.dart';

// class RegisterController extends GetxController {
//   TextEditingController usernameC = TextEditingController();
//   TextEditingController passwordC = TextEditingController();
//   TextEditingController emailC = TextEditingController();
//   TextEditingController roleC = TextEditingController();

//   final ApiController apiController = ApiController();

//   Future<void> registerWithEmail() async {
//     if (usernameC.text.isEmpty ||
//         emailC.text.isEmpty ||
//         passwordC.text.isEmpty ||
//         roleC.text.isEmpty) {
//       Get.snackbar('Failed', 'All fields are required!',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//       return;
//     }

//     try {
//       Map<String, dynamic> body = {
//         'username': usernameC.text,
//         'email': emailC.text,
//         'password': passwordC.text,
//         'role': roleC.text,
//       };
//       final response = await apiController.register(body);
//       final jsonResponse = jsonDecode(response.body);
//       if (response.statusCode == 201) {
//         if (jsonResponse['success'] == true) {
//           usernameC.clear();
//           emailC.clear();
//           roleC.clear();
//           passwordC.clear();
//           Get.snackbar('Success', jsonResponse['message'],
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: Colors.green,
//               colorText: Colors.white);
//           print("register berhasil");
//           Get.offNamed(RouteName.signin_screen);
//         } else {
//           throw (jsonResponse['message'] ?? "Register gagal");
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

class RegisterController extends GetxController {
  TextEditingController usernameC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController roleC = TextEditingController();

  String userEmail = ""; // Untuk menyimpan email user sementara

  final ApiController apiController = ApiController();

  Future<void> registerWithEmail() async {
    if (usernameC.text.isEmpty ||
        emailC.text.isEmpty ||
        passwordC.text.isEmpty ||
        roleC.text.isEmpty) {
      Get.snackbar('Failed', 'All fields are required!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      Map<String, dynamic> body = {
        'username': usernameC.text,
        'email': emailC.text,
        'password': passwordC.text,
        'role': roleC.text,
      };
      final response = await apiController.register(body);
      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (jsonResponse['success'] == true) {
          userEmail = emailC.text; // Simpan email untuk verifikasi

          // Simpan status verifikasi ke SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isVerifying', true);
          await prefs.setString('verifyingEmail', userEmail);

          usernameC.clear();
          emailC.clear();
          roleC.clear();
          passwordC.clear();
          Get.snackbar('Success', jsonResponse['message'],
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white);
          // Arahkan ke halaman input kode verifikasi
          Get.toNamed(RouteName.verificationCode_page, arguments: userEmail);
        } else {
          throw (jsonResponse['message'] ?? "Register gagal");
        }
      } else {
        throw (jsonResponse['message']);
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Failed', e.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> verifyCode(String email, String code) async {
    try {
      Map<String, dynamic> body = {
        'email': email,
        'code': code,
      };
      final response = await apiController.verifyCode(body);
      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (jsonResponse['success'] == true) {
          
          // Hapus status verifikasi dari SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('isVerifying');
          await prefs.remove('verifyingEmail');

          Get.snackbar('Success', jsonResponse['message'],
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white);
          // Arahkan ke halaman Sign In
          Get.offNamed(RouteName.signin_screen);
        } else {
          throw (jsonResponse['message'] ?? "Verification failed");
        }
      } else {
        throw (jsonResponse['message']);
      }
    } catch (e) {
      Get.snackbar('Failed', e.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> resendVerificationCode(String email) async {
    try {
      Map<String, dynamic> body = {
        'email': email,
      };
      final response = await apiController.resendCode(body);
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        Get.snackbar(
          "Kode Terkirim",
          jsonResponse['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw (jsonResponse['message'] ?? "Gagal mengirim ulang kode");
      }
    } catch (e) {
      Get.snackbar(
        "Gagal",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
