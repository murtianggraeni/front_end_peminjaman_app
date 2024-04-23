import 'package:build_app/widget/custom_form_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class formPeminjamanPrinting extends StatefulWidget {
  const formPeminjamanPrinting({super.key});

  @override
  State<formPeminjamanPrinting> createState() => _formPeminjamanPrintingState();
}

class _formPeminjamanPrintingState extends State<formPeminjamanPrinting> {
  @override
  Widget build(BuildContext context) {
    return customFormPeminjaman(body: TextFormField());
  }
}
