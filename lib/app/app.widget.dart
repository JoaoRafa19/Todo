import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/app/app.pages.dart';
import 'package:todo/app/routes.dart';
import 'package:todo/shared/themes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "TodoIsh",
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService.instance.theme,
      initialRoute: FirebaseAuth.instance.currentUser == null ||
              (FirebaseAuth.instance.currentUser != null &&
                  FirebaseAuth.instance.currentUser!.isAnonymous)
          ? Routes.login
          : Routes.home,
    );
  }
}
