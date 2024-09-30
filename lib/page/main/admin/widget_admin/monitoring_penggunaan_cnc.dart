
import 'package:build_app/controller/monitoring_controller.dart';
import 'package:build_app/enums/machine_type.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class monitoringPenggunaanCnc extends StatelessWidget {
  monitoringPenggunaanCnc({Key? key}) : super(key: key);

  final MonitoringController _controller =
      Get.put(MonitoringController(MachineType.CNC), tag: 'cnc');

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDateRow(),
                      const SizedBox(height: 12.0),
                      Text(
                        "Monitoring Penggunaan Mesin CNC Milling",
                        style: GoogleFonts.inter(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF113159).withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Obx(() => _controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : _buildMonitoringContent(constraints)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMonitoringContent(BoxConstraints constraints) {
    return Column(
      children: [
        _buildMonitoringCards(constraints),
        const SizedBox(height: 10.0),
        _buildDataTable2(constraints),
      ],
    );
  }

  Widget _buildMonitoringCards(BoxConstraints constraints) {
    double cardWidth = (constraints.maxWidth - 40 - 11) / 2; // Subtracting padding and gap
    return Wrap(
      spacing: 11.0,
      runSpacing: 11.0,
      children: [
        _buildMonitoringCard(
          title: "Penggunaan Mesin Hari Ini",
          value: _controller.data.value.totalDurationToday,
          icon: Icons.av_timer,
          width: cardWidth,
        ),
        _buildMonitoringCard(
          title: "Pengguna Mesin Per-hari Ini",
          value: "${_controller.data.value.userCountToday} pengguna",
          icon: Icons.person,
          width: cardWidth,
        ),
        _buildMonitoringCard(
          title: "Total Penggunaan Mesin",
          value: _controller.data.value.totalDurationAll,
          icon: Icons.access_time,
          width: cardWidth,
        ),
        _buildMonitoringCard(
          title: "Keseluruhan Pengguna Mesin",
          value: "${_controller.data.value.userCountAll} pengguna",
          icon: Icons.group,
          width: cardWidth,
        ),
      ],
    );
  }

  Widget _buildMonitoringCard({
    required String title,
    required String value,
    required IconData icon,
    required double width,
  }) {
    return Container(
      width: width,
      height: 78.0,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        border: Border.all(color: const Color(0xFFEAEBEE)),
        borderRadius: BorderRadius.circular(9.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: 38.0,
                  width: 38.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: const Color(0XFFDADBDF)),
                  ),
                  child: Icon(icon),
                ),
                const SizedBox(width: 7.0),
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF000019),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 8.0,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF202636).withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable2(BoxConstraints constraints) {
    return Container(
      height: constraints.maxHeight * 0.4, // Adjust this value as needed
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 600,
        columns: const [
          DataColumn2(
            label: Text('Nama', style: TextStyle(fontWeight: FontWeight.bold)),
            size: ColumnSize.L,
          ),
          DataColumn2(
            label: Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
            size: ColumnSize.M,
          ),
          DataColumn2(
            label: Text('Detail Keperluan', style: TextStyle(fontWeight: FontWeight.bold)),
            size: ColumnSize.L,
          ),
          DataColumn2(
            label: Text('Durasi', style: TextStyle(fontWeight: FontWeight.bold)),
            size: ColumnSize.S,
          ),
        ],
        rows: _controller.data.value.userDetails.map((user) => DataRow(cells: [
          DataCell(Text(user.nama)),
          DataCell(Text(user.kategori)),
          DataCell(Text(user.detailKeperluan)),
          DataCell(Text(user.durasi)),
        ])).toList(),
      ),
    );
  }

  Widget _buildDateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/calendar.png',
          height: 32.0,
          width: 32.0,
        ),
        const SizedBox(width: 6.0),
        Text(
          DateFormat('EEE, \ndd MMM yyyy').format(DateTime.now()),
          style: GoogleFonts.inter(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF202636).withOpacity(0.6),
          ),
        )
      ],
    );
  }
}