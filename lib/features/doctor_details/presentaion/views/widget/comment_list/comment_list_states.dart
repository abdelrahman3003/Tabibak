import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/features/doctor_details/presentaion/manager/doctor_details_provider.dart';
import 'package:tabibak/features/doctor_details/presentaion/views/widget/comment_list/comment_list_view.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

import '../../../../../home/presentation/views/widget/home_screen/titel_text.dart';

class CommentListStates extends StatelessWidget {
  const CommentListStates({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final doctorModel = ref.read(
          doctorDetailsNotifierProvider.select((state) => state.doctorModel),
        );
        List<Comment> recentComments =
            _getRecentComments(doctorModel!.comments);

        return recentComments.isEmpty
            ? SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitelText(title: AppStrings.comments),
                  CommentListView(doctorCommentModelList: recentComments),
                ],
              );
      },
    );
  }

  List<Comment> _getRecentComments(List<Comment>? comments) {
    if (comments == null) return [];
    return comments.take(7).toList();
  }
}
