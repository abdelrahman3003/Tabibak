import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/widgets/shimmer_widget.dart';

class CommentListShimmer extends StatelessWidget {
  const CommentListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        return Row(
          children: [
            ShimmerWidget(height: 40.h, width: 40.w),
            10.wBox,
            Expanded(child: ShimmerWidget(height: 8.h, width: 40.w)),
          ],
        );
      },
    );
  }
}
