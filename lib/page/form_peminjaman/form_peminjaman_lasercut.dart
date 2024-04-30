import 'package:build_app/page/custom/custom_form_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class formPeminjamanLasercut extends StatefulWidget {
  const formPeminjamanLasercut({super.key});

  @override
  State<formPeminjamanLasercut> createState() => _formPeminjamanLasercutState();
}

class _formPeminjamanLasercutState extends State<formPeminjamanLasercut> {
  final _formPeminjamanLasercut = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Color(0xFF757575), size: 20.0),
        titleTextStyle:
            GoogleFonts.inter(fontSize: 15.5, fontWeight: FontWeight.w500),
        elevation: 0, // agar appbar header tidak meninggalkan shadow
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Form(
            key: _formPeminjamanLasercut,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 23.0, vertical: 55.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Form Penggunaan Laser Cutting",
                    style: GoogleFonts.inter(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6B7888),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  const customFormPeminjaman(
                    returnText: "Silahkan mengisi email",
                    judul: "Email",
                    hintText: "contoh: ayu@mhs.polman-bandung.ac.id",
                  ),
                  const customFormPeminjaman(
                    returnText: "Silahkan mengisi nama lengkap",
                    judul: "Nama Pemohon",
                    hintText: "contoh: Ayu Asahi",
                  ),
                  customFormPeminjaman(
                    returnText: "Silahkan mengisi batas peminjaman",
                    judul: "Tenggat Peminjaman",
                    hintText: DateFormat('d/MM/yy').format(DateTime.now()),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
