import 'package:flutter/material.dart';

abstract final class AppColors {
  static const ink = Color(0xFF050516);
  static const muted = Color(0xFF85848E);
  static const orange = Color(0xFFFC4F22);
  static const purple = Color(0xFF5140B0);
  static const cyan = Color(0xFF06C1FF);
  static const border = Color(0xFFF0EFF2);
}

ThemeData appTheme() => ThemeData(
  useMaterial3: true,
  fontFamily: 'Roboto',
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orange),
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: AppColors.ink,
    displayColor: AppColors.ink,
  ),
  splashFactory: NoSplash.splashFactory,
  highlightColor: Colors.transparent,
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.orange),
    ),
  ),
);
