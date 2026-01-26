import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_provider.dart';
import 'package:tabibak/features/home/data/model/shift_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/title_text.dart';

class BookingTime extends ConsumerStatefulWidget {
  const BookingTime({super.key, required this.shifts});
  final ShiftModel shifts;

  @override
  ConsumerState<BookingTime> createState() => _BookingTimeState();
}

class _BookingTimeState extends ConsumerState<BookingTime> {
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentBookingNotifierProvider);

    final times = <String>[];
    if (widget.shifts.morningStart != null &&
        widget.shifts.morningEnd != null) {
      times.add("${widget.shifts.morningStart} - ${widget.shifts.morningEnd}");
    }
    if (widget.shifts.eveningStart != null &&
        widget.shifts.eveningEnd != null) {
      times.add("${widget.shifts.eveningStart} - ${widget.shifts.eveningEnd}");
    }

    return state.isShiftLoading
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: AppStrings.selectTime),
              8.hBox,
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: times.map((time) {
                  final isSelected = selectedTime == time;
                  return ChoiceChip(
                    label: Text(time),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedTime = selected ? time : null;
                      });

                      // // ممكن تنادي على البروڤايدر هنا لتحديث الحالة
                      // ref.read(appointmentBookingNotifierProvider.notifier)
                      //     .setSelectedTime(selectedTime);
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  );
                }).toList(),
              ),
            ],
          );
  }
}
