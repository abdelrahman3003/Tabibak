import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      this.errorText,
      this.onTap,
      this.readOnly = false});
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? hintStyle;
  final String? errorText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool readOnly;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTap: onTap,
      validator: validator,
      readOnly: readOnly,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp),
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        errorText: errorText,
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: suffixIcon,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: 18.sp, color: Theme.of(context).colorScheme.secondary),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.red, width: 1.0),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.red, width: 1.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
