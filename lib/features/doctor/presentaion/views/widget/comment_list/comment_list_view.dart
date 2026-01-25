import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/comment_list/comment_item.dart';
import 'package:tabibak/features/home/data/model/comment_model.dart';

class CommentListView extends StatelessWidget {
  const CommentListView({super.key, required this.doctorCommentModelList});
  final List<CommentModel> doctorCommentModelList;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: doctorCommentModelList.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        return CommentItem(
            comment:
                doctorCommentModelList[index].comment ?? AppStrings.unknown);
      },
    );
  }
}
