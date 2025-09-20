import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/home/presentation/manager/home_controller.dart';

class ReviewSendButton extends StatelessWidget {
  const ReviewSendButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final isSendCommentLoading = ref.watch(
        homeControllerPrvider.select((state) => state.isSendCommentLoading),
      );
      final doctorModel = ref.read(
        homeControllerPrvider.select((state) => state.doctorModel),
      );
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller:
                  ref.read(homeControllerPrvider.notifier).commentController,
              decoration: InputDecoration(
                hintText: "${AppStrings.writeCommentHere}..",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          AppButton(
            isLoading: isSendCommentLoading ?? false,
            isLoadingSide: true,
            title: AppStrings.send,
            onPressed: () {
              ref
                  .read(homeControllerPrvider.notifier)
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
