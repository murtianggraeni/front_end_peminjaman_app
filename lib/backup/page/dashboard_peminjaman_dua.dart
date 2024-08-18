// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';

// const activeDbColor = Color(0xFFE6EDF0);
// const inactiveDbColor = Color(0xFFffff);

// class dbPeminjamanDua extends StatefulWidget {
//   const dbPeminjamanDua(
//       {super.key,
//       required this.colorPage,
//       required this.mesin,
//       required this.objekDipilih,
//       required this.merekMesin,
//       required this.namaMesin,
//       required this.namaLab,
//       required this.gambarMesin,
//       required this.leftImage,
//       required this.topImage,
//       required this.topArrow,
//       required this.onCardTap});

//   final Color colorPage;
//   final int mesin;
//   final String objekDipilih;
//   final String merekMesin;
//   final String namaMesin;
//   final String namaLab;
//   final String gambarMesin;
//   final double leftImage;
//   final double topImage;
//   final double topArrow;
//   final Function(int) onCardTap;

//   @override
//   State<dbPeminjamanDua> createState() => _dbPeminjamanDuaState();
// }

// class _dbPeminjamanDuaState extends State<dbPeminjamanDua> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         print(widget.objekDipilih);
//         widget.onCardTap(widget.mesin);
//       },
//       child: Container(
//         height: 247.0,
//         width: 156.0,
//         decoration: BoxDecoration(
//           color: widget.colorPage,
//           shape: BoxShape.rectangle,
//           borderRadius: const BorderRadius.all(Radius.circular(12.0)),
//           // boxShadow: [
//           //   BoxShadow(
//           //     blurRadius: 15.0,
//           //     offset: Offset(0, 5.0),
//           //     color: Colors.grey.shade500,
//           //     spreadRadius: 0.0,
//           //   ),
//           //   BoxShadow(
//           //     blurRadius: 15.0,
//           //     offset: Offset(-5.0, 0),
//           //     color: Colors.white,
//           //     spreadRadius: 1.0,
//           //   ),
//           //   BoxShadow(
//           //     blurRadius: 15.0,
//           //     offset: Offset(0.0, -5.0),
//           //     color: Colors.white,
//           //     spreadRadius: 1.0,
//           //   ),
//           // ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 14.0,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 14.0),
//               Text(
//                 widget.merekMesin.toString(),
//                 style: GoogleFonts.inter(
//                   fontSize: 8.0,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 0.5),
//               Text(
//                 widget.namaMesin.toString(),
//                 style: GoogleFonts.inter(
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 0.5),
//               Text(
//                 widget.namaLab.toString(),
//                 style: GoogleFonts.inter(
//                   fontSize: 10.0,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(
//                     left: widget.leftImage, top: widget.topImage),
//                 child: Image(image: AssetImage(widget.gambarMesin)),
//               ),
//               Row(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(
//                       left: 110.0,
//                       top: widget.topArrow,
//                     ),
//                     child: const Icon(
//                       Icons.arrow_forward_ios,
//                       size: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// // Pengaturan untuk file di luar 

// // import 'package:build_app/theme/theme.dart';
// // import 'package:build_app/utility/coba.dart';
// // import 'package:build_app/utility/dashboard_choose.dart';
// // import 'package:build_app/utility/dashboard_peminjaman.dart';
// // import 'package:build_app/widget/custom_scaffold_page.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/widgets.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:table_calendar/table_calendar.dart';

// // const activeDbColor = Color(0xFFD8E5EB);
// // const inactiveDbColor = Color(0xFFE6EDF0);

// // class mainPageSatu extends StatefulWidget {
// //   const mainPageSatu({super.key});

// //   @override
// //   State<mainPageSatu> createState() => _mainPageSatuState();
// // }

// // class _mainPageSatuState extends State<mainPageSatu> {
// //   Color cncCardColor = inactiveDbColor;
// //   Color lasercutCardColor = inactiveDbColor;
// //   Color printingCardColor = inactiveDbColor;

// //   void updateColor(int mesin) {
// //     setState(() {
// //       // Matikan semua kartu terlebih dahulu
// //       cncCardColor = inactiveDbColor;
// //       lasercutCardColor = inactiveDbColor;
// //       printingCardColor = inactiveDbColor;

// //       // Kemudian aktifkan kartu yang dipilih
// //       if (mesin == 1) {
// //         cncCardColor = activeDbColor;
// //       } else if (mesin == 2) {
// //         lasercutCardColor = activeDbColor;
// //       } else if (mesin == 3) {
// //         printingCardColor = activeDbColor;
// //       }
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return customScaffoldPage(
// //         body: Column(
// //                     SingleChildScrollView(
// //                       scrollDirection: Axis.horizontal,
// //                       child: Row(
// //                         children: [
// //                           dbPeminjaman(
// //                             colorPage: cncCardColor,
// //                             mesin: 1,
// //                             objekDipilih: "Memilih CNC Milling",
// //                             merekMesin: "MTU 200 M",
// //                             namaMesin: "CNC Milling",
// //                             namaLab: "Lab. Elektro Mekanik",
// //                             gambarMesin: "assets/images/foto_cnc.png",
// //                             leftImage: 23.0,
// //                             topImage: 4.0,
// //                             topArrow: 2.0,
// //                             onCardTap: updateColor,
// //                           ),
// //                           const SizedBox(width: 17.0),
// //                           dbPeminjaman(
// //                             colorPage: lasercutCardColor,
// //                             mesin: 2,
// //                             objekDipilih: "Memilih Laser Cutting",
// //                             merekMesin: "TQL-1390",
// //                             namaMesin: "Laser Cutting",
// //                             namaLab: "Lab. Elektro Mekanik",
// //                             gambarMesin: "assets/images/foto_lasercut.png",
// //                             leftImage: 3.0,
// //                             topImage: 18.0,
// //                             topArrow: 11.0,
// //                             onCardTap: updateColor,
// //                           ),
// //                           const SizedBox(width: 17.0),
// //                           dbPeminjaman(
// //                             colorPage: printingCardColor,
// //                             mesin: 3,
// //                             objekDipilih: "Memilih 3D Printing",
// //                             merekMesin: "Anycubic 4Max Pro",
// //                             namaMesin: "3D Printing",
// //                             namaLab: "Lab. PLC & HMI",
// //                             gambarMesin: "assets/images/foto_3dp.png",
// //                             leftImage: 6.0,
// //                             topImage: 9.0,
// //                             topArrow: 4.5,
// //                             onCardTap: updateColor,
// //                           ),
// //                         ],
// //                       ),
// //                     ),
              
                    
// //                   ],
// //                 ),
// //               )),
// //         ),
// //       ],
// //     ));
// //   }
// // }
