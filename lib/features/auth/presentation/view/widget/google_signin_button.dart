import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_controller.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_states.dart';
import 'package:tabibak/gen/assets.gen.dart';

class GoogleSignInButton extends ConsumerWidget {
  final Animation<Offset> animation;
  const GoogleSignInButton({super.key, required this.animation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(authControllerProvider.notifier).nativeGoogleSignIn();
      },
      child: SlideTransition(
        position: animation,
        child: Consumer(builder: (context, ref, _) {
          final state = ref.watch(authControllerProvider);
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: 8.radius,
              border: Border.all(color: AppColors.textLight),
            ),
            child: state is LoginWithGoogleLoading
                ? SizedBox(
                    height: 30.h,
                    width: 30.h,
                    child: const Center(
                        child: CircularProgressIndicator(
                      color: AppColors.primary,
                    )),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.icons.googleIcon,
                          width: 24.h, height: 24.w),
                      10.wBox,
                      Text(
                        AppStrings.loginWithGoogle,
                        style: Apptextstyles.font16blackRegular,
                      )
                    ],
                  ),
          );
        }),
      ),
    );
  }
}
