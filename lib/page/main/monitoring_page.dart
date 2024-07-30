import 'dart:ui';
import 'package:build_app/page/main/custom_main_page.dart';
import 'package:build_app/page/monitoring/custom/card_monitoring.dart';
import 'package:build_app/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class monitoringPage extends StatefulWidget {
  const monitoringPage({super.key});

  @override
  State<monitoringPage> createState() => _monitoringPageState();
}

class _monitoringPageState extends State<monitoringPage>
    with SingleTickerProviderStateMixin {
  late TabController monitoringTabController;

  /* FUNGSI UNTUK MENGATUR TAB CONTROLLER */
  // @override
  // void initState() {
  //   monitoringTabController = TabController(length: 2, vsync: this);
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   monitoringTabController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return customScaffoldPage(
      body: Column(
        children: [
          const SizedBox(
            height: 36.0,
          ),
          Expanded(
            flex: 6,
            child: Container(
              // height: MediaQuery.of(context).size.height,
              // width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 24.0,
              ),
              decoration: BoxDecoration(
                color: pageModeScheme.background,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(22.0),
                  topLeft: Radius.circular(22.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Monitoring",
                        style: GoogleFonts.inter(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 23.0,
                    ),
                    const Column(
                      children: [
                        cardMonitoring(
                          merekMesin: "MTU 200M",
                          jenisMesin: "CNC Milling",
                          laboratoriumMesin: "Lab. Elektro Mekanik",
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        cardMonitoring(
                          merekMesin: "TQL-1390",
                          jenisMesin: "Laser Cutting",
                          laboratoriumMesin: "Lab. Elektro Mekanik",
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        cardMonitoring(
                          merekMesin: "Anycubic 4MAX Pro",
                          jenisMesin: "3D Printing",
                          laboratoriumMesin: "Lab. PLC & HMI",
                        )
                      ],
                    ),
                    // Container(
                    //   height: 85.0,
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 11.0,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     color: pageModeScheme.onPrimary,
                    //     borderRadius: const BorderRadius.all(
                    //       Radius.circular(8.0),
                    //     ),
                    //   ),
                    //   child: Stack(
                    //     children: [
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           const SizedBox(
                    //             height: 9.0,
                    //           ),
                    //           Row(
                    //             children: [
                    //               const Icon(
                    //                 MingCute.performance_fill,
                    //                 color: Color(0xFF09244B),
                    //                 size: 16.0,
                    //               ),
                    //               const SizedBox(
                    //                 width: 3.0,
                    //               ),
                    //               Column(
                    //                 children: [
                    //                   const SizedBox(
                    //                     height: 2.0,
                    //                   ),
                    //                   Text(
                    //                     "MTU 200M",
                    //                     style: GoogleFonts.inter(
                    //                       fontSize: 8.0,
                    //                       fontWeight: FontWeight.w500,
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ],
                    //           ),
                    //           Text(
                    //             "CNC Milling",
                    //             style: GoogleFonts.inter(
                    //               fontSize: 16.0,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //           Text(
                    //             "Lab. Elektro Mekanik",
                    //             style: GoogleFonts.inter(
                    //               fontSize: 10.0,
                    //               fontWeight: FontWeight.w500,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       Align(
                    //         alignment: Alignment.bottomRight,
                    //         child: Padding(
                    //           padding: const EdgeInsets.only(bottom: 11.0),
                    //           child: OutlinedButton(
                    //             onPressed: () {},
                    //             style: OutlinedButton.styleFrom(
                    //               shape: const RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.all(
                    //                   Radius.circular(6.0),
                    //                 ),
                    //               ),
                    //               minimumSize: const Size(96.0, 19.0),
                    //               padding: const EdgeInsets.all(
                    //                 10.0,
                    //               ),
                    //               backgroundColor: const Color(0xFFD9D9D9),
                    //               side: const BorderSide(
                    //                 color: Color(0xFFD9D9D9),
                    //               ),
                    //             ),
                    //             child: IntrinsicWidth(
                    //               child: Row(
                    //                 children: [
                    //                   Text(
                    //                     'detail monitoring',
                    //                     style: GoogleFonts.inter(
                    //                       color: Colors.black,
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 8.0,
                    //                     ),
                    //                   ),
                    //                   const SizedBox(
                    //                     width: 3.0,
                    //                   ),
                    //                   const Icon(
                    //                     IonIcons.play,
                    //                     size: 14.0,
                    //                     color: Colors.black,
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Scaffold(
    //   backgroundColor: pageModeScheme.primary,
    //   body: SafeArea(
    //     child: SingleChildScrollView(
    //       child: Stack(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.only(
    //               top: 36.0,
    //             ),
    //             child: Container(
    //               height: MediaQuery.of(context).size.height,
    //               decoration: const BoxDecoration(
    //                 shape: BoxShape.rectangle,
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.only(
    //                   topLeft: Radius.circular(22.0),
    //                   topRight: Radius.circular(22.0),
    //                 ),
    //               ),
    //               child: Column(
    //                 children: [
    //                   Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: SizedBox(
    //                       child: Column(
    //                         children: [
    //                           Container(
    //                             child: TabBar(
    //                               controller: monitoringTabController,
    //                               tabs: const [
    //                                 Tab(
    //                                   text: "Daily",
    //                                 ),
    //                                 Tab(
    //                                   text: "Monthly",
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

/* 
import 'package:build_app/page/main/custom_main_page.dart';
import 'package:build_app/page/main/monitoring/daily_monitoring.dart';
import 'package:build_app/page/main/monitoring/monthly_monitoring.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class monitoringPage extends StatefulWidget {
  const monitoringPage({super.key});

  @override
  State<monitoringPage> createState() => _monitoringPageState();
}

class _monitoringPageState extends State<monitoringPage>
    with SingleTickerProviderStateMixin {
  late TabController monitoringTabController;

  /* FUNGSI UNTUK MENGATUR TAB CONTROLLER */
  @override
  void initState() {
    monitoringTabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    monitoringTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return customScaffoldPage(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 36.0,
          ),
          child: Expanded(
            flex: 6,
            child: Column(
              children: [
                Container(
                  // height: MediaQuery.of(context).size.height,
                  // width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(22.0),
                      topRight: Radius.circular(22.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                      vertical: 24.0,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              color: Color(0xFFF1F1F1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: TabBar(
                                    controller: monitoringTabController,
                                    labelColor: Colors.black,
                                    unselectedLabelColor:
                                        const Color(0xFF6B7888),
                                    indicatorColor: Colors.white,
                                    indicatorWeight: 2,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    indicator: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    labelStyle: GoogleFonts.inter(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w200,
                                    ),
                                    labelPadding: EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    tabs: [
                                      Tab(
                                        text: "Daily",
                                      ),
                                      Tab(
                                        text: "Monthly",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: monitoringTabController,
                              children: const [
                                dailyMonitoring(),
                                monthlyMonitoring(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/
