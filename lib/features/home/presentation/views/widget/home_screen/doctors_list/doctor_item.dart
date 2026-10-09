import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/app_colors.dart';
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
    final hasNewOffer =
        doctorSummary.offers != null && doctorSummary.offers!.isNotEmpty;
    final hasOldOffer = doctorSummary.clinic?.offer != null &&
        doctorSummary.clinic!.offer!.isNotEmpty;
    final hasAnyOffer = hasNewOffer || hasOldOffer;

    String? offerTitle;
    if (hasNewOffer) {
      offerTitle = context.locale.languageCode == 'ar'
          ? doctorSummary.offers!.first.titleAr ?? 'Special Offer'.tr()
          : doctorSummary.offers!.first.titleEn ?? 'Special Offer'.tr();
    } else if (hasOldOffer) {
      offerTitle = doctorSummary.clinic!.offer;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.radius20,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: _decoration(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(),
                16.wBox,
                Expanded(child: _buildInfo(context)),
              ],
            ),
          ),
          if (hasAnyOffer && offerTitle != null && offerTitle.isNotEmpty)
            PositionedDirectional(
              top: 0,
              end: 0,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 160),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: const BorderRadiusDirectional.only(
                    topEnd: Radius.circular(20),
                    bottomStart: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_offer_rounded,
                      size: 14,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        offerTitle,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onTertiary,
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  BoxDecoration _decoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      border: Border.all(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
      ),
      borderRadius: AppRadius.radius20,
      boxShadow: [
        if (Theme.of(context).brightness == Brightness.light)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
      ],
    );
  }

  Widget _buildImage() {
    return Container(
      height: 90.h,
      width: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r8),
        color: AppColors.second,
        image: (doctorSummary.image != null && doctorSummary.image!.isNotEmpty)
            ? DecorationImage(
                image: CachedNetworkImageProvider(doctorSummary.image!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: (doctorSummary.image == null || doctorSummary.image!.isEmpty)
          ? Icon(
              Icons.person,
              size: 40.w,
              color: AppColors.primary.withValues(alpha: 0.5),
            )
          : null,
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
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSpecialty(BuildContext context) {
    return Text(
      context.locale.languageCode == 'ar'
          ? doctorSummary.specialty?.nameAr ?? ""
          : doctorSummary.specialty?.nameEn ?? "",
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
        Text(
          doctorSummary.avrRating.toString(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xffEAB308),
              ),
        ),
        const SizedBox(width: 3),
        Text(
          "(${doctorSummary.ratingsCount.toString()} ${doctorSummary.ratingsCount == 1 ? AppStrings.rating : AppStrings.ratings})",
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.subtextColor,
              ),
        ),
      ],
    );
  }

  Widget _buildPriceAndButton(BuildContext context) {
    if (doctorSummary.visitsCount == null || doctorSummary.visitsCount! <= 1) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        const Spacer(),
        Row(
          children: [
            const Icon(Icons.group, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              "${doctorSummary.visitsCount} ${"Visits".tr()}",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
