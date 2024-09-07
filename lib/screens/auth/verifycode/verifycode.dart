import '../../../controllers/auth/verifycode/verifycode_controller.dart';
import 'package:login_page/tools/customs/custom_appbar.dart';
import '../../../../../../tools/design/color_panel.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class VerifyCode extends StatelessWidget {
  final String email;
  const VerifyCode({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(VerifyCodeControllerImp());

    return Scaffold(
      appBar: const MyAppBar(text: 'Code'),
      body: GetBuilder<VerifyCodeControllerImp>(
        builder: (controller) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: ListView(
            children: [
              lottieAnimation(),
              headingText('Check Code'),
              const SizedBox(height: 10),
              subtitleText('Please Enter The Digit Code Sent To $email'),
              const SizedBox(height: 15),
              oTPTextField(controller, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget lottieAnimation() {
    return LottieBuilder.asset(
      'assets/lottie/code.json',
      height: 250,
      width: 250,
    );
  }

  Text headingText(String text) {
    return Text(
      text.tr,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.bold,
        fontSize: 35,
        color: AppColor.white,
      ),
    );
  }

  Text subtitleText(String text) {
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

  Widget oTPTextField(
      VerifyCodeControllerImp controller, BuildContext context) {
    return OTPTextField(
      length: 5,
      width: MediaQuery.of(context).size.width,
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldWidth: 50,
      fieldStyle: FieldStyle.box,
      outlineBorderRadius: 15,
      otpFieldStyle: OtpFieldStyle(
        borderColor:
            ValueNotifier(ThemeMode.system) == ValueNotifier(ThemeMode.light)
                ? AppColor.white
                : AppColor.black,
        focusBorderColor: const Color(0xFF166E98),
      ),
      style: const TextStyle(fontSize: 17),
      onChanged: (String code) {
        if (kDebugMode) {
          print(code);
        }
      },
      onCompleted: (String verifycode) {
        controller.goToResetPassword(verifycode);
      },
    );
  }
}
