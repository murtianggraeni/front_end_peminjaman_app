import 'package:build_app/page/custom/custom_form_page.dart';
import 'package:build_app/page/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class formPeminjamanPrinting extends StatefulWidget {
  const formPeminjamanPrinting({super.key});

  @override
  State<formPeminjamanPrinting> createState() => _formPeminjamanPrintingState();
}

class _formPeminjamanPrintingState extends State<formPeminjamanPrinting> {
  final _formPeminjamanPrinting = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return customFormPeminjaman(
        namaMesin: "3D Printing",
        body: SingleChildScrollView(
          child: Form(
              key: _formPeminjamanPrinting,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15.0),
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => mainPageSatu(),
                                  ));
                            },
                            icon: Icon(MingCute.left_line)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15.0),
                        child: Text(
                          "Form Peminjaman 3D Printing",
                          style: GoogleFonts.inter(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Silahkan mengisi email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: Text("E-mail"),
                        hintText: "Masukkan Email",
                        hintStyle: const TextStyle(color: Colors.black26),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
