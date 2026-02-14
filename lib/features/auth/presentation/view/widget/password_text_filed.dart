import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';

class PasswordTextFiled extends StatefulWidget {
  const PasswordTextFiled(
      {super.key, this.controller, this.validator, this.errorText, this.hint});
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? errorText;
  final String? hint;
  @override
  State<PasswordTextFiled> createState() => _PasswordTextFiledState();
}

bool isPassword = true;

class _PasswordTextFiledState extends State<PasswordTextFiled> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: widget.hint ?? AppStrings.password,
        prefixIcon: Icon(Icons.password_rounded),
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
      ),
      obscureText: isPassword,
      validator: widget.validator,
    );
  }
}
