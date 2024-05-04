import 'package:build_app/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class buttonPeminjaman extends StatefulWidget {
  const buttonPeminjaman({
    super.key,
    required this.page,
    required this.objekDipilih,
    required this.merekMesin,
    required this.namaMesin,
    required this.namaLab,
    required this.gambarMesin,
    required this.leftImage,
    required this.topImage,
    required this.topArrow,
    this.cardHeight = 247.0,
    this.cardWidth = 156.0,
  });

  final Widget page;
  final String objekDipilih;
  final String merekMesin;
  final String namaMesin;
  final String namaLab;
  final String gambarMesin;
  final double leftImage;
  final double topImage;
  final double topArrow;
  final double cardHeight;
  final double cardWidth;

  @override
  State<buttonPeminjaman> createState() => _buttonPeminjamanState();
}

class _buttonPeminjamanState extends State<buttonPeminjaman> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          print(widget.objekDipilih);
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: widget.page,
            withNavBar: false,
          );
        },
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.all(
          Radius.circular(12.04),
        ),
        child: Ink(
          height: 247.0,
          width: 156.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: pageModeScheme.onPrimary,
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14.0),
                Text(
                  widget.merekMesin,
                  style: GoogleFonts.inter(
                    fontSize: 8.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 0.5),
                Text(
                  widget.namaMesin,
                  style: GoogleFonts.inter(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 0.5),
                Text(
                  widget.namaLab,
                  style: GoogleFonts.inter(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: widget.leftImage,
                    top: widget.topImage,
                  ),
                  child: Image.asset(widget.gambarMesin),
                ),
                Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(left: 110.0, top: widget.topArrow),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
