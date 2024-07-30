import 'package:build_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:build_app/page/main/main_page.dart';
import 'package:build_app/page/main/monitoring_page.dart';
import 'package:build_app/page/main/account_page.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class customButtomNav extends StatefulWidget {
  const customButtomNav({super.key, this.showNavBar = true});

  final bool showNavBar;

  @override
  State<customButtomNav> createState() => _customButtomNavState();
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          MyApp(), // MyApp adalah widget tertinggi yang menaungi semua halaman
    ),
  );
}

class _customButtomNavState extends State<customButtomNav> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    List<Widget> _buildScreens() {
      return [
        const mainPageSatu(),
        const monitoringPage(),
        const accountPage(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(
            MingCute.home_4_fill,
          ),
          textStyle: GoogleFonts.inter(),
          title: ("Home"),
          activeColorPrimary: const Color(0xFF5794AE),
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(
            FontAwesome.chart_simple_solid,
            // color: Colors.white,
          ),
          textStyle: GoogleFonts.inter(),
          title: ("Monitoring"),
          activeColorPrimary: const Color(0xFF5794AE),
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(FontAwesome.user_solid),
          textStyle: GoogleFonts.inter(),
          title: ("Account"),
          activeColorPrimary: const Color(0xFF5794AE),
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ];
    }

    PersistentTabController _controller;
    _controller = PersistentTabController(initialIndex: 0);

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardAppears:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(19.0),
          topLeft: Radius.circular(19.0),
        ),
        colorBehindNavBar: Colors.transparent,
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            spreadRadius: 1.0,
            color: Colors.grey.shade500,
          ),
        ],
      ),
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
      ),
      // popAllScreensOnTapOfSelectedTab: true,
      // popActionScreens: PopActionScreensType.all,

      // itemAnimationProperties: const ItemAnimationProperties(
      //   // Navigation Bar's items animation properties.
      //   duration: Duration(milliseconds: 200),
      //   curve: Curves.ease,
      // ),
      // screenTransitionAnimation: const ScreenTransitionAnimation(
      //   // Screen transition animation on change of selected tab.
      //   animateTabTransition: true,
      //   curve: Curves.ease,
      //   duration: Duration(milliseconds: 200),
      // ),
      navBarStyle:
          NavBarStyle.style12, // Choose the nav bar style with this property.
    );
  }
}
