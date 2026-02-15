import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/helper/app_snack_bar.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/auth/presentation/manager/otp_verification/otp_verification_provider.dart';
import 'package:tabibak/features/auth/presentation/view/widget/otp_verification/otp_timer_text.dart';
import 'package:tabibak/features/auth/presentation/view/widget/otp_verification/title_text_states.dart';
import 'package:tabibak/features/auth/presentation/view/widget/otp_verification/verification_button_states.dart';
import 'package:tabibak/features/auth/presentation/view/widget/otp_widget.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  Timer? _timer;
  String? otp;
  UserModel? userModel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is UserModel) {
        setState(() {
          userModel = args;
          if (ref.read(secondsRemainingState) == 120) {
            ref
                .read(otpVerificationNotifierProvider.notifier)
                .sendOtp(email: userModel!.email!);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(otpVerificationNotifierProvider, (previous, next) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (next.isVerifiedIn) {
          ref.read(otpVerificationNotifierProvider.notifier).signUp(
              name: userModel?.name ?? "",
              email: userModel?.email ?? "",
              password: userModel?.password ?? "");
        } else if (next.isSignedUp) {
          context.pushNamedAndRemoveUntil(
              Routes.layoutScreen, (route) => false);
        } else if (next.errorMessage != null) {
          showErrorSnackBar(next.errorMessage!);
        }
      });
    });

    return Scaffold(
      appBar: AppBarWidget(title: AppStrings.confirmCode),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TitleTextStates(email: userModel?.email ?? ""),
            20.hBox,
            OtpWidget(
              onChanged: (value) {
                otp = value;
                setState(() {});
              },
            ),
            20.hBox,
            VerificationButtonStates(
                email: userModel?.email ?? "", otp: otp ?? ""),
            20.hBox,
            OtpTimerText(email: userModel?.email ?? "")
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
