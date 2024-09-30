import 'package:build_app/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class customScaffoldPage extends StatelessWidget {
  const customScaffoldPage({
    super.key,
    required this.body,
    this.drawer,
  });

  final Widget? body;
  final Widget? drawer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
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
