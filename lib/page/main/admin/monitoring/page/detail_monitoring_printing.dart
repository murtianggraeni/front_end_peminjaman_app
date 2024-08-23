import 'package:build_app/controller/peminjamanUserAllbyAdmin_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

import '../../../../../models/getPeminjamanAllAdmin_model.dart';
import '../../../../../enums/machine_type.dart';

class detailPagePrinting extends StatelessWidget {
  final PeminjamanUserAllbyAdminController _controller = Get.put(
      PeminjamanUserAllbyAdminController(MachineType.Printing),
      tag: 'printing');

  detailPagePrinting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFF757575), size: 20.0),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 15.5,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Data Permintaan Peminjaman",
                style: GoogleFonts.inter(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6B7888),
                ),
              ),
              const SizedBox(height: 20.0),
              _buildFilterRow(),
              const SizedBox(height: 20.0),
              Expanded(
                child: _buildDataTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: [
        IconButton(
          onPressed: _controller.selectedCheckboxes.isNotEmpty
              ? () {
                  _controller
                      .deletePeminjaman(_controller.selectedCheckboxes.first);
                }
              : null,
          icon: const Icon(MingCuteIcons.mgc_delete_2_line),
        ),
        const SizedBox(width: 10.0),
        Container(
          width: 120.0,
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          child: Obx(
            () => DropdownButton<String>(
              hint: const Text("Filter"),
              value: _controller.statusFilter.value,
              isExpanded: true,
              icon: const Iconify(Bx.bx_slider_alt),
              items: _controller.filterItem.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(
                    status,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                _controller.statusFilter.value = value!;
                _controller.filterPeminjaman();
              },
            ),
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Container(
            height: 40.0,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Cari",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                prefixIcon: Icon(MingCuteIcons.mgc_search_3_line),
              ),
              onChanged: (value) {
                _controller.filter.value = value;
                _controller.filterPeminjaman();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Obx(
        () => DataTable2(
          columns: const [
            DataColumn2(
              label: Text('Nama Pemohon'),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text('Status Verifikasi'),
              size: ColumnSize.M,
            ),
            DataColumn2(
              label: Text('Aksi'),
              size: ColumnSize.L,
            ),
          ],
          rows: _controller.peminjaman.map((peminjaman) {
            return DataRow2(
              cells: [
                DataCell(Text(peminjaman.namaPemohon)),
                DataCell(_buildStatusCell(peminjaman)),
                DataCell(_buildActionButtons(Get.context!, peminjaman)),
              ],
              selected: _controller.selectedCheckboxes
                  .contains(peminjaman.namaPemohon),
              onSelectChanged: (selected) {
                _controller.onSelectedRow(selected!, peminjaman);
              },
            );
          }).toList(),
          horizontalMargin: 12,
          minWidth: 600,
          columnSpacing: 20,
          fixedTopRows: 1,
          showCheckboxColumn: true,
          checkboxHorizontalMargin: 12,
        ),
      ),
    );
  }

  Widget _buildStatusCell(Datum peminjaman) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: _controller.getStatusColor(peminjaman.status),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        peminjaman.status,
        style: GoogleFonts.inter(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Datum peminjaman) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: peminjaman.status == "Menunggu"
              ? () => _controller.approvePeminjaman(context, peminjaman)
              : null,
          icon: Iconify(
            Bx.bx_check_circle,
            color: peminjaman.status == "Menunggu" ? Colors.green : Colors.grey,
          ),
        ),
        IconButton(
          onPressed: peminjaman.status == "Menunggu"
              ? () => _controller.rejectPeminjaman(context, peminjaman)
              : null,
          icon: Iconify(
            Bx.bx_x_circle,
            color: peminjaman.status == "Menunggu" ? Colors.red : Colors.grey,
          ),
        ),
        IconButton(
          onPressed: () => _controller.showDetails(context, peminjaman),
          icon: const Icon(MingCuteIcons.mgc_information_line),
        )
      ],
    );
  }
}