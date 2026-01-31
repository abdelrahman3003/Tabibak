import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/doctor/presentaion/manager/comment/comment_provider.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/comment_list/comment_list_view.dart';
import 'package:tabibak/features/home/data/model/comment_model.dart';

import '../../../../../home/presentation/views/widget/home_screen/title_text.dart';

class CommentListStates extends ConsumerStatefulWidget {
  final List<CommentModel> initialComments;

  const CommentListStates({super.key, required this.initialComments});

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
    final state = ref.watch(commentNotifierProvider);

    if (state.commentList == null || state.commentList!.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          title: AppStrings.comments,
          subtitle: "كل التعليقات",
        ),
        5.hBox,
        CommentListView(
          doctorCommentModelList: _getRecentComments(state.commentList!),
        ),
      ],
    );
  }

  List<CommentModel> _getRecentComments(List<CommentModel> comments) {
    return comments.take(2).toList();
  }
}
