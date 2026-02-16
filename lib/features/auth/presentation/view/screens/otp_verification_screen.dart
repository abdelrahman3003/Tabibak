import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/helper/app_snack_bar.dart';
import 'package:tabibak/core/helper/shared_pref.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/auth/presentation/manager/otp_verification/otp_verification_provider.dart';
import 'package:tabibak/features/auth/presentation/view/widget/otp_verification/otp_timer_text.dart';
import 'package:tabibak/features/auth/presentation/view/widget/otp_verification/otp_widget.dart';
import 'package:tabibak/features/auth/presentation/view/widget/otp_verification/title_text_states.dart';
import 'package:tabibak/features/auth/presentation/view/widget/otp_verification/verification_button_states.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key, required this.userModel});
  final UserModel userModel;
  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  @override
  void initState() {
    super.initState();
    // Future.microtask(() {
    //   ref
    //       .read(otpVerificationNotifierProvider.notifier)
    //       .sendOtp(email: widget.userModel.email!);
    // });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(otpVerificationNotifierProvider, (previous, next) async {
      if (next.isVerifiedIn) {
        await SharedPrefsService.prefs.setInt(SharedPrefKeys.step, 1);
        context.pushNamed(Routes.layoutScreen);
      } else if (next.errorMessage != null) {
        showErrorSnackBar(next.errorMessage!);
      }
    });

    return Scaffold(
      appBar: AppBarWidget(title: AppStrings.confirmCode),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TitleTextStates(email: widget.userModel.email ?? ""),
            20.hBox,
            OtpWidget(
              onChanged: (value) {
                ref.read(otpVerificationNotifierProvider.notifier).otp = value;
              },
            ),
            20.hBox,
            VerificationButtonStates(userModel: widget.userModel),
            20.hBox,
            OtpTimerText(email: widget.userModel.email ?? "")
          ],
        ),
      ),
    );
  }
}
