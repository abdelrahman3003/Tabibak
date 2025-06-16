import 'package:flutter/material.dart';
import 'package:tabibak/core/class/naviagtion.dart';
import 'package:tabibak/core/class/routes.dart';
import 'package:tabibak/core/theme/app_button.dart';
import 'package:tabibak/core/theme/app_text_formfiled.dart';
import 'package:tabibak/features/auth/signin/representation/view/widget/password_textfiled.dart';
import 'package:tabibak/features/auth/signup/representation/view/widget/do_you_have_account.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppTextFormFiled(
              hint: "الإسم",
              prefixIcon: Icon(Icons.person_3_outlined, size: 24)),
          const SizedBox(height: 15),
          AppTextFormFiled(
              hint: "الايميل",
              prefixIcon: Icon(Icons.email_outlined, size: 24)),
          const SizedBox(height: 15),
          PasswordTextfiled(),
          const SizedBox(height: 60),
          AppButton(title: "إنشاء حساب"),
          const SizedBox(height: 40),
          DoHaveAccount(
              title: "هل لديك حساب بالفعل؟",
              subtitle: "تسجيل الدخول",
              onTap: () {
                context.pushNamed(Routes.singinView);
              })
        ],
      ),
    ));
  }
}
