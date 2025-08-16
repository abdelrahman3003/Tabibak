import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/home/presentation/controller/home_controller.dart';
import 'package:tabibak/features/home/presentation/views/widget/doctor_details_screen/comment_list/comment_list_shimmer.dart';
import 'package:tabibak/features/home/presentation/views/widget/doctor_details_screen/comment_list/comment_list_view.dart';

class CommentListStates extends StatelessWidget {
  const CommentListStates({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(homeControllerPrvider);
        final doctorCommentModelList =
            ref.read(homeControllerPrvider.notifier).doctorCommentModelList;
        return doctorCommentModelList != null
            ? CommentListView(doctorCommentModelList: doctorCommentModelList)
            : CommentListShimmer();
      },
    );
  }
}
