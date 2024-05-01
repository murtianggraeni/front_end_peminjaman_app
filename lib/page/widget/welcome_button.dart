import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton(
      {super.key, this.buttonText, this.onTap, this.color, this.textColor});
  final String? buttonText;
  final Widget? onTap;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (e) => onTap!,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: color!,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
          ),
        ),
        child: Text(
          buttonText!,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            color: textColor!,
          ),
        ),
      ),
    );
  }
}
