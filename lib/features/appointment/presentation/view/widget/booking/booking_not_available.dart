import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';

class BookingNotAvailable extends StatelessWidget {
  const BookingNotAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            color: Colors.redAccent,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.clinicIsnotAvailableOnthisDay,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
