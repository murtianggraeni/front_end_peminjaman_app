import 'package:build_app/page/main/admin/main_page_admin.dart';
import 'package:build_app/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:build_app/page/main/user/main_page_user.dart';
import 'package:build_app/page/main/admin/confirm_page.dart';
import 'package:build_app/page/main/user/status_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  final UserController _userController = Get.find<UserController>();

  List<Widget> get _screens {
    return _userController.role.value == 'admin'
        ? [mainPageAdmin(), const confirmPage()]
        : [mainPageUser(), const statusPage()];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(19.0),
                topLeft: Radius.circular(19.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(19.0),
                topRight: Radius.circular(19.0),
              ),
              child: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  const BottomNavigationBarItem(
                    icon: Icon(MingCuteIcons.mgc_home_4_line),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(_userController.role.value == 'admin'
                        ? MingCuteIcons.mgc_chart_pie_2_line
                        : MingCuteIcons.mgc_file_upload_line),
                    label: _userController.role.value == 'admin'
                        ? 'Monitor'
                        : 'Status',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: const Color(0xFF5794AE),
                unselectedItemColor: Colors.grey,
                onTap: _onItemTapped,
                selectedLabelStyle: GoogleFonts.inter(fontSize: 12),
                unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
              ),
            ),
          ),
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

// -- METHODE 1 ---
// --- BOTTOM NAV BAR UTAMA --- //

// import 'package:build_app/page/main/admin/main_page_admin.dart';
// import 'package:build_app/controller/user_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:material_symbols_icons/material_symbols_icons.dart';
// import 'package:ming_cute_icons/ming_cute_icons.dart';
// import 'package:build_app/page/main/user/main_page_user.dart';
// import 'package:build_app/page/main/admin/monitoring_page.dart';
// import 'package:build_app/page/main/user/status_page.dart';

// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({Key? key}) : super(key: key);

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = [
//     mainPageUser(),
//     const monitoringPage(),
//     const statusPage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: _screens,
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           borderRadius: const BorderRadius.only(
//             topRight: Radius.circular(19),
//             topLeft: Radius.circular(19),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, -1),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(19.0),
//             topRight: Radius.circular(19.0),
//           ),
//           child: BottomNavigationBar(
//             items: const <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//                 icon: Icon(MingCuteIcons.mgc_home_4_line),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(MingCuteIcons.mgc_file_upload_line),
//                 // mgc_chart_pie_2_line),
//                 label: 'Confirm',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Symbols.deployed_code_update_rounded),
//                 label: 'Status',
//               ),
//             ],
//             currentIndex: _selectedIndex,
//             selectedItemColor: const Color(0xFF5794AE),
//             unselectedItemColor: Colors.grey,
//             onTap: _onItemTapped,
//             selectedLabelStyle: GoogleFonts.inter(fontSize: 12),
//             unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
//           ),
//         ),
//       ),
//     );
//   }
// }

// -- METHODE 2 --

// import 'package:build_app/page/main/admin/main_page_admin.dart';
// import 'package:build_app/controller/user_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:material_symbols_icons/material_symbols_icons.dart';
// import 'package:ming_cute_icons/ming_cute_icons.dart';
// import 'package:build_app/page/main/user/main_page_user.dart';
// import 'package:build_app/page/main/admin/monitoring_page.dart';
// import 'package:build_app/page/main/user/status_page.dart';

// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({Key? key}) : super(key: key);

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   int _selectedIndex = 0;
//   final UserController _userController = Get.find<UserController>();

//   List<Widget> get _screens {
//     return _userController.role.value == 'admin'
//         ? [mainPageAdmin(), const monitoringPage()]
//         : [mainPageUser(), const statusPage()];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Scaffold(
//           body: IndexedStack(
//             index: _selectedIndex,
//             children: _screens,
//           ),
//           bottomNavigationBar: BottomNavigationBar(
//             items: <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//                 icon: Icon(MingCuteIcons.mgc_home_4_line),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(_userController.role.value == 'admin'
//                     ? MingCuteIcons.mgc_chart_pie_2_line
//                     : MingCuteIcons.mgc_file_upload_line),
//                 label: _userController.role.value == 'admin'
//                     ? 'Monitor'
//                     : 'Status',
//               ),
//             ],
//             currentIndex: _selectedIndex,
//             selectedItemColor: const Color(0xFF5794AE),
//             unselectedItemColor: Colors.grey,
//             onTap: _onItemTapped,
//             selectedLabelStyle: GoogleFonts.inter(fontSize: 12),
//             unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),

//           ),
//         ));
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
// }

// -- Methode 3 ---

