import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/home/presentation/logic/home_controller.dart';
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
        return doctorModel?.comments == null || doctorModel!.comments!.isEmpty
            ? SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitelText(title: 'التعليقات'),
                  CommentListView(
                      doctorCommentModelList: doctorModel.comments!),
                ],
              );
      },
    );
  }
}
