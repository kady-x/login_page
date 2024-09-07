import 'package:login_page/screens/auth/forgetpassword/forget.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:login_page/tools/customs/custom_snackbar.dart';
import '../../../../../../tools/services/services.dart';
import '../../../../../tools/design/color_panel.dart';
import '../../../../../tools/routes/app_route.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../screens/auth/signup/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class LoginController extends GetxController {
  void goToSignUp();
  void goToForgetPassword();
  void showPassword();
  Future<void> signIn();
  Future<void> googleSignIn();
  Future<void> facebookSignIn();
}

class LoginControllerImp extends LoginController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Services services = Get.find();
  bool isShowPassword = true;
  late TextEditingController email;
  late TextEditingController password;

  @override
  void onInit() {
    super.onInit();
    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Future<void> signIn() async {
    if (formKey.currentState!.validate()) {
      handleSignIn();
    } else {
      showErrorSnackBar();
    }
  }

  Future<void> handleSignIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      showSuccessDialog();
      services.sharedPreferences.setInt("signin", 1);
      services.sharedPreferences.setString("username", '');
      services.sharedPreferences.setString("email", email.text);
      services.sharedPreferences.setString("phone", '');
      Get.offAllNamed(AppRoute.profile);
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
  Future<void> googleSignIn() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Future.delayed(const Duration(seconds: 2));

    final GoogleSignInAccount? currentUser = GoogleSignIn(
      clientId:
          '305594734666-t5077r9j3d3ajinfehkreghda8b5bi0e.apps.googleusercontent.com',
      scopes: [
        'email',
        "https://www.googleapis.com/auth/userinfo.profile",
      ],
    ).currentUser;
    if (currentUser != null) {
      if (kDebugMode) {
        print("User is already signed in: ${currentUser.email}");
      }
      return;
    }

    final GoogleSignInAccount? gUser = await GoogleSignIn(
      clientId:
          '305594734666-t5077r9j3d3ajinfehkreghda8b5bi0e.apps.googleusercontent.com',
      scopes: [
        'email',
        "https://www.googleapis.com/auth/userinfo.profile",
      ],
    ).signIn();
    if (gUser == null) {
      if (kDebugMode) {
        print("Error 1");
      }
      return;
    }

    final GoogleSignInAuthentication gAuth = await gUser.authentication;
    if (gAuth.accessToken == null || gAuth.idToken == null) {
      if (kDebugMode) {
        print("Error 2");
        print("accessToken = ${gAuth.accessToken}");
        print("idToken = ${gAuth.idToken}");
      }
      return;
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    await handleGoogleUser(gUser, credential);
  }

  Future<void> handleGoogleUser(
      GoogleSignInAccount gUser, AuthCredential credential) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await currentUser.linkWithCredential(credential);
    } else {
      await FirebaseAuth.instance.signInWithCredential(credential);
    }

    services.sharedPreferences.setInt("signin", 2);
    services.sharedPreferences.setInt("google", 1);
    services.sharedPreferences
        .setString("username", gUser.displayName ?? 'username');
    services.sharedPreferences.setString("email", gUser.email);
    services.sharedPreferences.setString("img", gUser.photoUrl ?? 'img');
    showSuccessDialog();
    Get.offAllNamed(AppRoute.profile);
  }

  @override
  Future<void> facebookSignIn() async {
    final LoginResult fUser = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile']);
    if (fUser.status != LoginStatus.success) return;

    final userData = await FacebookAuth.instance
        .getUserData(fields: "name,email,picture.width(200)");
    final credential =
        FacebookAuthProvider.credential(fUser.accessToken!.tokenString);
    await FirebaseAuth.instance.signInWithCredential(credential);
    await handleFacebookUser(userData);
  }

  Future<void> handleFacebookUser(Map<String, dynamic> userData) async {
    services.sharedPreferences.setInt("signin", 3);
    services.sharedPreferences.setInt("facebook", 1);
    services.sharedPreferences.setString("username", userData['name']);
    services.sharedPreferences.setString("email", userData['email']);
    services.sharedPreferences
        .setString("img", userData['picture']['data']['url']);
    showSuccessDialog();
    Get.offAllNamed(AppRoute.profile);
  }

  @override
  void goToSignUp() {
    Get.to(
      () => const SignUp(),
      transition: Transition.rightToLeft,
    );
  }

  @override
  void goToForgetPassword() {
    Get.to(
      () => const Forget(),
      transition: Transition.rightToLeft,
    );
  }

  @override
  void showPassword() {
    isShowPassword = !isShowPassword;
    update();
  }

  void showErrorSnackBar() {
    CustomSnackBarConfig.buildSnackBar(
      title: 'Error',
      message: 'Email or Password Not Correct',
      backgroundColor: AppColor.red,
      icon: Icons.error,
    ).show();
  }

  void showSuccessDialog() {
    CustomSnackBarConfig.buildSnackBar(
      title: 'Success',
      message: 'You have been signed in',
      backgroundColor: const Color(0xFF1B5E20),
      position: SnackPosition.TOP,
    ).show();
  }
}
