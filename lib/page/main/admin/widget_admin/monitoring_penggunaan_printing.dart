// library backend
import 'dart:math';
import 'dart:ui';

import 'package:build_app/controller/monitoring_controller.dart';
import 'package:build_app/enums/machine_type.dart';
import 'package:build_app/controller/currentMonitoring_controller.dart';
import 'package:build_app/models/monitoring_model.dart';
// library frontend
import 'package:data_table_2/data_table_2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';

class monitoringPenggunaanPrinting extends StatelessWidget {
  monitoringPenggunaanPrinting({Key? key}) : super(key: key);

  final MonitoringController _controller =
      Get.put(MonitoringController(MachineType.Printing), tag: 'printing');

  // final CurrentMonitoringController _currentController = Get.put(
  //     CurrentMonitoringController(machineType: MachineType.Printing),
  //     tag: 'printing');

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
        actions: [
          Obx(() => Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    children: [
                      if (_controller.isRefreshing.value)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF113159)),
                          ),
                        ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _controller.isRefreshing.value
                            ? null
                            : _controller.refreshData,
                        tooltip: 'Refresh Data',
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _controller.refreshData,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildDateRow(),
                            // SizedBox(
                            //   width: 10.0,
                            // ),
                            Obx(() => _buildConnectionStatus()),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Monitoring Penggunaan Mesin 3D Printing",
                              style: GoogleFonts.inter(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF113159).withOpacity(0.9),
                              ),
                            ),
                            // SizedBox(
                            //   height: 10.0,
                            // ),
                            // Obx(() => _buildConnectionStatus()),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        Obx(() {
                          if (_controller.isLoading.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (_controller.error.value.isNotEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline,
                                      size: 48, color: Colors.red[300]),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Gagal memuat data',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: Colors.red[300],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _controller.refreshData,
                                    child: const Text('Coba lagi'),
                                  ),
                                ],
                              ),
                            );
                          }
                          return _buildMonitoringContent(context, constraints);
                        }),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    if (_controller.isRefreshing.value) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Memperbarui...',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      );
    }

    final bool hasError = _controller.error.value.isNotEmpty;
    final bool isConnected = _controller.isConnected.value;

    final Color statusColor =
        hasError ? Colors.red : (isConnected ? Colors.green : Colors.orange);
    final String statusText =
        hasError ? 'Error' : (isConnected ? 'Terhubung' : 'Menghubungkan');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  //     AppBar(
  //       backgroundColor: Colors.transparent,
  //       iconTheme: const IconThemeData(color: Color(0xFF757575), size: 20.0),
  //       titleTextStyle: GoogleFonts.inter(
  //         fontSize: 15.5,
  //         fontWeight: FontWeight.w500,
  //       ),
  //       elevation: 0,
  //     ),
  //     body: SafeArea(
  //       child: LayoutBuilder(
  //         builder: (context, constraints) {
  //           return SingleChildScrollView(
  //             child: ConstrainedBox(
  //               constraints: BoxConstraints(minHeight: constraints.maxHeight),
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     _buildDateRow(),
  //                     const SizedBox(height: 12.0),
  //                     Text(
  //                       "Monitoring Penggunaan Mesin 3D Printing",
  //                       style: GoogleFonts.inter(
  //                         fontSize: 15.0,
  //                         fontWeight: FontWeight.bold,
  //                         color: const Color(0xFF113159).withOpacity(0.9),
  //                       ),
  //                     ),
  //                     const SizedBox(height: 15.0),
  //                     Obx(() => _controller.isLoading.value
  //                         ? const Center(child: CircularProgressIndicator())
  //                         : _buildMonitoringContent(context, constraints)),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _buildMonitoringContent(
      BuildContext context, BoxConstraints constraints) {
    return Column(
      children: [
        _buildMonitoringCards(constraints),
        const SizedBox(height: 16.0),
        _buildAverageStatsCard(constraints),
        const SizedBox(height: 16.0),
        _buildWeeklyTrendsCard(constraints),
        const SizedBox(height: 16.0),
        _buildUserTypeBreakdownCard(constraints),
        const SizedBox(height: 16.0),
        // _buildCurrentMonitoringCard(),
        // const SizedBox(height: 16.0),
        _buildDataTable2(context, constraints),
      ],
    );
  }

  Widget _buildMonitoringCards(BoxConstraints constraints) {
    double cardWidth =
        (constraints.maxWidth - 40 - 11) / 2; // Subtracting padding and gap
    return Wrap(
      spacing: 11.0,
      runSpacing: 11.0,
      children: [
        _buildMonitoringCard(
          title: "Penggunaan Mesin Hari Ini",
          value: _controller.data.value.stats.today.totalDuration,
          //_controller.data.value.totalDurationToday,
          icon: Icons.av_timer,
          width: cardWidth,
        ),
        _buildMonitoringCard(
          title: "Pengguna Mesin Per-hari Ini",
          value: "${_controller.data.value.stats.today.userCount} pengguna",
          // value: "${_controller.data.value.userCountToday} pengguna",
          icon: Icons.person,
          width: cardWidth,
        ),
        _buildMonitoringCard(
          title: "Total Penggunaan Mesin",
          value: _controller.data.value.stats.all.totalDuration,
          // value: _controller.data.value.totalDurationAll,
          icon: Icons.access_time,
          width: cardWidth,
        ),
        _buildMonitoringCard(
          title: "Keseluruhan Pengguna Mesin",
          value: "${_controller.data.value.stats.all.userCount} pengguna",
          // value: "${_controller.data.value.userCountAll} pengguna",
          icon: Icons.group,
          width: cardWidth,
        ),
        // _buildCurrentMonitoringCard(),
      ],
    );
  }

  // Widget _buildWeeklyTrendsCard(BoxConstraints constraints) {
  //   final weeklyData = _controller.data.value.trends.weekly.data;
  //   double maxDuration = 0;

  //   for (var day in weeklyData) {
  //     double minutes = _convertDurationToMinutes(day.stats.totalDuration);
  //     if (minutes > maxDuration) maxDuration = minutes;
  //   }

  //   // Mengatur maxY untuk lebih rapi
  //   double maxY = 30; // Fixed maxY untuk konsistensi

  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(20.0),
  //     decoration: BoxDecoration(
  //       color: Colors.white,//const Color(0xFF113159), // Sesuai color palette
  //       borderRadius: BorderRadius.circular(16.0),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.2),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Tren Penggunaan 7 Hari Terakhir',
  //           style: GoogleFonts.inter(
  //             fontSize: 16.0,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.black.withOpacity(0.95), // Colors.white.withOpacity(0.95),
  //           ),
  //         ),
  //         const SizedBox(height: 24.0),
  //         SizedBox(
  //           height: 180, // Mengurangi tinggi chart
  //           child: Padding(
  //             padding:
  //                 const EdgeInsets.only(right: 20.0, top: 12.0, bottom: 12.0),
  //             child: LineChart(
  //               LineChartData(
  //                 gridData: FlGridData(
  //                   show: true,
  //                   drawVerticalLine: false,
  //                   horizontalInterval: 5,
  //                   getDrawingHorizontalLine: (value) {
  //                     return FlLine(
  //                       color: Colors.black.withOpacity(0.1), //Colors.white.withOpacity(0.1),
  //                       strokeWidth: 1,
  //                     );
  //                   },
  //                 ),
  //                 titlesData: FlTitlesData(
  //                   show: true,
  //                   rightTitles: const AxisTitles(
  //                     sideTitles: SideTitles(showTitles: false),
  //                   ),
  //                   topTitles: const AxisTitles(
  //                     sideTitles: SideTitles(showTitles: false),
  //                   ),
  //                   bottomTitles: AxisTitles(
  //                     sideTitles: SideTitles(
  //                       showTitles: true,
  //                       reservedSize: 28,
  //                       interval: 1,
  //                       getTitlesWidget: (value, meta) {
  //                         if (value.toInt() >= 0 &&
  //                             value.toInt() < weeklyData.length) {
  //                           final date = weeklyData[value.toInt()].date;
  //                           return Text(
  //                             '${date.day}/${date.month}',
  //                             style: GoogleFonts.inter(
  //                               color: Colors.black.withOpacity(0.5), // Colors.white.withOpacity(0.5),
  //                               fontSize: 11,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           );
  //                         }
  //                         return const Text('');
  //                       },
  //                     ),
  //                   ),
  //                   leftTitles: AxisTitles(
  //                     sideTitles: SideTitles(
  //                       showTitles: true,
  //                       interval: 5,
  //                       reservedSize: 40, // Menambah ruang untuk label
  //                       getTitlesWidget: (value, meta) {
  //                         if (value == 0) return const Text('');
  //                         // Menyederhanakan label
  //                         return Padding(
  //                           padding: const EdgeInsets.only(right: 8),
  //                           child: Text(
  //                             value
  //                                 .toInt()
  //                                 .toString(), // Hanya menampilkan angka
  //                             style: GoogleFonts.inter(
  //                               color: Colors.black.withOpacity(0.5), // Colors.white.withOpacity(0.5),
  //                               fontSize: 11,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 ),
  //                 borderData: FlBorderData(show: false),
  //                 minX: 0,
  //                 maxX: (weeklyData.length - 1).toDouble(),
  //                 minY: 0,
  //                 maxY: maxY,
  //                 lineBarsData: [
  //                   // Line untuk durasi
  //                   LineChartBarData(
  //                     spots: weeklyData.asMap().entries.map((entry) {
  //                       return FlSpot(
  //                         entry.key.toDouble(),
  //                         _convertDurationToMinutes(
  //                             entry.value.stats.totalDuration),
  //                       );
  //                     }).toList(),
  //                     isCurved: true,
  //                     curveSmoothness: 0.5,
  //                     preventCurveOverShooting: true,
  //                     color: const Color(0xFF48DAC5), // Warna tosca
  //                     barWidth: 2.5,
  //                     isStrokeCapRound: true,
  //                     dotData: FlDotData(
  //                       show: true,
  //                       getDotPainter: (spot, percent, barData, index) {
  //                         return FlDotCirclePainter(
  //                           radius: 3.5,
  //                           color: const Color(0xFF48DAC5),
  //                           strokeWidth: 2,
  //                           strokeColor: Colors.white, // const Color(0xFF113159),
  //                         );
  //                       },
  //                     ),
  //                     belowBarData: BarAreaData(
  //                       // Shadow untuk garis durasi
  //                       show: true,
  //                       gradient: LinearGradient(
  //                         begin: Alignment.topCenter,
  //                         end: Alignment.bottomCenter,
  //                         colors: [
  //                           const Color(0xFF48DAC5).withOpacity(0.2),
  //                           const Color(0xFF48DAC5).withOpacity(0.0),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   // Line untuk jumlah pengguna
  //                   LineChartBarData(
  //                     spots: weeklyData.asMap().entries.map((entry) {
  //                       return FlSpot(
  //                         entry.key.toDouble(),
  //                         entry.value.stats.userCount.toDouble(),
  //                       );
  //                     }).toList(),
  //                     isCurved: true,
  //                     curveSmoothness: 0.35,
  //                     preventCurveOverShooting: true,
  //                     color: const Color(0xFFFF4081), // Warna pink
  //                     barWidth: 2.5,
  //                     isStrokeCapRound: true,
  //                     dotData: FlDotData(
  //                       show: true,
  //                       getDotPainter: (spot, percent, barData, index) {
  //                         return FlDotCirclePainter(
  //                           radius: 3.5,
  //                           color: const Color(0xFFFF4081),
  //                           strokeWidth: 2,
  //                           strokeColor: Colors.white, // const Color(0xFF113159),
  //                         );
  //                       },
  //                     ),
  //                     belowBarData: BarAreaData(
  //                       // Shadow untuk garis pengguna
  //                       show: true,
  //                       gradient: LinearGradient(
  //                         begin: Alignment.topCenter,
  //                         end: Alignment.bottomCenter,
  //                         colors: [
  //                           const Color(0xFFFF4081).withOpacity(0.2),
  //                           const Color(0xFFFF4081).withOpacity(0.0),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //                 lineTouchData: LineTouchData(
  //                   enabled: true,
  //                   touchTooltipData: LineTouchTooltipData(
  //                     tooltipRoundedRadius: 8,
  //                     tooltipPadding: const EdgeInsets.symmetric(
  //                       horizontal: 8,
  //                       vertical: 4,
  //                     ),
  //                     tooltipMargin: 0,
  //                     getTooltipItems: (touchedSpots) {
  //                       return touchedSpots.map((touchedSpot) {
  //                         final value = touchedSpot.y;
  //                         String text = touchedSpot.barIndex == 0
  //                             ? '${value.toInt()} menit'
  //                             : '${value.toInt()} pengguna';
  //                         return LineTooltipItem(
  //                           text,
  //                           GoogleFonts.inter(
  //                             color: touchedSpot.barIndex == 0
  //                                 ? const Color(0xFF48DAC5)
  //                                 : const Color(0xFFFF4081),
  //                             fontSize: 11,
  //                             fontWeight: FontWeight.w600,
  //                           ),
  //                         );
  //                       }).toList();
  //                     },
  //                   ),
  //                   getTouchedSpotIndicator:
  //                       (LineChartBarData barData, List<int> spotIndexes) {
  //                     return spotIndexes.map((index) {
  //                       return TouchedSpotIndicatorData(
  //                         FlLine(
  //                           color: Colors.black.withOpacity(0.1), // Colors.white.withOpacity(0.1),
  //                           strokeWidth: 1,
  //                         ),
  //                         FlDotData(
  //                           getDotPainter: (spot, percent, barData, index) {
  //                             return FlDotCirclePainter(
  //                               radius: 4,
  //                               color: barData.color ?? Colors.white,
  //                               strokeWidth: 2,
  //                               strokeColor: const Color(0xFF113159),//Colors.white, // const Color(0xFF113159),
  //                             );
  //                           },
  //                         ),
  //                       );
  //                     }).toList();
  //                   },
  //                   handleBuiltInTouches: true,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 24.0),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             _buildLegendItem(
  //               "Durasi (menit)",
  //               const Color(0xFF48DAC5),
  //             ),
  //             const SizedBox(width: 24.0),
  //             _buildLegendItem(
  //               "Jumlah Pengguna",
  //               const Color(0xFFFF4081),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildWeeklyTrendsCard(BoxConstraints constraints) {
    final weeklyData = _controller.data.value.trends.weekly.data;
    double maxDuration = 0;

    for (var day in weeklyData) {
      double minutes = _convertDurationToMinutes(day.stats.totalDuration);
      if (minutes > maxDuration) maxDuration = minutes;
    }

    // Fixed maxY untuk konsistensi
    double maxY = 30;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tren Penggunaan 7 Hari Terakhir',
            style: GoogleFonts.inter(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF113159),
            ),
          ),
          const SizedBox(height: 32.0),
          SizedBox(
            height: 240,
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 16.0, left: 0, top: 16.0, bottom: 16.0),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 5,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: const Color(0xFFE9ECEF),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: const Color(0xFFE9ECEF),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < weeklyData.length) {
                            final date = weeklyData[value.toInt()].date;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${date.day}/${date.month}',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF6B7280),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              value.toInt().toString(),
                              style: GoogleFonts.inter(
                                color: const Color(0xFF6B7280),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: const Color(0xFFE9ECEF),
                      width: 1,
                    ),
                  ),
                  minX: 0,
                  maxX: (weeklyData.length - 1).toDouble(),
                  minY: 0,
                  maxY: maxY,
                  lineBarsData: [
                    // Line untuk durasi
                    LineChartBarData(
                      spots: weeklyData.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          _convertDurationToMinutes(
                              entry.value.stats.totalDuration),
                        );
                      }).toList(),
                      isCurved: true,
                      curveSmoothness: 0.35,
                      preventCurveOverShooting: true,
                      color: const Color(0xFF48DAC5),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF48DAC5).withOpacity(0.2),
                            const Color(0xFF48DAC5).withOpacity(0.0),
                          ],
                          stops: const [0.0, 0.8],
                        ),
                      ),
                    ),
                    // Line untuk jumlah pengguna
                    LineChartBarData(
                      spots: weeklyData.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value.stats.userCount.toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      curveSmoothness: 0.35,
                      preventCurveOverShooting: true,
                      color: const Color(0xFFFF4081),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFFF4081).withOpacity(0.2),
                            const Color(0xFFFF4081).withOpacity(0.0),
                          ],
                          stops: const [0.0, 0.8],
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipRoundedRadius: 8,
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      tooltipMargin: 8,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((touchedSpot) {
                          final value = touchedSpot.y;
                          String text = touchedSpot.barIndex == 0
                              ? '${value.toInt()} menit'
                              : '${value.toInt()} pengguna';
                          return LineTooltipItem(
                            text,
                            GoogleFonts.inter(
                              color: touchedSpot.barIndex == 0
                                  ? const Color(0xFF48DAC5)
                                  : const Color(0xFFFF4081),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }).toList();
                      },
                    ),
                    getTouchedSpotIndicator:
                        (LineChartBarData barData, List<int> spotIndexes) {
                      return spotIndexes.map((index) {
                        return TouchedSpotIndicatorData(
                          FlLine(
                            color:
                                barData.color?.withOpacity(0.2) ?? Colors.white,
                            strokeWidth: 2,
                          ),
                          FlDotData(
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 6,
                                color: Colors.white,
                                strokeWidth: 3,
                                strokeColor: barData.color ?? Colors.white,
                              );
                            },
                          ),
                        );
                      }).toList();
                    },
                    handleBuiltInTouches: true,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(
                "Durasi (menit)",
                const Color(0xFF48DAC5),
              ),
              const SizedBox(width: 32.0),
              _buildLegendItem(
                "Jumlah Pengguna",
                const Color(0xFFFF4081),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.0,
            color:
                Colors.black.withOpacity(0.7), // Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  double _convertDurationToMinutes(double hours) {
    return hours * 60;
  }

  // Widget _buildWeeklyTrendsCard(BoxConstraints constraints) {
  //   final weeklyData = _controller.data.value.trends.weekly.data;

  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(20.0),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16.0),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Tren Penggunaan 7 Hari Terakhir',
  //           style: GoogleFonts.inter(
  //             fontSize: 16.0,
  //             fontWeight: FontWeight.bold,
  //             color: const Color(0xFF113159),
  //           ),
  //         ),
  //         const SizedBox(height: 20.0),
  //         SizedBox(
  //           height: 200,
  //           child: Stack(
  //             children: [
  //               AspectRatio(
  //                 aspectRatio: 1.70,
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(8),
  //                     color: Colors.white,
  //                   ),
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(
  //                       right: 18.0,
  //                       left: 12.0,
  //                       top: 24,
  //                       bottom: 12,
  //                     ),
  //                     child: LineChart(
  //                       mainData(weeklyData),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(height: 16.0),
  //         _buildChartLegend(),
  //       ],
  //     ),
  //   );
  // }

  // LineChartData mainData(List<DailyStats> weeklyData) {
  //   return LineChartData(
  //     gridData: FlGridData(
  //       show: true,
  //       drawVerticalLine: false,
  //       horizontalInterval: 1,
  //       getDrawingHorizontalLine: (value) {
  //         return FlLine(
  //           color: const Color(0xffe7e8ec),
  //           strokeWidth: 1,
  //         );
  //       },
  //     ),
  //     titlesData: FlTitlesData(
  //       show: true,
  //       rightTitles: AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //       topTitles: AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //       bottomTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           reservedSize: 30,
  //           interval: 1,
  //           getTitlesWidget: (value, meta) {
  //             if (value.toInt() >= 0 && value.toInt() < weeklyData.length) {
  //               return Text(
  //                 DateFormat('dd/MM').format(weeklyData[value.toInt()].date),
  //                 style: GoogleFonts.inter(
  //                   color: const Color(0xff68737d),
  //                   fontSize: 12,
  //                 ),
  //               );
  //             }
  //             return const Text('');
  //           },
  //         ),
  //       ),
  //       leftTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           interval: 1,
  //           getTitlesWidget: (value, meta) {
  //             return Text(
  //               value.toInt().toString(),
  //               style: GoogleFonts.inter(
  //                 color: const Color(0xff68737d),
  //                 fontSize: 12,
  //               ),
  //             );
  //           },
  //           reservedSize: 42,
  //         ),
  //       ),
  //     ),
  //     borderData: FlBorderData(
  //       show: true,
  //       border: Border.all(color: const Color(0xffe7e8ec)),
  //     ),
  //     minX: 0,
  //     maxX: (weeklyData.length - 1).toDouble(),
  //     minY: 0,
  //     maxY: _getMaxY(weeklyData),
  //     lineBarsData: [
  //       // Line untuk durasi
  //       LineChartBarData(
  //         spots: weeklyData.asMap().entries.map((entry) {
  //           return FlSpot(
  //             entry.key.toDouble(),
  //             entry.value.stats.totalDuration,
  //           );
  //         }).toList(),
  //         isCurved: true,
  //         color: const Color(0xFFF13159),
  //         barWidth: 2,
  //         isStrokeCapRound: true,
  //         dotData: FlDotData(show: true),
  //         belowBarData: BarAreaData(show: false),
  //       ),
  //       // Line untuk jumlah pengguna
  //       LineChartBarData(
  //         spots: weeklyData.asMap().entries.map((entry) {
  //           return FlSpot(
  //             entry.key.toDouble(),
  //             entry.value.stats.userCount.toDouble(),
  //           );
  //         }).toList(),
  //         isCurved: true,
  //         color: const Color(0xFFF4CAF50),
  //         barWidth: 2,
  //         isStrokeCapRound: true,
  //         dotData: FlDotData(show: true),
  //         belowBarData: BarAreaData(show: false),
  //       ),
  //     ],
  //   );
  // }

  // double _getMaxY(List<DailyStats> weeklyData) {
  //   double maxDuration = 0;
  //   double maxUsers = 0;

  //   for (var day in weeklyData) {
  //     if (day.stats.totalDuration > maxDuration) {
  //       maxDuration = day.stats.totalDuration;
  //     }
  //     if (day.stats.userCount > maxUsers) {
  //       maxUsers = day.stats.userCount.toDouble();
  //     }
  //   }

  //   return max(maxDuration, maxUsers) * 1.2; // Add 20% padding
  // }

  // Widget _buildChartLegend() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       _buildLegendItem(
  //         "Durasi (jam)",
  //         const Color(0xFFF13159),
  //       ),
  //       const SizedBox(width: 24.0),
  //       _buildLegendItem(
  //         "Jumlah Pengguna",
  //         const Color(0xFFF4CAF50),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildLegendItem(String label, Color color) {
  //   return Row(
  //     children: [
  //       Container(
  //         width: 12.0,
  //         height: 12.0,
  //         decoration: BoxDecoration(
  //           color: color,
  //           shape: BoxShape.circle,
  //         ),
  //       ),
  //       const SizedBox(width: 8.0),
  //       Text(
  //         label,
  //         style: GoogleFonts.inter(
  //           fontSize: 12.0,
  //           color: Colors.black87,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildUserTypeBreakdownCard(BoxConstraints constraints) {
    final userTypeStats = _controller.data.value.stats.all.byUserType;
    final total = userTypeStats.total;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Breakdown Tipe Pengguna',
            style: GoogleFonts.inter(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF113159),
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildUserTypeItem(
                "Mahasiswa",
                userTypeStats.mahasiswa,
                total,
                const Color(0xFF4CAF50),
              ),
              _buildUserTypeItem(
                "Pekerja",
                userTypeStats.pekerja,
                total,
                const Color(0xFF2196F3),
              ),
              _buildUserTypeItem(
                "PKL/Magang",
                userTypeStats.pklMagang,
                total,
                const Color(0xFFFFC107),
              ),
              _buildUserTypeItem(
                "External",
                userTypeStats.external,
                total,
                const Color(0xFFF44336),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserTypeItem(String label, int count, int total, Color color) {
    final percentage =
        total > 0 ? (count / total * 100).toStringAsFixed(1) : '0';
    return Column(
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
        Text(
          '$percentage%',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildAverageStatsCard(BoxConstraints constraints) {
    final allStats = _controller.data.value.stats.all;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF113159).withOpacity(0.9),
            const Color(0xFF113159).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Icon(
                        Icons.analytics,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Statistik Rata-rata',
                            style: GoogleFonts.inter(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Analisis penggunaan mesin per pengguna',
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rata-rata Durasi',
                          style: GoogleFonts.inter(
                            fontSize: 14.0,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          allStats.averageDurationPerUser,
                          style: GoogleFonts.inter(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.people_outline,
                            color: Colors.white,
                            size: 16.0,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            '${allStats.userCount} pengguna',
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF000019),
                      ),
                    ),
                  ),
                  // child: Text(
                  //   value,
                  //   style: GoogleFonts.inter(
                  //     fontSize: 16.5,
                  //     fontWeight: FontWeight.bold,
                  //     color: const Color(0xFF000019),
                  //   ),
                  // ),
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

  Widget _buildDataTable2(BuildContext context, BoxConstraints constraints) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Riwayat Penggunaan Mesin',
            style: GoogleFonts.inter(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF113159),
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            height: constraints.maxHeight * 0.4,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFE0E0E0),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: const Color(0xFFE0E0E0),
                  dataTableTheme: DataTableThemeData(
                    headingRowColor: MaterialStateProperty.all(
                      const Color(0xFFF5F5F5),
                    ),
                    dataRowColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.grey.withOpacity(0.08);
                        }
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.grey.withOpacity(0.04);
                        }
                        return Colors.transparent;
                      },
                    ),
                  ),
                ),
                child: DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 800,
                  headingRowHeight: 60,
                  dataRowHeight: 60,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFE0E0E0),
                        width: 1,
                      ),
                    ),
                  ),
                  columns: [
                    DataColumn2(
                      label: _buildColumnHeader('No'),
                      size: ColumnSize.S,
                      fixedWidth: 50,
                    ),
                    DataColumn2(
                      label: _buildColumnHeader('Nama'),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: _buildColumnHeader('Tanggal\nPeminjaman'),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: _buildColumnHeader('Profil'),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: _buildColumnHeader('Nomor\nIdentitas'),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: _buildColumnHeader('Kategori'),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: _buildColumnHeader('Durasi'),
                      size: ColumnSize.L,
                    ),
                  ],
                  rows: _buildTableRows(),
                  empty: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada data penggunaan mesin',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnHeader(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF113159),
          fontSize: 13,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  List<DataRow> _buildTableRows() {
    return _controller.data.value.userDetails.asMap().entries.map((entry) {
      final index = entry.key;
      final user = entry.value;

      return DataRow(
        cells: [
          DataCell(_buildDataCell('${index + 1}')),
          DataCell(_buildDataCell(user.nama)),
          DataCell(_buildDataCell(user.tanggal)),
          DataCell(_buildProfileCell(user.tipePengguna)),
          DataCell(_buildDataCell(user.nomorIdentitas)),
          DataCell(_buildCategoryCell(user.kategori)),
          DataCell(_buildDurationCell(user.durasi)),
        ],
      );
    }).toList();
  }

  Widget _buildDataCell(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        color: const Color(0xFF333333),
      ),
    );
  }

  Widget _buildProfileCell(String profile) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _getProfileColor(profile).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        profile,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: _getProfileColor(profile),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getProfileColor(String profile) {
    switch (profile.toLowerCase()) {
      case 'mahasiswa':
        return const Color(0xFF4CAF50);
      case 'pekerja':
        return const Color(0xFF2196F3);
      case 'pkl':
        return const Color(0xFFFFC107);
      case 'eksternal':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  Widget _buildCategoryCell(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF113159).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: const Color(0xFF113159),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDurationCell(String duration) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        duration,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: const Color(0xFF333333),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Updated Current Monitoring Card with better error handling and status indication
  // Widget _buildCurrentMonitoringCard() {
  //   return Obx(() {
  //     final isConnected = _currentController.isConnected.value;
  //     final hasError = _currentController.error.value.isNotEmpty;
  //     final isLoading = _currentController.isLoading.value;

  //     return Container(
  //       width: double.infinity,
  //       padding: const EdgeInsets.all(12.0),
  //       decoration: BoxDecoration(
  //         color: isConnected
  //             ? Colors.blueAccent.withOpacity(0.1)
  //             : Colors.grey.withOpacity(0.1),
  //         border: Border.all(
  //           color: isConnected
  //               ? Colors.blueAccent
  //               : hasError
  //                   ? Colors.redAccent
  //                   : Colors.grey,
  //         ),
  //         borderRadius: BorderRadius.circular(10.0),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 "Monitoring Arus Listrik",
  //                 style: GoogleFonts.inter(
  //                   fontSize: 12.0,
  //                   fontWeight: FontWeight.w500,
  //                   color: Colors.black87,
  //                 ),
  //               ),
  //               _buildStatusIndicator(isConnected, hasError, isLoading),
  //             ],
  //           ),
  //           const SizedBox(height: 8.0),
  //           if (isLoading)
  //             const Center(
  //               child: CircularProgressIndicator(strokeWidth: 2.0),
  //             )
  //           else if (hasError)
  //             Text(
  //               _currentController.error.value,
  //               style: GoogleFonts.inter(
  //                 fontSize: 14.0,
  //                 color: Colors.redAccent,
  //               ),
  //             )
  //           else
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   children: [
  //                     Icon(
  //                       Icons.electric_bolt,
  //                       color: Colors.blueAccent,
  //                       size: 24.0,
  //                     ),
  //                     const SizedBox(width: 8.0),
  //                     Text(
  //                       "${_currentController.currentData.value.data.current.toStringAsFixed(2)} A",
  //                       style: GoogleFonts.inter(
  //                         fontSize: 24.0,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.blueAccent,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 4.0),
  //                 Row(
  //                   children: [
  //                     Icon(
  //                       Icons.access_time_filled,
  //                       color: Colors.black54,
  //                       size: 16.0,
  //                     ),
  //                     const SizedBox(width: 4.0),
  //                     Text(
  //                       "Last Update: ${DateFormat('HH:mm:ss').format(_currentController.currentData.value.data.waktu)}",
  //                       style: GoogleFonts.inter(
  //                         fontSize: 12.0,
  //                         color: Colors.black54,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 if (!isConnected) ...[
  //                   const SizedBox(height: 4.0),
  //                   Text(
  //                     "WebSocket disconnected - Using polling",
  //                     style: GoogleFonts.inter(
  //                       fontSize: 11.0,
  //                       color: Colors.orange,
  //                     ),
  //                   ),
  //                 ],
  //               ],
  //             ),
  //         ],
  //       ),
  //     );
  //   });
  // }

  Widget _buildStatusIndicator(
      bool isConnected, bool hasError, bool isLoading) {
    if (isLoading) {
      return const SizedBox(
        width: 12.0,
        height: 12.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        ),
      );
    }

    return Container(
      width: 12.0,
      height: 12.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: hasError
            ? Colors.redAccent
            : isConnected
                ? Colors.greenAccent
                : Colors.orangeAccent,
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
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildDateRow(),
//                       const SizedBox(height: 12.0),
//                       Text(
//                         "Monitoring Penggunaan Mesin 3D Printing",
//                         style: GoogleFonts.inter(
//                           fontSize: 15.0,
//                           fontWeight: FontWeight.bold,
//                           color: const Color(0xFF113159).withOpacity(0.9),
//                         ),
//                       ),
//                       const SizedBox(height: 15.0),
//                       Obx(() => _controller.isLoading.value
//                           ? const Center(child: CircularProgressIndicator())
//                           : _buildMonitoringContent(constraints)),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildMonitoringContent(BoxConstraints constraints) {
//     return Column(
//       children: [
//         _buildMonitoringCards(constraints),
//         const SizedBox(height: 10.0),
//         _buildDataTable2(constraints),
//       ],
//     );
//   }

//   Widget _buildMonitoringCards(BoxConstraints constraints) {
//     double cardWidth =
//         (constraints.maxWidth - 40 - 11) / 2; // Subtracting padding and gap
//     return Wrap(
//       spacing: 11.0,
//       runSpacing: 11.0,
//       children: [
//         _buildMonitoringCard(
//           title: "Penggunaan Mesin Hari Ini",
//           value: _controller.data.value.stats.today.totalDuration,
//           //_controller.data.value.totalDurationToday,
//           icon: Icons.av_timer,
//           width: cardWidth,
//         ),
//         _buildMonitoringCard(
//           title: "Pengguna Mesin Per-hari Ini",
//           value: "${_controller.data.value.stats.today.userCount} pengguna",
//           // value: "${_controller.data.value.userCountToday} pengguna",
//           icon: Icons.person,
//           width: cardWidth,
//         ),
//         _buildMonitoringCard(
//           title: "Total Penggunaan Mesin",
//           value: _controller.data.value.stats.all.totalDuration,
//           // value: _controller.data.value.totalDurationAll,
//           icon: Icons.access_time,
//           width: cardWidth,
//         ),
//         _buildMonitoringCard(
//           title: "Keseluruhan Pengguna Mesin",
//           value: "${_controller.data.value.stats.all.userCount} pengguna",
//           // value: "${_controller.data.value.userCountAll} pengguna",
//           icon: Icons.group,
//           width: cardWidth,
//         ),
//         _buildCurrentMonitoringCard(),
//       ],
//     );
//   }

//   Widget _buildMonitoringCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     required double width,
//   }) {
//     return Container(
//       width: width,
//       height: 78.0,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF3F4F6),
//         border: Border.all(color: const Color(0xFFEAEBEE)),
//         borderRadius: BorderRadius.circular(9.0),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   height: 38.0,
//                   width: 38.0,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white,
//                     border: Border.all(color: const Color(0XFFDADBDF)),
//                   ),
//                   child: Icon(icon),
//                 ),
//                 const SizedBox(width: 6.0),
//                 Expanded(
//                   child: Text(
//                     value,
//                     style: GoogleFonts.inter(
//                       fontSize: 16.5,
//                       fontWeight: FontWeight.bold,
//                       color: const Color(0xFF000019),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8.0),
//             Text(
//               title,
//               style: GoogleFonts.inter(
//                 fontSize: 9.0,
//                 fontWeight: FontWeight.w400,
//                 color: const Color(0xFF202636).withOpacity(0.6),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDataTable2(BoxConstraints constraints) {
//     return Container(
//       height: constraints.maxHeight * 0.4,
//       child: DataTable2(
//         columnSpacing: 12,
//         horizontalMargin: 12,
//         minWidth: 600,
//         columns: const [
//           // Tambah kolom untuk nomor
//           DataColumn2(
//             label: Text('No', style: TextStyle(fontWeight: FontWeight.bold)),
//             size: ColumnSize.S,
//             fixedWidth: 50, // Optional: tetapkan lebar kolom nomor
//           ),
//           DataColumn2(
//             label: Text('Nama', style: TextStyle(fontWeight: FontWeight.bold)),
//             size: ColumnSize.L,
//           ),
//           DataColumn2(
//             label: Text('Tanggal Peminjaman',
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             size: ColumnSize.L,
//           ),
//           DataColumn2(
//             label:
//                 Text('Profil', style: TextStyle(fontWeight: FontWeight.bold)),
//             size: ColumnSize.M,
//           ),
//           DataColumn2(
//             label: Text('Nomor Identitas',
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             size: ColumnSize.L,
//           ),
//           DataColumn2(
//             label:
//                 Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
//             size: ColumnSize.L,
//           ),
//           DataColumn2(
//             label:
//                 Text('Durasi', style: TextStyle(fontWeight: FontWeight.bold)),
//             size: ColumnSize.S,
//           ),
//         ],
//         rows: _controller.data.value.userDetails.asMap().entries.map((entry) {
//           final index = entry.key;
//           final user = entry.value;
//           return DataRow(cells: [
//             // Tambah cell untuk nomor
//             DataCell(Text('${index + 1}')), // +1 karena index dimulai dari 0
//             DataCell(Text(user.nama)),
//             DataCell(Text(user.tanggal)),
//             DataCell(Text(user.tipePengguna)),
//             DataCell(Text(user.nomorIdentitas)),
//             DataCell(Text(user.kategori)),
//             DataCell(Text(user.durasi)),
//           ]);
//         }).toList(),
//       ),
//     );
//   }

//   // Widget _buildDataTable2(BoxConstraints constraints) {
//   //   return Container(
//   //     height: constraints.maxHeight * 0.4, // Adjust this value as needed
//   //     child: DataTable2(
//   //       columnSpacing: 12,
//   //       horizontalMargin: 12,
//   //       minWidth: 600,
//   //       columns: [
//   //         DataColumn2(
//   //           label: Text('Nama',
//   //               style: GoogleFonts.inter(
//   //                 fontWeight: FontWeight.bold,
//   //               )),
//   //           size: ColumnSize.L,
//   //         ),
//   //         DataColumn2(
//   //           label: Text('Kategori',
//   //               style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
//   //           size: ColumnSize.M,
//   //         ),
//   //         DataColumn2(
//   //           label: Text('Detail Keperluan',
//   //               style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
//   //           size: ColumnSize.L,
//   //         ),
//   //         DataColumn2(
//   //           label: Text('Durasi',
//   //               style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
//   //           size: ColumnSize.S,
//   //         ),
//   //       ],
//   //       rows: _controller.data.value.userDetails
//   //           .map((user) => DataRow(cells: [
//   //                 DataCell(Text(user.nama)),
//   //                 DataCell(Text(user.kategori)),
//   //                 DataCell(Text(user.detailKeperluan)),
//   //                 DataCell(Text(user.durasi)),
//   //               ]))
//   //           .toList(),
//   //     ),
//   //   );
//   // }

//   // Updated Current Monitoring Card with better error handling and status indication
//   Widget _buildCurrentMonitoringCard() {
//     return Obx(() {
//       final isConnected = _currentController.isConnected.value;
//       final hasError = _currentController.error.value.isNotEmpty;
//       final isLoading = _currentController.isLoading.value;

//       return Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(12.0),
//         decoration: BoxDecoration(
//           color: isConnected
//               ? Colors.blueAccent.withOpacity(0.1)
//               : Colors.grey.withOpacity(0.1),
//           border: Border.all(
//             color: isConnected
//                 ? Colors.blueAccent
//                 : hasError
//                     ? Colors.redAccent
//                     : Colors.grey,
//           ),
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Monitoring Arus Listrik",
//                   style: GoogleFonts.inter(
//                     fontSize: 12.0,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 _buildStatusIndicator(isConnected, hasError, isLoading),
//               ],
//             ),
//             const SizedBox(height: 8.0),
//             if (isLoading)
//               const Center(
//                 child: CircularProgressIndicator(strokeWidth: 2.0),
//               )
//             else if (hasError)
//               Text(
//                 _currentController.error.value,
//                 style: GoogleFonts.inter(
//                   fontSize: 14.0,
//                   color: Colors.redAccent,
//                 ),
//               )
//             else
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.electric_bolt,
//                         color: Colors.blueAccent,
//                         size: 24.0,
//                       ),
//                       const SizedBox(width: 8.0),
//                       Text(
//                         "${_currentController.currentData.value.data.current.toStringAsFixed(2)} A",
//                         style: GoogleFonts.inter(
//                           fontSize: 24.0,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blueAccent,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4.0),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.access_time_filled,
//                         color: Colors.black54,
//                         size: 16.0,
//                       ),
//                       const SizedBox(width: 4.0),
//                       Text(
//                         "Last Update: ${DateFormat('HH:mm:ss').format(_currentController.currentData.value.data.waktu)}",
//                         style: GoogleFonts.inter(
//                           fontSize: 12.0,
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (!isConnected) ...[
//                     const SizedBox(height: 4.0),
//                     Text(
//                       "WebSocket disconnected - Using polling",
//                       style: GoogleFonts.inter(
//                         fontSize: 11.0,
//                         color: Colors.orange,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//           ],
//         ),
//       );
//     });
//   }

//   Widget _buildStatusIndicator(
//       bool isConnected, bool hasError, bool isLoading) {
//     if (isLoading) {
//       return const SizedBox(
//         width: 12.0,
//         height: 12.0,
//         child: CircularProgressIndicator(
//           strokeWidth: 2.0,
//           valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
//         ),
//       );
//     }

//     return Container(
//       width: 12.0,
//       height: 12.0,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: hasError
//             ? Colors.redAccent
//             : isConnected
//                 ? Colors.greenAccent
//                 : Colors.orangeAccent,
//       ),
//     );
//   }

//   Widget _buildDateRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Image.asset(
//           'assets/images/calendar.png',
//           height: 32.0,
//           width: 32.0,
//         ),
//         const SizedBox(width: 6.0),
//         Text(
//           DateFormat('EEE, \ndd MMM yyyy').format(DateTime.now()),
//           style: GoogleFonts.inter(
//             fontSize: 14.0,
//             fontWeight: FontWeight.bold,
//             color: const Color(0xFF202636).withOpacity(0.6),
//           ),
//         )
//       ],
//     );
//   }
// }
