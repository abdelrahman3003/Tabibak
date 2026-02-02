import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.radius16,
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.radius16,
          borderSide: BorderSide(color: AppColors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.radius16,
          borderSide: BorderSide(color: AppColors.red, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.radius16,
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        )),
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.radius16,
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.radius16,
          borderSide: BorderSide(color: AppColors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.radius16,
          borderSide: BorderSide(color: AppColors.red, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.radius16,
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        )),
  );
}
