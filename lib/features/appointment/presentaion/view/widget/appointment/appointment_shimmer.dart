import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/widgets/shimmer_widget.dart';

class AppointmentShimmer extends StatelessWidget {
  const AppointmentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerWidget(height: 16.h, width: 60.w),
                    Spacer(),
                    ShimmerWidget(height: 30.h, width: 80.w),
                  ],
                ),
                10.hBox,
                ShimmerWidget(height: 10.h, width: 120.w),
                40.hBox,
              ],
            ));
  }
}
