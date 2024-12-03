// library backend
import 'package:build_app/models/getPeminjamanAllAdmin_model.dart';
import 'package:build_app/controller/peminjamanUserAllbyAdmin_controller.dart';
import 'package:build_app/enums/machine_type.dart';
// library frontend
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

class detailPageLasercut extends StatefulWidget {
  detailPageLasercut({Key? key}) : super(key: key);

  @override
  State<detailPageLasercut> createState() => _detailPageLasercutState();
}

class _detailPageLasercutState extends State<detailPageLasercut> {
  // final PeminjamanUserAllbyAdminController _controller = Get.put(
  //     PeminjamanUserAllbyAdminController(MachineType.LaserCutting),
  //     tag: 'laser');

  late final PeminjamanUserAllbyAdminController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<PeminjamanUserAllbyAdminController>(tag: 'laser');
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
        title: Text("Monitoring Laser Cutting"),
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
//                 "Data Permintaan Peminjaman Laser Cutting",
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
//         // IconButton(
//         //   onPressed: _controller.selectedCheckboxes.isNotEmpty
//         //       ? () {
//         //           _controller
//         //               .deletePeminjaman(_controller.selectedCheckboxes.first);
//         //         }
//         //       : null,
//         //   icon: const Icon(MingCuteIcons.mgc_delete_2_line),
//         // ),
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
//             border: Border.all(color: const Color(0xFFE0E0E0)),
//           ),
//           padding: const EdgeInsets.only(left: 4.0, right: 4.0),
//           child: Obx(
//             () => DropdownButton<String>(
//               hint: Text(
//                 "Filter",
//                 style: GoogleFonts.inter(),
//               ),
//               value: _controller.statusFilter.value,
//               isExpanded: true,
//               underline: Container(),
//               icon: const Iconify(
//                 Bx.bx_slider_alt,
//                 size: 18.0,
//               ),
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
//               border: Border.all(color: const Color(0xFFE0E0E0)),
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             child: TextField(
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 hintText: "Cari",
//                 contentPadding:
//                     EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
//           icon: const Icon(MingCuteIcons.mgc_file_export_line),
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
