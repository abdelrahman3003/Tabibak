import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/widgets/app_text_formfiled.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_provider.dart';

class BookingDate extends ConsumerStatefulWidget {
  const BookingDate({super.key, required this.clinicID});
  final int clinicID;

  @override
  ConsumerState<BookingDate> createState() => _BookingDateState();
}

TextEditingController dateController = TextEditingController();

class _BookingDateState extends ConsumerState<BookingDate> {
  @override
  Widget build(BuildContext context) {
    return AppTextFormFiled(
      hint: "Date",
      controller: dateController,
      readOnly: true,
      onTap: () async {
        await _datePicker(context);
      },
    );
  }

  Future<void> _datePicker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      dateController.text =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

      final dayEn = pickedDate.weekdayToEnglish();
      ref
          .read(appointmentBookingNotifierProvider.notifier)
          .getSHift(dayEn: dayEn, clinicId: widget.clinicID);
    }
  }
}

extension WeekdayToString on DateTime {
  String weekdayToEnglish() {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }
}
