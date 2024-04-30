import 'package:build_app/page/custom/custom_form_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class formPeminjamanPrinting extends StatefulWidget {
  const formPeminjamanPrinting({super.key});

  @override
  State<formPeminjamanPrinting> createState() => _formPeminjamanPrintingState();
}

class _formPeminjamanPrintingState extends State<formPeminjamanPrinting> {
  final _formPeminjamanPrinting = GlobalKey<FormState>();

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
            key: _formPeminjamanPrinting,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 23.0, vertical: 55.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Form Penggunaan 3D Printing",
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

// backup form text
      // body: SingleChildScrollView(
      //   child: Form(
      //       key: _formPeminjamanPrinting,
      //       child: Column(
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.symmetric(
      //                 horizontal: 23.0, vertical: 55.0),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 /* EMAIL */
      //                 Text(
      //                   "Email",
      //                   style: GoogleFonts.inter(
      //                     fontSize: 14.0,
      //                     fontWeight: FontWeight.w300,
      //                     color: const Color(0xFF6B7888),
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   height: 4.0,
      //                 ),
      //                 TextFormField(
      //                   validator: (value) {
      //                     if (value == null || value.isEmpty) {
      //                       return "Silahkan mengisi email";
      //                     }
      //                     return null;
      //                   },
      //                   decoration: InputDecoration(
      //                     hintText: "Masukkan Email",
      //                     hintStyle: const TextStyle(color: Colors.black26),
      //                     border: OutlineInputBorder(
      //                       borderSide: const BorderSide(
      //                         color: Color(0xFFD9D9D9),
      //                       ),
      //                       borderRadius: BorderRadius.circular(10),
      //                     ),
      //                     enabledBorder: OutlineInputBorder(
      //                       borderSide: const BorderSide(
      //                         color: Colors.black12,
      //                       ),
      //                       borderRadius: BorderRadius.circular(10),
      //                     ),
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   height: 11.0,
      //                 ),
      //                 /* NAMA PEMOHON */
      //                 Text(
      //                   "Nama Pemohon",
      //                   style: GoogleFonts.inter(
      //                     fontSize: 14.0,
      //                     fontWeight: FontWeight.w300,
      //                     color: const Color(0xFF6B7888),
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   height: 4.0,
      //                 ),
      //                 TextFormField(
      //                   validator: (value) {
      //                     if (value == null || value.isEmpty) {
      //                       return "Silahkan mengisi nama lengkap";
      //                     }
      //                     return null;
      //                   },
      //                   decoration: InputDecoration(
      //                     hintText: "Masukkan nama lengkap",
      //                     hintStyle: const TextStyle(color: Colors.black26),
      //                     border: OutlineInputBorder(
      //                       borderSide: const BorderSide(
      //                         color: Color(0xFFD9D9D9),
      //                       ),
      //                       borderRadius: BorderRadius.circular(10),
      //                     ),
      //                     enabledBorder: OutlineInputBorder(
      //                       borderSide: const BorderSide(
      //                         color: Colors.black12,
      //                       ),
      //                       borderRadius: BorderRadius.circular(10),
      //                     ),
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   height: 11.0,
      //                 ),
      //                 /* WAKTU PEMINJAMAN */
      //                 Text(
      //                   "Batas Peminjaman",
      //                   style: GoogleFonts.inter(
      //                     fontSize: 14.0,
      //                     fontWeight: FontWeight.w300,
      //                     color: const Color(0xFF6B7888),
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   height: 4.0,
      //                 ),
      //                 TextFormField(
      //                   validator: (value) {
      //                     if (value == null || value.isEmpty) {
      //                       return "Silahkan mengisi tenggat peminjaman";
      //                     }
      //                     return null;
      //                   },
      //                   decoration: InputDecoration(
      //                     hintText: "Masukkan tanggal terakhir peminjaman",
      //                     hintStyle: const TextStyle(color: Colors.black26),
      //                     border: OutlineInputBorder(
      //                       borderSide: const BorderSide(
      //                         color: Color(0xFFD9D9D9),
      //                       ),
      //                       borderRadius: BorderRadius.circular(10),
      //                     ),
      //                     enabledBorder: OutlineInputBorder(
      //                       borderSide: const BorderSide(
      //                         color: Colors.black12,
      //                       ),
      //                       borderRadius: BorderRadius.circular(10),
      //                     ),
      //                     suffixIcon: IconButton(
      //                         onPressed: () {},
      //                         icon: const Icon(MingCute.calendar_month_fill)),
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   height: 11.0,
      //                 ),
      //                 /* BATAS PEMINJAMAN */
      //                 Text(
      //                   "Batas Peminjaman",
      //                   style: GoogleFonts.inter(
      //                     fontSize: 14.0,
      //                     fontWeight: FontWeight.w300,
      //                     color: const Color(0xFF6B7888),
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   height: 4.0,
      //                 ),
      //                 TextFormField(
      //                   validator: (value) {
      //                     if (value == null || value.isEmpty) {
      //                       return "Silahkan mengisi tenggat peminjaman";
      //                     }
      //                     return null;
      //                   },
      //                   decoration: InputDecoration(
      //                     hintText: "Masukkan tanggal terakhir peminjaman",
      //                     hintStyle: const TextStyle(color: Colors.black26),
      //                     border: OutlineInputBorder(
      //                       borderSide: const BorderSide(
      //                         color: Color(0xFFD9D9D9),
      //                       ),
      //                       borderRadius: BorderRadius.circular(10),
      //                     ),
      //                     enabledBorder: OutlineInputBorder(
      //                       borderSide: const BorderSide(
      //                         color: Colors.black12,
      //                       ),
      //                       borderRadius: BorderRadius.circular(10),
      //                     ),
      //                     suffixIcon: IconButton(
      //                         onPressed: () {},
      //                         icon: const Icon(MingCute.calendar_month_fill)),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       )),
      // )
