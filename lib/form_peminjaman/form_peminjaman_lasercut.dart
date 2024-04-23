import 'package:build_app/widget/custom_form_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class formPeminjamanLasercut extends StatefulWidget {
  const formPeminjamanLasercut({super.key});

  @override
  State<formPeminjamanLasercut> createState() => _formPeminjamanLasercutState();
}

class _formPeminjamanLasercutState extends State<formPeminjamanLasercut> {
  @override
  Widget build(BuildContext context) {
    return customFormPeminjaman(
      body: TextFormField(),
    );
  }
}
