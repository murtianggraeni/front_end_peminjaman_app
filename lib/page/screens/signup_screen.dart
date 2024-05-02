import 'package:build_app/routes/route_name.dart';
import 'package:build_app/theme/socialMediaLogo.dart';
import 'package:build_app/theme/theme.dart';
import 'package:build_app/page/widget/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;
  bool hidden = true;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: Column(
      children: [
        const Expanded(
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
                      topRight: Radius.circular(40.0))),
              child: SingleChildScrollView(
                // get started form
                child: Form(
                    child: Form(
                        key: _formSignupKey,
                        child: Column(
                          // get started text
                          children: [
                            Text(
                              "Ayo Mulai",
                              style: GoogleFonts.inter(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w700,
                                  color: lightColorScheme.primary),
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            // NAMA LENGKAP
                            TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Silahkan mengisi nama lengkap";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                label: const Text("Nama Lengkap"),
                                hintText: "Masukkan Nama",
                                hintStyle: TextStyle(
                                  color: Colors.black26,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            // EMAIL
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Silahkan mengisi alamat email";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  label: const Text("Email"),
                                  hintText: "Masukkan Email",
                                  hintStyle: TextStyle(
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
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            // PASSWORD
                            TextFormField(
                              obscureText: hidden,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Silahkan mengisi password";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  label: const Text("Password"),
                                  hintText: "Masukkan Password",
                                  hintStyle: TextStyle(
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
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidden = !hidden;
                                      });
                                    },
                                    icon: hidden
                                        ? Icon(
                                            Icons.visibility_off,
                                            color: Colors.black38,
                                          )
                                        : Icon(Icons.visibility,
                                            color: Colors.black38),
                                  )),
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            // Persetujuan untuk proses data selanjutnya
                            Row(
                              children: [
                                Checkbox(
                                  value: agreePersonalData,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      agreePersonalData = value!;
                                    });
                                  },
                                  activeColor: lightColorScheme.primary,
                                ),
                                const Text(
                                  "Saya menyetujui penyimpanan ",
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                ),
                                Text(
                                  "Data pribadi",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: lightColorScheme.primary),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(328, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: lightColorScheme.primary,
                                      textStyle: GoogleFonts.poppins()),
                                  onPressed: () {
                                    if (_formSignupKey.currentState!
                                            .validate() &&
                                        agreePersonalData) {
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(const SnackBar(
                                      //   content: Text("Memproses Data"),
                                      //   behavior: SnackBarBehavior.floating,
                                      //   duration: Duration(seconds: 2),
                                      // ));
                                      Get.snackbar("Registrasi Berhasil",
                                          "Memproses data");
                                      Get.offNamed(RouteName.custom_buttom_nav);
                                    } else if (!agreePersonalData) {
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(const SnackBar(
                                      //   content: Text(
                                      //       "Setujui proses data pribadi Anda"),
                                      //   behavior: SnackBarBehavior.floating,
                                      //   duration: Duration(seconds: 2),
                                      // ));
                                      Get.snackbar("Registrasi Gagal",
                                          "Setujui proses data pribadi Anda");
                                    }
                                  },
                                  child: const Text(
                                    "Sign up",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Divider(
                                  thickness: 0.7,
                                  color: Colors.grey.withOpacity(0.5),
                                )),
                                const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      "Sign up dengan",
                                      style: TextStyle(
                                        color: Colors.black45,
                                      ),
                                    )),
                                Expanded(
                                  child: Divider(
                                    thickness: 0.7,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            // sign up with social media
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Logo(logoAsset: "assets/images/google.png"),
                                SizedBox(width: 22),
                                Logo(logoAsset: "assets/images/facebook.png"),
                              ],
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Sudah memiliki akun? ",
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(RouteName.signin_screen);
                                  },
                                  child: Text(
                                    "Sign in",
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
                        ))),
              ),
            ))
      ],
    ));
  }
}
