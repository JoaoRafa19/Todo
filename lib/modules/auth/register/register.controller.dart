import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/data/repositories/auth.repository.dart';

class RegisterController extends GetxController {
  RegisterController();

  //TextEditing controllers

  var loading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  AuthRepository repository = AuthRepository.instance;

  Future register() async {
    loading.value = true;
    try {
      final user = await repository.register(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
      );
      if (user == null) {
        throw Exception("Error");
      } else {
        Get.snackbar("Registro", "Sucesso!");
        Get.offAllNamed('/home');
      }
    } catch (e) {
      loading.value = false;
      Get.dialog(
        AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Get.back();
              },
            )
          ],
        ),
      );
    }
  }
}
