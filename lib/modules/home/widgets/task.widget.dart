import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/modules/home/home.controller.dart';

import '../../../data/models/task.model.dart';

Future<TimeOfDay?> _selectTime(BuildContext context) async {
  TimeOfDay selectedTime = TimeOfDay.now();
  final TimeOfDay? timeOfDay = await showTimePicker(
    context: context,
    initialTime: selectedTime,
    initialEntryMode: TimePickerEntryMode.dial,
  );
  if (timeOfDay != null && timeOfDay != selectedTime) {
    return timeOfDay;
  }
  return null;
}

Widget taskDialog(HomeController controller) {
  return SingleChildScrollView(
    child: Container(
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back),
                ),
              ],
            ),
            const Text(
              'Add Task',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.taskController,
              decoration: InputDecoration(
                  constraints: BoxConstraints(
                    maxWidth: Get.width * 0.8,
                  ),
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  label: const Text('Task'),
                  hintText: 'Descrição da task',
                  focusColor: Colors.white,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  suffixIcon: const Icon(Icons.task)),
            ),
            const SizedBox(height: 10),
            //DeadLine
            Container(
              width: Get.width * 0.8,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.white),
              ),
              child: TextButton(
                onPressed: () async {
                  await controller.setAlarm(await _selectTime(Get.context!));
                },
                child: const Text(
                  "Definir alarme",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            GestureDetector(
                onTap: () async {
                  DateTime? selected = await Get.dialog(DatePickerDialog(
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2050)));
                  if (selected != null) {
                    controller.setDeadLine = selected;
                  }
                },
                child: Obx(() => Container(
                      alignment: Alignment.center,
                      width: Get.width * 0.8,
                      decoration: BoxDecoration(
                          color: Theme.of(Get.context!).secondaryHeaderColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(10),
                      child: Text(
                          "Deadline: ${controller.selectedDate.value.toString().split(' ')[0].replaceAll('-', '/')}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                    ))),
            const SizedBox(height: 20),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Add to calendar",
                        style: TextStyle(fontSize: 18)),
                    Switch(
                        value: controller.addToCalendar.value,
                        onChanged: (value) {
                          controller.addToCalendar.value = value;
                        }),
                  ],
                )),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                if (controller.taskController.text.isNotEmpty &&
                    !controller.loading.value) {
                  await controller.addTask();
                  Get.back();
                } else {
                  if (!controller.loading.value) {
                    Get.snackbar(
                        "Ops, Que apressado!", "Preencha o campo de task",
                        snackPosition: SnackPosition.BOTTOM);
                  }
                }
              },
              child: Container(
                width: Get.width * 0.8,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                padding: const EdgeInsets.all(10),
                child: Obx(() => controller.loading.value
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Add',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      )),
              ),
            ),
            const SizedBox(height: 20),
          ],
        )),
  );
}

Widget buildListTile(Task task) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    title: Text(task.task!,
        style: TextStyle(
            fontSize: 18,
            decoration:
                task.done! ? TextDecoration.lineThrough : TextDecoration.none)),
    leading: Checkbox(
      value: task.done,
      onChanged: (value) {},
    ),
    subtitle: Text(task.deadline.toString().split(' ')[0]),
  );
}
