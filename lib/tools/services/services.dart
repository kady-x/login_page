import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../firebase_options.dart';
import 'package:get/get.dart';
import '../../../main.dart';

class Services extends GetxService with WidgetsBindingObserver {
  late SharedPreferences sharedPreferences;
  Future<Services> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    sharedPreferences = await SharedPreferences.getInstance();
    var selectedThemeMode = sharedPreferences.getInt("selectedThemeMode") ?? 0;
    if (selectedThemeMode == 0) {
      MyApp.themeNotifier.value = ThemeMode.system;
    }
    if (selectedThemeMode == 1) {
      MyApp.themeNotifier.value = ThemeMode.light;
    }
    if (selectedThemeMode == 2) {
      MyApp.themeNotifier.value = ThemeMode.dark;
    }

    return this;
  }
}

Future<void> initialServices() async {
  await Get.putAsync(() => Services().init());
}
