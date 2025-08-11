import 'package:flutter/material.dart';
import 'package:tabibak/core/theme/app_text_formfiled.dart';

class PasswordTextfiled extends StatefulWidget {
  const PasswordTextfiled(
      {super.key, this.controller, this.validator, this.errorText, this.hint});
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? errorText;
  final String? hint;
  @override
  State<PasswordTextfiled> createState() => _PasswordTextfiledState();
}

bool isPassword = true;

class _PasswordTextfiledState extends State<PasswordTextfiled> {
  @override
  Widget build(BuildContext context) {
    return AppTextFormFiled(
      hint: widget.hint ?? "كلمة المرور",
      prefixIcon: Icon(
        Icons.password_rounded,
      ),
      obscureText: isPassword,
      controller: widget.controller,
      validator: widget.validator,
      errorText: widget.errorText,
      suffixIcon: IconButton(
          onPressed: () {
            isPassword = !isPassword;
            setState(() {});
          },
          icon: Icon(
              isPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 24),
          color: Colors.grey),
    );
  }
}
