import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/theme/app_button.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/home/presentation/controller/home_controller.dart';

class ReviewSendButton extends StatelessWidget {
  const ReviewSendButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final isLoading = ref.watch(
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
              decoration: const InputDecoration(
                hintText: "اكتب تعليقك هنا...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          AppButton(
            isLoading: isLoading ?? false,
            isLoadingSide: true,
            title: "إرسال",
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
