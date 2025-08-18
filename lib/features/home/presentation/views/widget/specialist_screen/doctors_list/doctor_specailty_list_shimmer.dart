import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/core/widgets/shimmer_widget.dart';

class DoctorSpecailtyListShimmer extends StatelessWidget {
  const DoctorSpecailtyListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      shrinkWrap: true,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShimmerWidget(
              height: 110.h,
              width: 100.w,
            ),
            8.wBox,
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(height: 20.h, width: 150.w),
                5.hBox,
                ShimmerWidget(height: 16.h, width: 120.w),
                5.hBox,
                ShimmerWidget(height: 14.h, width: 30.w),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
