import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:login_page/screens/auth/signin/signin.dart';
import 'package:login_page/screens/profile/profile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../tools/customs/custom_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import '../../tools/design/color_panel.dart';
import '../../tools/services/services.dart';
import '../../tools/routes/app_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

abstract class ProfileController extends GetxController {
  actionButton();
  updateImg();
  updateName();
  googleLink();
  facebookLink();
  gotosignin();
  signout();
}

class ProfileControllerImp extends ProfileController {
  GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  FocusNode userFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  Services services = Get.find();
  late TextEditingController username = TextEditingController();
  late TextEditingController email = TextEditingController();
  late TextEditingController password = TextEditingController();
  late TextEditingController repassword = TextEditingController();
  late TextEditingController phone = TextEditingController();
  late String img = '';
  late String id = '';
  late int facebook = 0;
  late int google = 0;
  late int signed = 0;

  String selectedImagePath = '';
  late File image;
  final imagePicker = ImagePicker();
  bool isEnable = true;
  bool isImagePickerActive = false;

  selectImageFromGallery() async {
    if (!isImagePickerActive) {
      isImagePickerActive = true;
      XFile? file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      isImagePickerActive = false;

      if (file != null) {
        selectedImagePath = file.path;
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: file.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: AppColor.primary,
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: AppColor.primary,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
              ],
            ),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
              ],
            ),
          ],
        );

        if (croppedFile != null) {
          selectedImagePath = croppedFile.path;
          await updateImg();
          return selectedImagePath;
        } else {
          return '';
        }
      } else {
        return '';
      }
    } else {
      if (kDebugMode) {
        print('Image picker is already active');
      }
      return '';
    }
  }

  @override
  actionButton() {
    if (isEnable) {
      isEnable = false;
      username.text = services.sharedPreferences.getString('username')!;
      email.text = services.sharedPreferences.getString('email')!;
      phone.text = services.sharedPreferences.getString('phone')!;
      id = services.sharedPreferences.getInt("id").toString();
    } else {
      isEnable = true;
      username.clear();
      email.clear();
      phone.clear();
    }
  }

  @override
  updateImg() async {
    File imgFile = File(selectedImagePath);
    Uint8List bytes = await imgFile.readAsBytes();
    File tempFile = File('${imgFile.path}.temp');
    await tempFile.writeAsBytes(bytes);
    services.sharedPreferences.setString("img", selectedImagePath);
  }

  @override
  updateName() async {
    if (kDebugMode) {
      print("Name updated successfully");
      services.sharedPreferences.setString("username", username.text);
    }
  }

  updateEmail() {
    if (kDebugMode) {
      print("eMail updated successfully");
      services.sharedPreferences.setString("email", email.text);
      services.sharedPreferences.setString("phone", phone.text);
    }
  }

  updatePhone() {
    if (phone.text == '') {
      Get.showSnackbar(
        CustomSnackBarConfig.buildSnackBar(
          title: 'Error',
          message: 'Phone number can\'t be empty',
          backgroundColor: Colors.red,
          icon: Icons.close,
        ),
      );
      return;
    }
    if (kDebugMode) {
      print("Phone updated successfully");
      services.sharedPreferences.setString("email", email.text);
      services.sharedPreferences.setString("phone", phone.text);
    }
  }

  @override
  googleLink() async {
    await GoogleSignIn().signOut();
    Future<void> updateAccount(
        GoogleSignInAccount gUser, User? currentUser) async {
      Get.offAllNamed(AppRoute.profile);
      CustomSnackBarConfig.buildSnackBar(
        title: 'Success',
        message: 'Google account linked',
        backgroundColor: Colors.green,
      );
    }

    Future<void> handleExistingAccount(
      GoogleSignInAccount gUser,
      AuthCredential? credential,
    ) async {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        if (credential != null) {
          await currentUser.linkWithCredential(credential);
        }
        await updateAccount(gUser, currentUser);
      } else {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential!);
        await updateAccount(gUser, userCredential.user);
      }
    }

    final GoogleSignInAccount? currentUser = GoogleSignIn().currentUser;

    if (currentUser != null) {
      if (kDebugMode) {
        print("User is already signed in: ${currentUser.email}");
      }
      await handleExistingAccount(currentUser, null);
      return;
    }

    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if (gUser == null) {
      if (kDebugMode) {
        print("Google Sign-In aborted by user.");
      }
      return;
    }

    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    if (gAuth.accessToken == null || gAuth.idToken == null) {
      if (kDebugMode) {
        print("Failed to obtain IDs during sign-in.");
      }
      return;
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    await handleExistingAccount(gUser, credential);
  }

  @override
  facebookLink() async {
    await FacebookAuth.instance.logOut();
    final LoginResult fUser = await FacebookAuth.instance.login(permissions: [
      'email',
      'public_profile',
    ]);
    final OAuthCredential credential = FacebookAuthProvider.credential(
      fUser.accessToken!.tokenString,
    );

    final currentUser = FirebaseAuth.instance.currentUser;
    Get.offNamed(AppRoute.profile);
    Get.offNamed(AppRoute.profile);
    if (kDebugMode) {
      print("linked Successfully");

      Get.offNamed(AppRoute.profile);
      if (kDebugMode) {
        print("Already linked And Email Or Phone Alreday Exist");
      }
      await FirebaseAuth.instance.signInWithCredential(credential);
      await currentUser?.linkWithCredential(credential);
    }
  }

  @override
  void onInit() {
    super.onInit();
    id = services.sharedPreferences.getInt("id").toString();
    username.text =
        services.sharedPreferences.getString('username') ?? 'username';
    email.text = services.sharedPreferences.getString('email') ?? 'email';
    password = TextEditingController();
    repassword = TextEditingController();
    phone.text = services.sharedPreferences.getString('phone') ?? 'phone';
    img = services.sharedPreferences.getString('img') ?? '';
    google = services.sharedPreferences.getInt("google") ?? 0;
    facebook = services.sharedPreferences.getInt("facebook") ?? 0;
    signed = services.sharedPreferences.getInt("signin") ?? 0;
  }

  @override
  void dispose() {
    super.dispose();
    phone.dispose();
    username.dispose();
    email.dispose();
    password.dispose();
    repassword.dispose();
  }

  @override
  gotosignin() {
    Get.to(
      () => const SignIn(),
      transition: Transition.rightToLeft,
    );
  }

  @override
  signout() async {
    await FirebaseAuth.instance.signOut();
    int? signedin = services.sharedPreferences.getInt("signin");
    signedin == 2
        ? await GoogleSignIn().signOut()
        : await FacebookAuth.instance.logOut();
    services.sharedPreferences.setInt("signin", 0);
    services.sharedPreferences.setInt("google", 0);
    services.sharedPreferences.setInt("facebook", 0);
    Get.offAll(
      () => const Profile(),
      transition: Transition.size,
    );
    CustomSnackBarConfig.buildSnackBar(
      title: 'Success',
      message: 'You have been signed out',
      backgroundColor: Colors.red,
    ).show();
  }
}
