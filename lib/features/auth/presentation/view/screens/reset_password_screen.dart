import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/helper/app_snack_bar.dart';
import 'package:tabibak/core/helper/validation.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/auth/presentation/manager/reset_password/reset_password_provider.dart';
import 'package:tabibak/features/auth/presentation/view/widget/reset_passwprd/reset_password_button_states.dart';
import 'package:tabibak/features/auth/presentation/view/widget/sign_up/password_text_filed.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  late TextEditingController newPasswordController;
  late TextEditingController conformPasswordController;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    newPasswordController = TextEditingController();
    conformPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(resetPasswordNotifierProvider, (previous, next) {
      if (next.isReset) {
        context.pushNamed(Routes.resetPasswordSuccessScreen);
      } else if (next.errorMessage != null) {
        showErrorSnackBar(next.errorMessage!);
      }
    });

    return Scaffold(
      appBar: AppBarWidget(
        title: AppStrings.setNewPassword,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
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
              ResetPasswordButtonStates(
                  formKey: formKey,
                  newPasswordController: newPasswordController)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    newPasswordController.dispose();
    conformPasswordController.dispose();
  }
}
