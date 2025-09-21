import 'package:flutter/material.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/doctor_details/presentaion/views/widget/review_send_button.dart';

import 'comment_list/comment_list_states.dart';

class DoctorReviewSection extends StatelessWidget {
  const DoctorReviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommentListStates(),
        10.hBox,
        ReviewSendButton(),
      ],
    );
  }
}
