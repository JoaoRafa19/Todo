import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/shared/themes.dart';

import 'home.controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Get.reloadAll();
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
                      ? const Icon(Icons.logout)
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
            Positioned(
                top: 100,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    alignment: Alignment.center,
                    height: Get.height * 0.5,
                    width: Get.width * 0.9,
                    child: ListView.builder(
                        itemCount: 100,
                        itemBuilder: (itemBuilder, index) {
                          return ListTile(
                            title: Text('Item $index'),
                            onTap: () {
                              Get.log('Item $index');
                            },
                          );
                        }),
                  ),
                ))
          ],
        ),
      ),
      floatingActionButton:
          FloatingActionButton(child: const Icon(Icons.add), onPressed: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
