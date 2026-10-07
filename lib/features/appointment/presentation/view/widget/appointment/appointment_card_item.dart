import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_padding.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/function/formate_date.dart';
import 'package:tabibak/core/function/language_state.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppointmentCardItem extends StatelessWidget {
  const AppointmentCardItem({super.key, required this.appointment, this.onTap});

  final AppointmentModel appointment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppPadding.all16,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).cardColor
              : Colors.white,
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
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (appointment.doctor?.image != null &&
                        appointment.doctor!.image!.isNotEmpty)
                    ? CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.transparent,
                        backgroundImage: CachedNetworkImageProvider(
                            appointment.doctor!.image!),
                      )
                    : const Icon(
                        Icons.local_hospital_outlined,
                        size: 44,
                        color: Colors.grey,
                      ),
                10.wBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctor?.name ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      5.hBox,
                      Text(
                        isArabic(context)
                            ? appointment.doctor?.specialty?.nameAr ?? ""
                            : appointment.doctor?.specialty?.nameEn ?? "",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey
                                  : const Color(0xff94A3B8),
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                10.wBox,
                _buildStatusContainer(context),
              ],
            ),
            12.hBox,
            Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.grey.withValues(alpha: 0.1),
            ),
            12.hBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconTextRow(
                  icon: Icons.calendar_month_outlined,
                  text: formatDayMonth(appointment.appointmentDate ?? ""),
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  iconColor: AppColors.primary,
                ),
                _buildIconTextRow(
                  icon: Icons.medical_services_outlined,
                  text: isArabic(context)
                      ? appointment.appointmentTypeModel?.appointmentTypeAr ??
                          ""
                      : appointment.appointmentTypeModel?.appointmentTypeEn ??
                          "",
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  iconColor: AppColors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconTextRow({
    required IconData icon,
    required String text,
    TextStyle? textStyle,
    double iconSize = 20,
    Color? iconColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: iconSize, color: iconColor ?? Colors.grey),
        6.wBox,
        Text(text, style: textStyle),
      ],
    );
  }

  Widget _buildStatusContainer(BuildContext context) {
    final color = _getColor(appointment.status ?? 0);
    final statusText = context.locale.languageCode == 'ar'
        ? appointment.appointmentsStatus?.statusAr ?? ""
        : appointment.appointmentsStatus?.statusEn ?? "";
    final icon = _getStatusIcon(appointment.status ?? 0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        borderRadius: AppRadius.radius8,
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          4.wBox,
          Text(
            statusText,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Color _getColor(int index) {
    switch (index) {
      case 1:
        return AppColors.orange;
      case 2:
        return AppColors.green;
      case 3:
        return AppColors.primary;
      case 4:
        return AppColors.red;
      default:
        return AppColors.primary;
    }
  }

  IconData _getStatusIcon(int index) {
    switch (index) {
      case 1:
        return Icons.hourglass_empty_rounded;
      case 2:
        return Icons.check_circle_outline_rounded;
      case 3:
        return Icons.done_all_rounded;
      case 4:
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline_rounded;
    }
  }
}
