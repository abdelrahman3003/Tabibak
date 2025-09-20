import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/shimmer_widget.dart';

class HeaderProfileShimmer extends StatelessWidget {
  const HeaderProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          ShimmerWidget(height: 100.h, width: 100.w, isCircle: true),
          8.hBox,
          ShimmerWidget(height: 8.h, width: 150.w),
          8.hBox,
          ShimmerWidget(height: 8.h, width: 150.w),
        ],
      ),
    );
  }
}
