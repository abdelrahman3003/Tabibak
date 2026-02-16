import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/auth/presentation/manager/reset_password/reset_password_provider.dart';

class ResetPasswordButtonStates extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController newPasswordController;
  const ResetPasswordButtonStates({
    super.key,
    required this.formKey,
    required this.newPasswordController,
  });

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(resetPasswordNotifierProvider);
    return AppButton(
      title: state.isLoading
          ? "${AppStrings.changing}..."
          : AppStrings.savePassword,
      isLoadingSide: state.isLoading,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          ref
              .read(resetPasswordNotifierProvider.notifier)
              .resetPassword(newPassword: newPasswordController.text);
        }
      },
    );
  }
}
