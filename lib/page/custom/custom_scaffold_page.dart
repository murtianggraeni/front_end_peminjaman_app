import 'package:build_app/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class customScaffoldPage extends StatelessWidget {
  const customScaffoldPage({super.key, required this.body});

  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: pageModeScheme.primary,
            ),
          ),
          SafeArea(child: body!)
        ],
      ),
    );
  }
}
