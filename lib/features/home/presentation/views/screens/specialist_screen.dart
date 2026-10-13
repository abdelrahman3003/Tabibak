import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/search_bar_widget.dart';
import 'package:tabibak/features/home/presentation/manager/specialty_doctors_provider/doctors_specialty_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/doctor_available_counter.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/doctors_list/doctor_specialty_list_states.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/filters_list/location_filter_bottom_sheet.dart';

class SpecialistScreen extends ConsumerWidget {
  const SpecialistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final specialty = ref.watch(specialtyProvider);
    final specialtyName = specialty?.getName(locale) ?? '';
    final state = ref.watch(doctorsSpecialtyProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasActiveFilter = state.hasLocationFilter;

    return Scaffold(
      appBar: AppBarWidget(title: specialtyName),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            10.hBox,
            Row(
              children: [
                Expanded(
                  child: SearchBarWidget(
                    controller: TextEditingController(),
                    onChanged: (text) {
                      ref
                          .read(doctorsSpecialtyProvider.notifier)
                          .searchDoctorSpecialty(text);
                    },
                  ),
                ),
                10.wBox,
                GestureDetector(
                  key: const Key('specialty_filter_icon_button'),
                  onTap: () => showLocationFilterBottomSheet(context, ref),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 52.w,
                    height: 52.h,
                    decoration: BoxDecoration(
                      color: hasActiveFilter
                          ? AppColors.primary
                          : theme.cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: hasActiveFilter
                            ? AppColors.primary
                            : (isDark
                                ? Colors.white12
                                : const Color(0xffE5E7EB)),
                      ),
                      boxShadow: hasActiveFilter
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.tune_rounded,
                          size: 22.sp,
                          color: hasActiveFilter
                              ? Colors.white
                              : AppColors.primary,
                        ),
                        if (hasActiveFilter)
                          Positioned(
                            top: 10.h,
                            right: 10.w,
                            child: Container(
                              width: 8.w,
                              height: 8.h,
                              decoration: const BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            16.hBox,
            const DoctorAvailableCounter(),
            10.hBox,
            const DoctorSpecialtyListStates()
          ],
        ),
      ),
    );
  }
}
