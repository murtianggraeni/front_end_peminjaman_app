import 'package:build_app/controller/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:build_app/theme/theme.dart';

class VerificationCodePage extends StatelessWidget {
  final String email;
  // final RegisterController _registerC = Get.find();
  final RegisterController _registerC = Get.put(RegisterController());
  final TextEditingController codeC = TextEditingController();

  VerificationCodePage({required this.email});

  @override
  Widget build(BuildContext context) {
    final String email = Get.arguments; // Ambil email dari arguments

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Verifikasi Email",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        backgroundColor: pageModeScheme.primary,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              pageModeScheme.primary.withOpacity(0.9),
              pageModeScheme.primary.withOpacity(0.6),
              pageModeScheme.primary.withOpacity(0.3),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                MingCuteIcons.mgc_mail_line,
                // Ikon dari Mingcute
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Text(
                "Verifikasi Email Anda",
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: pageModeScheme.onPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Masukkan kode verifikasi yang telah dikirim ke:",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: pageModeScheme.onPrimary.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: codeC,
                keyboardType: TextInputType.number,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: "Kode Verifikasi",
                  labelStyle: GoogleFonts.inter(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (codeC.text.isNotEmpty) {
                    _registerC.verifyCode(email, codeC.text);
                  } else {
                    Get.snackbar(
                      "Gagal",
                      "Kode verifikasi tidak boleh kosong",
                      backgroundColor: pageModeScheme.error,
                      colorText: pageModeScheme.onError,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: pageModeScheme.primary,
                  foregroundColor: pageModeScheme.onPrimary,
                  textStyle: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text("Verifikasi"),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _registerC.resendVerificationCode(email);
                },
                child: Text(
                  "Kirim ulang kode?",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Belum menerima kode? Cek folder spam atau pastikan email Anda benar.",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
