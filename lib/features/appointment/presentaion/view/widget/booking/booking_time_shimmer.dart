import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/widgets/shimmer_widget.dart';

class BookingTimeShimmer extends StatelessWidget {
  const BookingTimeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerWidget(height: 10.h, width: 50.w),
        20.hBox,
        Row(
          children: [
            ShimmerWidget(height: 20.h, width: 50.w),
            20.wBox,
            ShimmerWidget(height: 20.h, width: 50.w),
          ],
        ),
      ],
    );
  }
}
