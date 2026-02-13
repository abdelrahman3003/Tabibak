import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_padding.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/doctor/presentaion/manager/rating/rating_provider.dart';

void showRatingDialog(BuildContext context) {
  final ratingProvider = StateProvider<double>((ref) => 0);

  showDialog(
    context: context,
    builder: (_) => Consumer(
      builder: (context, ref, _) {
        final rating = ref.watch(ratingProvider);
        final state = ref.watch(ratingNotifierProvider);

        if (state.isSuccess) {
          context.pop();
        }
        return AlertDialog(
          title: Text(AppStrings.rateTheDoctor),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => IconButton(
                icon: Icon(
                  Icons.star,
                  color: index < rating ? Colors.amber : Colors.grey,
                ),
                onPressed: () {
                  ref.read(ratingProvider.notifier).state = index + 1.0;
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.cancel),
            ),
            SizedBox(
              width: 80.w,
              child: AppButton(
                padding: AppPadding.all8,
                isLoading: state.isLoading,
                title: AppStrings.submit,
                onPressed: state.isLoading
                    ? null
                    : () {
                        ref
                            .read(ratingNotifierProvider.notifier)
                            .addRate(rate: ref.read(ratingProvider));
                      },
              ),
            ),
          ],
        );
      },
    ),
  );
}
