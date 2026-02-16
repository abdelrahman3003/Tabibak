import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/helper/validation.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/auth/presentation/view/widget/do_you_have_account.dart';
import 'package:tabibak/features/auth/presentation/view/widget/password_text_filed.dart';
import 'package:tabibak/features/auth/presentation/view/widget/sign_up/sign_up_button_states.dart';

class SignupBody extends ConsumerWidget {
  final GlobalKey<FormState> signUpFormKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Animation<Offset> nameAnimation;
  final Animation<Offset> emailAnimation;
  final Animation<Offset> passwordAnimation;
  final Animation<Offset> signupAnimation;

  const SignupBody({
    super.key,
    required this.signUpFormKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.nameAnimation,
    required this.emailAnimation,
    required this.passwordAnimation,
    required this.signupAnimation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: signUpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SlideTransition(
            position: nameAnimation,
            child: TextFormField(
              controller: nameController,
              validator: (value) {
                return Validation.validateName(value);
              },
              decoration: InputDecoration(
                hintText: AppStrings.name,
                prefixIcon: Icon(Icons.person_3_outlined, size: 24),
              ),
            ),
          ),
          const SizedBox(height: 15),
          SlideTransition(
            position: emailAnimation,
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: AppStrings.email,
                  prefixIcon: Icon(Icons.email_outlined)),
              controller: emailController,
              validator: (value) {
                return Validation.validateEmail(value);
              },
            ),
          ),
          const SizedBox(height: 15),
          SlideTransition(
              position: passwordAnimation,
              child: PasswordTextFiled(
                controller: passwordController,
                validator: (value) {
                  return Validation.validatePassword(value);
                },
              )),
          const SizedBox(height: 60),
          SignUpButtonStates(
            animation: signupAnimation,
            signUpFormKey: signUpFormKey,
            nameController: nameController,
            emailController: emailController,
            passwordController: passwordController,
          ),
          const SizedBox(height: 40),
          DoHaveAccount(
              title: AppStrings.alreadyHaveAccount,
              subtitle: AppStrings.login,
              onTap: () {
                nameController.clear();
                emailController.clear();
                passwordController.clear();
                context.pop();
                context.pushNamed(Routes.singInScreen);
              })
        ],
      ),
    );
  }
}
