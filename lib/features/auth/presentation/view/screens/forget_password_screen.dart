import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_controller.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_states.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class ForgetPasswordScreen extends ConsumerWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authControllerProvider, (previous, next) {
      if (next is SendOtpSuccess) {
        context.pushNamed(Routes.oTPVerificationScreen,
            arguments: UserModel(
              email: "",
            ));
      } else if (next is SendOtpFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error), backgroundColor: AppColors.red),
        );
      }
    });

    return Scaffold(
      appBar: AppBarWidget(
        title: AppStrings.forgotPassword,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // key: ref.read(authControllerProvider.notifier).sendOtpKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.enterEmailForCode,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              20.hBox,
              TextFormField(
                  decoration: InputDecoration(
                    hintText: AppStrings.email,
                    prefixIcon: Icon(Icons.email_outlined, size: 24),
                  ),
                  controller: TextEditingController()

                  // validator: (value) => Validation.validateEmail(value),
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
            if (!isLoading
                // ref
                //     .read(authControllerProvider.notifier)
                //     .sendOtpKey
                //     .currentState!
                //     .validate()

                ) {
              // ref.read(authControllerProvider.notifier).sendOtp();
            }
          },
        );
      },
    );
  }
}
