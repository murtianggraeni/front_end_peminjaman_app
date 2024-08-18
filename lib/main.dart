import 'package:build_app/controller/peminjamanUserAllbyAdmin_controller.dart';
import 'package:build_app/page/main/admin/widget_admin/monitoring_penggunaan.dart';
import 'package:build_app/page/screens/welcome_screen.dart';
import 'package:build_app/routes/page_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');
  runApp(MyApp(accessToken: accessToken));
  // Get.put(PeminjamanUserAllbyAdminController());
}

class MyApp extends StatelessWidget {
  final String? accessToken;
  MyApp({this.accessToken});

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
      home: WelcomeScreen(),
      // monitoringPenggunaan(),
      // WelcomeScreen(),
      // WelcomeScreen(),

      getPages: AppPage.pages,
    );
  }
}
