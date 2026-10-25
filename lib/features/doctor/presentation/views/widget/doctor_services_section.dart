import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/home/data/model/doctor_service_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/title_text.dart';

class DoctorServicesSection extends StatelessWidget {
  const DoctorServicesSection({
    super.key,
    required this.services,
  });

  final List<DoctorServiceModel>? services;

  @override
  Widget build(BuildContext context) {
    if (services == null || services!.isEmpty) {
      return const SizedBox.shrink();
    }

    // Deduplicate by localized name
    final seen = <String>{};
    final uniqueServices = <DoctorServiceModel>[];
    for (final s in services!) {
      final name = s.getLocalizedName(context);
      if (name.isNotEmpty && !seen.contains(name)) {
        seen.add(name);
        uniqueServices.add(s);
      }
    }

    if (uniqueServices.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(title: AppStrings.doctorServices),
        12.hBox,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : AppColors.primary.withValues(alpha: 0.12),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: uniqueServices.map((service) {
              final name = service.getLocalizedName(context);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? Theme.of(context).cardColor
                      : AppColors.primaryLight.withValues(alpha: 0.4),
                  borderRadius: AppRadius.radius12,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.medical_services_outlined,
                      size: 18.sp,
                      color: AppColors.primary,
                    ),
                    8.wBox,
                    Flexible(
                      child: Text(
                        name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        20.hBox,
      ],
    );
  }
}
