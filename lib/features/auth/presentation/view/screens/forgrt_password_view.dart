import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/helper/validation.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_controller.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_states.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class ForgrtPasswordView extends ConsumerWidget {
  const ForgrtPasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppStrings.forgotPassword,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: ref.read(authControllerProvider.notifier).sendOtpKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.enterEmailForCode,
                style: Apptextstyles.font20BlackRegular,
              ),
              20.hBox,
              TextFormField(
                decoration: InputDecoration(
                  hintText: AppStrings.email,
                  prefixIcon: const Icon(Icons.email_outlined, size: 24),
                ),
                controller:
                    ref.read(authControllerProvider.notifier).emailController,
                validator: (value) => Validation.validateEmail(value),
              ),
              20.hBox,
              sendOtpButtonStates()
            ],
          ),
        ),
      ),
    );
  }

  Consumer sendOtpButtonStates() {
    return Consumer(
      builder: (context, ref, _) {
        final sendOtpState = ref.watch(authControllerProvider);

        bool isLoading = sendOtpState is SendOtpLoading;
        return AppButton(
          title: isLoading ? "${AppStrings.sendCode}..." : AppStrings.sendCode,
          isLoading: isLoading,
          onPressed: () {
            if (!isLoading &&
                ref
                    .read(authControllerProvider.notifier)
                    .sendOtpKey
                    .currentState!
                    .validate()) {
              ref.read(authControllerProvider.notifier).sendOtp(context);
            }
          },
        );
      },
    );
  }
}
