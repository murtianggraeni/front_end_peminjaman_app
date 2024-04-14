import 'package:flutter/material.dart';

class customScaffoldMain extends StatelessWidget {
  const customScaffoldMain({super.key, required this.body});

  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF115C7C),
            ),
          ),
          SafeArea(child: body!)
        ],
      ),
    );
  }
}
