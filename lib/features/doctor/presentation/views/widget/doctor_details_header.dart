import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_padding.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/ratings_row.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/show_rating_dialog.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/image_circle.dart';

class DoctorDetailsHeader extends StatelessWidget {
  const DoctorDetailsHeader({
    super.key,
    required this.doctor,
  });
  final DoctorModel doctor;
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return Column(
      children: [
        Stack(
          children: [
            ImageCircle(urlImage: doctor.image, radius: 60.r),
            if (doctor.clinic?.isOpen != null && doctor.clinic!.isOpen!)
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  padding: AppPadding.all8,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        12.hBox,
        Text(doctor.name ?? AppStrings.nameNotFound,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        Text(
            "${locale == 'ar' ? doctor.specialty?.nameAr : doctor.specialty?.nameEn ?? ""} - ${doctor.education?.university ?? ""}",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.subtextColor)),
        4.hBox,
        RatingsRow(
          rate: doctor.avrRating,
          ratingCount: doctor.ratingsCount,
        ),
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
