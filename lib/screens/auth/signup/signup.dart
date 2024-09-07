import '../../../controllers/auth/signup/signup_controller.dart';
import 'package:login_page/tools/customs/custom_appbar.dart';
import '../../../../../../tools/functions/valid_input.dart';
import '../../../../../../tools/design/color_panel.dart';
import 'package:flutter_customs/flutter_customs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Get.put(SignUpControllerImp());

    return Scaffold(
      appBar: const MyAppBar(text: 'Sign Up'),
      body: GetBuilder<SignUpControllerImp>(
        builder: (controller) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 26),
          child: Form(
            key: controller.formKey,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                welcomeText(),
                const SizedBox(height: 10),
                instructionText(),
                const SizedBox(height: 15),
                textFormField(
                  controller.username,
                  Icons.person_outline,
                  "Username".tr,
                  (val) => validInput(val!, 3, 16, "username"),
                ),
                textFormField(
                  controller.email,
                  Icons.email_outlined,
                  "Email".tr,
                  (val) => validInput(val!, 5, 35, "email"),
                ),
                CustomPhoneForm(
                  valid: (val) => validInput(val!, 7, 14, "phone"),
                  mycontroller: controller.phone,
                  iconData: Icons.phone_android_outlined,
                  labeltext: "Phone (optional)".tr,
                  hinttext: '',
                ),
                passwordField(controller),
                confirmPasswordField(controller),
                checkbox(controller),
                signUpButton(controller),
                const SizedBox(height: 40),
                signInPrompt(controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget welcomeText() {
    return const Text(
      "Welcome to our app",
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
      text: "Sign Up With Your Email And Password".tr,
    );
  }

  Widget textFormField(
    TextEditingController controller,
    IconData iconData,
    String labelText,
    FormFieldValidator<String> validator,
  ) {
    return CustomTextForm(
      valid: validator,
      mycontroller: controller,
      iconData: iconData,
      labeltext: labelText,
      hinttext: '',
      isNumber: false,
      obscureText: false,
    );
  }

  Widget passwordField(SignUpControllerImp controller) {
    return CustomTextForm(
      valid: (val) => validInput(val!, 5, 30, "password"),
      mycontroller: controller.password,
      iconData:
          controller.isshowPassword ? Icons.visibility : Icons.visibility_off,
      labeltext: "Password".tr,
      hinttext: '',
      isNumber: false,
      obscureText: controller.isshowPassword,
      onTapIcon: () => controller.showPassword(),
    );
  }

  Widget confirmPasswordField(SignUpControllerImp controller) {
    return CustomTextForm(
      valid: (val) => validInput(val!, 5, 30, "password"),
      mycontroller: controller.repassword,
      iconData:
          controller.isshowRePassword ? Icons.visibility : Icons.visibility_off,
      labeltext: "Confirm Password".tr,
      hinttext: '',
      isNumber: false,
      obscureText: controller.isshowRePassword,
      onTapIcon: () => controller.showRePassword(),
    );
  }

  Widget checkbox(SignUpControllerImp controller) {
    return CustomCheckbox(
      onTap: () {},
      valid: (isChecked) => validInput(isChecked.toString(), 0, 9, "checkbox"),
      text: "I have read and accept ".tr,
      linktext: "terms and conditions".tr,
      initialValue: isChecked,
      onChanged: (value) {
        setState(() {
          controller.checkbox = isChecked = value!;
        });
      },
      value: isChecked,
    );
  }

  Widget signUpButton(SignUpControllerImp controller) {
    return CustomButton(
      text: "Sign Up".tr,
      onPressed: () {
        if (controller.phone.text.isNotEmpty &&
            controller.phone.text.isPhoneNumber) {
          phoneSubmition(controller.phone);
        }
        Future.delayed(const Duration(milliseconds: 25), () {
          controller.signUp();
        });
      },
      fontColor: AppColor.primary,
    );
  }

  Widget signInPrompt(SignUpControllerImp controller) {
    return CustomTextSignUpOrSignIn(
      textone: " have an account ? ".tr,
      texttwo: "Sign In".tr,
      onTap: () => controller.goToSignIn(),
      fontColor: AppColor.primary,
    );
  }
}
