import '../../../controllers/auth/forgetpassword/forget_controller.dart';
import 'package:login_page/tools/customs/custom_appbar.dart';
import '../../../../../../tools/functions/valid_input.dart';
import '../../../../../../tools/design/color_panel.dart';
import 'package:flutter_customs/flutter_customs.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class Forget extends StatelessWidget {
  const Forget({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ForgetControllerImp());

    return Scaffold(
      appBar: const MyAppBar(text: 'Forget Password'),
      body: GetBuilder<ForgetControllerImp>(
        builder: (controller) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: Form(
            key: controller.formstateforgetpassword,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                lottieAnimation(),
                const SizedBox(height: 20),
                welcomeText(),
                const SizedBox(height: 10),
                instructionText(),
                const SizedBox(height: 15),
                emailField(controller),
                const SizedBox(height: 20),
                checkButton(controller),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget lottieAnimation() {
    return LottieBuilder.asset(
      "assets/lottie/mail.json",
      height: 180,
      width: 200,
    );
  }

  Widget welcomeText() {
    return const Text(
      "Check Email",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColor.white,
        fontFamily: 'Nunito',
        fontSize: 34,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget instructionText() {
    return CustomTextBody(
      text: "Please Enter Your Email Address To Receive A Verification Code".tr,
    );
  }

  Widget emailField(ForgetControllerImp controller) {
    return CustomTextForm(
      valid: (val) => validInput(val!, 5, 35, "email"),
      mycontroller: controller.email,
      iconData: Icons.email_outlined,
      labeltext: "Email",
      hinttext: '',
      isNumber: false,
      obscureText: false,
    );
  }

  Widget checkButton(ForgetControllerImp controller) {
    return CustomButton(
      text: "Check",
      onPressed: () {
        controller.checkemail();
      },
      fontColor: AppColor.primary,
    );
  }
}
