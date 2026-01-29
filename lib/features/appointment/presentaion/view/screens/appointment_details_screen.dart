import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/function/formate_date.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/appointment_details/delete_button_states.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/appointment_details/details_item.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final AppointmentModel appointment;

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
                        value: appointment.doctor?.specialty?.nameAr ??
                            AppStrings.unknown),
                    10.hBox,
                    DetailsItem(
                        title: AppStrings.bookingStatus,
                        value: appointment.appointmentsStatus?.statusAr ??
                            AppStrings.unknown),
                    10.hBox,
                    DetailsItem(
                        title: AppStrings.date2,
                        value:
                            appointment.appointmentDate ?? AppStrings.unknown),
                    10.hBox,
                    DetailsItem(
                        title: AppStrings.time,
                        value: appointment.shiftMorning == null
                            ? "${appointment.shiftEvening?.start}- ${appointment.shiftEvening?.end}"
                            : "${appointment.shiftMorning?.start}- ${appointment.shiftMorning?.end}"),
                    10.hBox,
                    DetailsItem(
                        title: AppStrings.bookingTime,
                        value: formatDayMonth(appointment.createdAt!)),
                    10.hBox,
                    DetailsItem(
                        title: AppStrings.consultationPrice,
                        value:
                            "${appointment.doctor?.clinic?.consultationFee ?? AppStrings.unknown} ${AppStrings.egp}"),
                    10.hBox,
                  ],
                ),
              ),
            ),
            const Spacer(),
            DeleteButtonStates(appointmentId: 1)
          ],
        ),
      ),
    );
  }
}
