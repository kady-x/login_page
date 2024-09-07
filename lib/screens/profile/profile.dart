import 'package:cached_network_image/cached_network_image.dart';
import 'package:login_page/tools/customs/custom_appbar.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../../tools/design/color_panel.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ProfileControllerImp controller = Get.put(ProfileControllerImp());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        text: 'Profile',
        showLeading: false,
      ),
      body: controller.signed == 1 ||
              controller.signed == 2 ||
              controller.signed == 3
          ? GetBuilder<ProfileControllerImp>(
              builder: (controller) => Padding(
                padding: const EdgeInsets.all(5.0),
                child: Form(
                  key: controller.profileFormKey,
                  child: ListView(
                    children: [
                      const SizedBox(height: 15),
                      ProfileImage(controller: controller),
                      const SizedBox(height: 15),
                      ProfileField(
                        controller: controller,
                        label: "Name".tr,
                        hint: "Enter your name here",
                        focusNode: controller.userFocusNode,
                        textController: controller.username,
                        onUpdate: controller.updateName,
                      ),
                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 15),
                      ProfileField(
                        controller: controller,
                        label: "Email".tr,
                        hint: "Enter your email here",
                        focusNode: controller.emailFocusNode,
                        textController: controller.email,
                        onUpdate: controller.updateEmail,
                      ),
                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 15),
                      ProfileField(
                        controller: controller,
                        label: "Phone".tr,
                        hint: "Enter your phone here",
                        focusNode: controller.phoneFocusNode,
                        textController: controller.phone,
                        onUpdate: controller.updatePhone,
                      ),
                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 15),
                      SocialLink(
                        image: "assets/images/google.png",
                        label: "Google Account: ".tr,
                        isConnected: controller.google == 1,
                        onTap: controller.googleLink,
                      ),
                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 15),
                      SocialLink(
                        image: "assets/images/facebook.png",
                        label: "Facebook Account: ".tr,
                        isConnected: controller.facebook == 1,
                        onTap: controller.facebookLink,
                      ),
                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 3),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: AppColor.red,
                        ),
                        onPressed: () {
                          controller.signout();
                        },
                        child: const Text(
                          'Sign Out',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock,
                      size: 80,
                      color: AppColor.primary,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'You are currently not signed in.',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please sign in to access your profile.',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 30,
                        ),
                        backgroundColor: AppColor.primary,
                      ),
                      onPressed: () {
                        controller.gotosignin();
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  final ProfileControllerImp controller;

  const ProfileImage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () async {
          String selectedImagePath = await controller.selectImageFromGallery();
          controller.selectedImagePath = selectedImagePath;
        },
        child: controller.signed == 1
            ? controller.selectedImagePath != ''
                ? Image.file(
                    File(controller.selectedImagePath),
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.2,
                    fit: BoxFit.fill,
                  )
                : LottieBuilder.asset(
                    "assets/lottie/user.json",
                    height: 140,
                    width: 140,
                  )
            : CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: MediaQuery.of(context).size.width * 0.18,
                backgroundImage: CachedNetworkImageProvider(
                  controller.img,
                ),
              ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final ProfileControllerImp controller;
  final String label;
  final String hint;
  final FocusNode focusNode;
  final TextEditingController textController;
  final VoidCallback onUpdate;

  const ProfileField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.focusNode,
    required this.textController,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        focusNode.requestFocus();
      },
      child: Stack(
        children: [
          TextField(
            focusNode: focusNode,
            controller: textController,
            readOnly: true,
            decoration: InputDecoration(
              hintStyle: const TextStyle(fontSize: 14),
              hintText: label,
              label: Text(label, style: const TextStyle(fontSize: 16)),
              suffixIcon: const Icon(Icons.edit),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showEditDialog(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter your $label',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: textController,
                decoration: InputDecoration(hintText: hint),
              ),
              Row(
                children: [
                  MaterialButton(
                      onPressed: () => Navigator.of(context).pop(),
                      textColor: AppColor.primary,
                      child: Text("Cancel".tr)),
                  const Spacer(),
                  MaterialButton(
                      onPressed: () {
                        onUpdate();
                        Navigator.of(context).pop();
                      },
                      textColor: AppColor.primary,
                      child: Text("Submit".tr)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class SocialLink extends StatelessWidget {
  final String image;
  final String label;
  final bool isConnected;
  final VoidCallback onTap;

  const SocialLink({
    super.key,
    required this.image,
    required this.label,
    required this.isConnected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Image.asset(image, height: 35, width: 35),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 17)),
        const Spacer(),
        InkWell(
          onTap: isConnected ? null : onTap,
          child: Text(
            isConnected ? "Connected".tr : "Connect".tr,
            style: TextStyle(
              fontSize: 16,
              color: isConnected ? Colors.green.shade500 : Colors.lightBlue,
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
