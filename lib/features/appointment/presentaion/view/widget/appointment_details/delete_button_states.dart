import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/alert_widget.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_details_provider/appointment_details_provider.dart';

class DeleteButtonStates extends StatelessWidget {
  const DeleteButtonStates({
    super.key,
    required this.appointmentId,
  });
  final int appointmentId;
  @override
  Widget build(BuildContext context) {
    return AppButton(
      title: AppStrings.deleteBooking,
      color: AppColors.red,
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) => Consumer(
                  builder: (context, ref, child) {
                    final state = ref.watch(appointmentdetailsNotifer);
                    return AlertWidget(
                      context: context,
                      title: AppStrings.deleteConfirmation,
                      subtitle: AppStrings.deleteMessage,
                      confirmString: AppStrings.delete,
                      confirmColor: AppColors.red,
                      isLoading: state.isLoading,
                      onPressed: () {
                        ref
                            .read(appointmentdetailsNotifer.notifier)
                            .deleteAppointment(context, appointmentId);
                      },
                    );
                  },
                ));
      },
    );
  }
}
