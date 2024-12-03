import 'package:build_app/controller/peminjamanUserAllbyAdmin_controller.dart';
import 'package:build_app/models/getPeminjamanAllAdmin_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:data_table_2/data_table_2.dart';

class detailPageCnc extends StatefulWidget {
  detailPageCnc({Key? key}) : super(key: key);

  @override
  State<detailPageCnc> createState() => _detailPageCncState();
}

class _detailPageCncState extends State<detailPageCnc> {
  late final PeminjamanUserAllbyAdminController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<PeminjamanUserAllbyAdminController>(tag: 'cnc');
    _controller.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF2D3748), size: 24.0),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3748),
        ),
        title: Text("Monitoring CNC Milling"),
      ),
      body: SafeArea(
        child: Container(
          color: Color(0xFFF7FAFC),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24.0),
                _buildFilterRow(context),
                const SizedBox(height: 24.0),
                Expanded(
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: _buildDataTable(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(MingCuteIcons.mgc_dashboard_2_line,
              color: Color(0xFF4A5568), size: 24),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Data Permintaan Peminjaman",
                style: GoogleFonts.inter(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 4),
              Obx(
                () => Text(
                  'Total Peminjaman: ${_controller.peminjaman.length}',
                  style: GoogleFonts.inter(
                    fontSize: 14.0,
                    color: Color(0xFF718096),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Obx(
            () => IconButton(
              onPressed: _controller.selectedCheckboxes.isNotEmpty
                  ? () => _controller.showDeleteConfirmationDialog(
                      context, _controller.selectedCheckboxes.first)
                  : null,
              icon: Icon(
                MingCuteIcons.mgc_delete_2_line,
                color: _controller.selectedCheckboxes.isNotEmpty
                    ? Color(0xFFE53E3E)
                    : Color(0xFFCBD5E0),
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 16),
          Container(
            width: 120,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFE2E8F0)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Obx(
              () => DropdownButton<String>(
                hint: Text("Filter", style: GoogleFonts.inter()),
                isExpanded: true,
                icon: Iconify(Bx.bx_slider_alt, size: 20),
                underline: Container(),
                value: _controller.statusFilter.value,
                items: _controller.filterItem.map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status,
                        style: GoogleFonts.inter(color: Color(0xFF4A5568))),
                  );
                }).toList(),
                onChanged: (value) {
                  _controller.statusFilter.value = value!;
                  _controller.filterPeminjaman();
                },
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                style: GoogleFonts.inter(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Cari pemohon...",
                  hintStyle: GoogleFonts.inter(color: Color(0xFFA0AEC0)),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  prefixIcon: Icon(MingCuteIcons.mgc_search_3_line,
                      color: Color(0xFF718096)),
                ),
                onChanged: (value) {
                  _controller.filter.value = value;
                  _controller.filterPeminjaman();
                },
              ),
            ),
          ),
          SizedBox(width: 16),
          IconButton(
            onPressed: () => _controller.exportToExcel(),
            icon: Icon(MingCuteIcons.mgc_file_export_line,
                color: Color(0xFF4A5568), size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(
        () => DataTable2(
          headingRowColor: MaterialStateProperty.all(Color(0xFFF7FAFC)),
          columns: [
            DataColumn2(
              label: Text(
                'Nama Pemohon',
                style: GoogleFonts.inter(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text(
                'Nomor Identitas',
                style: GoogleFonts.inter(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text(
                'Status',
                style: GoogleFonts.inter(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text(
                'Aksi',
                style: GoogleFonts.inter(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              size: ColumnSize.L,
            ),
          ],
          rows: _controller.filteredPeminjaman.map((peminjaman) {
            return DataRow2(
              color: MaterialStateProperty.all(Colors.white),
              cells: [
                DataCell(
                  Text(
                    peminjaman.namaPemohon,
                    style: GoogleFonts.inter(
                      color: Color(0xFF4A5568),
                      fontSize: 13.0,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    peminjaman.nomorIdentitas,
                    style: GoogleFonts.inter(
                      color: Color(0xFF4A5568),
                      fontSize: 13.0,
                    ),
                  ),
                ),
                DataCell(_buildStatusCell(peminjaman)),
                DataCell(_buildActionButtons(context, peminjaman)),
              ],
              selected: _controller.selectedCheckboxes.contains(peminjaman.id),
              onSelectChanged: (selected) {
                if (selected!) {
                  _controller.selectedCheckboxes.add(peminjaman.id);
                } else {
                  _controller.selectedCheckboxes.remove(peminjaman.id);
                }
                _controller.update();
              },
            );
          }).toList(),
          horizontalMargin: 12,
          minWidth: 700,
          columnSpacing: 24,
          fixedTopRows: 1,
          showCheckboxColumn: true,
          checkboxHorizontalMargin: 12,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
          ),
          dividerThickness: 1,
        ),
      ),
    );
  }

  // Widget _buildDataTable() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: Obx(
  //       () => DataTable2(
  //         columns: [
  //           DataColumn2(
  //             label: Text(
  //               'Nama Pemohon',
  //               style: GoogleFonts.inter(
  //                 fontSize: 14.0,
  //                 fontWeight: FontWeight.w600,
  //                 color: Color(0xFF2D3748),
  //               ),
  //             ),
  //             size: ColumnSize.L,
  //           ),
  //           DataColumn2(
  //             label: Text(
  //               'Nomor Identitas',
  //               style: GoogleFonts.inter(
  //                 fontSize: 14.0,
  //                 fontWeight: FontWeight.w600,
  //                 color: Color(0xFF2D3748),
  //               ),
  //             ),
  //             size: ColumnSize.L,
  //           ),
  //           DataColumn2(
  //             label: Text(
  //               'Status',
  //               style: GoogleFonts.inter(
  //                 fontSize: 14.0,
  //                 fontWeight: FontWeight.w600,
  //                 color: Color(0xFF2D3748),
  //               ),
  //             ),
  //             size: ColumnSize.L,
  //           ),
  //           DataColumn2(
  //             label: Text(
  //               'Aksi',
  //               style: GoogleFonts.inter(
  //                 fontSize: 14.0,
  //                 fontWeight: FontWeight.w600,
  //                 color: Color(0xFF2D3748),
  //               ),
  //             ),
  //             size: ColumnSize.L,
  //           ),
  //         ],
  //         rows: _controller.filteredPeminjaman.map((peminjaman) {
  //           return DataRow2(
  //             cells: [
  //               DataCell(
  //                 Text(
  //                   peminjaman.namaPemohon,
  //                   style: GoogleFonts.inter(color: Color(0xFF4A5568)),
  //                 ),
  //               ),
  //               DataCell(
  //                 Text(
  //                   peminjaman.nomorIdentitas,
  //                   style: GoogleFonts.inter(color: Color(0xFF4A5568)),
  //                 ),
  //               ),
  //               DataCell(_buildStatusCell(peminjaman)),
  //               DataCell(_buildActionButtons(context, peminjaman)),
  //             ],
  //             selected: _controller.selectedCheckboxes.contains(peminjaman.id),
  //             onSelectChanged: (selected) {
  //               if (selected!) {
  //                 _controller.selectedCheckboxes.add(peminjaman.id);
  //               } else {
  //                 _controller.selectedCheckboxes.remove(peminjaman.id);
  //               }
  //               _controller.update();
  //             },
  //           );
  //         }).toList(),
  //         horizontalMargin: 12,
  //         minWidth: 700,
  //         columnSpacing: 24,
  //         fixedTopRows: 1,
  //         showCheckboxColumn: true,
  //         checkboxHorizontalMargin: 12,
  //         decoration: BoxDecoration(
  //           border: Border.all(color: Color(0xFFE2E8F0)),
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildStatusCell(Datum peminjaman) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusBackgroundColor(peminjaman.status),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        peminjaman.status,
        style: GoogleFonts.inter(
          color: _getStatusTextColor(peminjaman.status),
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu':
        return Color(0xFFFEF3C7);
      case 'disetujui':
        return Color(0xFFDEFEE6);
      case 'ditolak':
        return Color(0xFFFFE6E6);
      default:
        return Color(0xFFF7FAFC);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu':
        return Color(0xFFB45309);
      case 'disetujui':
        return Color(0xFF059669);
      case 'ditolak':
        return Color(0xFFDC2626);
      default:
        return Color(0xFF4A5568);
    }
  }

  Widget _buildActionButtons(BuildContext context, Datum peminjaman) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: peminjaman.status == "Menunggu"
              ? () => _controller.approvePeminjaman(context, peminjaman)
              : null,
          icon: Iconify(
            Bx.bx_check_circle,
            color: peminjaman.status == "Menunggu"
                ? Color(0xFF059669)
                : Color(0xFFCBD5E0),
            size: 24,
          ),
        ),
        IconButton(
          onPressed: peminjaman.status == "Menunggu"
              ? () => _controller.rejectPeminjaman(context, peminjaman)
              : null,
          icon: Iconify(
            Bx.bx_x_circle,
            color: peminjaman.status == "Menunggu"
                ? Color(0xFFDC2626)
                : Color(0xFFCBD5E0),
            size: 24,
          ),
        ),
        IconButton(
          onPressed: () => _controller.showDetails(context, peminjaman),
          icon: Icon(
            MingCuteIcons.mgc_information_line,
            color: Color(0xFF4A5568),
            size: 24,
          ),
        ),
      ],
    );
  }
}

//   Widget _buildDataTable() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Obx(
//         () => DataTable2(
//           columns: [
//             DataColumn2(
//               label: Text(
//                 'Nama Pemohon',
//                 style: GoogleFonts.inter(
//                   fontSize: 14.0,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF2D3748),
//                 ),
//               ),
//               size: ColumnSize.L,
//             ),
//             DataColumn2(
//               label: Text(
//                 'Nomor Identitas',
//                 style: GoogleFonts.inter(
//                   fontSize: 14.0,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF2D3748),
//                 ),
//               ),
//               size: ColumnSize.L,
//             ),
//             DataColumn2(
//               label: Text(
//                 'Status',
//                 style: GoogleFonts.inter(
//                   fontSize: 14.0,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF2D3748),
//                 ),
//               ),
//               size: ColumnSize.L,
//             ),
//             DataColumn2(
//               label: Text(
//                 'Aksi',
//                 style: GoogleFonts.inter(
//                   fontSize: 14.0,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF2D3748),
//                 ),
//               ),
//               size: ColumnSize.L,
//             ),
//           ],
//           rows: _controller.filteredPeminjaman.map((peminjaman) {
//             return DataRow2(
//               cells: [
//                 DataCell(
//                   Text(
//                     peminjaman.namaPemohon,
//                     style: GoogleFonts.inter(color: Color(0xFF4A5568)),
//                   ),
//                 ),
//                 DataCell(
//                   Text(
//                     peminjaman.nomorIdentitas,
//                     style: GoogleFonts.inter(color: Color(0xFF4A5568)),
//                   ),
//                 ),
//                 DataCell(_buildStatusCell(peminjaman)),
//                 DataCell(_buildActionButtons(context, peminjaman)),
//               ],
//               selected: _controller.selectedCheckboxes.contains(peminjaman.id),
//               onSelectChanged: (selected) {
//                 if (selected!) {
//                   _controller.selectedCheckboxes.add(peminjaman.id);
//                 } else {
//                   _controller.selectedCheckboxes.remove(peminjaman.id);
//                 }
//                 _controller.update();
//               },
//             );
//           }).toList(),
//           horizontalMargin: 12,
//           minWidth: 700,
//           columnSpacing: 24,
//           fixedTopRows: 1,
//           showCheckboxColumn: true,
//           checkboxHorizontalMargin: 12,
//           decoration: BoxDecoration(
//             border: Border.all(color: Color(0xFFE2E8F0)),
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusCell(Datum peminjaman) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: _getStatusBackgroundColor(peminjaman.status),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Text(
//         peminjaman.status,
//         style: GoogleFonts.inter(
//           color: _getStatusTextColor(peminjaman.status),
//           fontWeight: FontWeight.w500,
//           fontSize: 13,
//         ),
//       ),
//     );
//   }

//   Color _getStatusBackgroundColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'menunggu':
//         return Color(0xFFFEF3C7);
//       case 'disetujui':
//         return Color(0xFFDEFEE6);
//       case 'ditolak':
//         return Color(0xFFFFE6E6);
//       default:
//         return Color(0xFFF7FAFC);
//     }
//   }

//   Color _getStatusTextColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'menunggu':
//         return Color(0xFFB45309);
//       case 'disetujui':
//         return Color(0xFF059669);
//       case 'ditolak':
//         return Color(0xFFDC2626);
//       default:
//         return Color(0xFF4A5568);
//     }
//   }

//   Widget _buildActionButtons(BuildContext context, Datum peminjaman) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           onPressed: peminjaman.status == "Menunggu"
//               ? () => _controller.approvePeminjaman(context, peminjaman)
//               : null,
//           icon: Iconify(
//             Bx.bx_check_circle,
//             color: peminjaman.status == "Menunggu"
//                 ? Color(0xFF059669)
//                 : Color(0xFFCBD5E0),
//             size: 24,
//           ),
//         ),
//         IconButton(
//           onPressed: peminjaman.status == "Menunggu"
//               ? () => _controller.rejectPeminjaman(context, peminjaman)
//               : null,
//           icon: Iconify(
//             Bx.bx_x_circle,
//             color: peminjaman.status == "Menunggu"
//                 ? Color(0xFFDC2626)
//                 : Color(0xFFCBD5E0),
//             size: 24,
//           ),
//         ),
//         IconButton(
//           onPressed: () => _controller.showDetails(context, peminjaman),
//           icon: Icon(
//             MingCuteIcons.mgc_information_line,
//             color: Color(0xFF4A5568),
//             size: 24,
//           ),
//         ),
//       ],
//     );
//   }
// }
// import 'package:build_app/controller/peminjamanUserAllbyAdmin_controller.dart';
// import 'package:build_app/models/getPeminjamanAllAdmin_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconify_flutter/iconify_flutter.dart';
// import 'package:iconify_flutter/icons/bx.dart';
// import 'package:ming_cute_icons/ming_cute_icons.dart';
// import 'package:data_table_2/data_table_2.dart';

// class detailPageCnc extends StatefulWidget {
//   detailPageCnc({Key? key}) : super(key: key);

//   @override
//   State<detailPageCnc> createState() => _detailPageCncState();
// }

// class _detailPageCncState extends State<detailPageCnc> {
//   late final PeminjamanUserAllbyAdminController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = Get.find<PeminjamanUserAllbyAdminController>(tag: 'cnc');
//     _controller.fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF8FAFC),
//       appBar: _buildAppBar(),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               _buildHeaderSection(),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 24),
//                     _buildStatsCards(),
//                     SizedBox(height: 24),
//                     _buildFilterSection(),
//                     SizedBox(height: 24),
//                     _buildDataTableSection(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.white,
//       leading: IconButton(
//         icon:
//             Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF1E293B)),
//         onPressed: () => Navigator.pop(context),
//       ),
//       title: Text(
//         "Monitoring CNC",
//         style: GoogleFonts.inter(
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//           color: Color(0xFF1E293B),
//         ),
//       ),
//       actions: [
//         IconButton(
//           icon:
//               Icon(MingCuteIcons.mgc_settings_2_line, color: Color(0xFF64748B)),
//           onPressed: () {}, // Add settings functionality
//         ),
//         SizedBox(width: 8),
//       ],
//     );
//   }

//   Widget _buildHeaderSection() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           bottom: BorderSide(
//             color: Color(0xFFE2E8F0),
//             width: 1,
//           ),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Dashboard Monitoring",
//             style: GoogleFonts.inter(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1E293B),
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             "Kelola dan pantau permintaan peminjaman mesin CNC",
//             style: GoogleFonts.inter(
//               fontSize: 14,
//               color: Color(0xFF64748B),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatsCards() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildStatCard(
//             "Total Permintaan",
//             "${_controller.peminjaman.length}",
//             MingCuteIcons.mgc_folder_line,
//             Color(0xFF3B82F6),
//           ),
//         ),
//         SizedBox(width: 16),
//         Expanded(
//           child: _buildStatCard(
//             "Menunggu",
//             "${_controller.peminjaman.where((p) => p.status == 'Menunggu').length}",
//             MingCuteIcons.mgc_time_line,
//             Color(0xFFF59E0B),
//           ),
//         ),
//         SizedBox(width: 16),
//         Expanded(
//           child: _buildStatCard(
//             "Disetujui",
//             "${_controller.peminjaman.where((p) => p.status == 'Disetujui').length}",
//             MingCuteIcons.mgc_check_circle_line,
//             Color(0xFF10B981),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard(
//       String title, String value, IconData icon, Color color) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF64748B).withOpacity(0.06),
//             blurRadius: 12,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(icon, color: color, size: 20),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           Text(
//             value,
//             style: GoogleFonts.inter(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1E293B),
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             title,
//             style: GoogleFonts.inter(
//               fontSize: 14,
//               color: Color(0xFF64748B),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterSection() {
//     return Container(
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF64748B).withOpacity(0.06),
//             blurRadius: 12,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(
//                 "Filter & Pencarian",
//                 style: GoogleFonts.inter(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//               Spacer(),
//               _buildExportButton(),
//             ],
//           ),
//           SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(child: _buildSearchField()),
//               SizedBox(width: 16),
//               _buildFilterDropdown(),
//               SizedBox(width: 16),
//               _buildDeleteButton(),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return Container(
//       height: 44,
//       decoration: BoxDecoration(
//         color: Color(0xFFF1F5F9),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: TextField(
//         style: GoogleFonts.inter(fontSize: 14),
//         decoration: InputDecoration(
//           hintText: "Cari nama pemohon...",
//           hintStyle: GoogleFonts.inter(
//             color: Color(0xFF94A3B8),
//             fontSize: 14,
//           ),
//           prefixIcon: Icon(
//             MingCuteIcons.mgc_search_3_line,
//             color: Color(0xFF64748B),
//             size: 20,
//           ),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 16),
//         ),
//         onChanged: (value) {
//           _controller.filter.value = value;
//           _controller.filterPeminjaman();
//         },
//       ),
//     );
//   }

//   Widget _buildFilterDropdown() {
//     return Container(
//       height: 44,
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Color(0xFFF1F5F9),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: Obx(
//           () => DropdownButton<String>(
//             value: _controller.statusFilter.value,
//             hint: Text(
//               "Filter Status",
//               style: GoogleFonts.inter(
//                 fontSize: 14,
//                 color: Color(0xFF64748B),
//               ),
//             ),
//             icon: Icon(MingCuteIcons.mgc_down_line, size: 20),
//             style: GoogleFonts.inter(
//               fontSize: 14,
//               color: Color(0xFF1E293B),
//             ),
//             items: _controller.filterItem.map((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//             onChanged: (value) {
//               _controller.statusFilter.value = value!;
//               _controller.filterPeminjaman();
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildExportButton() {
//     return ElevatedButton.icon(
//       onPressed: () => _controller.exportToExcel(),
//       icon: Icon(MingCuteIcons.mgc_file_export_line, size: 20),
//       label: Text(
//         "Export",
//         style: GoogleFonts.inter(
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Color(0xFF3B82F6),
//         foregroundColor: Colors.white,
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }

//   Widget _buildDeleteButton() {
//     return Obx(
//       () => IconButton(
//         onPressed: _controller.selectedCheckboxes.isNotEmpty
//             ? () => _controller.showDeleteConfirmationDialog(
//                 context, _controller.selectedCheckboxes.first)
//             : null,
//         icon: Icon(
//           MingCuteIcons.mgc_delete_2_line,
//           color: _controller.selectedCheckboxes.isNotEmpty
//               ? Color(0xFFEF4444)
//               : Color(0xFFCBD5E0),
//         ),
//         style: IconButton.styleFrom(
//           backgroundColor: _controller.selectedCheckboxes.isNotEmpty
//               ? Color(0xFFEF4444).withOpacity(0.1)
//               : Color(0xFFE2E8F0),
//           padding: EdgeInsets.all(12),
//         ),
//       ),
//     );
//   }

//   Widget _buildDataTableSection() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF64748B).withOpacity(0.06),
//             blurRadius: 12,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(20),
//             child: Text(
//               "Daftar Permintaan",
//               style: GoogleFonts.inter(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1E293B),
//               ),
//             ),
//           ),
//           _buildDataTable(),
//         ],
//       ),
//     );
//   }

//   Widget _buildDataTable() {
//     return Obx(
//       () => DataTable2(
//         columns: [
//           DataColumn2(
//             label: Text(
//               'Nama Pemohon',
//               style: GoogleFonts.inter(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1E293B),
//               ),
//             ),
//             size: ColumnSize.L,
//           ),
//           DataColumn2(
//             label: Text(
//               'Nomor Identitas',
//               style: GoogleFonts.inter(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1E293B),
//               ),
//             ),
//             size: ColumnSize.L,
//           ),
//           DataColumn2(
//             label: Text(
//               'Status',
//               style: GoogleFonts.inter(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1E293B),
//               ),
//             ),
//             size: ColumnSize.M,
//           ),
//           DataColumn2(
//             label: Text(
//               'Aksi',
//               style: GoogleFonts.inter(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1E293B),
//               ),
//             ),
//             size: ColumnSize.S,
//           ),
//         ],
//         rows: _controller.filteredPeminjaman.map((peminjaman) {
//           return DataRow2(
//             cells: [
//               DataCell(
//                 Text(
//                   peminjaman.namaPemohon,
//                   style: GoogleFonts.inter(
//                     fontSize: 14,
//                     color: Color(0xFF334155),
//                   ),
//                 ),
//               ),
//               DataCell(
//                 Text(
//                   peminjaman.nomorIdentitas,
//                   style: GoogleFonts.inter(
//                     fontSize: 14,
//                     color: Color(0xFF334155),
//                   ),
//                 ),
//               ),
//               DataCell(_buildStatusBadge(peminjaman)),
//               DataCell(_buildActionButtons(context, peminjaman)),
//             ],
//             selected: _controller.selectedCheckboxes.contains(peminjaman.id),
//             onSelectChanged: (selected) {
//               if (selected!) {
//                 _controller.selectedCheckboxes.add(peminjaman.id);
//               } else {
//                 _controller.selectedCheckboxes.remove(peminjaman.id);
//               }
//               _controller.update();
//             },
//           );
//         }).toList(),
//         horizontalMargin: 20,
//         checkboxHorizontalMargin: 12,
//         columnSpacing: 24,
//         showCheckboxColumn: true,
//         // Lanjutan dari DataTable2 sebelumnya...
//         dividerThickness: 1,
//         headingRowHeight: 56,
//         dataRowHeight: 72,
        
//         minWidth: 900,
//         border: TableBorder(
//           horizontalInside: BorderSide(
//             color: Color(0xFFE2E8F0),
//             width: 1,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusBadge(Datum peminjaman) {
//     final Map<String, Map<String, Color>> statusStyles = {
//       'menunggu': {
//         'bg': Color(0xFFFEF9C3),
//         'text': Color(0xFFCA8A04),
//         'border': Color(0xFFFCD34D),
//       },
//       'disetujui': {
//         'bg': Color(0xFFDCFCE7),
//         'text': Color(0xFF059669),
//         'border': Color(0xFF6EE7B7),
//       },
//       'ditolak': {
//         'bg': Color(0xFFFFE4E6),
//         'text': Color(0xFFDC2626),
//         'border': Color(0xFFFCA5A5),
//       },
//     };

//     final status = peminjaman.status.toLowerCase();
//     final style = statusStyles[status] ?? statusStyles['menunggu']!;

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: style['bg'],
//         border: Border.all(color: style['border']!),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 6,
//             height: 6,
//             decoration: BoxDecoration(
//               color: style['text'],
//               shape: BoxShape.circle,
//             ),
//           ),
//           SizedBox(width: 8),
//           Text(
//             peminjaman.status,
//             style: GoogleFonts.inter(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: style['text'],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons(BuildContext context, Datum peminjaman) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (peminjaman.status == "Menunggu") ...[
//           _buildActionButton(
//             onPressed: () => _controller.approvePeminjaman(context, peminjaman),
//             icon: Bx.bx_check_circle,
//             color: Color(0xFF059669),
//             tooltip: 'Setujui',
//           ),
//           SizedBox(width: 8),
//           _buildActionButton(
//             onPressed: () => _controller.rejectPeminjaman(context, peminjaman),
//             icon: Bx.bx_x_circle,
//             color: Color(0xFFDC2626),
//             tooltip: 'Tolak',
//           ),
//         ],
//         SizedBox(width: 8),
//         _buildActionButton(
//           onPressed: () => _controller.showDetails(context, peminjaman),
//           icon: Bx.bx_info_circle,
//           color: Color(0xFF3B82F6),
//           tooltip: 'Detail',
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButton({
//     required VoidCallback onPressed,
//     required String icon,
//     required Color color,
//     required String tooltip,
//   }) {
//     return Tooltip(
//       message: tooltip,
//       child: Container(
//         width: 32,
//         height: 32,
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: onPressed,
//             borderRadius: BorderRadius.circular(8),
//             child: Center(
//               child: Iconify(
//                 icon,
//                 color: color,
//                 size: 18,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Tambahan helper method untuk format tanggal
//   String _formatDate(DateTime date) {
//     return "${date.day}-${date.month}-${date.year}";
//   }

//   // Tambahan widget untuk menampilkan detail dialog
//   void _showDetailDialog(BuildContext context, Datum peminjaman) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Container(
//           padding: EdgeInsets.all(24),
//           constraints: BoxConstraints(maxWidth: 500),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Detail Peminjaman',
//                     style: GoogleFonts.inter(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1E293B),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.close),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 24),
//               _buildDetailItem('Nama Pemohon', peminjaman.namaPemohon),
//               _buildDetailItem('Nomor Identitas', peminjaman.nomorIdentitas),
//               _buildDetailItem('Status', peminjaman.status),
//               _buildDetailItem(
//                   'Tanggal Pengajuan', _formatDate(DateTime.now())),
//               SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text(
//                       'Tutup',
//                       style: GoogleFonts.inter(
//                         color: Color(0xFF64748B),
//                       ),
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

//   Widget _buildDetailItem(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.inter(
//               fontSize: 12,
//               color: Color(0xFF64748B),
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             value,
//             style: GoogleFonts.inter(
//               fontSize: 14,
//               color: Color(0xFF1E293B),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // --- Methode 2: detailMonitoringCnc.dart --
// // library backend
// import 'package:build_app/controller/peminjamanUserAllbyAdmin_controller.dart';
// import 'package:build_app/models/getPeminjamanAllAdmin_model.dart';
// import 'package:build_app/enums/machine_type.dart';
// import 'package:build_app/page/main/admin/monitoring/monitoring_bindings.dart';
// // library frontend
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconify_flutter/iconify_flutter.dart';
// import 'package:iconify_flutter/icons/bx.dart';
// import 'package:ming_cute_icons/ming_cute_icons.dart';
// import 'package:data_table_2/data_table_2.dart';

// class detailPageCnc extends StatefulWidget {
//   detailPageCnc({Key? key}) : super(key: key);

//   @override
//   State<detailPageCnc> createState() => _detailPageCncState();
// }

// class _detailPageCncState extends State<detailPageCnc> {
//   // final PeminjamanUserAllbyAdminController _controller =
//   //     Get.put(PeminjamanUserAllbyAdminController(MachineType.CNC), tag: 'cnc');

//   late final PeminjamanUserAllbyAdminController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = Get.find<PeminjamanUserAllbyAdminController>(tag: 'cnc');
//     _controller.fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         iconTheme: const IconThemeData(color: Color(0xFF757575), size: 20.0),
//         titleTextStyle: GoogleFonts.inter(
//           fontSize: 15.5,
//           fontWeight: FontWeight.w500,
//         ),
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Data Permintaan Peminjaman CNC Milling",
//                 style: GoogleFonts.inter(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xFF6B7888),
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               Obx(
//                 () => Text(
//                   'Total Peminjaman: ${_controller.peminjaman.length}',
//                   style: GoogleFonts.inter(
//                     fontSize: 14.0,
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xFF6B7888),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20.0),
//               _buildFilterRow(context),
//               const SizedBox(height: 20.0),
//               Expanded(
//                 child: _buildDataTable(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterRow(BuildContext context) {
//     return Row(
//       children: [
//         Obx(
//           () => IconButton(
//             onPressed: _controller.selectedCheckboxes.isNotEmpty
//                 ? () {
//                     // Ambil ID dari peminjaman yang dipilih
//                     String selectedId = _controller.selectedCheckboxes.first;
//                     // Panggil fungsi showDeleteConfirmationDialog dengan ID
//                     _controller.showDeleteConfirmationDialog(
//                         context, selectedId);
//                   }
//                 : null,
//             icon: Icon(
//               MingCuteIcons.mgc_delete_2_line,
//               color: _controller.selectedCheckboxes.isNotEmpty
//                   ? Colors.red
//                   : Colors.grey,
//             ),
//           ),
//         ),
//         const SizedBox(width: 10.0),
//         Container(
//           width: 90.0,
//           height: 40.0,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8.0),
//             border: Border.all(
//               color: const Color(0xFFE0E0E0),
//             ),
//           ),
//           padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//           child: Obx(
//             () => DropdownButton<String>(
//               hint: Text(
//                 "Filter",
//                 style: GoogleFonts.inter(),
//               ),
//               isExpanded: true,
//               icon: const Iconify(
//                 Bx.bx_slider_alt,
//                 size: 18.0,
//               ),
//               underline: Container(),
//               value: _controller.statusFilter.value,
//               items: _controller.filterItem.map((status) {
//                 return DropdownMenuItem<String>(
//                   value: status,
//                   child: Text(
//                     status,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 _controller.statusFilter.value = value!;
//                 _controller.filterPeminjaman();
//               },
//             ),
//           ),
//         ),
//         const SizedBox(width: 10.0),
//         Expanded(
//           child: Container(
//             height: 40.0,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: const Color(0xFFE0E0E0),
//               ),
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             child: TextField(
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 hintText: "Cari",
//                 contentPadding: EdgeInsets.symmetric(
//                   vertical: 8.0,
//                   horizontal: 8.0,
//                 ),
//                 prefixIcon: Icon(MingCuteIcons.mgc_search_3_line),
//               ),
//               onChanged: (value) {
//                 _controller.filter.value = value;
//                 _controller.filterPeminjaman();
//               },
//             ),
//           ),
//         ),
//         IconButton(
//           onPressed: () {
//             _controller.exportToExcel();
//           },
//           icon: Icon(MingCuteIcons.mgc_file_export_line),
//         ),
//       ],
//     );
//   }

//   Widget _buildDataTable() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 25.0),
//       child: Obx(
//         () => DataTable2(
//           columns: [
//             DataColumn2(
//               label: Text(
//                 'Nama Pemohon',
//                 style: GoogleFonts.inter(
//                   fontSize: 15.0,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               size: ColumnSize.L,
//             ),
//             DataColumn2(
//               label: Text(
//                 'Nomor Identitas',
//                 style: GoogleFonts.inter(
//                   fontSize: 15.0,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               size: ColumnSize.L,
//             ),
//             DataColumn2(
//               label: Text(
//                 'Status Verifikasi',
//                 style: GoogleFonts.inter(
//                   fontSize: 15.0,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               size: ColumnSize.L,
//             ),
//             DataColumn2(
//               label: Text(
//                 'Aksi',
//                 style: GoogleFonts.inter(
//                   fontSize: 15.0,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               size: ColumnSize.L,
//             ),
//           ],
//           rows: _controller.filteredPeminjaman.map((peminjaman) {
//             // _controller.peminjaman.map((peminjaman) {
//             return DataRow2(
//               cells: [
//                 DataCell(
//                   Text(
//                     peminjaman.namaPemohon,
//                     style: GoogleFonts.inter(),
//                   ),
//                 ),
//                 DataCell(
//                   Text(
//                     peminjaman.nomorIdentitas,
//                     style: GoogleFonts.inter(),
//                   ),
//                 ),
//                 DataCell(_buildStatusCell(peminjaman)),
//                 DataCell(_buildActionButtons(Get.context!, peminjaman)),
//               ],
//               selected: _controller.selectedCheckboxes
//                   .contains(peminjaman.id), // Pastikan menggunakan ID
//               onSelectChanged: (selected) {
//                 if (selected != null && selected) {
//                   _controller.selectedCheckboxes
//                       .add(peminjaman.id); // Tambahkan ID ke list
//                 } else if (selected != null && !selected) {
//                   _controller.selectedCheckboxes
//                       .remove(peminjaman.id); // Hapus ID dari list
//                 }
//                 _controller.update(); // Update UI setelah perubahan
//               },

//               // selected: _controller.selectedCheckboxes
//               //     .contains(peminjaman.namaPemohon),
//               // onSelectChanged: (selected) {
//               //   _controller.onSelectedRow(selected!, peminjaman);
//               // },
//             );
//           }).toList(),
//           horizontalMargin: 12,
//           minWidth: 700,
//           columnSpacing: 20,
//           fixedTopRows: 1,
//           showCheckboxColumn: true,
//           checkboxHorizontalMargin: 12,
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusCell(Datum peminjaman) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//       decoration: BoxDecoration(
//         color: _controller.getStatusColor(peminjaman.status),
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: Text(
//         peminjaman.status,
//         style: GoogleFonts.inter(
//           color: Colors.black,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButtons(BuildContext context, Datum peminjaman) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         IconButton(
//           onPressed: peminjaman.status == "Menunggu"
//               ? () => _controller.approvePeminjaman(context, peminjaman)
//               : null,
//           icon: Iconify(
//             Bx.bx_check_circle,
//             color: peminjaman.status == "Menunggu" ? Colors.green : Colors.grey,
//           ),
//         ),
//         IconButton(
//           onPressed: peminjaman.status == "Menunggu"
//               ? () => _controller.rejectPeminjaman(context, peminjaman)
//               : null,
//           icon: Iconify(
//             Bx.bx_x_circle,
//             color: peminjaman.status == "Menunggu" ? Colors.red : Colors.grey,
//           ),
//         ),
//         IconButton(
//           onPressed: () => _controller.showDetails(context, peminjaman),
//           icon: const Icon(MingCuteIcons.mgc_information_line),
//         )
//       ],
//     );
//   }
// }

// ---------------------------------------------------------------------------------- //

// import 'package:build_app/controller/peminjamanUserAllbyAdmin_controller.dart';
// import 'package:build_app/enums/machine_type.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconify_flutter/iconify_flutter.dart';
// import 'package:iconify_flutter/icons/bx.dart';
// import 'package:ming_cute_icons/ming_cute_icons.dart';

// import '../../../../../models/getPeminjamanAllAdmin_model.dart';

// class detailPageCnc extends StatelessWidget {
//   final PeminjamanUserAllbyAdminController _controller =
//       Get.put(PeminjamanUserAllbyAdminController(MachineType.CNC), tag: 'cnc');

//   detailPageCnc({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         iconTheme: const IconThemeData(color: Color(0xFF757575), size: 20.0),
//         titleTextStyle: GoogleFonts.inter(
//           fontSize: 15.5,
//           fontWeight: FontWeight.w500,
//         ),
//         elevation: 0,
//       ),
//       extendBodyBehindAppBar: true,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Data Permintaan Peminjaman",
//                 style: GoogleFonts.inter(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xFF6B7888),
//                 ),
//               ),
//               const SizedBox(height: 20.0),
//               Row(
//                 children: [
//                   IconButton(
//                     onPressed: _controller.selectedCheckboxes.isNotEmpty
//                         ? () {
//                             _controller.deletePeminjaman(
//                                 _controller.selectedCheckboxes.first);
//                           }
//                         : null,
//                     icon: const Icon(MingCuteIcons.mgc_delete_2_line),
//                   ),
//                   const SizedBox(width: 10.0),
//                   Container(
//                     width: 120.0,
//                     height: 40.0,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8.0),
//                       border: Border.all(color: const Color(0xFFE0E0E0)),
//                     ),
//                     padding: const EdgeInsets.only(left: 4.0, right: 4.0),
//                     child: Obx(
//                       () => DropdownButton<String>(
//                         hint: const Text("Filter"),
//                         value: _controller.statusFilter.value,
//                         isExpanded: true,
//                         icon: const Iconify(Bx.bx_slider_alt),
//                         items: _controller.filterItem.map((status) {
//                           return DropdownMenuItem<String>(
//                             value: status,
//                             child: Text(
//                               status,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           _controller.statusFilter.value = value!;
//                           _controller.filterPeminjaman();
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10.0),
//                   Expanded(
//                     child: Container(
//                       height: 40.0,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: const Color(0xFFE0E0E0)),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: TextField(
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           hintText: "Cari",
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 8.0, horizontal: 8.0),
//                           prefixIcon: Icon(MingCuteIcons.mgc_search_3_line),
//                         ),
//                         onChanged: (value) {
//                           _controller.filter.value = value;
//                           _controller.filterPeminjaman();
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20.0),
//               Expanded(
//                 child: StreamBuilder<List<Datum>>(
//                   stream: _controller.sensorStream,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     if (snapshot.hasError) {
//                       return Center(child: Text("Error: ${snapshot.error}"));
//                     }
//                     if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return const Center(
//                           child: Text("Tidak ada data peminjaman."));
//                     }

//                     final filteredList = snapshot.data!;

//                     return SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: DataTable(
//                         // sortAscending: _controller.sortAscending,
//                         columns: [
//                           DataColumn(
//                             label: const Text("Nama Pemohon"),
//                             onSort: (columnIndex, ascending) {
//                               // _controller.sortPeminjaman();
//                             },
//                           ),
//                           DataColumn(
//                             label: const Text("Status Verifikasi"),
//                             onSort: (columnIndex, ascending) {
//                               _controller.sortStatus();
//                             },
//                           ),
//                           const DataColumn(label: Text("Aksi")),
//                         ],
//                         rows: filteredList.map((peminjaman) {
//                           return DataRow(
//                             selected: _controller.selectedCheckboxes
//                                 .contains(peminjaman.namaPemohon),
//                             onSelectChanged: (selected) {
//                               _controller.onSelectedRow(selected!, peminjaman);
//                             },
//                             cells: [
//                               DataCell(
//                                 Text(
//                                   peminjaman.namaPemohon,
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 2,
//                                 ),
//                               ),
//                               DataCell(
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 8.0, vertical: 4.0),
//                                   decoration: BoxDecoration(
//                                     color: _controller
//                                         .getStatusColor(peminjaman.status),
//                                     borderRadius: BorderRadius.circular(12.0),
//                                   ),
//                                   child: Text(
//                                     peminjaman.status,
//                                     style: GoogleFonts.inter(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               DataCell(
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     IconButton(
//                                       onPressed: peminjaman.status == "Menunggu"
//                                           ? () => _controller.approvePeminjaman(
//                                               context, peminjaman)
//                                           : null,
//                                       icon: Iconify(
//                                         Bx.bx_check_circle,
//                                         color: peminjaman.status == "Menunggu"
//                                             ? Colors.green
//                                             : Colors.grey,
//                                       ),
//                                     ),
//                                     IconButton(
//                                       onPressed: peminjaman.status == "Menunggu"
//                                           ? () => _controller.rejectPeminjaman(
//                                               context, peminjaman)
//                                           : null,
//                                       icon: Iconify(
//                                         Bx.bx_x_circle,
//                                         color: peminjaman.status == "Menunggu"
//                                             ? Colors.red
//                                             : Colors.grey,
//                                       ),
//                                     ),
//                                     IconButton(
//                                       onPressed: () => _controller.showDetails(
//                                           context, peminjaman),
//                                       icon: const Icon(
//                                           MingCuteIcons.mgc_information_line),
//                                     )
//                                   ],
//                                 ),
//                               )
//                             ],
//                           );
//                         }).toList(),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
