import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/helper/app_snack_bar.dart';
import 'package:tabibak/core/helper/validation.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/auth/presentation/manager/forget_password/forget_password_provider.dart';
import 'package:tabibak/features/auth/presentation/view/widget/forget_password/send_otp_button_states.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class ForgetPasswordScreen extends ConsumerStatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ConsumerState<ForgetPasswordScreen> createState() =>
      _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends ConsumerState<ForgetPasswordScreen> {
  late TextEditingController emailController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(forgetPasswordNotifierProvider, (previous, next) {
      if (next.isOTPSended) {
        context.pushNamed(Routes.oTPVerificationScreen,
            arguments: UserModel(email: emailController.text));
      } else if (next.errorMessage != null) {
        showErrorSnackBar(next.errorMessage!);
      }
    });

    return Scaffold(
      appBar: AppBarWidget(
        title: AppStrings.forgotPassword,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
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
                  prefixIcon: const Icon(Icons.email_outlined, size: 24),
                ),
                controller: emailController,
                validator: (value) => Validation.validateEmail(value),
              ),
              20.hBox,
              SendOtpButtonStates(formKey: formKey, email: emailController.text)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
