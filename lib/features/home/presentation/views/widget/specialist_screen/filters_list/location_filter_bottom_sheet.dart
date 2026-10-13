import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/home/data/model/clinic_model.dart';
import 'package:tabibak/features/home/presentation/manager/specialty_doctors_provider/doctors_specialty_provider.dart';

void showLocationFilterBottomSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (context) => const LocationFilterBottomSheet(),
  );
}

class LocationFilterBottomSheet extends ConsumerStatefulWidget {
  const LocationFilterBottomSheet({super.key});

  @override
  ConsumerState<LocationFilterBottomSheet> createState() =>
      _LocationFilterBottomSheetState();
}

class _LocationFilterBottomSheetState
    extends ConsumerState<LocationFilterBottomSheet> {
  int? _selectedGovernorateId;
  int? _selectedMarkazId;
  int? _selectedVillageId;
  String _villageSearchQuery = '';
  final TextEditingController _villageSearchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = ref.read(doctorsSpecialtyProvider);
    _selectedGovernorateId = state.selectedGovernorateId;
    _selectedMarkazId = state.selectedMarkazId;
    _selectedVillageId = state.selectedVillageId;

    if (state.villages.isEmpty || state.governorates.isEmpty) {
      Future.microtask(() {
        ref.read(doctorsSpecialtyProvider.notifier).loadLocations();
      });
    }
  }

  @override
  void dispose() {
    _villageSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(doctorsSpecialtyProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).languageCode;

    final governorates = state.governorates.isNotEmpty
        ? state.governorates
        : DoctorsSpecialtyProvider.defaultGovernorates;

    final markazes = state.markazes.isNotEmpty
        ? state.markazes
        : DoctorsSpecialtyProvider.defaultMarkazes;

    final allVillages = state.villages;
    final markazVillages = _selectedMarkazId == null
        ? <CityModel>[]
        : allVillages
            .where((v) =>
                v.parentId == _selectedMarkazId &&
                (v.type == 'village' || v.type == 'city'))
            .where((v) {
              if (_villageSearchQuery.isEmpty) return true;
              final q = _villageSearchQuery.toLowerCase();
              return v.getName(locale).toLowerCase().contains(q) ||
                  v.arabicName.toLowerCase().contains(q);
            })
            .toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          12.hBox,
          Center(
            child: Container(
              width: 44.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          12.hBox,

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                12.wBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.filterByLocation,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        AppStrings.selectLocation,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? Colors.white54 : Colors.black54,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: AppStrings.cancel,
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Scrollable selection content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 1. Governorate Section ---
                  _buildSectionHeader(
                    icon: Icons.map_outlined,
                    title: AppStrings.governorate,
                    subtitle: _selectedGovernorateId == null
                        ? AppStrings.allGovernorates
                        : governorates
                            .firstWhere(
                              (g) => g.id == _selectedGovernorateId,
                              orElse: () => governorates.first,
                            )
                            .getName(locale),
                  ),
                  10.hBox,
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildChip(
                        label: AppStrings.allGovernorates,
                        isSelected: _selectedGovernorateId == null,
                        onTap: () {
                          setState(() {
                            _selectedGovernorateId = null;
                          });
                        },
                      ),
                      ...governorates.map((gov) {
                        final isSelected = _selectedGovernorateId == gov.id;
                        return _buildChip(
                          label: gov.getName(locale),
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedGovernorateId =
                                  isSelected ? null : gov.id;
                            });
                          },
                        );
                      }),
                    ],
                  ),
                  20.hBox,

                  // --- 2. Markaz Section ---
                  _buildSectionHeader(
                    icon: Icons.location_city_rounded,
                    title: AppStrings.markaz,
                    subtitle: _selectedMarkazId == null
                        ? AppStrings.allMarkazes
                        : markazes
                            .firstWhere(
                              (m) => m.id == _selectedMarkazId,
                              orElse: () => markazes.first,
                            )
                            .getName(locale),
                  ),
                  10.hBox,
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildChip(
                        label: AppStrings.allMarkazes,
                        isSelected: _selectedMarkazId == null,
                        onTap: () {
                          setState(() {
                            _selectedMarkazId = null;
                            _selectedVillageId = null;
                            _villageSearchQuery = '';
                            _villageSearchController.clear();
                          });
                        },
                      ),
                      ...markazes.map((markaz) {
                        final isSelected = _selectedMarkazId == markaz.id;
                        return _buildChip(
                          label: markaz.getName(locale),
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedMarkazId = null;
                                _selectedVillageId = null;
                              } else {
                                _selectedMarkazId = markaz.id;
                                _selectedVillageId = null;
                              }
                              _villageSearchQuery = '';
                              _villageSearchController.clear();
                            });
                          },
                        );
                      }),
                    ],
                  ),
                  20.hBox,

                  // --- 3. Village Section ---
                  _buildSectionHeader(
                    icon: Icons.holiday_village_outlined,
                    title: AppStrings.village,
                    subtitle: _selectedVillageId == null
                        ? (_selectedMarkazId == null
                            ? ''
                            : AppStrings.allVillages)
                        : allVillages
                            .where((v) => v.id == _selectedVillageId)
                            .firstOrNull
                            ?.getName(locale),
                  ),
                  10.hBox,

                  if (_selectedMarkazId == null)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.04),
                        borderRadius: AppRadius.radius12,
                        border: Border.all(
                          color: isDark ? Colors.white12 : Colors.black12,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 18.sp,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                          10.wBox,
                          Expanded(
                            child: Text(
                              AppStrings.selectMarkazFirst,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark ? Colors.white60 : Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    // Search bar for villages
                    Container(
                      height: 42.h,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: AppRadius.radius12,
                        border: Border.all(
                          color: isDark ? Colors.white12 : Colors.black12,
                        ),
                      ),
                      child: TextField(
                        controller: _villageSearchController,
                        onChanged: (val) {
                          setState(() {
                            _villageSearchQuery = val.trim();
                          });
                        },
                        style: theme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: AppStrings.searchVillage,
                          hintStyle: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          suffixIcon: _villageSearchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _villageSearchController.clear();
                                    setState(() {
                                      _villageSearchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                        ),
                      ),
                    ),
                    12.hBox,

                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        _buildChip(
                          label: AppStrings.allVillages,
                          isSelected: _selectedVillageId == null,
                          onTap: () {
                            setState(() {
                              _selectedVillageId = null;
                            });
                          },
                        ),
                        ...markazVillages.map((village) {
                          final isSelected = _selectedVillageId == village.id;
                          return _buildChip(
                            label: village.getName(locale),
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                _selectedVillageId =
                                    isSelected ? null : village.id;
                              });
                            },
                          );
                        }),
                      ],
                    ),

                    if (markazVillages.isEmpty &&
                        _villageSearchQuery.isNotEmpty) ...[
                      12.hBox,
                      Center(
                        child: Text(
                          AppStrings.noData,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),

          // Bottom Action Buttons
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.white12 : Colors.black12,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.radius12,
                      ),
                      side: BorderSide(
                        color: isDark ? Colors.white24 : Colors.black26,
                      ),
                    ),
                    onPressed: () {
                      ref
                          .read(doctorsSpecialtyProvider.notifier)
                          .clearLocationFilter();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppStrings.clearFilter,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                12.wBox,
                Expanded(
                  flex: 3,
                  child: AppButton(
                    title: AppStrings.applyFilter,
                    onPressed: () {
                      ref
                          .read(doctorsSpecialtyProvider.notifier)
                          .filterByLocation(
                            governorateId: _selectedGovernorateId,
                            markazId: _selectedMarkazId,
                            villageId: _selectedVillageId,
                          );
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 18.sp, color: AppColors.primary),
        8.wBox,
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
        if (subtitle != null && subtitle.isNotEmpty) ...[
          8.wBox,
          Expanded(
            child: Text(
              subtitle,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.grey.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? Colors.white12 : Colors.black12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(
                Icons.check_rounded,
                size: 16,
                color: Colors.white,
              ),
              6.wBox,
            ],
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black87),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
