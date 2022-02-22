import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/data/repositories/auth.repository.dart';

import '../../../app/routes.dart';

class LoginController extends GetxController {
  //Text controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final AuthRepository repository = AuthRepository.instance;

  Future login() async {
    final user =
        await repository.login(emailController.text, passwordController.text);
    if (user == null) {
      emailController.clear();
      passwordController.clear();
      Get.dialog(AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.error),
            SizedBox(width: 10),
            Text('Error'),
          ],
        ),
        content: const Text('Invalid credentials'),
        actions: <Widget>[
          TextButton(
            child: const Text('ok'),
            onPressed: () {
              Get.back();
            },
          )
        ],
      ));
    } else {
      Get.offNamed(Routes.home);
    }
  }

  Future register() async {}

  LoginController();
}
