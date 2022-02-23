import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/modules/home/home.controller.dart';

Widget taskDialog(HomeController controller) {
  return Container(
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
          GestureDetector(
              onTap: () async {
                DateTime selected = await Get.dialog(DatePickerDialog(
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2050)));

                controller.selectedDate.value = selected;
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
                        "Deadline: ${controller.selectedDate.value.toString().split(' ')[0]}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                  ))),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              await controller.addTask();
              Get.back();
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
        ],
      ));
}
