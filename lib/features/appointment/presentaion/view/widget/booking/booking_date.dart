import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_provider.dart';

class BookingDate extends ConsumerStatefulWidget {
  const BookingDate({super.key, required this.clinicID});
  final int clinicID;

  @override
  ConsumerState<BookingDate> createState() => _BookingDateState();
}

DateTime? selectedDate;

class _BookingDateState extends ConsumerState<BookingDate> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await _datePicker(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          selectedDate != null
              ? selectedDate!.toLocal().toString().split(' ')[0]
              : "Select date",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _datePicker(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });

      final dayEn = picked.weekdayToEnglish();
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
