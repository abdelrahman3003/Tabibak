import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/features/auth/presentation/manager/otp_verification/otp_verification_provider.dart';

class OtpTimerText extends ConsumerStatefulWidget {
  const OtpTimerText({
    super.key,
  });

  @override
  ConsumerState<OtpTimerText> createState() => _OtpTimerTextState();
}

class _OtpTimerTextState extends ConsumerState<OtpTimerText> {
  late int _secondsRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = 120;
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
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
    final isLoading = ref.watch(otpVerificationNotifierProvider.select(
      (s) => s.isLoading,
    ));

    return InkWell(
      onTap: _secondsRemaining == 0 ? startTimer : null,
      child: Text(
        isLoading
            ? AppStrings.sendingCode
            : _secondsRemaining > 0
                ? "${AppStrings.resendAfter} $_secondsRemaining ${AppStrings.seconds}"
                : AppStrings.resendCode,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
