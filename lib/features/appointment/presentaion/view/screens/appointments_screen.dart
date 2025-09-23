import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/appointment/appointment_list_states.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/titel_text.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          10.hBox,
          TitelText(title: AppStrings.appointments),
          Expanded(child: AppointmentListStates()),
        ],
      ),
    );
  }
}
