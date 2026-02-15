import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/helper/validation.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/auth/presentation/manager/sign_in/sign_in_provider.dart';
import 'package:tabibak/features/auth/presentation/view/widget/do_you_have_account.dart';
import 'package:tabibak/features/auth/presentation/view/widget/google_signin_button.dart';
import 'package:tabibak/features/auth/presentation/view/widget/password_text_filed.dart';

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
          const SizedBox(height: 30),
          SlideTransition(
            position: passwordAnimation,
            child: PasswordTextFiled(
                validator: (value) {
                  return Validation.validatePassord(value);
                },
                controller: passwordController),
          ),
          20.hBox,
          InkWell(
            onTap: () {
              context.pushNamed(Routes.resetPasswordScreen);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                AppStrings.forgotPassword,
                style: Apptextstyles.font16blackRegular
                    .copyWith(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 30),
          _LoginButton(
            animation: signinAnimation,
            signinKey: signinKey,
            emailController: emailController,
            passwordController: passwordController,
          ),
          20.hBox,
          GoogleSignInButton(animation: googleAnimation),
          const SizedBox(height: 60),
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

class _LoginButton extends ConsumerWidget {
  final Animation<Offset> animation;
  final GlobalKey<FormState> signinKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const _LoginButton({
    required this.animation,
    required this.signinKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(signInNotifierProvider);
    bool isLoading = loginState.isLoading;
    return SlideTransition(
        position: animation,
        child: AppButton(
          fontSize: 18.sp,
          title: isLoading ? "${AppStrings.loggingIn}.." : AppStrings.login,
          isLoading: isLoading,
          onPressed: () {
            if (!isLoading && signinKey.currentState!.validate()) {
              ref.read(signInNotifierProvider.notifier).signIn(
                    email: emailController.text,
                    password: passwordController.text,
                  );
            }
          },
        ));
  }
}
