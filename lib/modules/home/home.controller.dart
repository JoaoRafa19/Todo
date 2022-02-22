import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo/app/routes.dart';

import '../../shared/themes.dart';

class HomeController extends GetxController {
  late Rx<User> user;

  var theme = false.obs;
  final appdata = GetStorage();

  HomeController() {
    FirebaseAuth.instance.currentUser == null
        ? Get.offAllNamed(Routes.login)
        : user = FirebaseAuth.instance.currentUser!.obs;

    theme.value = ThemeService().theme == ThemeMode.dark;
    Get.reloadAll();
  }

  final loading = false.obs;
  Future logOut() async {
    Get.offAllNamed(Routes.login);
  }
}
