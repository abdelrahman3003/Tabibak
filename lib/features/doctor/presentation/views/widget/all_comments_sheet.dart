import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_padding.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/doctor/presentation/manager/comment/comment_provider.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/comment_list/comment_item.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/review_send_button.dart';

class AllCommentsSheet extends StatelessWidget {
  const AllCommentsSheet({super.key, required this.doctorId});
  final String doctorId;
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
              color: Theme.of(context).cardColor,
              borderRadius: AppRadius.radius16),
          child: Column(
            children: [
              Text(
                AppStrings.comments,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              12.hBox,
              Expanded(child: Consumer(builder: (context, ref, _) {
                final state = ref.watch(commentNotifierProvider);
                final comments = state.commentList ?? [];
                return ListView.separated(
                  separatorBuilder: (context, index) => 10.hBox,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return CommentItem(comment: comments[index]);
                  },
                );
              })),
              20.hBox,
              ReviewSendButton(doctorId: doctorId)
            ],
          ),
        );
      },
    );
  }
}
