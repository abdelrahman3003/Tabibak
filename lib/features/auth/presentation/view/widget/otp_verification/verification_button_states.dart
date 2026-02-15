import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/auth/presentation/manager/otp_verification/otp_verification_provider.dart';

class VerificationButtonStates extends ConsumerWidget {
  const VerificationButtonStates({
    super.key,
    required this.userModel,
  });
  final UserModel userModel;
  @override
  Widget build(BuildContext context, ref) {
    final isLoading = ref.watch(otpVerificationNotifierProvider.select(
      (s) => s.isLoading,
    ));

    return AppButton(
      fontSize: 18.sp,
      title: isLoading ? "${AppStrings.sendingCode}..." : AppStrings.confirm,
      isLoading: isLoading,
      onPressed: isLoading
          ? null
          : () {
              ref
                  .read(otpVerificationNotifierProvider.notifier)
                  .verifyOtpCode(userModel: userModel);
            },
    );
  }
}
