import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/doctor/presentation/manager/comment/comment_provider.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/all_comments_sheet.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/comment_list/comment_list_view.dart';
import 'package:tabibak/features/home/data/model/comment_model.dart';

import '../../../../../home/presentation/views/widget/home_screen/title_text.dart';

class CommentListStates extends ConsumerStatefulWidget {
  final List<CommentModel> initialComments;
  final String doctorId;
  const CommentListStates({
    super.key,
    required this.initialComments,
    required this.doctorId,
  });

  @override
  ConsumerState<CommentListStates> createState() => _CommentListStatesState();
}

class _CommentListStatesState extends ConsumerState<CommentListStates> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(commentNotifierProvider.notifier).init(widget.initialComments);
    });
  }

  @override
  Widget build(BuildContext context) {
    final commentList = ref.watch(commentNotifierProvider.select(
      (s) => s.commentList,
    ));
    final comments = (commentList ?? widget.initialComments)
        .where((c) => c.doctorId == widget.doctorId)
        .toList();

    if (comments.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(title: AppStrings.comments),
          10.hBox,
          Text('No reviews yet'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey
                        : const Color(0xff94A3B8),
                  )),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          title: AppStrings.comments,
          subtitle: AppStrings.allComments,
          onTap: () {
            showCommentsBottomSheet(context);
          },
        ),
        10.hBox,
        CommentListView(
          doctorCommentModelList: _getRecentComments(comments),
        ),
      ],
    );
  }

  List<CommentModel> _getRecentComments(List<CommentModel>? comments) {
    return comments == null ? [] : comments.take(2).toList();
  }

  void showCommentsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return AllCommentsSheet(doctorId: widget.doctorId);
      },
    );
  }
}
