import 'package:flutter/material.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/doctor_details_screen/comment_list/comment_item.dart';

class CommentListView extends StatelessWidget {
  const CommentListView({super.key, required this.doctorCommentModelList});
  final List<Comment> doctorCommentModelList;
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
                doctorCommentModelList[index].comment ?? "تعليق غير معروف");
      },
    );
  }
}
