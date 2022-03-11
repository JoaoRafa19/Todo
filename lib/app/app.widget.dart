import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo/app/app.pages.dart';
import 'package:todo/app/routes.dart';
import 'package:todo/app/translations.dart';
import 'package:todo/shared/themes.dart';

class AppWidget extends StatelessWidget {
  AppWidget({Key? key}) : super(key: key);
  final appdata = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "ToDo",
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      theme: Themes.light,
      defaultTransition: Transition.zoom,
      transitionDuration: const Duration(seconds: 1),
      translations: Messages(),
      locale: const Locale('pt', 'BR'),
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      initialRoute: FirebaseAuth.instance.currentUser == null ||
              (FirebaseAuth.instance.currentUser != null &&
                  FirebaseAuth.instance.currentUser!.isAnonymous)
          ? Routes.login
          : Routes.home,
    );
  }
}
