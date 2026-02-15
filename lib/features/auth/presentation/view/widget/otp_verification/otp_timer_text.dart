import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/features/auth/presentation/manager/otp_verification/otp_verification_provider.dart';

final secondsRemainingState = StateProvider<int>((ref) => 120);

class OtpTimerText extends ConsumerStatefulWidget {
  const OtpTimerText({
    super.key,
    required this.email,
  });
  final String email;
  @override
  ConsumerState<OtpTimerText> createState() => _OtpTimerTextState();
}

class _OtpTimerTextState extends ConsumerState<OtpTimerText> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startTimer();
    });
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = ref.read(secondsRemainingState.notifier);
      if (remaining.state > 0) {
        remaining.state--;
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secondsRemaining = ref.watch(secondsRemainingState);
    final isLoading = ref.watch(otpVerificationNotifierProvider.select(
      (s) => s.isSendingOtp,
    ));

    return InkWell(
      onTap: secondsRemaining == 0
          ? () {
              startTimer();
              ref
                  .read(otpVerificationNotifierProvider.notifier)
                  .sendOtp(email: widget.email);
            }
          : null,
      child: Text(
        isLoading
            ? AppStrings.sendingCode
            : secondsRemaining > 0
                ? "${AppStrings.resendAfter} $secondsRemaining ${AppStrings.seconds}"
                : AppStrings.resendCode,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
