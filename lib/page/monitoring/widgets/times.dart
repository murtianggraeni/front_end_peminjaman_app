import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class times extends StatefulWidget {
  const times({super.key});

  @override
  State<times> createState() => _timesState();
}

class _timesState extends State<times> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70.0,
      color: Colors.yellow,
    );
  }
}
