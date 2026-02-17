import 'package:flutter/material.dart';
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
      this.readOnly = false,
      this.maxLines,
      this.contentPadding});
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
  final int? maxLines;
  final EdgeInsetsGeometry? contentPadding;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTap: onTap,
      validator: validator,
      readOnly: readOnly,
      obscureText: obscureText,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        contentPadding: contentPadding,
        errorText: errorText,
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: suffixIcon,
        ),
        hintText: hint,
        hintStyle: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: AppColors.subtextColor),
      ),
    );
  }
}
