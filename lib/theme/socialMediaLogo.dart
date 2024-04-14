import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, required this.logoAsset});
  final String logoAsset;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(logoAsset),
      width: 45.0,
      height: 45.0,
    );
  }
}
