import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/doctor/presentaion/manager/doctor_provider.dart';

class ReviewSendButton extends StatelessWidget {
  const ReviewSendButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final isLoading = ref.watch(
        doctorNotifierProvider.select((state) => state.isLoading),
      );
      final doctorModel = ref.read(
        doctorNotifierProvider.select((state) => state.doctorModel),
      );
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: ref
                  .read(doctorNotifierProvider.notifier)
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
              // ref
              //     .read(doctorDetailsNotifierProvider.notifier)
              //     .addComment(doctorModel!.doctorId);
            },
            color: AppColors.textLight,
            textColor: AppColors.white,
          )
        ],
      );
    });
  }
}
