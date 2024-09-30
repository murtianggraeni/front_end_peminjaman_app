import 'package:build_app/controller/count_controller.dart';
import 'package:build_app/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

// class dashboardInformasiPeminjaman extends StatefulWidget {
//   const dashboardInformasiPeminjaman({
//     super.key,
//     required this.namaMesin,
//     required this.dataAcc,
//     required this.dataTidakAcc,
//     required this.dataDiproses,
//     required this.alamatInformasiLanjutan,
//   });

//   final String namaMesin;
//   final String dataAcc;
//   final String dataTidakAcc;
//   final String dataDiproses;
//   final String alamatInformasiLanjutan;

//   @override
//   State<dashboardInformasiPeminjaman> createState() =>
//       _dashboardInformasiPeminjamanState();
// }

// class _dashboardInformasiPeminjamanState
//     extends State<dashboardInformasiPeminjaman> {
//   final CountController countC = Get.put(CountController());
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 170.0,
//       width: 350.0,
//       decoration: BoxDecoration(
//         color: pageModeScheme.onPrimary,
//         shape: BoxShape.rectangle,
//         borderRadius: const BorderRadius.all(
//           Radius.circular(12.0),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
//         child: Flexible(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     DateFormat('EEE, d MMM yyyy').format(
//                       DateTime.now(),
//                     ),
//                     style: GoogleFonts.inter(
//                       fontSize: 8.0,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 12.0,
//                   ),
//                   Row(
//                     children: [
//                       const Icon(
//                         MingCuteIcons.mgc_information_line,
//                         color: Color(0xFF09244B),
//                         size: 12.0,
//                       ),
//                       const SizedBox(
//                         width: 2.0,
//                       ),
//                       Text(
//                         "Informasi Data Peminjaman",
//                         style: GoogleFonts.inter(
//                           fontSize: 8.0,
//                           fontWeight: FontWeight.w500,
//                           color: const Color(0xFF294D5C),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 3.0,
//                   ),
//                   Text(
//                     widget.namaMesin,
//                     style: GoogleFonts.inter(
//                       fontSize: 22.0,
//                       fontWeight: FontWeight.bold,
//                       color: const Color(0xFF738E99),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 3.0,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             height: 24.0,
//                             width: 75.0,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.rectangle,
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(6.0),
//                               ),
//                               color: Color(0xFFC8D4DA),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 7.0, vertical: 5.0),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Icon(
//                                     MingCuteIcons.mgc_check_line,
//                                     color: Color(0xFF09244B),
//                                     size: 16.0,
//                                   ),
//                                   const SizedBox(width: 1.0),
//                                   Text(
//                                     widget.dataAcc,
//                                     style: GoogleFonts.inter(
//                                       fontSize: 10.0,
//                                       fontWeight: FontWeight.w600,
//                                       color: const Color(0xFF142932),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 4.0),
//                           Container(
//                             height: 24.0,
//                             width: 75.0,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.rectangle,
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(6.0),
//                               ),
//                               color: Color(0xFFC8D4DA),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 7.0, vertical: 5.0),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Icon(
//                                     MingCuteIcons.mgc_close_line,
//                                     color: Color(0xFF09244B),
//                                     size: 16.0,
//                                   ),
//                                   const SizedBox(width: 1.0),
//                                   Text(
//                                     widget.dataTidakAcc,
//                                     style: GoogleFonts.inter(
//                                       fontSize: 10.0,
//                                       fontWeight: FontWeight.w600,
//                                       color: const Color(0xFF142932),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 3.0),
//                       Container(
//                         height: 24.0,
//                         width: 75.0,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.rectangle,
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(6.0),
//                           ),
//                           color: Color(0xFFC8D4DA),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 7.0,
//                             vertical: 6.0,
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Icon(
//                                 MingCuteIcons.mgc_loading_2_line,
//                                 color: Color(0xFF09244B),
//                                 size: 16.0,
//                               ),
//                               const SizedBox(width: 1.0),
//                               Text(
//                                 widget.dataDiproses,
//                                 style: GoogleFonts.inter(
//                                   fontSize: 10.0,
//                                   fontWeight: FontWeight.w600,
//                                   color: const Color(0xFF142932),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 12.0,
//                   ),
//                   Expanded(
//                     child: Column(
//                       children: [
//                         OutlinedButton(
//                           onPressed: () {
//                             Get.toNamed(widget.alamatInformasiLanjutan);
//                           },
//                           style: OutlinedButton.styleFrom(
//                             shape: const RoundedRectangleBorder(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(10.0),
//                               ),
//                             ),
//                             minimumSize: const Size(87.0, 17.0),
//                             padding: const EdgeInsets.all(
//                               10.0,
//                             ),
//                             backgroundColor: pageModeScheme.secondary,
//                             side: BorderSide(color: pageModeScheme.onSecondary),
//                           ),
//                           child: Row(
//                             children: [
//                               Text(
//                                 'Informasi lebih lanjut',
//                                 style: GoogleFonts.inter(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 8.0,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 3.0,
//                               ),
//                               const Icon(
//                                 Icons.chevron_right,
//                                 size: 11.0,
//                                 color: Colors.black,
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const Flexible(
//                 child: Image(
//                   image: AssetImage("assets/images/cartoon_informasi_dua.png"),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class dashboardInformasiPeminjaman extends StatefulWidget {
  const dashboardInformasiPeminjaman({
    Key? key,
    required this.namaMesin,
    required this.dataAcc,
    required this.dataTidakAcc,
    required this.dataDiproses,
    required this.alamatInformasiLanjutan,
  }) : super(key: key);

  final String namaMesin;
  final String dataAcc;
  final String dataTidakAcc;
  final String dataDiproses;
  final String alamatInformasiLanjutan;

  @override
  State<dashboardInformasiPeminjaman> createState() =>
      _dashboardInformasiPeminjamanState();
}

class _dashboardInformasiPeminjamanState
    extends State<dashboardInformasiPeminjaman> {
  final CountController countC = Get.put(CountController());
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 360;
        return Container(
          constraints: BoxConstraints(
            minHeight: 170,
            maxHeight: isSmallScreen ? 220 : 200,
          ),
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: pageModeScheme.onPrimary,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEE, d MMM yyyy').format(DateTime.now()),
                        style: GoogleFonts.inter(
                          fontSize: 8.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6.0), //8.0
                      Row(
                        children: [
                          Icon(MingCuteIcons.mgc_information_line, size: 12.0),
                          const SizedBox(width: 2.0),
                          Flexible(
                            child: Text(
                              "Informasi Data Peminjaman",
                              style: GoogleFonts.inter(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF294D5C),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2.0), //4.0
                      Text(
                        widget.namaMesin,
                        style: GoogleFonts.inter(
                          fontSize: isSmallScreen ? 18.0 : 22.0,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF738E99),
                        ),
                      ),
                      const SizedBox(height: 6.0), //8.0
                      Row(
                        children: [
                          _buildDataChip(
                              MingCuteIcons.mgc_check_line, widget.dataAcc),
                          const SizedBox(width: 4.0),
                          _buildDataChip(MingCuteIcons.mgc_close_line,
                              widget.dataTidakAcc),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      _buildDataChip(MingCuteIcons.mgc_loading_2_line,
                          widget.dataDiproses),
                      const Spacer(),
                      SizedBox(
                        height: 20, // Fixed height for the button
                        child: OutlinedButton(
                          onPressed: () =>
                              Get.toNamed(widget.alamatInformasiLanjutan),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 2.0),
                            backgroundColor: pageModeScheme.secondary,
                            side: BorderSide(color: pageModeScheme.onSecondary),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Informasi lebih lanjut',
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 6.0,
                                ),
                              ),
                              const SizedBox(width: 2.0),
                              const Icon(
                                Icons.chevron_right,
                                size: 8.0,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: constraints.maxWidth *
                          0.95, // Mengatur lebar gambar menjadi 25% dari lebar total
                      child: Image.asset(
                        "assets/images/cartoon_informasi_dua.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDataChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFC8D4DA),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.0,
            color: const Color(0xFF09244B),
          ),
          const SizedBox(width: 4.0),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
