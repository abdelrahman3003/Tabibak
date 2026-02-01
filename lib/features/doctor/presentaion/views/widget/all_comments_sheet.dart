import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_padding.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/comment_list/comment_list_view.dart';
import 'package:tabibak/features/home/data/model/comment_model.dart';

class AllCommentsSheet extends StatelessWidget {
  const AllCommentsSheet({super.key, required this.comments});
  final List<CommentModel> comments;
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.66,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          padding: AppPadding.all20,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: AppRadius.radius16),
          child: Column(
            children: [
              Text(
                "التعليقات",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              12.hBox,
              Expanded(
                child: CommentListView(
                  doctorCommentModelList: comments,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
