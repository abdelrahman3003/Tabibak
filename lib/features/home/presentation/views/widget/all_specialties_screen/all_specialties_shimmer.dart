import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/widgets/shimmer_widget.dart';

class AllSpecialtiesShimmer extends StatelessWidget {
  const AllSpecialtiesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
      itemCount: 10,
      shrinkWrap: true,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ShimmerWidget(
          width: 100.w,
          height: 100.w,
        ),
      ),
    );
  }
}
