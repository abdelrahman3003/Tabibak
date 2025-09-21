import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/doctor_details/presentaion/manager/doctor_details_provider.dart';

class ReviewSendButton extends StatelessWidget {
  const ReviewSendButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final isLoading = ref.watch(
        doctorDetailsNotifierProvider.select((state) => state.isLoading),
      );
      final doctorModel = ref.read(
        doctorDetailsNotifierProvider.select((state) => state.doctorModel),
      );
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: ref
                  .read(doctorDetailsNotifierProvider.notifier)
                  .commentTextController,
              decoration: InputDecoration(
                hintText: "${AppStrings.writeCommentHere}..",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          AppButton(
            isLoading: isLoading,
            isLoadingSide: true,
            title: AppStrings.send,
            onPressed: () {
              ref
                  .read(doctorDetailsNotifierProvider.notifier)
                  .addComment(doctorModel!.id);
            },
            color: AppColors.textLight,
            textColor: AppColors.white,
          )
        ],
      );
    });
  }
}
