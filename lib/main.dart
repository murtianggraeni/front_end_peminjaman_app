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

import 'package:build_app/controller/user_controller.dart';
import 'package:build_app/controller/extendPeminjaman_controller.dart';
import 'package:build_app/controller/detailPeminjaman_controller.dart';
import 'package:build_app/services/firebase_messaging_handler.dart';
import 'package:build_app/page/screens/verificationCode_page.dart';
import 'package:build_app/firebase_options.dart';
import 'package:build_app/page/screens/welcome_screen.dart';
import 'package:build_app/page/widget/custom_buttom_nav.dart';
import 'package:build_app/routes/page_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:build_app/services/notification_services.dart';
import 'package:build_app/services/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initServices() async {
  // First, initialize controllers
  Get.put(DetailPeminjamanController());
  Get.put(ExtendPeminjamanController());

  // Then, initialize notification service
  try {
    final notificationService = await NotificationService().init();
    Get.put(notificationService);
  } catch (e) {
    print('Error initializing notification service: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LoggerService.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // Initialize notification service
  // Initialize all services before running app
  await initServices();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? accessToken = prefs.getString('accessToken');
  String? role = prefs.getString('role'); // Ambil role dari SharedPreferences
  bool isVerifying = prefs.getBool('isVerifying') ?? false;
  String? verifyingEmail = prefs.getString('verifyingEmail');

  // Initialize UserController
  Get.put(UserController()); // Add this line to initialize UserController

  runApp(MyApp(
    accessToken: accessToken,
    userRole: role,
    isVerifying: isVerifying,
    verifyingEmail: verifyingEmail,
  ));
  // runApp(MyApp(accessToken: accessToken)); // UTAMA
  // Get.put(PeminjamanUserAllbyAdminController());
}

class MyApp extends StatelessWidget {
  final String? accessToken;
  final String? userRole;
  final bool isVerifying;
  final String? verifyingEmail;
  MyApp({
    this.accessToken,
    this.userRole,
    required this.isVerifying,
    this.verifyingEmail,
  });

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
      ),
      home: _decideHomePage(), // Gunakan fungsi untuk memutuskan halaman utama
      // SideMenu(),
      // monitoringPenggunaan(),
      // WelcomeScreen(),

      getPages: AppPage.pages,
    );
  }

  Widget _decideHomePage() {
    if (isVerifying) {
      // Jika dalam proses verifikasi
      return VerificationCodePage(email: verifyingEmail!);
    } else if (accessToken == null) {
      // Jika belum login
      return const WelcomeScreen();
    } else if (userRole == 'admin') {
      // Halaman admin
      return const BottomNavBar();
    } else if (userRole == 'user') {
      // Halaman user
      return const BottomNavBar();
    } else {
      // Default halaman welcome
      return const WelcomeScreen();
    }
  }

  // Widget _decideHomePage() {
  //   if (accessToken == null) {
  //     return const WelcomeScreen();
  //   } else if (userRole == 'admin') {
  //     return const BottomNavBar(); // Admin BottomNavBar
  //   } else if (userRole == 'user') {
  //     return const BottomNavBar(); // User BottomNavBar
  //   } else {
  //     return const WelcomeScreen(); // Jika role tidak dikenali, kembalikan ke welcome
  //   }
  // }
}
