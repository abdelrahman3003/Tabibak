import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/core/helper/validation.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_button.dart';
import 'package:tabibak/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tabibak/features/auth/presentation/controllers/auth_states.dart';
import 'package:tabibak/features/auth/presentation/view/widget/password_textfiled.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class ResetPasswordView extends ConsumerWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "تعيين كلمة مرور جديدة",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: ref.read(resetPasswordKeyForm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "أدخل كلمة مرور جديدة وأكدها",
                style: Apptextstyles.font20BlackRegular,
              ),
              20.hBox,
              PasswordTextfiled(
                controller: ref.read(newPasswordConrtollerprovider),
                hint: "كلمة المرور الجديدة",
                validator: (value) => Validation.validatePassord(value),
              ),
              20.hBox,
              PasswordTextfiled(
                  controller: ref.read(confirmNewPasswordConrtollerprovider),
                  hint: "تأكيد كلمة المرور",
                  validator: (value) {
                    if (value != ref.read(newPasswordConrtollerprovider).text) {
                      return "كلمة المرور غير متطابقة";
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
        title: isLoading ? "جاري التغير ..." : " حفظ كلمة المرور",
        isLoading: isLoading,
        onPressed: () {
          if (!isLoading &&
              ref.read(resetPasswordKeyForm).currentState!.validate()) {
            ref.read(authControllerProvider.notifier).resetPassword(context);
          }
        },
      );
    });
  }
}
