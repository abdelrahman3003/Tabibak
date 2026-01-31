import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/doctor/presentaion/manager/comment/comment_provider.dart';
import 'package:tabibak/features/home/data/model/comment_model.dart';

class ReviewSendButton extends ConsumerStatefulWidget {
  const ReviewSendButton({super.key, required this.doctorId});
  final String doctorId;

  @override
  ConsumerState<ReviewSendButton> createState() => _ReviewSendButtonState();
}

class _ReviewSendButtonState extends ConsumerState<ReviewSendButton> {
  late TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(commentNotifierProvider);

    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: commentController,
          decoration: InputDecoration(
            fillColor: Color(0xffE2E8F0),
            hintText: ' اكتب تعليقك هنا...',
            hintStyle: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Color(0xff878B94)),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: const BorderSide(color: Color(0xffE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        )),
        const SizedBox(width: 10),
        AppButton(
          isLoading: state.isLoading,
          isLoadingSide: true,
          title: "ارسال",
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          onPressed: () {
            ref.read(commentNotifierProvider.notifier).addComment(
                  CommentModel(
                    comment: commentController.text,
                    doctorId: widget.doctorId,
                    userId: Supabase.instance.client.auth.currentUser?.id,
                  ),
                );
            commentController.clear();
          },
          color: Color(0xff475569),
          textColor: AppColors.white,
        ),
      ],
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}
