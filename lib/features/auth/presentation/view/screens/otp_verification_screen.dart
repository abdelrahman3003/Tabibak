import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_controller.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_states.dart';
import 'package:tabibak/features/auth/presentation/view/widget/otp_widget.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  int _secondsRemaining = 120;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(authControllerProvider.notifier).sendOtp();
    });
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
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final userModel = ModalRoute.of(context)!.settings.arguments as UserModel?;

    ref.listen(authControllerProvider, (previous, next) {
      if (next is VerifyOtpSuccess) {
        context.pushNamed(Routes.resetPasswordScreen);
      } else if (next is VerifyOtpFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error), backgroundColor: AppColors.red),
        );
      } else if (next is SendOtpFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error), backgroundColor: AppColors.red),
        );
      }
    });

    return Scaffold(
      appBar: AppBarWidget(title: AppStrings.confirmCode),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            titleTextStates(state, userModel?.email ?? ""),
            20.hBox,
            OtpWidget(
                controller: TextEditingController(), onCompleted: (pin) => {}),
            20.hBox,
            verifyOtpButtonStates(userModel?.email ?? "", state),
            20.hBox,
            timerTextStates(context, state),
          ],
        ),
      ),
    );
  }

  Text titleTextStates(AuthStates state, String email) {
    return Text(
        state is SendOtpLoading
            ? "${AppStrings.sendingCode}..."
            : "${AppStrings.codeSentTo} $email",
        style: Theme.of(context).textTheme.bodyLarge);
  }

  InkWell timerTextStates(BuildContext context, AuthStates state) {
    return InkWell(
      onTap: () {
        if (_secondsRemaining == 0) {
          // ref.read(authControllerProvider.notifier).sendOtp();
          _startTimer();
        }
      },
      child: Text(
          state is SendOtpLoading
              ? AppStrings.sendingCode
              : _secondsRemaining > 0
                  ? "${AppStrings.resendAfter} $_secondsRemaining ${AppStrings.seconds}"
                  : AppStrings.resendCode,
          style: Theme.of(context).textTheme.bodyLarge),
    );
  }

  verifyOtpButtonStates(String email, AuthStates state) {
    bool isLoading = state is VerifyOtpLoading;
    return AppButton(
      fontSize: 18.sp,
      title: isLoading ? "${AppStrings.sendingCode}..." : AppStrings.confirm,
      isLoading: isLoading,
      onPressed: () {
        if (!isLoading) {
          //   ref.read(authControllerProvider.notifier).verifyOtpCode();
        }
      },
    );
  }
}
