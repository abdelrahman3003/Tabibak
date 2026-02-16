import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/helper/validation.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_controller.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_states.dart';
import 'package:tabibak/features/auth/presentation/view/widget/password_text_filed.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

late TextEditingController newPasswordController;
late TextEditingController conformPasswordController;

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  @override
  void initState() {
    super.initState();

    ref.listen(authControllerProvider, (previous, next) {
      if (next is ResetPasswordSuccess) {
        context.pushNamed(Routes.resetPasswordSuccessScreen);
      } else if (next is ResetPasswordFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error), backgroundColor: AppColors.red),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(authControllerProvider.notifier);

    return Scaffold(
      appBar: AppBarWidget(
        title: AppStrings.setNewPassword,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppStrings.enterNewPassword,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 20.sp),
              ),
              20.hBox,
              PasswordTextFiled(
                controller: newPasswordController,
                hint: AppStrings.newPassword,
                validator: (value) => Validation.validatePassword(value),
              ),
              20.hBox,
              PasswordTextFiled(
                controller: conformPasswordController,
                hint: AppStrings.confirmNewPassword,
                validator: (value) {
                  if (value != newPasswordController.text) {
                    return AppStrings.passwordsNotMatch;
                  }
                  return Validation.validatePassword(value);
                },
              ),
              30.hBox,
              // const ResetPasswordButtonStates(
              //     resetPasswordKeyForm: resetPasswordKeyForm,
              //     newPassword: newPassword)
            ],
          ),
        ),
      ),
    );
  }
}
