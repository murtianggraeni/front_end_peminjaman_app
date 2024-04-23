import 'package:build_app/widget/custom_form_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class formPeminjamanCnc extends StatefulWidget {
  const formPeminjamanCnc({super.key});

  @override
  State<formPeminjamanCnc> createState() => _formPeminjamanCncState();
}

class _formPeminjamanCncState extends State<formPeminjamanCnc> {
  bool showNavBar = false;

  @override
  Widget build(BuildContext context) {
    return customFormPeminjaman(
      body: TextFormField(),
      showNavBar: showNavBar,
    );
  }
}
