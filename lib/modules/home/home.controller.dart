import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/app/routes.dart';
import 'package:todo/data/repositories/auth.repository.dart';
import 'package:todo/data/repositories/task.repository.dart';

import '../../data/models/task.model.dart';
import '../../shared/themes.dart';

class HomeController extends GetxController {
  late Rx<User> user;

  var theme = false.obs;
  final loading = false.obs;
  final TaskRepository _repository = TaskRepository.instance;

  final tasks = [].obs;

  // TextControllers
  TextEditingController taskController = TextEditingController();
  final selectedDate = DateTime.now().obs;

  HomeController();

  @override
  Future<void> onInit() async {
    super.onInit();
    FirebaseAuth.instance.currentUser == null
        ? Get.offAllNamed(Routes.login)
        : user = FirebaseAuth.instance.currentUser!.obs;

    theme.value = ThemeService().theme == ThemeMode.dark;
    tasks.value = await _repository.getByUser(user.value.uid);
  }

  Future logOut() async {
    Get.offAllNamed(Routes.login);
  }

  Future addTask() async {
    try {
      loading.value = true;
      final currentUser = await AuthRepository.instance.getCurrentUser();
      if (currentUser == null) {
        Get.toNamed(Routes.login);
      }
      Task task = Task.newtask(
          deadline: selectedDate.value,
          task: taskController.text,
          uid: currentUser!.uid);
      await _repository.add(task);
    } catch (e) {
      Get.dialog(AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.error),
            SizedBox(width: 10),
            Text('Error'),
          ],
        ),
        content: const Text('Error adding task'),
        actions: <Widget>[
          TextButton(
            child: const Text('ok'),
            onPressed: () {
              Get.back();
              loading.value = false;
            },
          )
        ],
      ));
    }
  }
}
