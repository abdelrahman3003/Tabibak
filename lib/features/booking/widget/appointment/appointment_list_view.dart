import 'package:flutter/material.dart';
import 'package:tabibak/features/booking/widget/appointment/appointment_card_item.dart';

class AppointmentListView extends StatelessWidget {
  const AppointmentListView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> bookings = [
      {
        "doctor": "د. محمد علي",
        "specialty": "باطنة",
        "date": "12/08/2025",
        "time": "5:30 م",
        "status": "مؤكد",
      },
      {
        "doctor": "د. سارة أحمد",
        "specialty": "أسنان",
        "date": "15/08/2025",
        "time": "3:00 م",
        "status": "قيد الانتظار",
      },
      {
        "doctor": "د. علي حسن",
        "specialty": "جلدية",
        "date": "20/08/2025",
        "time": "7:00 م",
        "status": "ملغي",
      },
    ];
    return ListView.builder(
      itemCount: bookings.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return AppointmentCardItem(booking: booking);
      },
    );
  }
}
