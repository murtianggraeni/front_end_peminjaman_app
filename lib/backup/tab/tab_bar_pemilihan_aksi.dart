// import 'package:build_app/backup/tab/form/form_laporan_kerusakan.dart';
// import 'package:build_app/backup/tab/form/form_peminjaman.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class TabAksiPemilihan extends StatefulWidget {
//   const TabAksiPemilihan({super.key});

//   @override
//   State<TabAksiPemilihan> createState() => _TabAksiPemilihanState();
// }

// class _TabAksiPemilihanState extends State<TabAksiPemilihan>
//     with SingleTickerProviderStateMixin {
//   late TabController tabController;

//   @override
//   void initState() {
//     tabController = TabController(length: 2, vsync: this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 750.0,
//       child: Column(
//         children: [
//           Container(
//             // height: 52.0,
//             width: MediaQuery.of(context).size.height,
//             decoration: const BoxDecoration(
//               color: Color(0xFFF1F1F1),
//               borderRadius: BorderRadius.all(Radius.circular(10.0)),
//             ),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(5.0),
//                   child: TabBar(
//                     labelColor: Colors.black,
//                     unselectedLabelColor: const Color(0xFF6B7888),
//                     indicatorColor: Colors.white,
//                     indicatorWeight: 2,
//                     indicatorSize: TabBarIndicatorSize.tab,
//                     indicator: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(5.0),
//                     ),
//                     controller: tabController,
//                     labelStyle: GoogleFonts.inter(
//                       fontSize: 15.0,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     tabs: const [
//                       Tab(
//                         text: 'Peminjaman',
//                       ),
//                       Tab(
//                         text: 'Laporan Kerusakan',
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: tabController,
//               children: const [
//                 formPeminjamanBackupTiga(),
//                 formLaporanKerusakanBackup(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
