import 'package:flutter/material.dart';
import 'package:tabibak/features/home/presentation/views/widget/doctor_details_screen/review_send_button.dart';

import 'comment_list/comment_list_states.dart';

class DoctorReviewSection extends StatelessWidget {
  const DoctorReviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommentListStates(),
        ReviewSendButton(),
      ],
    );
  }
}
