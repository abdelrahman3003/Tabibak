import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/manager/home_controller.dart';
import 'package:tabibak/features/home/presentation/views/widget/doctor_details_screen/comment_list/comment_list_view.dart';

import '../../home_screen/titel_text.dart';

class CommentListStates extends StatelessWidget {
  const CommentListStates({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final doctorModel = ref.read(
          homeControllerPrvider.select((state) => state.doctorModel),
        );
        List<Comment> recentComments =
            _getRecentComments(doctorModel!.comments);

        return recentComments.isEmpty
            ? SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitelText(title: AppStrings.account),
                  CommentListView(doctorCommentModelList: recentComments),
                ],
              );
      },
    );
  }

  List<Comment> _getRecentComments(List<Comment>? comments) {
    List<Comment>? recentComments = [];
    if (comments != null) {
      for (var i = 0; i < 7; i++) {
        recentComments.add(comments[i]);
      }
    }
    return recentComments;
  }
}
