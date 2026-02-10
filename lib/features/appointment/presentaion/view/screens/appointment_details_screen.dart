import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/appointment_details/appointment_info_card.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/appointment_details/delete_button_states.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/appointment_details/doctor_header_widget.dart';
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoctorHeaderWidget(appointment: appointment),
                    24.hBox,
                    _buildStatusBadge(context),
                    32.hBox,
                    Text(
                      AppStrings.appointmentDetails,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    16.hBox,
                    AppointmentInfoCard(
                      title: AppStrings.date,
                      value: appointment.appointmentDate ?? AppStrings.unknown,
                      icon: Icons.calendar_today,
                    ),
                    AppointmentInfoCard(
                      title: AppStrings.time,
                      value: _getFormattedTime(),
                      icon: Icons.access_time,
                    ),
                    AppointmentInfoCard(
                      title: AppStrings.price,
                      value:
                          "${appointment.doctor?.clinic?.consultationFee ?? AppStrings.unknown} ${AppStrings.egp}",
                      icon: Icons.monetization_on_outlined,
                    ),
                  ],
                ),
              ),
            ),
            DeleteButtonStates(appointmentId: appointment.id!),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getStatusColor(appointment.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getStatusColor(appointment.status)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 10,
            color: _getStatusColor(appointment.status),
          ),
          8.wBox,
          Text(
            appointment.appointmentsStatus?.statusAr ?? AppStrings.unknown,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _getStatusColor(appointment.status),
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  String _getFormattedTime() {
    if (appointment.shiftMorning != null) {
      return "${appointment.shiftMorning?.start} - ${appointment.shiftMorning?.end}";
    } else if (appointment.shiftEvening != null) {
      return "${appointment.shiftEvening?.start} - ${appointment.shiftEvening?.end}";
    }
    return AppStrings.unknown;
  }

  Color _getStatusColor(int? status) {
    switch (status) {
      case 1:
        return AppColors.orange;
      case 2:
        return AppColors.green;
      case 3:
        return AppColors.red;
      case 4:
        return AppColors.primary;
      default:
        return AppColors.primary;
    }
  }
}
