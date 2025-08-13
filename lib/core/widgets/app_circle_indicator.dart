import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class AppCircleIndicator extends StatelessWidget {
  const AppCircleIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            height: 24.h,
            width: 24.w,
            child: CircularProgressIndicator(
              color: AppColors.primary,
            )));
  }
}
