import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/app/routes.dart';
import 'package:todo/data/repositories/auth.repository.dart';
import 'package:todo/data/repositories/task.repository.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

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

  var addToCalendar = false.obs;

  // TextControllers
  TextEditingController taskController = TextEditingController();
  final selectedDate = DateTime.now().obs;

  set setDeadLine(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> setAlarm(TimeOfDay? time) async {
    try {
      if (time != null) {
        selectedDate.value = DateTime(
            selectedDate.value.year,
            selectedDate.value.month,
            selectedDate.value.day,
            time.hour,
            time.minute);
      }
    } catch (e) {
      Get.dialog(AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.error),
            SizedBox(width: 10),
            Text('Error'),
          ],
        ),
        content: const Text('Error adding to calendar'),
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
        Event event = Event(
            title: taskController.text,
            description: '',
            startDate: selectedDate.value,
            endDate: selectedDate.value,
            location: '',
            allDay: false);

        loading.value = false;

        if (addToCalendar.value) {
          Add2Calendar.addEvent2Cal(event).then((value) {
            if (value) {
              Get.snackbar('Success', 'Event added to calendar',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  borderColor: Colors.green);
            } else {
              Get.snackbar('Error', 'Error adding to calendar',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  borderColor: Colors.red);
            }
            Get.back();
          });
        } else {
          Get.back();
        }
      } else {
        throw Exception('Error adding task');
      }
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
