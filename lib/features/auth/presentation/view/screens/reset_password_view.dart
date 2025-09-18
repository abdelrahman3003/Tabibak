import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/helper/validation.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_controller.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_states.dart';
import 'package:tabibak/features/auth/presentation/view/widget/password_textfiled.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class ResetPasswordView extends ConsumerWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppStrings.setNewPassword,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: ref.read(authControllerProvider.notifier).resetPasswordKeyForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppStrings.enterNewPassword,
                style: Apptextstyles.font20BlackRegular,
              ),
              20.hBox,
              PasswordTextfiled(
                controller: ref
                    .read(authControllerProvider.notifier)
                    .newPasswordController,
                hint: AppStrings.newPassword,
                validator: (value) => Validation.validatePassord(value),
              ),
              20.hBox,
              PasswordTextfiled(
                  controller: ref
                      .read(authControllerProvider.notifier)
                      .confirmNewPasswordController,
                  hint: AppStrings.confirmNewPassword,
                  validator: (value) {
                    if (value !=
                        ref
                            .read(authControllerProvider.notifier)
                            .newPasswordController
                            .text) {
                      return AppStrings.passwordsNotMatch;
                    }
                    Validation.validatePassord(value);
                    return null;
                  }),
              30.hBox,
              resetPassowrdButtonStates(context),
            ],
          ),
        ),
      ),
    );
  }

  resetPassowrdButtonStates(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(authControllerProvider);
      bool isLoading = state is ResetPassordLoading;
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
