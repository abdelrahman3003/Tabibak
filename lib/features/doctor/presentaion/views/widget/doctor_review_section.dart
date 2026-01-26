import 'package:flutter/material.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/comment_list/comment_list_states.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/review_send_button.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

class DoctorReviewSection extends StatelessWidget {
  const DoctorReviewSection({super.key, required this.doctorModel});
  final DoctorModel doctorModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommentListStates(initialComments: doctorModel.comments ?? []),
        10.hBox,
        ReviewSendButton(doctorId: doctorModel.doctorId),
      ],
    );
  }
}
