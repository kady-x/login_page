import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackBarConfig {
  static GetSnackBar buildSnackBar({
    String? title,
    String? message,
    required Color backgroundColor,
    IconData? icon,
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    Get.closeAllSnackbars();
    return GetSnackBar(
      title: title,
      message: message,
      snackPosition: position,
      margin: const EdgeInsets.only(bottom: 70),
      maxWidth: 330,
      backgroundColor: backgroundColor,
      borderRadius: 20,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(milliseconds: 1350),
      icon: icon != null
          ? Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Icon(
                icon,
                size: 50,
              ),
            )
          : null,
      titleText: Center(
        child: title != null
            ? Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w800,
                  fontSize: 19,
                  color: Colors.white,
                ),
              )
            : null,
      ),
      messageText: Center(
        child: message != null
            ? Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}
