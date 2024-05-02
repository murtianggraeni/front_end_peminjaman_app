import 'package:build_app/page/screens/signin_screen.dart';
import 'package:build_app/page/screens/signup_screen.dart';
import 'package:build_app/theme/theme.dart';
import 'package:build_app/page/widget/custom_scaffold.dart';
import 'package:build_app/page/widget/welcome_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return CustomScaffold(
        child: Column(
      children: [
        SizedBox(height: 250),
        Flexible(
            flex: 9,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              child: Center(
                  child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: "Selamat Datang!\n",
                    style: GoogleFonts.inter(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  WidgetSpan(
                    child: SizedBox(
                      height: 40,
                    ),
                  ),
                  TextSpan(
                      text: "Siap untuk pengalaman meminjam mesin yang\n",
                      style: GoogleFonts.inter(color: Colors.white)),
                  WidgetSpan(
                    child: SizedBox(
                      height: 23,
                    ),
                  ),
                  TextSpan(
                      text: "lebih mudah dan efisien? Mari mulai!",
                      style: GoogleFonts.inter(color: Colors.white))
                ]),
              )),
            )),
        Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: WelcomeButton(
                      buttonText: "Sign in",
                      onTap: SignInScreen(),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                      child: WelcomeButton(
                    buttonText: "Sign up",
                    onTap: const SignUpScreen(),
                    color: Colors.white,
                    textColor: lightColorScheme.primary,
                  )),
                ],
              ),
            ))
      ],
    ));
  }
}
