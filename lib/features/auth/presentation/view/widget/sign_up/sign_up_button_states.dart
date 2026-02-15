import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/auth/presentation/manager/sign%20up/sign_up_provider.dart';

class SignUpButtonStates extends ConsumerWidget {
  final Animation<Offset> animation;
  final GlobalKey<FormState> signUpFormKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const SignUpButtonStates({
    super.key,
    required this.animation,
    required this.signUpFormKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      signUpNotifierProvider.select((s) => s.isLoading),
    );

    return SlideTransition(
        position: animation,
        child: AppButton(
          fontSize: 18.sp,
          title: isLoading
              ? "${AppStrings.creatingAccount}..."
              : AppStrings.createAccount,
          isLoadingSide: isLoading,
          onPressed: () {
            if (!isLoading && signUpFormKey.currentState!.validate()) {
              ref.read(signUpNotifierProvider.notifier).signUp(
                  name: nameController.text,
                  email: emailController.text,
                  password: passwordController.text);
            }
          },
        ));
  }
}
