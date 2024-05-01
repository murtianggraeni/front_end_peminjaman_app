import 'package:build_app/page/main/custom_main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class accountPage extends StatefulWidget {
  const accountPage({super.key});

  @override
  State<accountPage> createState() => _accountPageState();
}

class _accountPageState extends State<accountPage> {
  @override
  Widget build(BuildContext context) {
    return customScaffoldPage(
        body: Center(
      child: Text("Account Page",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 30.0,
          )),
    ));
  }
}
