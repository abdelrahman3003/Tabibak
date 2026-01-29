import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

class DoctorItem extends StatelessWidget {
  const DoctorItem({
    super.key,
    this.onTap,
    required this.doctorSummary,
  });

  final Function()? onTap;
  final DoctorModel doctorSummary;

  @override
  Widget build(BuildContext context) {
    return _buildRoot(context);
  }

  Widget _buildRoot(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: 8.radius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: const Color(0xffF1F5F9)),
          borderRadius: AppRadius.radius20,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            16.wBox,
            Expanded(child: _buildInfo(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: 110.h,
      width: 100.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r8),
        color: AppColors.second,
        image: doctorSummary.image == null
            ? null
            : DecorationImage(
                image: CachedNetworkImageProvider(doctorSummary.image!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildName(context),
        _buildSpecialty(context),
        5.hBox,
        _buildRating(context),
        8.hBox,
        _buildPriceAndButton(context),
      ],
    );
  }

  Widget _buildName(BuildContext context) {
    return Text(
      doctorSummary.name ?? "",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSpecialty(BuildContext context) {
    return Text(
      doctorSummary.specialty?.nameAr ?? "",
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(color: AppColors.subtextColor),
    );
  }

  Widget _buildRating(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: Color(0xffEAB308), size: 12),
        const SizedBox(width: 3),
        Text(
          "4.8",
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xffEAB308),
              ),
        ),
        const SizedBox(width: 3),
        Text(
          "(120 تقييم)",
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.subtextColor,
              ),
        ),
      ],
    );
  }

  Widget _buildPriceAndButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            doctorSummary.clinic?.consultationFee == null
                ? "سعر الكشف غير محدد"
                : "${doctorSummary.clinic!.consultationFee} جنيه",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ),
        ),
        const SizedBox(width: 40),
        AppButton(
          title: "احجز الآن",
          onPressed: () {},
          padding: const EdgeInsets.symmetric(horizontal: 14),
          fontSize: 12.sp,
        ),
      ],
    );
  }
}
