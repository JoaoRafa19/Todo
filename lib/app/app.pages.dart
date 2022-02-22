import 'package:get/get.dart';
import 'package:todo/app/bindings.dart';
import 'package:todo/modules/auth/login/login.page.dart';

import '../modules/home/home.page.dart';
import 'routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      binding: HomeBinding(),
      name: Routes.home,
      page: () => const HomePage(),
    ),
    GetPage(
      binding: LoginBinding(),
      name: Routes.login,
      page: () => const LoginPage(),
    ),
  ];
}
