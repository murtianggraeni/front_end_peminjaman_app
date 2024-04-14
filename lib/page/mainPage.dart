import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class mainPage extends StatefulWidget {
  const mainPage({super.key});

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF115C7C),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Hi, ",
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.white)),
                            Text(
                              "Name",
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Selamat datang kembali!",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Color(0xFFDFE7EF),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Icon(
                      Icons.notification_add,
                      color: Color(0xFF1D5973),
                    ))
              ],
            ),
          ),
        ],
      )),
    );
  }
}
