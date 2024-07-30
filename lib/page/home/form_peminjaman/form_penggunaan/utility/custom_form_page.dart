import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class customFormPeminjaman extends StatefulWidget {
  const customFormPeminjaman({
    super.key,
    required this.judul,
    required this.returnText,
    this.controller,
    this.onTap,
    required this.hintText,
    this.icon,
    this.keyboardType,
    this.readOnly = false,
    // required this.body,
  });

  // final Widget? body;
  final String judul;
  final String returnText;
  final TextEditingController? controller;
  final OnTap? onTap;
  final String hintText;
  final IconButton? icon;
  final TextInputType? keyboardType;
  final bool? readOnly;

  @override
  State<customFormPeminjaman> createState() => _customFormPeminjamanState();
}

class _customFormPeminjamanState extends State<customFormPeminjaman> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* EMAIL */
        Text(
          widget.judul,
          style: GoogleFonts.inter(
            fontSize: 14.0,
            fontWeight: FontWeight.w300,
            color: const Color(0xFF6B7888),
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        TextFormField(
          controller: widget.controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return widget.returnText;
            }
            return null;
          },
          onTap: () {
            widget.onTap;
          },
          decoration: InputDecoration(
            
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Colors.black26),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xFFD9D9D9),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: widget.icon),
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly ?? false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
        const SizedBox(
          height: 11.0,
        ),
      ],
    );
  }
}


/* backup */
// Container(
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 21.0, vertical: 55.0),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(
        //           "Form Penggunaan ${namaMesin}",
        //           style: GoogleFonts.inter(
        //             fontSize: 18.0,
        //             fontWeight: FontWeight.bold,
        //             color: Color(0xFF6B7888),
        //           ),
        //         ),
        //         SizedBox(
        //           height: 15.0,
        //         ),
        //         Text(
        //           "Email",
        //           style: GoogleFonts.inter(
        //             fontSize: 14.0,
        //             fontWeight: FontWeight.w300,
        //             color: const Color(0xFF6B7888),
        //           ),
        //         ),
        //         Container(
        //           height: 49.5,
        //           margin: EdgeInsets.only(top: 4.0),
        //           padding: EdgeInsets.only(left: 10.0),
        //           decoration: BoxDecoration(
        //               borderRadius: BorderRadius.all(Radius.circular(6.0)),
        //               border: Border.all(
        //                 color: Color(0xFFE2E2E2),
        //                 width: 1.0,
        //               )),
        //           child: TextFormField(
        //             autofocus: false,
        //             cursorColor: Color(0xFFB9B9B9),
        //             validator: (value) {
        //               if (value == null || value.isEmpty) {
        //                 return "Silahkan mengisi email";
        //               }
        //               return null;
        //             },
        //             decoration: InputDecoration(
        //               hintText: "Masukkan Email",
        //               hintStyle: TextStyle(color: Colors.black26),
        //               focusedBorder: const UnderlineInputBorder(
        //                 borderSide: BorderSide(
        //                   color: Color(0xFFE2E2E2),
        //                   width: 0,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ),