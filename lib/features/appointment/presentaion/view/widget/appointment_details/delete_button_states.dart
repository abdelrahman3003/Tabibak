import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_details_provider/appointment_details_provider.dart';

class DeleteButtonStates extends ConsumerWidget {
  const DeleteButtonStates({
    super.key,
    required this.appointmentId,
  });
  final int appointmentId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appointmentdetailsNotifer);
    return AppButton(
      title: state.isLoading ? AppStrings.deleting : AppStrings.deleteBooking,
      color: AppColors.red,
      isLoading: state.isLoading,
      onPressed: () {
        log("--------------------- done");
        ref
            .read(appointmentdetailsNotifer.notifier)
            .deleteAppointment(context, appointmentId);
      },
    );
  }
}
