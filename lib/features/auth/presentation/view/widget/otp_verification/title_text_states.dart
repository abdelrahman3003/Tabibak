import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/features/auth/presentation/manager/otp_verification/otp_verification_provider.dart';

class TitleTextStates extends ConsumerWidget {
  const TitleTextStates({super.key, required this.email});
  final String email;
  @override
  Widget build(BuildContext context, ref) {
    final isLoading = ref.watch(
      otpVerificationNotifierProvider.select((s) => s.isSendingOtp),
    );
    return Text(
        isLoading
            ? "${AppStrings.sendingCode}..."
            : "${AppStrings.codeSentTo} $email",
        style: Theme.of(context).textTheme.bodyLarge);
  }
}
