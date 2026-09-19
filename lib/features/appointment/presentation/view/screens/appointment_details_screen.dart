import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/function/language_state.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/appointment/presentation/manager/appointment_details_provider/appointment_details_provider.dart';
import 'package:tabibak/features/appointment/presentation/view/widget/appointment_details/appointment_info_card.dart';
import 'package:tabibak/features/appointment/presentation/view/widget/appointment_details/delete_button_states.dart';
import 'package:tabibak/features/appointment/presentation/view/widget/appointment_details/doctor_header_widget.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class AppointmentDetailsScreen extends ConsumerStatefulWidget {
  final int appointmentId;

  const AppointmentDetailsScreen({
    super.key,
    required this.appointmentId,
  });

  @override
  ConsumerState<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState
    extends ConsumerState<AppointmentDetailsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appointmentId = widget.appointmentId;
      ref
          .read(appointmentDetailsNotifier.notifier)
          .getAppointmentDetails(appointmentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentDetailsNotifier);
    final appointment = state.appointment;
    log("------------${state.appointment?.queueNumber}");
    return Scaffold(
      appBar: AppBarWidget(
        title: AppStrings.appointmentDetailsTitle,
      ),
      body: state.isLoading || appointment == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DoctorHeaderWidget(
                            appointment: appointment,
                          ),
                          24.hBox,
                          _buildStatusBadge(
                            context,
                            appointment,
                          ),
                          32.hBox,
                          Text(
                            AppStrings.appointmentDetails,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          16.hBox,
                          AppointmentInfoCard(
                            title: AppStrings.date,
                            value: appointment.appointmentDate ??
                                AppStrings.unknown,
                            icon: Icons.calendar_today,
                          ),
                          AppointmentInfoCard(
                            title: AppStrings.time,
                            value: _getFormattedTime(
                              context,
                              appointment,
                            ),
                            icon: Icons.access_time,
                          ),
                          AppointmentInfoCard(
                            title: AppStrings.price,
                            value:
                                "${appointment.doctor?.clinic?.consultationFee ?? AppStrings.unknown} ${AppStrings.egp}",
                            icon: Icons.monetization_on_outlined,
                          ),
                          AppointmentInfoCard(
                            title: AppStrings.appointmentType,
                            value: context.locale.languageCode == 'ar'
                                ? appointment.appointmentTypeModel
                                        ?.appointmentTypeAr ??
                                    AppStrings.unknown
                                : appointment.appointmentTypeModel
                                        ?.appointmentTypeEn ??
                                    AppStrings.unknown,
                            icon: Icons.medical_services_outlined,
                          ),
                          if (appointment.followUpDate != null)
                            AppointmentInfoCard(
                              title: AppStrings.followUpDate,
                              value: DateFormat(
                                'dd/MM/yyyy',
                                isArabic(context) ? 'ar' : 'en',
                              ).format(
                                appointment.followUpDate!,
                              ),
                              icon: Icons.event_repeat_outlined,
                            ),
                          if (state.appointment?.queueNumber != null)
                            AppointmentInfoCard(
                              title: AppStrings.queuePosition,
                              value: state.appointment!.queueNumber.toString(),
                              icon: Icons.format_list_numbered,
                            ),
                          16.hBox,
                        ],
                      ),
                    ),
                  ),
                  if (appointment.status == 1 || appointment.status == 2)
                    DeleteButtonStates(
                      appointmentId: appointment.id!,
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusBadge(
    BuildContext context,
    appointment,
  ) {
    final statusColor = _getStatusColor(appointment.status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 10,
            color: statusColor,
          ),
          8.wBox,
          Text(
            context.locale.languageCode == 'ar'
                ? appointment.appointmentsStatus?.statusAr ?? ""
                : appointment.appointmentsStatus?.statusEn ?? "",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  String _formatTime(
    String? time,
    BuildContext context,
  ) {
    if (time == null || time.isEmpty) {
      return '';
    }

    try {
      final parsedTime = DateFormat("HH:mm").parse(time);

      final isArabic = Localizations.localeOf(context).languageCode == 'ar';

      return DateFormat(
        "h:mm a",
        isArabic ? "ar" : "en",
      ).format(parsedTime);
    } catch (e) {
      return time;
    }
  }

  String _getFormattedTime(
    BuildContext context,
    appointment,
  ) {
    final shift = appointment.shiftMorning ?? appointment.shiftEvening;

    if (shift != null) {
      final start = _formatTime(
        shift.start,
        context,
      );

      final end = _formatTime(
        shift.end,
        context,
      );

      return "$start - $end";
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
        return AppColors.primary;
      case 4:
        return AppColors.red;
      default:
        return AppColors.primary;
    }
  }
}
