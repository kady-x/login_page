import '../../../controllers/auth/resetpassword/reset_controller.dart';
import 'package:login_page/tools/customs/custom_appbar.dart';
import '../../../../../../tools/functions/valid_input.dart';
import '../../../../../../tools/design/color_panel.dart';
import 'package:flutter_customs/flutter_customs.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class Reset extends StatelessWidget {
  const Reset({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ResetControllerImp());

    return Scaffold(
      appBar: const MyAppBar(text: 'Reset Password'),
      body: GetBuilder<ResetControllerImp>(
        builder: (controller) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 35),
          child: Form(
            key: controller.formstateresetpassword,
            child: ListView(
              children: [
                lottieAnimation(),
                title('New Password'),
                subtitle('Please Enter a New Password'),
                const SizedBox(height: 20),
                passwordField(controller, isConfirm: false),
                const SizedBox(height: 8),
                passwordField(controller, isConfirm: true),
                const SizedBox(height: 10),
                saveButton(controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget lottieAnimation() {
    return LottieBuilder.asset(
      "assets/lottie/code2.json",
      height: 250,
      width: 250,
    );
  }

  Widget title(String text) {
    return Text(
      text.tr,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: AppColor.white,
      ),
    );
  }

  Widget subtitle(String text) {
    return Text(
      text.tr,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: AppColor.white,
      ),
    );
  }

  Widget passwordField(ResetControllerImp controller,
      {required bool isConfirm}) {
    return CustomTextForm(
      valid: (val) => validInput(val!, 5, 30, "password"),
      mycontroller: isConfirm ? controller.repassword : controller.password,
      iconData: isConfirm
          ? (controller.isshowRePassword
              ? Icons.visibility
              : Icons.visibility_off)
          : (controller.isshowPassword
              ? Icons.visibility
              : Icons.visibility_off),
      labeltext: isConfirm ? "Confirm Password" : "Password",
      hinttext: '',
      isNumber: false,
      obscureText:
          isConfirm ? controller.isshowRePassword : controller.isshowPassword,
      onTapIcon: () {
        if (isConfirm) {
          controller.showRePassword();
        } else {
          controller.showPassword();
        }
      },
    );
  }

  Widget saveButton(ResetControllerImp controller) {
    return CustomButton(
      text: "Save Password",
      onPressed: controller.resetSuccess,
      fontColor: AppColor.primary,
    );
  }
}
