import 'package:flutter/material.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class BookingTime extends StatefulWidget {
  const BookingTime({super.key});

  @override
  State<BookingTime> createState() => _BookingTimeState();
}

String? selectedTime;
final List<String> availableTimes = [
  "10:00 ص",
  "11:30 ص",
  "1:00 م",
  "2:30 م",
  "4:00 م",
];

class _BookingTimeState extends State<BookingTime> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: availableTimes.map((time) {
        bool isSelected = selectedTime == time;
        return ChoiceChip(
          label: Text(time),
          selected: isSelected,
          onSelected: (_) {
            setState(() {
              selectedTime = time;
            });
          },
          selectedColor: AppColors.primary,
          labelStyle:
              TextStyle(color: isSelected ? Colors.white : Colors.black),
        );
      }).toList(),
    );
  }
}
