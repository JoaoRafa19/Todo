import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/data/repositories/auth.repository.dart';

import '../../../app/routes.dart';

class LoginController extends GetxController {
  LoginController();
  //Text controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final loading = false.obs;

  final AuthRepository repository = AuthRepository.instance;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future login() async {
    loading.value = true;
    await Future.delayed(const Duration(seconds: 3));
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
      loading.value = false;
    } else {
      Get.offNamed(Routes.home);
    }
  }

  Future loginWithGoogle() async {
    loading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 3));
      final user = await repository.loginWithGoogle();
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
        loading.value = false;
      } else {
        analytics.logLogin(
          loginMethod: 'google',
        );
        Get.offNamed(Routes.home);
      }
    } catch (e) {
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
        content: Text("Invalid credentials, ${e}"),
        actions: <Widget>[
          TextButton(
            child: const Text('ok'),
            onPressed: () {
              loading.value = false;
              Get.back();
            },
          )
        ],
      ));
    }
  }
}
