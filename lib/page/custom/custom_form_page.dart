import 'package:build_app/page/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

class customFormPeminjaman extends StatelessWidget {
  const customFormPeminjaman({
    super.key,
    required this.namaMesin,
    required this.body,

    /*this.showNavBar = true*/
  });

  final Widget? body;
  final String? namaMesin;
  // final bool showNavBar;

  // final MingCuteIconData iconData = MingCuteIconData(

  // // Set your desired size
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Color(0xFF757575), size: 20.0),
        centerTitle: true,
        title: Text("Form Peminjaman ${namaMesin}"),
        titleTextStyle:
            GoogleFonts.inter(fontSize: 15.5, fontWeight: FontWeight.w500),
        elevation: 0, // agar appbar header tidak meninggalkan shadow
        // leading: IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => mainPageSatu(),
        //           ));
        //     },
        //     icon: Icon(MingCute.left_line)),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Positioned(
          //   top: 200.0,
          //   left: 25.0,
          //   right: 25.0,
          //   child: Container(
          //     padding: EdgeInsets.symmetric(vertical: 88.0, horizontal: 25.0),
          //   ),
          // ),
          Container(
            color: Colors.white,
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
          //   child: Text(
          //     "Form Peminjaman ${namaMesin}",
          //     style: GoogleFonts.inter(
          //       fontSize: 15.5,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          // ),
          SafeArea(child: body!), /*if (showNavBar) customButtomNav()*/
        ],
      ),
    );
  }
}
