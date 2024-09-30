import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:build_app/provider/api.dart';
import 'package:build_app/controller/user_controller.dart';

class LogoutController extends GetxController {
  final ApiController apiController = ApiController();
  final UserController userController = Get.find<UserController>();

  Future<bool> logout() async {
    try {
      print('Attempting to logout');
      final response = await apiController.logout();
      print('Logout API response status: ${response.statusCode}');
      print('Logout API response body: ${response.body}');
      
      final responseBody = json.decode(response.body);
      
      if (response.statusCode == 200 && responseBody['success'] == true) {
        print('Logout successful, clearing user data');
        await userController.logout();
        Get.snackbar(
          'Success', 
          responseBody['message'] ?? 'Logged out successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white
        );
        return true;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print('Token invalid or expired, clearing user data anyway');
        await userController.logout();
        Get.snackbar(
          'Session Expired', 
          'Your session has expired. Please login again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white
        );
        return true;
      } else {
        throw (responseBody['message'] ?? 'Logout failed');
      }
    } catch (e) {
      print('Error during logout: $e');
      Get.snackbar(
        'Failed', 
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
      return false;
    }
  }
}