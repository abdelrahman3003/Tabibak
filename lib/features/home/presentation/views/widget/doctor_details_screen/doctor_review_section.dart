import 'package:flutter/material.dart';
import 'package:tabibak/core/theme/app_button.dart';
import 'package:tabibak/core/theme/app_colors.dart';

import 'comment_list/comment_list_states.dart';

class DoctorReviewSection extends StatelessWidget {
  const DoctorReviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommentListStates(),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "اكتب تعليقك هنا...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            AppButton(
              title: "إرسال",
              onPressed: () {},
              color: AppColors.textLight,
              textColor: AppColors.white,
            )
          ],
        ),
      ],
    );
  }
}
