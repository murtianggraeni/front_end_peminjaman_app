import 'dart:convert';

import 'package:build_app/provider/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/route_name.dart';

class RegisterController extends GetxController {
  TextEditingController usernameC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController roleC = TextEditingController();

  final ApiController apiController = ApiController();

  Future<void> registerWithEmail() async {
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
          usernameC.clear();
          emailC.clear();
          roleC.clear();
          passwordC.clear();
          Get.snackbar('Success', jsonResponse['message'],
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white);
          print("register berhasil");
          Get.offNamed(RouteName.signin_screen);
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
}
