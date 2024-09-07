import '../../../screens/auth/verifycode/verifycode.dart';
import '../../../tools/customs/custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class ForgetController extends GetxController {
  checkemail();
}

class ForgetControllerImp extends ForgetController {
  GlobalKey<FormState> formstateforgetpassword = GlobalKey<FormState>();
  late TextEditingController email;

  @override
  checkemail() async {
    if (formstateforgetpassword.currentState!.validate()) {
      Get.to(
        () => VerifyCode(email: email.text),
        arguments: {'email': email.text},
        transition: Transition.rightToLeft,
      );
      Get.showSnackbar(
        CustomSnackBarConfig.buildSnackBar(
          title: "Warning",
          message: "An email has been sent",
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        ),
      );
      if (kDebugMode) {
        print("Mail sent");
      }
    }
  }

  @override
  void onInit() {
    email = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  void goToSignIn() {}
}
