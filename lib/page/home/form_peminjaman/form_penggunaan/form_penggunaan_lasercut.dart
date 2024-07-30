import 'package:build_app/page/home/form_peminjaman/form_penggunaan/utility/tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class formPenggunaanLasercut extends StatefulWidget {
  const formPenggunaanLasercut({super.key});

  @override
  State<formPenggunaanLasercut> createState() => _formPenggunaanLasercutState();
}

class _formPenggunaanLasercutState extends State<formPenggunaanLasercut>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formPenggunaanLasercut = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return TabForm(
      namaMesin: "Laser Cutting",
      keyForm: _formPenggunaanLasercut,
    );
  }
}

/* BACKUP */
/*

import 'package:build_app/page/form_penggunaan/tab_penggunaan/tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class formPenggunaanLasercut extends StatefulWidget {
  const formPenggunaanLasercut({super.key});

  @override
  State<formPenggunaanLasercut> createState() => _formPenggunaanLasercutState();
}

class _formPenggunaanLasercutState extends State<formPenggunaanLasercut>
    with SingleTickerProviderStateMixin {
  // final _formPeminjaman = GlobalKey<FormState>();
  // final GlobalKey<_formPenggunaanLasercutState> _formPenggunaanLasercut =
  //     GlobalKey<_formPenggunaanLasercutState>();

  final GlobalKey<FormState> _formPenggunaanLasercut = GlobalKey<FormState>();

  // final TextEditingController _formEmail = TextEditingController();
  // final TextEditingController _formNamaLengkap = TextEditingController();

  // @override
  // void initState() {
  //   tabController = TabController(length: 2, vsync: this);
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   tabController.dispose();
  //   super.dispose();
  // }

  // bool validateForm() {
  //   return _formEmail.text.isEmpty && _formNamaLengkap.text.isEmpty;
  // }

  @override
  Widget build(BuildContext context) {
    return TabForm(
      namaMesin: "Laser Cutting",
      keyForm: _formPenggunaanLasercut,
    );

    // Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.transparent,
    //     iconTheme: const IconThemeData(color: Color(0xFF757575), size: 20.0),
    //     titleTextStyle:
    //         GoogleFonts.inter(fontSize: 15.5, fontWeight: FontWeight.w500),
    //     elevation: 0, // agar appbar header tidak meninggalkan shadow
    //   ),
    //   extendBodyBehindAppBar: true,
    //   body: SingleChildScrollView(
    //     child: Form(
    //       key: _formPeminjaman,
    //       child: Padding(
    //         padding:
    //             const EdgeInsets.symmetric(horizontal: 23.0, vertical: 55.0),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               "Form Penggunaan Laser Cutting",
    //               style: GoogleFonts.inter(
    //                 fontSize: 18.0,
    //                 fontWeight: FontWeight.bold,
    //                 color: const Color(0xFF6B7888),
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 15.0,
    //             ),
    //             customFormPeminjaman(
    //               controller: _formEmail,
    //               returnText: "Silahkan mengisi email",
    //               judul: "Email",
    //               hintText: "Contoh: ayu@mhs.polman-bandung.ac.id",
    //               keyboardType: TextInputType.emailAddress,
    //             ),
    //             customFormPeminjaman(
    //               controller: _formNamaLengkap,
    //               returnText: "Silahkan mengisi nama lengkap",
    //               judul: "Nama Pemohon",
    //               hintText: "contoh: Ayu Asahi",
    //             ),
    //             Text(
    //               "Keperluan",
    //               style: GoogleFonts.inter(
    //                 fontSize: 14.0,
    //                 fontWeight: FontWeight.w300,
    //                 color: const Color(0xFF6B7888),
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 4.0,
    //             ),
    //             const SizedBox(
    //               height: 11.0,
    //             ),
    //             TabAksiPemilihan()
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
*/