import 'package:login_page/tools/customs/custom_snackbar.dart';
import 'package:login_page/tools/routes/app_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../tools/design/color_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class SignUpController extends GetxController {
  signUp();
  goToSignIn();
}

class SignUpControllerImp extends SignUpController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController username;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController password;
  late TextEditingController repassword;
  late bool checkbox;

  bool isshowPassword = true;
  bool isshowRePassword = true;

  List data = [];

  @override
  signUp() async {
    if (!formKey.currentState!.validate()) {
      phone = TextEditingController();
      return;
    }
    if (password.text != repassword.text) {
      CustomSnackBarConfig.buildSnackBar(
        title: 'Error',
        message: 'Wrong Confirm Password',
        backgroundColor: AppColor.red,
      ).show();
      return;
    }
    if (!checkbox) {
      CustomSnackBarConfig.buildSnackBar(
        title: 'Error',
        message: 'You must agree to the terms and conditions',
        backgroundColor: AppColor.red,
      ).show();
      return;
    }
    Future.delayed(
      const Duration(milliseconds: 20),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      CustomSnackBarConfig.buildSnackBar(
        title: 'Success',
        message: "Your email have been created successfully",
        backgroundColor: Colors.green.shade500,
      ).show();
      Get.offAllNamed(AppRoute.signin);
    } on FirebaseAuthException catch (e) {
      CustomSnackBarConfig.buildSnackBar(
        title: 'Error',
        message: e.message!,
        backgroundColor: AppColor.red,
      ).show();
    } catch (e) {
      CustomSnackBarConfig.buildSnackBar(
        title: 'Error',
        message: 'An unexpected error occurred: ${e.toString()}',
        backgroundColor: AppColor.red,
      ).show();
    }
  }

  @override
  goToSignIn() {
    Get.back();
  }

  showPassword() {
    isshowPassword = isshowPassword == true ? false : true;
    update();
  }

  showRePassword() {
    isshowRePassword = isshowRePassword == true ? false : true;
    update();
  }

  @override
  void onInit() {
    username = TextEditingController();
    phone = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    repassword = TextEditingController();
    checkbox = false;
    super.onInit();
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    repassword.dispose();
    super.dispose();
  }
}
