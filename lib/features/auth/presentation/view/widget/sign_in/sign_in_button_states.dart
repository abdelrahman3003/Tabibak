import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/auth/presentation/manager/sign_in/sign_in_provider.dart';

class SignInButtonStates extends ConsumerWidget {
  final Animation<Offset> animation;
  final GlobalKey<FormState> signinKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const SignInButtonStates({
    super.key,
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
