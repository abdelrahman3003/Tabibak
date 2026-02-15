import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/widgets/app_button.dart';

class ResetPasswordSuccessScreen extends StatelessWidget {
  const ResetPasswordSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle,
                  color: Colors.lightGreen, size: 120),
              20.hBox,
              Text(
                "${AppStrings.passwordChangedSuccess}🎉",
                style: Theme.of(context).textTheme.titleLarge!,
                textAlign: TextAlign.center,
              ),
              10.hBox,
              Text(
                AppStrings.passwordChangedMessage,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              30.hBox,
              AppButton(
                title: AppStrings.goToLogin,
                onPressed: () {
                  context.pushNamedAndRemoveUntil(
                      Routes.singInScreen, (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
