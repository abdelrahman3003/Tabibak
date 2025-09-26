import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_provider.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/titel_text.dart';

class BookingTime extends StatelessWidget {
  const BookingTime({super.key, required this.shifts});
  final Shifts shifts;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(appointmentBookingNotiferProvider);
      final timeSlots = [
        if (shifts.morning != null) shifts.morning!,
        if (shifts.evening != null) shifts.evening!,
      ];
      return state.selectedDate == null
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitelText(title: AppStrings.selectTime),
                8.hBox,
                Wrap(
                  spacing: 8,
                  children: timeSlots.map((time) {
                    bool isSelected = state.selectedTime == time;
                    return ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _timeText(time.start, context, isSelected),
                          _timeText(" - ", context, isSelected),
                          _timeText(time.end, context, isSelected),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (_) {
                        ref
                            .watch(appointmentBookingNotiferProvider.notifier)
                            .selectTime(time);
                      },
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black),
                      showCheckmark: false,
                    );
                  }).toList(),
                ),
              ],
            );
    });
  }

  Text _timeText(String? text, BuildContext context, bool isSelected) {
    return Text(
      text ?? AppStrings.notAvailable,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: isSelected ? AppColors.white : AppColors.black),
    );
  }
}
