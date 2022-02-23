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

  final tasks = <Task>[].obs;

  var todayVisibility = true.obs;

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

  Future closeTask(Task task) async {
    task.done = !task.done!;
    await _repository.update(task);

    tasks.value = await _repository.getByUser(user.value.uid);
  }

  Future removeTask(Task task) async {
    await _repository.delete(task);
    tasks.value = await _repository.getByUser(user.value.uid);
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
      final ref = await _repository.add(task);
      if (!ref.isBlank!) {
        tasks.add(task);
        taskController.clear();
        Get.back();
      }
      loading.value = false;
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
