import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/auth/presentation/manager/forget_password/forget_password_provider.dart';

class SendOtpButtonStates extends ConsumerWidget {
  const SendOtpButtonStates({
    super.key,
    required this.formKey,
    required this.emailController,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(forgetPasswordNotifierProvider);

    return AppButton(
      title:
          state.isLoading ? "${AppStrings.sendCode}..." : AppStrings.sendCode,
      isLoadingSide: state.isLoading,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          ref
              .read(forgetPasswordNotifierProvider.notifier)
              .sendOtp(email: emailController.text);
        }
      },
    );
  }
}
