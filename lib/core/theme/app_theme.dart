import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      secondary: AppColors.primaryLight,
      onSecondary: AppColors.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(5.r),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(5.r),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(5.r),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(5.r),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    colorScheme: ColorScheme.dark(
      surface: Colors.grey.shade900,
      primary: Colors.grey.shade700,
      secondary: Colors.grey.shade500,
      onSecondary: AppColors.white,
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
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[900],
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(5.r),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(5.r),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(5.r),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(5.r),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    ),
  );
}
