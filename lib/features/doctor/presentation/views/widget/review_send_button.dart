import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/helper/app_snack_bar.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_text_formfiled.dart';
import 'package:tabibak/features/doctor/presentation/manager/comment/comment_provider.dart';
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
    ref.listen(commentNotifierProvider, (previous, next) {
      if (next.isSended) {
        commentController.clear();
      } else if (next.errorMessage != null) {
        showErrorSnackBar(next.errorMessage!);
      }
    });
    return Row(
      children: [
        Expanded(
          child: AppTextFormFiled(
            controller: commentController,
            hint: AppStrings.writeCommentHere,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: state.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.white,
                    ),
                  )
                : IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () async {
                      await ref
                          .read(commentNotifierProvider.notifier)
                          .addComment(
                            CommentModel(
                              comment: commentController.text,
                              doctorId: widget.doctorId,
                              userId:
                                  Supabase.instance.client.auth.currentUser?.id,
                            ),
                          );
                      commentController.clear();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: AppColors.white,
                      size: 22,
                    ),
                  ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}
