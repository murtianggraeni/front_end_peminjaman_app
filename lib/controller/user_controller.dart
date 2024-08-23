// user_controller.dart utama
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserController extends GetxController {
//   var username = ''.obs;
//   static String authToken = '';

//   Future<bool> checkLoggedIn() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? accessToken = prefs.getString('accessToken');
//     if (accessToken != null) {
//       String username = prefs.getString('userName') ?? 'Anonymous';
//       setUsername(username);
//       return true;
//     } else {
//       return false;
//     }
//   }

//   setUsername(String name) {
//     username.value = name;
//   }

//   static Future<void> clearAuthToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('accessToken');
//     authToken = ''; // Hapus token dari AuthHelper
//   }

//   Future<void> logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('accessToken');
//     await prefs.remove('userName');
//     setUsername(''); // Clear username value
//     await clearAuthToken();
//   }
// }

// user_controller.dart
import 'package:build_app/routes/route_name.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var username = ''.obs;
  var role = ''.obs;
  var accessToken = ''.obs;

  Future<void> setUserData(String name, String userRole, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
    await prefs.setString('userName', name);
    await prefs.setString('role', userRole);
    username.value = name;
    role.value = userRole;
    accessToken.value = token;
  }

  Future<bool> checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    if (token != null) {
      username.value = prefs.getString('userName') ?? '';
      role.value = prefs.getString('role') ?? '';
      accessToken.value = token;
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    username.value = '';
    role.value = '';
    accessToken.value = '';
    Get.offAllNamed(RouteName.welcome_screen);
  }
}