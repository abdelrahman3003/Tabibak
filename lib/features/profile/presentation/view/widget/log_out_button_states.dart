import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/profile/presentation/manager/profile_controller.dart';

class LogOutButtonStates extends ConsumerWidget {
  const LogOutButtonStates({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(
      profileProviderController.select((state) => state.isLogOutLoading),
    );
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      onPressed: () {
        ref.read(profileProviderController.notifier).logOut(context);
      },
      child: state
          ? SizedBox(
              height: 14.h,
              width: 14.w,
              child: CircularProgressIndicator(
                color: AppColors.white,
                strokeWidth: 2,
              ))
          : const Text(
              "خروج",
              style: TextStyle(color: Colors.white),
            ),
    );
  }
}
