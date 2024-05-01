import 'package:build_app/page/main/custom_main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class monitoringPage extends StatefulWidget {
  const monitoringPage({super.key});

  @override
  State<monitoringPage> createState() => _monitoringPageState();
}

class _monitoringPageState extends State<monitoringPage> {
  @override
  Widget build(BuildContext context) {
    return customScaffoldPage(
        body: Center(
      child: Column(
        children: [
          Text("Account Page",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 30.0,
              )),
        ],
      ),
    ));
  }
}
