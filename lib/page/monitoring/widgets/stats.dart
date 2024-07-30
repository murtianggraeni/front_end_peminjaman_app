import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class stats extends StatefulWidget {
  const stats({super.key});

  @override
  State<stats> createState() => _statsState();
}

class _statsState extends State<stats> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170.0,
      color: Colors.yellow,
    );
  }
}
