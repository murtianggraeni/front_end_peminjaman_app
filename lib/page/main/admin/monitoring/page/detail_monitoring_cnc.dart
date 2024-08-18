import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:build_app/controller/peminjamanUserAllbyAdmin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

import '../../../../../models/getPeminjamanAllAdmin_model.dart';

class detailPageCnc extends StatelessWidget {
  final PeminjamanUserAllbyAdminController _controller =
      Get.put(PeminjamanUserAllbyAdminController());

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
      extendBodyBehindAppBar: true,
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
              Row(
                children: [
                  IconButton(
                    onPressed: _controller.selectedCheckboxes.isNotEmpty
                        ? () {
                            _controller.deletePeminjaman(
                                _controller.selectedCheckboxes.first);
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
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
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: StreamBuilder<List<Datum>>(
                  stream: _controller.sensorStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text("Tidak ada data peminjaman."));
                    }

                    final filteredList = snapshot.data!;

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        // sortAscending: _controller.sortAscending,
                        columns: [
                          DataColumn(
                            label: const Text("Nama Pemohon"),
                            onSort: (columnIndex, ascending) {
                              // _controller.sortPeminjaman();
                            },
                          ),
                          DataColumn(
                            label: const Text("Status Verifikasi"),
                            onSort: (columnIndex, ascending) {
                              _controller.sortStatus();
                            },
                          ),
                          const DataColumn(label: Text("Aksi")),
                        ],
                        rows: filteredList.map((peminjaman) {
                          return DataRow(
                            selected: _controller.selectedCheckboxes
                                .contains(peminjaman.namaPemohon),
                            onSelectChanged: (selected) {
                              _controller.onSelectedRow(selected!, peminjaman);
                            },
                            cells: [
                              DataCell(
                                Text(
                                  peminjaman.namaPemohon,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: _controller
                                        .getStatusColor(peminjaman.status),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Text(
                                    peminjaman.status,
                                    style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      onPressed: peminjaman.status == "Menunggu"
                                          ? () => _controller.approvePeminjaman(
                                              context, peminjaman)
                                          : null,
                                      icon: Iconify(
                                        Bx.bx_check_circle,
                                        color: peminjaman.status == "Menunggu"
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: peminjaman.status == "Menunggu"
                                          ? () => _controller.rejectPeminjaman(
                                              context, peminjaman)
                                          : null,
                                      icon: Iconify(
                                        Bx.bx_x_circle,
                                        color: peminjaman.status == "Menunggu"
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => {},
                                      icon: const Icon(
                                          MingCuteIcons.mgc_information_line),
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
