import '../../../controllers/auth/signin/signin_controller.dart';
import 'package:login_page/tools/customs/custom_appbar.dart';
import '../../../../../../tools/functions/valid_input.dart';
import '../../../../../../tools/design/color_panel.dart';
import 'package:flutter_customs/flutter_customs.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    Get.put(LoginControllerImp());

    return Scaffold(
      appBar: const MyAppBar(text: 'sign in'),
      body: GetBuilder<LoginControllerImp>(
        builder: (controller) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 28),
          child: Form(
            key: controller.formKey,
            child: ListView(
              children: [
                const SizedBox(height: 15),
                lottieAnimation(),
                welcomeText(),
                const SizedBox(height: 5),
                instructionText(),
                const SizedBox(height: 15),
                emailField(controller),
                passwordField(controller),
                forgotPasswordLink(controller),
                const SizedBox(height: 3),
                signInButton(controller),
                const SizedBox(height: 40),
                signUpPrompt(controller),
                const SizedBox(height: 5),
                buildDivider(),
                socialMediaLoginButtons(controller),
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
      "assets/lottie/user.json",
      height: 140,
      width: 140,
    );
  }

  Widget welcomeText() {
    return const Text(
      "Welcome Back",
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
      text: "Sign In With Your Email And Password".tr,
    );
  }

  Widget emailField(LoginControllerImp controller) {
    return CustomTextForm(
      valid: (val) => validInput(val!, 5, 35, "email"),
      mycontroller: controller.email,
      iconData: Icons.email_outlined,
      labeltext: "Email".tr,
      hinttext: '',
      isNumber: false,
      obscureText: false,
    );
  }

  Widget passwordField(LoginControllerImp controller) {
    return CustomTextForm(
      valid: (val) => validInput(val!, 6, 30, "password"),
      mycontroller: controller.password,
      iconData:
          controller.isShowPassword ? Icons.visibility : Icons.visibility_off,
      labeltext: "Password".tr,
      hinttext: '',
      isNumber: false,
      obscureText: controller.isShowPassword,
      onTapIcon: () => controller.showPassword(),
    );
  }

  Widget forgotPasswordLink(LoginControllerImp controller) {
    return InkWell(
      onTap: () => controller.goToForgetPassword(),
      child: Text(
        "Forgot Password".tr,
        textAlign: TextAlign.end,
        style: const TextStyle(
          color: AppColor.white,
          fontFamily: 'Nunito',
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget signInButton(LoginControllerImp controller) {
    return CustomButton(
      text: "Sign In".tr,
      onPressed: () => controller.signIn(),
      fontColor: AppColor.primary,
    );
  }

  Widget signUpPrompt(LoginControllerImp controller) {
    return CustomTextSignUpOrSignIn(
      textone: "Don't have an account ? ".tr,
      texttwo: "SignUp".tr,
      onTap: () => controller.goToSignUp(),
      fontColor: AppColor.primary,
    );
  }

  Widget buildDivider() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: const Divider(height: 36),
          ),
        ),
        Text("OR".tr),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: const Divider(height: 36),
          ),
        ),
      ],
    );
  }

  Widget socialMediaLoginButtons(LoginControllerImp controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        socialMediaButton(
          imagePath: 'assets/images/google.png',
          onTap: () => controller.googleSignIn(),
        ),
        const SizedBox(width: 23),
        socialMediaButton(
          imagePath: 'assets/images/facebook.png',
          onTap: () => controller.facebookSignIn(),
        ),
      ],
    );
  }

  Widget socialMediaButton(
      {required String imagePath, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          imagePath,
          height: MediaQuery.of(context).size.width * 0.12,
        ),
      ),
    );
  }
}
