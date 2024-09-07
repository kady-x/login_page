import 'package:flutter/material.dart';
import 'color_panel.dart';

ThemeData darkTheme = ThemeData(
  colorSchemeSeed: AppColor.primary,
  useMaterial3: true,
  brightness: Brightness.dark,
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: AppColor.white,
      fontFamily: 'Nunito',
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: AppColor.white,
      fontFamily: 'Nunito',
      fontSize: 13.0,
      fontWeight: FontWeight.bold,
    ),
  ),
);

ThemeData lightTheme = ThemeData(
  colorSchemeSeed: AppColor.primary,
  useMaterial3: true,
  brightness: Brightness.light,
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: AppColor.black,
      fontFamily: 'Nunito',
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: AppColor.black,
      fontFamily: 'Nunito',
      fontSize: 13.0,
      fontWeight: FontWeight.bold,
    ),
  ),
);
