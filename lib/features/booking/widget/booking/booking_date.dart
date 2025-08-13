import 'package:flutter/material.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class BookingDate extends StatefulWidget {
  const BookingDate({super.key});

  @override
  State<BookingDate> createState() => _BookingDateState();
}

DateTime? selectedDate;

class _BookingDateState extends State<BookingDate> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 30)),
          locale: const Locale("ar", "EG"),
        );
        if (picked != null) {
          setState(() {
            selectedDate = picked;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textLight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          selectedDate == null
              ? "اضغط لاختيار التاريخ"
              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
