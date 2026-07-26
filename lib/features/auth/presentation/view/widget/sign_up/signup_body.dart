import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/helper/validation.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/auth/presentation/view/widget/sign_up/city_drop_down.dart';
import 'package:tabibak/features/auth/presentation/view/widget/sign_up/do_you_have_account.dart';
import 'package:tabibak/features/auth/presentation/view/widget/sign_up/password_text_filed.dart';
import 'package:tabibak/features/auth/presentation/view/widget/sign_up/sign_up_button_states.dart';

class SignupBody extends ConsumerWidget {
  final GlobalKey<FormState> signUpFormKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Animation<Offset> nameAnimation;
  final Animation<Offset> emailAnimation;
  final Animation<Offset> specialtyAnimation;
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
    required this.specialtyAnimation,
    required this.passwordAnimation,
    required this.signupAnimation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: signUpFormKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideTransition(
                      position: nameAnimation,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: nameController,
                        validator: Validation.validateName,
                        decoration: InputDecoration(
                          hintText: AppStrings.name,
                          prefixIcon: const Icon(
                            Icons.person_3_outlined,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SlideTransition(
                      position: emailAnimation,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: emailController,
                        validator: Validation.validateEmail,
                        decoration: InputDecoration(
                          hintText: AppStrings.email,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SlideTransition(
                      position: specialtyAnimation,
                      child: const CityDropdown(),
                    ),
                    const SizedBox(height: 15),
                    SlideTransition(
                      position: passwordAnimation,
                      child: PasswordTextFiled(
                        controller: passwordController,
                        validator: Validation.validatePassword,
                      ),
                    ),
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
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
