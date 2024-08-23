// import 'package:build_app/controller/peminjamanUserAllbyAdmin_controller.dart';
// import 'package:build_app/page/main/admin/widget_admin/monitoring_penggunaan_cnc.dart';
// import 'package:build_app/controller/user_controller.dart';
// import 'package:build_app/page/screens/welcome_screen.dart';
// import 'package:build_app/routes/page_route.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? accessToken = prefs.getString('accessToken');

//   // runApp(MyApp(accessToken: accessToken)); // UTAMA
//   // Get.put(PeminjamanUserAllbyAdminController());
// }

// class MyApp extends StatelessWidget {
//   final String? accessToken;

//   MyApp({this.accessToken});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     print('accessToken: ${accessToken}');
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       opaqueRoute: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//         textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
//       ),
//       home: WelcomeScreen(),
//       // monitoringPenggunaan(),
//       // WelcomeScreen(),
//       // WelcomeScreen(),

//       getPages: AppPage.pages,
//     );
//   }
// }

import 'package:build_app/controller/peminjamanUserAllbyAdmin_controller.dart';
import 'package:build_app/page/main/admin/widget_admin/monitoring_penggunaan_cnc.dart';
import 'package:build_app/controller/user_controller.dart';
import 'package:build_app/page/screens/welcome_screen.dart';
import 'package:build_app/page/widget/custom_buttom_nav.dart';
import 'package:build_app/routes/page_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');
  String? role = prefs.getString('role'); // Ambil role dari SharedPreferences

  // Initialize UserController
  Get.put(UserController()); // Add this line to initialize UserController

  runApp(MyApp(accessToken: accessToken, userRole: role));
  // runApp(MyApp(accessToken: accessToken)); // UTAMA
  // Get.put(PeminjamanUserAllbyAdminController());
}

class MyApp extends StatelessWidget {
  final String? accessToken;
  final String? userRole;
  MyApp({this.accessToken, this.userRole});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print('accessToken: ${accessToken}');
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      opaqueRoute: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      home: _decideHomePage(), // Gunakan fungsi untuk memutuskan halaman utama
      // monitoringPenggunaan(),
      // WelcomeScreen(),
      // WelcomeScreen(),

      getPages: AppPage.pages,
    );
  }

  Widget _decideHomePage() {
    if (accessToken == null) {
      return WelcomeScreen();
    } else if (userRole == 'admin') {
      return BottomNavBar(); // Admin BottomNavBar
    } else if (userRole == 'user') {
      return BottomNavBar(); // User BottomNavBar
    } else {
      return WelcomeScreen(); // Jika role tidak dikenali, kembalikan ke welcome
    }
  }
}
