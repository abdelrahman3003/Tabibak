import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/enums/appointment_status.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';

class AppointmentCardItem extends StatelessWidget {
  const AppointmentCardItem({super.key, required this.appointment, this.onTap});
  final Appointment appointment;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final status =
        AppointmentStatusX.fromString(appointment.appointmentStatus?.status);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.calendar_today, color: Colors.white),
      ),
      title: Text(
        appointment.doctor?.name ?? AppStrings.unknown,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        appointment.doctor?.specialties?.name ?? AppStrings.unknown,
        style: const TextStyle(fontSize: 13),
      ),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: status.color,
        ),
        child: Text(status.label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.white, fontWeight: FontWeight.w600)),
      ),
      onTap: onTap,
    );
  }
}
