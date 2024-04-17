import 'package:build_app/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

const activeDbColor = Color(0xFFE6EDF0);
const inactiveDbColor = Color(0xFFffff);

class dbPeminjaman extends StatefulWidget {
  const dbPeminjaman(
      {super.key,
      required this.colorPage,
      required this.mesin,
      required this.objekDipilih,
      required this.merekMesin,
      required this.namaMesin,
      required this.namaLab,
      required this.gambarMesin,
      required this.leftImage,
      required this.topImage,
      required this.topArrow,
      required this.onCardTap});

  final Color colorPage;
  final int mesin;
  final String objekDipilih;
  final String merekMesin;
  final String namaMesin;
  final String namaLab;
  final String gambarMesin;
  final double leftImage;
  final double topImage;
  final double topArrow;
  final Function(int) onCardTap;

  @override
  State<dbPeminjaman> createState() => _dbPeminjamanState();
}

class _dbPeminjamanState extends State<dbPeminjaman> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(widget.objekDipilih);
        widget.onCardTap(widget.mesin);
      },
      child: Container(
        height: 247.0,
        width: 156.0,
        decoration: BoxDecoration(
          color: widget.colorPage,
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          // boxShadow: [
          //   BoxShadow(
          //     blurRadius: 15.0,
          //     offset: Offset(0, 5.0),
          //     color: Colors.grey.shade500,
          //     spreadRadius: 0.0,
          //   ),
          //   BoxShadow(
          //     blurRadius: 15.0,
          //     offset: Offset(-5.0, 0),
          //     color: Colors.white,
          //     spreadRadius: 1.0,
          //   ),
          //   BoxShadow(
          //     blurRadius: 15.0,
          //     offset: Offset(0.0, -5.0),
          //     color: Colors.white,
          //     spreadRadius: 1.0,
          //   ),
          // ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14.0),
              Text(
                widget.merekMesin.toString(),
                style: GoogleFonts.inter(
                  fontSize: 8.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 0.5),
              Text(
                widget.namaMesin.toString(),
                style: GoogleFonts.inter(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 0.5),
              Text(
                widget.namaLab.toString(),
                style: GoogleFonts.inter(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: widget.leftImage, top: widget.topImage),
                child: Image(image: AssetImage(widget.gambarMesin)),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 110.0,
                      top: widget.topArrow,
                    ),
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
    );
  }
}
