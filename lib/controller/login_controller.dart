import 'dart:convert';

import 'package:build_app/provider/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/route_name.dart';

class LoginController extends GetxController {
  TextEditingController passwordC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  final ApiController apiController = ApiController();

  Future<void> loginWithEmail() async {
    try {
      Map<String, dynamic> body = {
        'email': emailC.text,
        'password': passwordC.text,
      };
      final response = await apiController.login(body);
      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (jsonResponse['success'] == true) {
          emailC.clear();
          passwordC.clear();
          Get.snackbar('Success', jsonResponse['message'],
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white);
          print("register berhasil");
          Get.offNamed(RouteName.custom_buttom_nav);
        } else {
          throw (jsonResponse['message'] ?? "Login gagal");
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
}
