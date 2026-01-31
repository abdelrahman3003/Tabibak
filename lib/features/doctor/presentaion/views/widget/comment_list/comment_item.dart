import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_padding.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/function/formate_date.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/home/data/model/comment_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/image_circle.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({super.key, required this.comment});
  final CommentModel comment;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.all12,
      decoration: BoxDecoration(
        color: Color(0xffE2E8F0),
        borderRadius: AppRadius.radius8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageCircle(
            radius: 20,
            urlImage: comment.userModel?.image,
          ),
          12.wBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.userModel?.name ?? AppStrings.unknown,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      timeAgo(comment.createdAt),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: AppColors.subtextColor),
                    ),
                  ],
                ),
                Text(
                  comment.comment ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: AppColors.subtextColor),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
