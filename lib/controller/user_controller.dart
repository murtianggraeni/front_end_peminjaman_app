// user_controller.dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var username = ''.obs;
  static String authToken = '';

  Future<bool> checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken != null) {
      String username = prefs.getString('userName') ?? 'Anonymous';
      setUsername(username);
      return true;
    } else {
      return false;
    }
  }

  setUsername(String name) {
    username.value = name;
  }

  static Future<void> clearAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    authToken = ''; // Hapus token dari AuthHelper
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('userName');
    setUsername(''); // Clear username value
    await clearAuthToken();
  }
}
