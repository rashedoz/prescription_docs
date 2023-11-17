import 'package:get/get.dart';
import 'package:prescription_document/bindings/home_page_binding.dart';
import 'package:prescription_document/home_page.dart';
import 'package:prescription_document/routes/app_routes.dart';
import 'package:prescription_document/views/members/add_member_page.dart';

class AppPages {
  static var list = [
    // GetPage(
    //   name: AppRoutes.nav_screen,
    //   page: () => const NavbarPage(),
    //   binding: HomeBinding(),
    // ),
    GetPage(
      name: AppRoutes.home_screen,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: AppRoutes.add_member,
      page: () => AddMemberPage(),
      binding: HomeBinding(),
    ),
  ];
}
