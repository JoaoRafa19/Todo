import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home.controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  Get.toNamed('/item1');
                },
              ),
              Obx(() => ListTile(
                    title: controller.loading.value
                        ? const Icon(Icons.logout)
                        : const Text('Logout'),
                    onTap: () async {
                      controller.logOut();
                    },
                  )),
            ],
          ),
        ),
        appBar:  AppBar(title: const Text('HomePage')),
        body: const SafeArea(child: Text('HomeController')));
  }
}
