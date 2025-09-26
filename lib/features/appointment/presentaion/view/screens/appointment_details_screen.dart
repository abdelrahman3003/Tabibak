import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/appointment_details/delete_button_states.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/appointment_details/details_item.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailsScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: AppStrings.appointmentDetailsTitle),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailsItem(
                        title: AppStrings.doctor,
                        value: appointment.doctor?.name ?? AppStrings.unknown),
                    10.hBox,
                    DetailsItem(
                        title: AppStrings.specialty,
                        value: appointment.doctor?.specialties?.name ??
                            AppStrings.unknown),
                    10.hBox,
                    DetailsItem(
                        title: AppStrings.bookingStatus,
                        value: appointment.appointmentStatus?.status ??
                            AppStrings.unknown),
                    10.hBox,
                    DetailsItem(
                        title: AppStrings.date2,
                        value: appointment.appointmentDate == null
                            ? AppStrings.unknown
                            : DateFormat("yyyy-MM-dd")
                                .format(appointment.appointmentDate!)),
                    10.hBox,
                    DetailsItem(
                        title: AppStrings.time,
                        value:
                            appointment.appointmentTime ?? AppStrings.unknown),
                    10.hBox,
                    DetailsItem(
                        title: AppStrings.bookingTime,
                        value: DateFormat("yyyy-MM-dd")
                            .format(appointment.createDate!)),
                    10.hBox,
                    DetailsItem(
                        title: AppStrings.consultationPrice,
                        value:
                            "${appointment.doctor?.clinicData?.consultationFee ?? AppStrings.unknown} ${AppStrings.egp}"),
                    10.hBox,
                  ],
                ),
              ),
            ),
            const Spacer(),
            DeleteButtonStates(appointmentId: appointment.id)
          ],
        ),
      ),
    );
  }
}
