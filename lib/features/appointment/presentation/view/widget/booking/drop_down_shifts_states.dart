import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/appointment/presentation/manager/appointment_booking_provider/appointment_booking_provider.dart';
import 'package:tabibak/features/appointment/presentation/manager/appointment_booking_provider/appointment_booking_states.dart';
import 'package:tabibak/features/home/data/model/day_shift_model.dart';

class DropDownShiftsStates extends ConsumerStatefulWidget {
  final Function({int? shiftMorningId, int? shiftEveningId})? onSelected;

  const DropDownShiftsStates({super.key, this.onSelected});

  @override
  ConsumerState<DropDownShiftsStates> createState() =>
      _DropDownShiftsStatesState();
}

class _DropDownShiftsStatesState extends ConsumerState<DropDownShiftsStates> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentBookingNotifierProvider);

    ref.listen(
      appointmentBookingNotifierProvider.select((s) => s.dayShiftsModel),
      (previous, next) {
        setState(() => _selectedValue = null);
        widget.onSelected?.call(shiftMorningId: null, shiftEveningId: null);
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.periodLabel,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        6.hBox,
        _buildBody(state, _buildShiftMap(state.dayShiftsModel)),
      ],
    );
  }

  Widget _buildBody(AppointmentBookingStates state, Map<String, int> shiftMap) {
    if (state.isShiftLoading) {
      return _buildLoadingBox();
    }
    if (state.dayShiftsModel == null || shiftMap.isEmpty) {
      return _buildEmptyBox();
    }
    return _buildCards(state.dayShiftsModel!, shiftMap);
  }

  Widget _buildLoadingBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.secondWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
            height: 20.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
          12.wBox,
          Text(
            'Loading shifts...',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.subtextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.secondWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18.r, color: AppColors.subtextColor),
          8.wBox,
          Expanded(
            child: Text(
              AppStrings.thisDayNotAvailable,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.subtextColor,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCards(DayShiftsModel dayShiftsModel, Map<String, int> shiftMap) {
    return Row(
      children: [
        if (shiftMap.containsKey('morning'))
          Expanded(
            child: _buildCard(
              value: 'morning',
              label: AppStrings.morningShift,
              icon: Icons.sunny,
              shiftTime: dayShiftsModel.morning,
              isSelected: _selectedValue == 'morning',
              onTap: () {
                setState(() => _selectedValue = 'morning');
                widget.onSelected?.call(
                  shiftMorningId: shiftMap['morning'],
                  shiftEveningId: null,
                );
              },
            ),
          ),
        if (shiftMap.containsKey('morning') && shiftMap.containsKey('evening'))
          12.wBox,
        if (shiftMap.containsKey('evening'))
          Expanded(
            child: _buildCard(
              value: 'evening',
              label: AppStrings.eveningShift,
              icon: Icons.nightlight_round,
              shiftTime: dayShiftsModel.evening,
              isSelected: _selectedValue == 'evening',
              onTap: () {
                setState(() => _selectedValue = 'evening');
                widget.onSelected?.call(
                  shiftMorningId: null,
                  shiftEveningId: shiftMap['evening'],
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildCard({
    required String value,
    required String label,
    required IconData icon,
    required dynamic shiftTime,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final hasTime = shiftTime?.start != null && shiftTime?.end != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28.r,
              color: isSelected ? AppColors.primary : AppColors.subtextColor,
            ),
            8.hBox,
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textDark,
              ),
            ),
            if (hasTime) ...[
              4.hBox,
              Text(
                "${shiftTime.start} - ${shiftTime.end}",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isSelected
                      ? AppColors.primaryDark
                      : AppColors.subtextColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Map<String, int> _buildShiftMap(DayShiftsModel? model) {
    final map = <String, int>{};
    final morning = model?.morning;
    if (morning?.start != null && morning?.end != null) {
      map['morning'] = morning!.id;
    }
    final evening = model?.evening;
    if (evening?.start != null && evening?.end != null) {
      map['evening'] = evening!.id;
    }
    return map;
  }
}
