import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/auth/presentation/manager/sign_in/sign_in_provider.dart';
import 'package:tabibak/gen/assets.gen.dart';

class GoogleSignInButton extends ConsumerWidget {
  final Animation<Offset> animation;
  const GoogleSignInButton({super.key, required this.animation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        if (!ref.read(signInNotifierProvider).isGoogleLoading) {
          ref.read(signInNotifierProvider.notifier).nativeGoogleSignIn();
        }
      },
      child: SlideTransition(
        position: animation,
        child: Consumer(builder: (context, ref, _) {
          final state = ref.watch(signInNotifierProvider);
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: 8.radius,
              border: Border.all(color: AppColors.textLight),
            ),
            child: state.isGoogleLoading
                ? SizedBox(
                    height: 24.h,
                    width: 24.w,
                    child: const Center(
                        child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 3,
                    )),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.icons.googleIcon,
                          width: 24.w, height: 24.h),
                      10.wBox,
                      Text(
                        AppStrings.loginWithGoogle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w500,
                            ),
                      )
                    ],
                  ),
          );
        }),
      ),
    );
  }
}
