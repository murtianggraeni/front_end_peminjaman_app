import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, required this.child});

  final Widget? child;

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
        children: [
          Image(
            image: AssetImage("assets/images/screen.png"),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 200.0,
            left: 40.0,
            right: 40.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            ),
          ),
          SafeArea(child: child!)
        ],
      ),
    );
  }
}
