import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/home/presentation/views/widget/doctor_details_screen/ratings_row.dart';
import 'package:tabibak/features/home/presentation/views/widget/doctor_details_screen/show_rating_dialog.dart';
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
        Text(name ?? "اسم غير موجود", style: Apptextstyles.font18blackBold),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(specialty ?? "تخصص غير متاح",
                style: Apptextstyles.font16blackRegular),
            4.wBox,
            Text(
              "-",
              style: Apptextstyles.font14BlackReqular
                  .copyWith(color: AppColors.textLight),
            ),
            4.wBox,
            Text(
              university ?? "",
              style: Apptextstyles.font14BlackReqular
                  .copyWith(color: AppColors.textLight),
            ),
          ],
        ),
        4.hBox,
        RatingsRow(rate: rate),
        4.hBox,
        TextButton.icon(
          onPressed: () => showRatingDialog(context),
          label: Text(
            "قيم الدكتور",
            style: Apptextstyles.font14BlackReqular
                .copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
