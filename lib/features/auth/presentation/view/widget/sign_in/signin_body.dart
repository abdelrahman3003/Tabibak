import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/helper/validation.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/auth/presentation/view/widget/do_you_have_account.dart';
import 'package:tabibak/features/auth/presentation/view/widget/password_text_filed.dart';
import 'package:tabibak/features/auth/presentation/view/widget/sign_in/google_signin_button.dart';
import 'package:tabibak/features/auth/presentation/view/widget/sign_in/sign_in_button_states.dart';

class SigninBody extends ConsumerWidget {
  final GlobalKey<FormState> signinKey;
  final Animation<Offset> emailAnimation;
  final Animation<Offset> passwordAnimation;
  final Animation<Offset> signinAnimation;
  final Animation<Offset> googleAnimation;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const SigninBody(
      {super.key,
      required this.signinKey,
      required this.emailAnimation,
      required this.passwordAnimation,
      required this.signinAnimation,
      required this.googleAnimation,
      required this.emailController,
      required this.passwordController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: signinKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SlideTransition(
              position: emailAnimation,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: AppStrings.email,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                controller: emailController,
                validator: (value) {
                  return Validation.validateEmail(value);
                },
              )),
          30.hBox,
          SlideTransition(
            position: passwordAnimation,
            child: PasswordTextFiled(
                validator: (value) {
                  return Validation.validatePassword(value);
                },
                controller: passwordController),
          ),
          20.hBox,
          InkWell(
            onTap: () {
              context.pushNamed(Routes.forgetPasswordScreen);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(AppStrings.forgotPassword,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColors.primary)),
            ),
          ),
          30.hBox,
          SignInButtonStates(
            animation: signinAnimation,
            signinKey: signinKey,
            emailController: emailController,
            passwordController: passwordController,
          ),
          20.hBox,
          GoogleSignInButton(animation: googleAnimation),
          50.hBox,
          DoHaveAccount(
            title: AppStrings.noAccount,
            subtitle: AppStrings.createAccount,
            onTap: () {
              context.pop();
              context.pushNamed(Routes.singUpScreen);
            },
          )
        ],
      ),
    );
  }
}
