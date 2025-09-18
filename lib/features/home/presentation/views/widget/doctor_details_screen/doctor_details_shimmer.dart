import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/widgets/shimmer_widget.dart';

class DoctorDetailsShimmer extends StatelessWidget {
  const DoctorDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  10.hBox,
                  ShimmerWidget(height: 100.h, width: 100.w, radius: 99),
                  10.hBox,
                  ShimmerWidget(height: 10.h, width: 100.w),
                  10.hBox,
                  ShimmerWidget(height: 10.h, width: 150.w),
                  10.hBox,
                  ShimmerWidget(height: 8.h, width: 80.w),
                ],
              ),
            ),
            30.hBox,
            ShimmerWidget(height: 15.h, width: 140.w),
            15.hBox,
            ShimmerWidget(height: 8.h, width: double.infinity),
            8.hBox,
            ShimmerWidget(height: 8.h, width: double.infinity),
            20.hBox,
            Row(
              children: [
                ShimmerWidget(height: 40.h, width: 40.w, radius: 90),
                10.wBox,
                Column(
                  children: [
                    ShimmerWidget(height: 12.h, width: 50.w),
                    8.hBox,
                    ShimmerWidget(height: 8.h, width: 60.w),
                  ],
                ),
              ],
            ),
            20.hBox,
            Row(
              children: [
                ShimmerWidget(height: 40.h, width: 40.w, radius: 90),
                10.wBox,
                Column(
                  children: [
                    ShimmerWidget(height: 12.h, width: 50.w),
                    8.hBox,
                    ShimmerWidget(height: 8.h, width: 60.w),
                  ],
                ),
              ],
            ),
            20.hBox,
            Row(
              children: [
                ShimmerWidget(height: 40.h, width: 40.w, radius: 90),
                10.wBox,
                Column(
                  children: [
                    ShimmerWidget(height: 12.h, width: 50.w),
                    8.hBox,
                    ShimmerWidget(height: 8.h, width: 60.w),
                  ],
                ),
              ],
            ),
            40.hBox,
            ShimmerWidget(height: 15.h, width: 120.w),
            15.hBox,
            Column(
                children: List.generate(
              7,
              (index) => timeItemShimmer(),
            ))
          ],
        ),
      ),
    );
  }

  timeItemShimmer() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          ShimmerWidget(height: 30.h, width: 30.w),
          10.wBox,
          Expanded(child: ShimmerWidget(height: 10.h, width: 30.w)),
          30.wBox,
          Expanded(child: ShimmerWidget(height: 10.h, width: 30.w)),
        ],
      ),
    );
  }
}
