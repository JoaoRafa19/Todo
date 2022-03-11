import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todo/app/app.widget.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();

  return runApp(AppWidget());
}
/*

id app
ca-app-pub-4292490624006412~3296282998


id banner
ca-app-pub-4292490624006412/1128450501

id insterstial
ca-app-pub-4292490624006412/8815368830

*/