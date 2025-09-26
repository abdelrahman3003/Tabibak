import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';

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

    // AppTextFormFiled(
    //   hint: widget.hint ?? AppStrings.password,
    //   prefixIcon: Icon(
    //     Icons.password_rounded,
    //   ),
    //   obscureText: isPassword,
    //   controller: widget.controller,
    //   validator: widget.validator,
    //   errorText: widget.errorText,
    //   suffixIcon: IconButton(
    //       onPressed: () {
    //         isPassword = !isPassword;
    //         setState(() {});
    //       },
    //       icon: Icon(
    //           isPassword
    //               ? Icons.visibility_off_outlined
    //               : Icons.visibility_outlined,
    //           size: 24),
    //       color: Colors.grey),
    // );
  }
}
