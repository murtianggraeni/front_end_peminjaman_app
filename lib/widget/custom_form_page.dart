import 'package:build_app/widget/custom_button_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class customFormPeminjaman extends StatelessWidget {
  const customFormPeminjaman(
      {super.key, required this.body, this.showNavBar = true});

  final Widget? body;
  final bool showNavBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0, // agar appbar header tidak meninggalkan shadow
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [SafeArea(child: body!), if (showNavBar) customButtonNav()],
      ),
    );
  }
}
