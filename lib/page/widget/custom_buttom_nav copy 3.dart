// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:material_symbols_icons/material_symbols_icons.dart';
// import 'package:ming_cute_icons/ming_cute_icons.dart';
// import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
// import 'package:build_app/page/main/user/main_page_user.dart';
// import 'package:build_app/page/main/admin/monitoring_page.dart';
// import 'package:build_app/page/main/user/status_page.dart';

// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({Key? key}) : super(key: key);

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   late PersistentTabController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = PersistentTabController(initialIndex: 0);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   List<Widget> _buildScreens() {
//     return [
//       mainPageUser(),
//       const monitoringPage(),
//       const accountPage(),
//     ];
//   }

//   List<PersistentBottomNavBarItem> _navBarsItems() {
//     return [
//       PersistentBottomNavBarItem(
//         icon: const Icon(MingCuteIcons.mgc_home_4_line),
//         title: "Home",
//         activeColorPrimary: const Color(0xFF5794AE),
//         inactiveColorPrimary: Colors.grey,
//         textStyle: GoogleFonts.inter(fontSize: 12.0),
//       ),
//       PersistentBottomNavBarItem(
//         icon: const Icon(MingCuteIcons.mgc_chart_pie_2_line),
//         title: "Confirm",
//         activeColorPrimary: const Color(0xFF5794AE),
//         inactiveColorPrimary: Colors.grey,
//         textStyle: GoogleFonts.inter(fontSize: 12.0),
//       ),
//       PersistentBottomNavBarItem(
//         icon: const Icon(Symbols.deployed_code_update_rounded),
//         title: "Status",
//         activeColorPrimary: const Color(0xFF5794AE),
//         inactiveColorPrimary: Colors.grey,
//         textStyle: GoogleFonts.inter(fontSize: 12.0),
//       ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PersistentTabView(
//       context,
//       controller: _controller,
//       screens: _buildScreens(),
//       items: _navBarsItems(),
//       confineToSafeArea: true,
//       backgroundColor: Colors.white, // Default is Colors.white.
//       handleAndroidBackButtonPress: true, // Default is true.
//       navBarHeight: 60.0,
//       padding: EdgeInsets.symmetric(vertical: 8),
//       resizeToAvoidBottomInset:
//           true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
//       stateManagement: true, // Default is true.
//       hideNavigationBarWhenKeyboardAppears:
//           true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
//       decoration: NavBarDecoration(
//         borderRadius: const BorderRadius.only(
//           topRight: Radius.circular(19.0),
//           topLeft: Radius.circular(19.0),
//         ),
//         colorBehindNavBar: Colors.transparent,
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 5.0,
//             spreadRadius: 1.0,
//             color: Colors.grey.shade500,
//           ),
//         ],
//       ),
//       popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
//       animationSettings: const NavBarAnimationSettings(
//         navBarItemAnimation: ItemAnimationSettings(
//           duration: Duration(milliseconds: 200),
//           curve: Curves.ease,
//         ),
//         screenTransitionAnimation: ScreenTransitionAnimationSettings(
//           animateTabTransition: true,
//           curve: Curves.ease,
//           duration: Duration(milliseconds: 200),
//         ),
//       ),
//       navBarStyle:
//           NavBarStyle.style8, // Choose the nav bar style with this property.
//     );
//   }
// }
