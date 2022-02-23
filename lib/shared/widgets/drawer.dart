
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modules/home/home.controller.dart';
import '../themes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                                decoration:
                                    const BoxDecoration(shape: BoxShape.circle),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
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
    );
  }
}
