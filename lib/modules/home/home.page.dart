import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:todo/modules/home/widgets/task.widget.dart';

import '../../data/models/task.model.dart';
import '../../shared/widgets/drawer.dart';
import 'home.controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: CustomDrawer(controller: controller),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.account_circle),
                  onPressed: () {
                    if (_scaffoldKey.currentState != null) {
                      _scaffoldKey.currentState?.openEndDrawer();
                    }
                  },
                ),
              ),
            ),
            Obx(() => Positioned(
                top: 50,
                child: Column(
                  children: [
                    Container(
                      width: Get.width,
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: Get.width * 0.05,
                                left: Get.width * 0.05,
                                right: Get.width * 0.05),
                            child: listTitle("Hoje",
                                visibility: controller.todayVisibility),
                          ),
                          controller.loadintasks.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                  color: Colors.white,
                                ))
                              : taskList(controller.tasks,
                                  height: Get.height * 0.4,
                                  visibility: controller.todayVisibility.value),
                          Padding(
                            padding: EdgeInsets.all(Get.width * 0.05),
                            child: listTitle("Amanhã",
                                fontsize: 30,
                                visibility: controller.tomorrowVisibility),
                          ),
                          controller.loadintasks.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                  color: Colors.white,
                                ))
                              : taskList(controller.notTodayTasks,
                                  height: Get.height * 0.3,
                                  visibility:
                                      controller.tomorrowVisibility.value),
                        ],
                      ),
                    ),
                  ],
                )))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Get.bottomSheet(taskDialog(controller),
                enableDrag: true,
                backgroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    side: BorderSide(
                        color: Colors.white,
                        style: BorderStyle.solid,
                        width: 1)));
          }),
    );
  }

  taskList(List list, {double? width, double? height, bool visibility = true}) {
    return Visibility(
      visible: visibility,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        height: height ?? Get.height * 0.4,
        width: width ?? Get.width * 0.9,
        child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (itemBuilder, index) {
              Task task = list[index];
              return Slidable(
                key: Key(task.id!),
                child: buildListTile(task),
                direction: Axis.horizontal,
                endActionPane: ActionPane(
                  dismissible: DismissiblePane(
                      onDismissed: () async =>
                          await controller.removeTask(task)),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.redAccent,
                      icon: Icons.delete,
                      label: 'Excluir',
                      onPressed: (context) async {
                        await controller.removeTask(task);
                      },
                    ),
                  ],
                  motion: const ScrollMotion(),
                ),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 0.35,
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.greenAccent,
                      icon: task.done! ? Icons.remove_done : Icons.done,
                      foregroundColor: Colors.white,
                      label: task.done! ? 'Desmarcar' : 'Concluir',
                      onPressed: (context) async {
                        await controller.closeTask(task);
                      },
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Row listTitle(String title, {double? fontsize, required RxBool visibility}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Text(title,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: fontsize ?? 40,
                fontWeight: FontWeight.bold,
              )),
        ),
        TextButton(
          onPressed: () {
            visibility.value = !visibility.value;
          },
          child: Text(
            visibility.value ? "Esconder" : "Mostrar",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
