import 'package:flutter/material.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/features/booking/widget/appointment/appointment_list_view.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/titel_text.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          10.hBox,
          TitelText(title: "الحجوزات"),
          Expanded(child: AppointmentListView()),
        ],
      ),
    );
  }
}
