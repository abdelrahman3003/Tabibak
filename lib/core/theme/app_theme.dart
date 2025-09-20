import 'package:flutter/material.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: "Tajawal",
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.scaffoldBG,
    colorScheme: ColorScheme.light(
        surface: AppColors.scaffoldBG,
        primary: AppColors.primary,
        secondary: AppColors.primaryLight),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    colorScheme: ColorScheme.dark(
      surface: Colors.grey.shade900,
      primary: AppColors.primaryDark,
      secondary: Colors.grey.shade700,
    ),
    fontFamily: "Tajawal",
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
  );
}
