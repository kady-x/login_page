import 'package:flutter/material.dart';
import '../design/color_panel.dart';
import 'package:get/get.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final Color? barColor;
  final List<BarAction>? barActions;
  final bool showLeading;
  const MyAppBar({
    super.key,
    required this.text,
    this.barColor,
    this.barActions,
    this.showLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        text.toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Nunito',
          color: AppColor.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
          wordSpacing: 8,
        ),
      ),
      backgroundColor: AppColor.primary,
      centerTitle: true,
      elevation: 0.0,
      actions: barActions?.map((action) {
        return Row(
          children: [
            InkWell(
              onTap: action.onTap,
              child: Icon(
                action.icon,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
          ],
        );
      }).toList(),
      leading: showLeading
          ? TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios_outlined,
                color: AppColor.white,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class BarAction {
  final IconData icon;
  final VoidCallback onTap;

  BarAction({required this.icon, required this.onTap});
}
