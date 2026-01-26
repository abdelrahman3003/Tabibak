import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/booking/booking_button_states.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/booking/booking_date.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/booking/booking_header.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/booking/booking_time_states.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/title_text.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class AppointmentBookingScreen extends StatelessWidget {
  const AppointmentBookingScreen({super.key, required this.doctorModel});
  final DoctorModel doctorModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: AppStrings.bookingInquiry),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.hBox,
            BookingHeader(doctorModel: doctorModel),
            20.hBox,
            TitleText(title: AppStrings.selectDate),
            8.hBox,
            BookingDate(clinicID: doctorModel.clinic!.id!),
            20.hBox,
            BookingTimeStates(),
            Spacer(),
            BookingButtonStates(
              doctorModel: doctorModel,
            )
          ],
        ),
      ),
    );
  }
}
