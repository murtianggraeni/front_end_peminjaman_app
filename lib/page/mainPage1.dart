import 'package:build_app/widget/custom_scaffold_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class mainPageSatu extends StatefulWidget {
  const mainPageSatu({super.key});

  @override
  State<mainPageSatu> createState() => _mainPageSatuState();
}

class _mainPageSatuState extends State<mainPageSatu> {
  @override
  Widget build(BuildContext context) {
    return customScaffoldMain(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Hi, ",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white),
                      ),
                      Text(
                        "Nama",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Selamat datang kembali!",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFFE2E2E2),
                    ),
                  )
                ],
              ),
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    color: Color(0xFFDFE7EF)),
                child: Icon(
                  Icons.notifications_active_sharp,
                  size: 24,
                  color: Color(0xFF1D5973),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 71),
        Expanded(
          flex: 6,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 19),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22.0),
                      topRight: Radius.circular(22.0))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          child: Text(
                            "CNC",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 10.5,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                              minimumSize: Size(48.0, 24.0),
                              padding: EdgeInsets.all(11.0),
                              backgroundColor: Color(0xFFF2F8FA),
                              side: BorderSide(color: Color(0xFFC4CCD0))),
                        ),
                        SizedBox(width: 8.0),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text(
                            "Laser Cutting",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 10.5,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                              minimumSize: Size(95.0, 24.0),
                              padding: EdgeInsets.all(11.0),
                              backgroundColor: Color(0xFFF2F8FA),
                              side: BorderSide(color: Color(0xFFC4CCD0))),
                        ),
                        SizedBox(width: 8.0),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text(
                            "3D Printing",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 10.5,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                              minimumSize: Size(81.0, 24.0),
                              padding: EdgeInsets.all(11.0),
                              backgroundColor: Color(0xFFF2F8FA),
                              side: BorderSide(color: Color(0xFFC4CCD0))),
                        )
                      ],
                    )
                  ],
                ),
              )),
        )
      ],
    ));
  }
}
