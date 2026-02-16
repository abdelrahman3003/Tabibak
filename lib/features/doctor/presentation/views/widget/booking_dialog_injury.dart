import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';

class BookingDialogInjury extends StatelessWidget {
  const BookingDialogInjury({super.key, required this.isBooked});
  final bool isBooked;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isBooked ? Icons.check_circle : Icons.block,
            size: 60,
            color: isBooked ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 20),
          Text(
            isBooked
                ? AppStrings.bookingSuccess
                : AppStrings.bookingUnavailable,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            isBooked
                ? AppStrings.bookingConfirmedMessage
                : AppStrings.chooseAnotherDayMessage,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppStrings.ok),
          )
        ],
      ),
    );
  }
}
