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

  final loadintasks = false.obs;

  final notTodayTasks = <Task>[].obs;

  var todayVisibility = true.obs;
  var tomorrowVisibility = true.obs;

  // TextControllers
  TextEditingController taskController = TextEditingController();
  final selectedDate = DateTime.now().obs;

  HomeController();

  @override
  Future<void> onInit() async {
    super.onInit();
    loadintasks.value = true;
    await Future.delayed(const Duration(seconds: 2));
    FirebaseAuth.instance.currentUser == null
        ? Get.offAllNamed(Routes.login)
        : user = FirebaseAuth.instance.currentUser!.obs;

    theme.value = ThemeService().theme == ThemeMode.dark;
    await getTasks();
    loadintasks.value = false;
  }

  Future getTasks() async {
    final tasks = await _repository.getByUser(user.value.uid);
    this.tasks.value =
        tasks.where((task) => task.deadline!.isBefore(DateTime.now())).toList();

    notTodayTasks.value =
        tasks.where((task) => task.deadline!.isAfter(DateTime.now())).toList();
  }

  Future logOut() async {
    Get.offAllNamed(Routes.login);
  }

  Future closeTask(Task task) async {
    task.done = !task.done!;
    task.updateAt = DateTime.now();
    await _repository.update(task);

    await getTasks();
  }

  Future removeTask(Task task) async {
    await _repository.delete(task);
    await getTasks();
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
        await getTasks();
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
