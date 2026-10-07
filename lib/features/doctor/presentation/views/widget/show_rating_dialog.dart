import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/constatnt/app_padding.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/doctor/presentation/manager/doctor/doctor_provider.dart';
import 'package:tabibak/features/doctor/presentation/manager/comment/comment_provider.dart';
import 'package:tabibak/features/doctor/presentation/manager/rating/rating_provider.dart';
import 'package:tabibak/features/home/data/model/comment_model.dart';

void showRatingDialog(BuildContext context, {required String doctorId}) {
  showDialog<void>(
    context: context,
    builder: (_) => _RatingReviewDialog(doctorId: doctorId),
  );
}

class _RatingReviewDialog extends ConsumerStatefulWidget {
  const _RatingReviewDialog({required this.doctorId});

  final String doctorId;

  @override
  ConsumerState<_RatingReviewDialog> createState() =>
      _RatingReviewDialogState();
}

class _RatingReviewDialogState extends ConsumerState<_RatingReviewDialog> {
  final _reviewController = TextEditingController();
  int _rating = 0;
  String? _validationMessage;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ratingNotifierProvider);
    ref.listen(ratingNotifierProvider, (previous, next) {
      if (next.isSuccess) {
        ref.invalidate(doctorNotifierProvider);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.pop();
        });
      }
    });

    return AlertDialog(
      title: Text(AppStrings.rateTheDoctor),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  tooltip: '${index + 1} ${AppStrings.rating}',
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  constraints: const BoxConstraints(),
                  onPressed: state.isLoading
                      ? null
                      : () => setState(() {
                            _rating = index + 1;
                            _validationMessage = null;
                          }),
                  icon: Icon(
                    Icons.star,
                    size: 34.r,
                    color: index < _rating ? Colors.amber : Colors.grey,
                  ),
                ),
              ),
            ),
            if (_rating > 0) ...[
              SizedBox(height: 6.h),
              Text('$_rating / 5'),
            ],
            SizedBox(height: 16.h),
            TextField(
              controller: _reviewController,
              minLines: 2,
              maxLines: 4,
              maxLength: 500,
              enabled: !state.isLoading,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'writeReviewOptional'.tr(),
                border: const OutlineInputBorder(),
                contentPadding: AppPadding.all12,
              ),
            ),
            if (_validationMessage != null || state.errorMessage != null) ...[
              SizedBox(height: 8.h),
              Text(
                _validationMessage ?? state.errorMessage!,
                style: const TextStyle(color: AppColors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 42.h,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: state.isLoading ? null : () => context.pop(),
                  child: Text(AppStrings.cancel),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: SizedBox(
                height: 42.h,
                child: AppButton(
                  width: double.infinity,
                  height: 42.h,
                  minHeight: 0,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  isLoading: state.isLoading,
                  title: AppStrings.submit,
                  onPressed: state.isLoading ? null : _submit,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _submit() {
    if (Supabase.instance.client.auth.currentUser == null) {
      setState(() => _validationMessage = 'loginBeforeReview'.tr());
      return;
    }
    if (_rating == 0) {
      setState(() => _validationMessage = 'ratingRequired'.tr());
      return;
    }

    setState(() => _validationMessage = null);

    final reviewText = _reviewController.text.trim();

    ref.read(ratingNotifierProvider.notifier).addRate(
          rate: _rating,
          doctorId: widget.doctorId,
          review: null,
        );

    if (reviewText.isNotEmpty) {
      ref.read(commentNotifierProvider.notifier).addComment(
            CommentModel(
              comment: reviewText,
              doctorId: widget.doctorId,
              userId: Supabase.instance.client.auth.currentUser?.id,
            ),
          );
    }
  }
}
