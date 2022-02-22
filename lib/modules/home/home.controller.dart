import 'package:get/get.dart';
import 'package:todo/app/routes.dart';

class HomeController extends GetxController {
  HomeController();

  final loading = false.obs;
  Future logOut() async {
    await Get.offAllNamed(Routes.login);
  }
}