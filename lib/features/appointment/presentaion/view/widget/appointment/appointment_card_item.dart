import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_padding.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/function/formate_date.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';

class AppointmentCardItem extends StatelessWidget {
  const AppointmentCardItem({super.key, required this.appointment, this.onTap});
  final AppointmentModel appointment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppPadding.all20,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: AppRadius.radius16,
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            if (Theme.of(context).brightness == Brightness.light)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            _buildIconCircle(
                Icons.book_online_outlined, AppColors.primaryLight),
            10.wBox,
            Expanded(child: _buildDoctorInfo(context)),
            _buildStatusColumn(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIconCircle(IconData icon, Color bgColor) {
    return Container(
      padding: AppPadding.all12,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.radius12,
      ),
      child: Icon(icon),
    );
  }

  Widget _buildDoctorInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appointment.doctor?.name ?? "",
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        5.hBox,
        _buildIconTextRow(
          icon: Icons.local_fire_department_outlined,
          text: appointment.doctor?.specialty?.nameAr ?? "",
          textStyle: Theme.of(context).textTheme.bodyMedium,
          iconSize: 16,
        ),
      ],
    );
  }

  Widget _buildIconTextRow({
    required IconData icon,
    required String text,
    TextStyle? textStyle,
    double iconSize = 20,
  }) {
    return Row(
      children: [
        Icon(icon, size: iconSize),
        5.wBox,
        Text(text, style: textStyle),
      ],
    );
  }

  Widget _buildStatusColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildStatusContainer(context),
        10.hBox,
        Text(
          formatDayMonth(appointment.appointmentDate ?? ""),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey
                  : const Color(0xff94A3B8)),
        ),
      ],
    );
  }

  Widget _buildStatusContainer(BuildContext context) {
    final color = _getColor(appointment.status ?? 0);
    final statusText = appointment.appointmentsStatus?.statusAr ?? "";

    return Container(
      padding: AppPadding.all8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.radius8,
      ),
      child: Text(
        statusText,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Color _getColor(int index) {
    switch (index) {
      case 2:
        return AppColors.lightGreen;
      case 3:
        return AppColors.red;
      default:
        return AppColors.orange;
    }
  }
}
