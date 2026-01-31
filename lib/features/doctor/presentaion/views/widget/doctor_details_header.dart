import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/ratings_row.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/show_rating_dialog.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/image_circle.dart';

class DoctorDetailsHeader extends StatelessWidget {
  const DoctorDetailsHeader(
      {super.key,
      required this.name,
      this.image,
      this.specialty,
      this.university,
      this.rate});
  final String? image;
  final String? name;
  final String? specialty;
  final String? university;
  final double? rate;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ImageCircle(urlImage: image, radius: 60.r),
        12.hBox,
        Text(name ?? AppStrings.nameNotFound,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        Text("$specialty - $university" ?? "",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.subtextColor)),
        4.hBox,
        RatingsRow(rate: rate),
        4.hBox,
        TextButton.icon(
          onPressed: () => showRatingDialog(context),
          label: Text(AppStrings.rateDoctor,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
