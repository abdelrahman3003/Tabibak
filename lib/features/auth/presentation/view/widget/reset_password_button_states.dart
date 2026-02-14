import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_controller.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_states.dart';

class ResetPasswordButtonStates extends StatelessWidget {
  const ResetPasswordButtonStates({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(authControllerProvider);
      bool isLoading = state is ResetPasswordLoading;
      return AppButton(
        title:
            isLoading ? "${AppStrings.changing}..." : AppStrings.savePassword,
        isLoading: isLoading,
        onPressed: () {
          if (!isLoading &&
              ref
                  .read(authControllerProvider.notifier)
                  .resetPasswordKeyForm
                  .currentState!
                  .validate()) {
            ref.read(authControllerProvider.notifier).resetPassword(context);
          }
        },
      );
    });
  }
}
