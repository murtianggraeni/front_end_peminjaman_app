import 'package:build_app/page/home/form_peminjaman/form_penggunaan_cnc.dart';
import 'package:build_app/page/home/form_peminjaman/form_penggunaan_lasercut.dart';
import 'package:build_app/page/home/form_peminjaman/form_penggunaan_printing.dart';
import 'package:build_app/page/home/informasi_page/halaman_informasi_cnc.dart';
import 'package:build_app/page/home/informasi_page/halaman_informasi_lasercut.dart';
import 'package:build_app/page/home/informasi_page/halaman_informasi_printing.dart';
import 'package:build_app/page/main/admin/main_page_admin.dart';
import 'package:build_app/page/main/user/main_page_user.dart';
import 'package:build_app/page/main/admin/monitoring/page/detail_monitoring_cnc.dart';
import 'package:build_app/page/screens/forget_password.dart';
import 'package:build_app/page/screens/signin_screen.dart';
import 'package:build_app/page/screens/signup_screen.dart';
import 'package:build_app/page/widget/custom_buttom_nav.dart';
import 'package:build_app/routes/route_name.dart';
import 'package:get/get.dart';

class AppPage {
  static final pages = [
    GetPage(
      name: RouteName.signup_screen,
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: RouteName.signin_screen,
      page: () => const SignInScreen(),
    ),
    GetPage(
      name: RouteName.forget_password,
      page: () => const ForgetPasswordScreen(),
    ),
    GetPage(
      name: RouteName.custom_buttom_nav,
      page: () => const BottomNavBar(),
    ),
    GetPage(
      name: RouteName.main_page_user,
      page: () =>  mainPageUser(),
    ),
    GetPage(
      name: RouteName.main_page_admin,
      page: () => const mainPageAdmin(),
    ),
    GetPage(
      name: RouteName.halaman_informasi_cnc,
      page: () => const halamanInformasiCnc(),
    ),
    GetPage(
      name: RouteName.halaman_informasi_lasercut,
      page: () => const halamanInformasiLasercut(),
    ),
    GetPage(
      name: RouteName.halaman_informasi_printing,
      page: () => const halamanInformasiPrinting(),
    ),
    GetPage(
      name: RouteName.form_penggunaan_cnc,
      page: () => formPenggunaanCnc(),
    ),
    GetPage(
      name: RouteName.form_penggunaan_lasercut,
      page: () => formPenggunaanLasercut(),
    ),
    GetPage(
      name: RouteName.form_penggunaan_printing,
      page: () => formPenggunaanPrinting(),
    ),
    GetPage(
      name: RouteName.detail_monitoring_cnc,
      page: () =>  detailPageCnc(),
    )
  ];
}
