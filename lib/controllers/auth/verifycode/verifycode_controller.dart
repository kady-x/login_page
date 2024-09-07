import 'package:login_page/screens/auth/resetpassword/reset.dart';
import '../../../tools/customs/custom_snackbar.dart';
import '../../../../tools/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class VerifyCodeController extends GetxController {
  checkCode();
  goToResetPassword(String verifycode);
}

class VerifyCodeControllerImp extends VerifyCodeController {
  late String verifycode;
  late String email;
  Services services = Get.find();

  @override
  checkCode() {}

  @override
  goToResetPassword(verifycode) async {
    int retries = 0;
    while (true) {
      if (retries >= 3) {
        if (kDebugMode) {
          print("Timeout occurred");
        }
        Get.showSnackbar(
          CustomSnackBarConfig.buildSnackBar(
            title: 'Timeout out',
            message: 'Email verfication failed, Please try again later.',
            backgroundColor: Colors.red,
            icon: Icons.close,
          ),
        );
        update();
        break;
      }
      Get.to(
        () => const Reset(),
        arguments: {
          "email": email,
        },
        transition: Transition.rightToLeft,
      );
      update();
      break;
    }
  }

  @override
  void onInit() {
    email = Get.arguments['email'] ?? '';
    super.onInit();
  }
}
