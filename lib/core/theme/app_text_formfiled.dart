import 'package:flutter/material.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class AppTextFormFiled extends StatelessWidget {
  const AppTextFormFiled(
      {super.key,
      this.hint,
      this.prefixIcon,
      this.controller,
      this.validator,
      this.suffixIcon,
      this.hintStyle,
      this.obscureText = false,
      this.errorText});
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? hintStyle;
  final String? errorText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: Apptextstyles.font18LightRegular,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        errorText: errorText,
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: suffixIcon,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        hintText: hint,
        hintStyle: hintStyle ?? Apptextstyles.font18LightRegular,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.red, width: 1.0), // أحمر من درجات Material
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.red, width: 1.0), // أحمر من درجات Material
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary, // لون البوردر عند التركيز
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
