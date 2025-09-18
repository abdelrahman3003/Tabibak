import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_controller.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_states.dart';
import 'package:tabibak/features/auth/presentation/view/widget/otp_widget.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class OTPVerificationScreen extends ConsumerStatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  ConsumerState<OTPVerificationScreen> createState() =>
      _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends ConsumerState<OTPVerificationScreen> {
  int _secondsRemaining = 120;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 120;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    ref.read(authControllerProvider.notifier).otpController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    String email = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBarWidget(title: "تأكيد الرمز"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            titeTextStates(state, email),
            20.hBox,
            OtpWidget(
                controller:
                    ref.read(authControllerProvider.notifier).otpController,
                onCompleted: (pin) => ref
                    .read(authControllerProvider.notifier)
                    .verifyOtpCode(context)),
            20.hBox,
            verifyOtpButtonStates(email, state),
            20.hBox,
            timerTextStates(context, state),
          ],
        ),
      ),
    );
  }

  Text titeTextStates(AuthStates state, String email) {
    return Text(
        state is SendOtpLoading
            ? "جاري ارسال الرمز ..."
            : "تم ارسال الرمز الي $email",
        style: Apptextstyles.font16blackRegular);
  }

  InkWell timerTextStates(BuildContext context, AuthStates state) {
    return InkWell(
      onTap: () {
        ref.read(authControllerProvider.notifier).sendOtp(context);
      },
      child: Text(
          state is SendOtpLoading
              ? "جاري ارسال الرمز"
              : _secondsRemaining > 0
                  ? "إعادة الإرسال بعد $_secondsRemaining ثانية"
                  : "إعادة إرسال الرمز",
          style: Apptextstyles.font16blackRegular),
    );
  }

  verifyOtpButtonStates(String email, AuthStates state) {
    bool isLoading = state is VerifyOtpLoading;
    return AppButton(
      title: isLoading ? "جاري ارسال الرمز..." : "تاكيد",
      isLoading: isLoading,
      onPressed: () {
        if (!isLoading) {
          ref.read(authControllerProvider.notifier).verifyOtpCode(context);
        }
      },
    );
  }
}
