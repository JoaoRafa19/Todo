import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:todo/modules/home/widgets/task.widget.dart';
import 'package:todo/shared/themes.dart';

import '../../data/models/task.model.dart';
import 'home.controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Obx(() => controller.user.value.photoURL != null
                          ? Image.network(
                              controller.user.value.photoURL!,
                              fit: BoxFit.contain,
                              frameBuilder: (context, child, frame,
                                  wasSynchronouslyLoaded) {
                                return Container(
                                  child: child,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return Container(
                                    child: child,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle),
                                  );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            )
                          : Image.asset(
                              'assets/images/account.png',
                              isAntiAlias: true,
                              width: 100,
                              alignment: Alignment.center,
                              color: Colors.grey,
                            )),
                    ),
                  ),
                  Positioned(
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Obx(() => Text(
                                    controller.user.value.displayName
                                            ?.split(' ')[0] ??
                                        'Nome do usuário',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Obx(() => Text(
                                    controller.user.value.email ??
                                        'Nome do usuário',
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          )))
                ],
              ),
            ),
            Obx(() => ListTile(
                  title: controller.loading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Logout'),
                  onTap: () async {
                    controller.logOut();
                  },
                )),
            Obx(() => ListTile(
                  title: Row(
                    children: [
                      const Text('Light'),
                      Switch(
                        value: controller.theme.value,
                        onChanged: (value) => {
                          ThemeService().switchTheme(),
                          controller.theme.value =
                              ThemeService().theme == ThemeMode.dark
                        },
                      ),
                      const Text("Dark"),
                    ],
                  ),
                  onTap: () {},
                )),
          ],
        ),
      ),
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
                child: Container(
                  width: Get.width,
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(Get.width * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Expanded(
                              child: Text("Hoje",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.todayVisibility.value =
                                    !controller.todayVisibility.value;
                              },
                              child: Text(
                                controller.todayVisibility.value
                                    ? "Esconder"
                                    : "Mostrar",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: controller.todayVisibility.value,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          height: Get.height * 0.5,
                          width: Get.width * 0.9,
                          child: ListView.builder(
                              itemCount: controller.tasks.length,
                              itemBuilder: (itemBuilder, index) {
                                Task task = controller.tasks[index];
                                return Slidable(
                                  closeOnScroll: true,
                                  child: buildListTile(task),
                                  direction: Axis.horizontal,
                                  endActionPane: ActionPane(
                                    extentRatio: 0.25,
                                    children: const [],
                                    motion: Container(
                                        color: Colors.red,
                                        width: 25,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.delete_forever,
                                            color: Colors.white,
                                          ),
                                          onPressed: () async {
                                            await controller.removeTask(task);
                                          },
                                        )),
                                  ),
                                  startActionPane: ActionPane(
                                    extentRatio: 0.25,
                                    children: const [],
                                    motion: Container(
                                        color: task.done!
                                            ? Colors.redAccent
                                            : Colors.greenAccent,
                                        child: IconButton(
                                          icon: Icon(
                                            task.done!
                                                ? Icons.remove_done
                                                : Icons.done,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            controller.closeTask(task);
                                          },
                                        )),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
