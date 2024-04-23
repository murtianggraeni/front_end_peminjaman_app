import 'package:build_app/screens/forget_password.dart';
import 'package:build_app/screens/signup_screen.dart';
import 'package:build_app/theme/socialMediaLogo.dart';
import 'package:build_app/theme/theme.dart';
import 'package:build_app/widget/custom_button_nav.dart';
import 'package:build_app/widget/custom_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = false;
  bool hidden = true;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: Column(
      children: [
        Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            )),
        Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  )),
              child: SingleChildScrollView(
                child: Form(
                    key: _formSignInKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Selamat Datang!",
                          style: GoogleFonts.inter(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                            color: lightColorScheme.primary,
                          ),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        // EMAIL
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Silahkan mengisi alamat email";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text("Email"),
                            hintText: "Masukkan Email",
                            hintStyle: const TextStyle(color: Colors.black26),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        // PASSWORD
                        TextFormField(
                          obscureText: hidden,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Silahkan mengisi password";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              label: const Text("Password"),
                              hintText: "Masukkan Password",
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              suffixIcon: IconButton(
                                icon: hidden
                                    ? const Icon(Icons.visibility_off,
                                        color: Colors.black54)
                                    : const Icon(Icons.visibility,
                                        color: Colors.black54),
                                onPressed: () {
                                  setState(() {
                                    hidden = !hidden;
                                  });
                                },
                              )),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        // CHECK BOX UNTUK INGAT SAYA DAN LUPA PASSWORD
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberPassword,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      rememberPassword = value!;
                                    });
                                  },
                                  activeColor: lightColorScheme.primary,
                                ),
                                Text(
                                  "Ingat saya",
                                  style: GoogleFonts.inter(
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              child: Text("Lupa password?",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    color: lightColorScheme.primary,
                                  )),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (e) =>
                                            const ForgetPasswordScreen()));
                              },
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        // SIGN IN BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(328, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: lightColorScheme.primary,
                              textStyle: GoogleFonts.inter(
                                fontSize: 15.0,
                              ),
                            ),
                            onPressed: () {
                              if (_formSignInKey.currentState!.validate() &&
                                  !rememberPassword) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Data diproses"),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                ));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const customButtonNav(),
                                    ));
                              } else if (rememberPassword) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      "Menyetujui untuk menyimpan data personal"),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                ));
                              }
                            },
                            child: const Text(
                              "Sign in",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        // sign up divider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.7,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 10,
                              ),
                              child: Text("Sign in dengan",
                                  style: TextStyle(
                                    color: Colors.black45,
                                  )),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.7,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        // sign up social media logo
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Logo(logoAsset: "assets/images/google.png"),
                            SizedBox(width: 22),
                            Logo(logoAsset: "assets/images/facebook.png"),
                          ],
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Belum memiliki akun? ",
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (e) => const SignUpScreen(),
                                    ));
                              },
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: lightColorScheme.primary,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        )
                      ],
                    )),
              ),
            ))
      ],
    ));
  }
}
