import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/widgets/app_text_formfiled.dart';
import 'package:tabibak/features/appointment/presentation/manager/appointment_booking_provider/appointment_booking_provider.dart';

class BookingDate extends ConsumerStatefulWidget {
  const BookingDate({
    super.key,
    required this.clinicID,
    required this.dateController,
  });
  final int clinicID;
  final TextEditingController dateController;

  @override
  ConsumerState<BookingDate> createState() => _BookingDateState();
}

class _BookingDateState extends ConsumerState<BookingDate> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentBookingNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.dateLabel,
          style: Apptextstyles.font14Blackbold,
        ),
        6.hBox,
        AppTextFormFiled(
          hint: AppStrings.selectDate,
          controller: widget.dateController,
          prefixIcon: Icon(
            Icons.calendar_today_outlined,
            color: AppColors.primary,
            size: 20.r,
          ),
          readOnly: true,
          onTap: _pickDate,
        ),
        if (state.isShiftLoading)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
                8.wBox,
                Text(
                  'Loading shifts...',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.subtextColor,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final locale = EasyLocalization.of(context)?.locale ?? const Locale('en');
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: locale,
      helpText: AppStrings.selectDate,
      cancelText: AppStrings.cancel,
      confirmText: AppStrings.ok,
    );
    if (selected != null) {
      final formatted =
          "${selected.year}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}";
      widget.dateController.text = formatted;
      final dayEn = _weekdayToEnglish(selected.weekday);
      ref
          .read(appointmentBookingNotifierProvider.notifier)
          .getSHift(dayEn: dayEn, clinicId: widget.clinicID);
    }
  }

  String _weekdayToEnglish(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }
}
