import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_controller.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_states.dart';

class SendOtpButtonStates extends ConsumerWidget {
  const SendOtpButtonStates({
    super.key,
    required this.formKey,
  });
  final GlobalKey<FormState> formKey;
  @override
  Widget build(BuildContext context, ref) {
    return Consumer(
      builder: (context, ref, _) {
        final sendOtpState = ref.watch(authControllerProvider);

        bool isLoading = sendOtpState is SendOtpLoading;
        return AppButton(
          title: isLoading ? "${AppStrings.sendCode}..." : AppStrings.sendCode,
          isLoading: isLoading,
          onPressed: () {
            if (!isLoading && formKey.currentState!.validate()) {
              // ref
              //     .read(authControllerProvider.notifier)
              //     .sendOtp(email: emailController.text);
            }
          },
        );
      },
    );
  }
}
