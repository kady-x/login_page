import 'package:login_page/tools/routes/app_route.dart';
import '../../../tools/customs/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class ResetController extends GetxController {
  resetPassword();
  resetSuccess();
}

class ResetControllerImp extends ResetController {
  GlobalKey<FormState> formstateresetpassword = GlobalKey<FormState>();
  late TextEditingController password;
  late TextEditingController repassword;
  bool isshowPassword = true;
  bool isshowRePassword = true;
  String? email;

  showPassword() {
    isshowPassword = isshowPassword == true ? false : true;
    update();
  }

  showRePassword() {
    isshowRePassword = isshowRePassword == true ? false : true;
    update();
  }

  @override
  resetPassword() {}

  @override
  resetSuccess() async {
    int retries = 0;
    const maxRetries = 3;

    if (password.text != repassword.text) {
      Get.showSnackbar(
        CustomSnackBarConfig.buildSnackBar(
          title: 'Error',
          message: 'Wrong Confirm Password',
          backgroundColor: Colors.red,
          icon: Icons.check_circle,
        ),
      );
      return;
    }

    if (retries > maxRetries) {
      Get.showSnackbar(
        CustomSnackBarConfig.buildSnackBar(
          title: 'Server time out',
          message: 'Please contact us.',
          backgroundColor: Colors.red,
          icon: Icons.check_circle,
        ),
      );
      return;
    }

    if (retries <= maxRetries) {
      var formdata = formstateresetpassword.currentState;

      if (formdata != null && formdata.validate()) {
        Get.showSnackbar(
          CustomSnackBarConfig.buildSnackBar(
            title: 'Success',
            message: 'Password has been reset',
            backgroundColor: Colors.green,
            icon: Icons.check_circle,
          ),
        );
        Get.offAllNamed(AppRoute.profile);
        return;
      } else {
        retries++;
        Get.showSnackbar(
          CustomSnackBarConfig.buildSnackBar(
            title: "Warning",
            message: "Password reset failed.\n Please contact us.",
            backgroundColor: Colors.red,
            icon: Icons.close,
          ),
        );
      }
    }
  }

  @override
  void onInit() {
    email = Get.arguments['email'];
    password = TextEditingController();
    repassword = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    password.dispose();
    repassword.dispose();
    super.dispose();
  }
}
