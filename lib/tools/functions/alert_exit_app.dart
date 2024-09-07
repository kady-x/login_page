import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

Future<bool> alertExitApp() {
  Get.defaultDialog(
    title: "Exit...".tr,
    middleText: "Are You Sure,You Want to Exit?".tr,
    actions: [
      ElevatedButton(
        onPressed: () {
          exit(0);
        },
        child: Text("yes".tr),
      ),
      ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("cancel".tr),
      ),
    ],
  );
  return Future.value(true);
}
