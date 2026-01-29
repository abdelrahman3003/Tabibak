import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagrion.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/alert_widget.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_details_provider/appointment_details_provider.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_provider/appointment_provider.dart';

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
                    final state = ref.watch(appointmentDetailsNotifier);
                    if (state.isDeleted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        await ref
                            .read(appointsProviderNotifier.notifier)
                            .getAppointments();
                        context.pushReplacementNamed(Routes.layoutScreen);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Appointment deleted successfully")),
                        );
                      });
                    }
                    if (state.errorMessage != null) {
                      context.pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage!)),
                      );
                    }
                    return AlertWidget(
                      context: context,
                      isLoading: state.isLoading,
                      title: AppStrings.deleteConfirmation,
                      subtitle: AppStrings.deleteMessage,
                      confirmString: AppStrings.delete,
                      confirmColor: AppColors.red,
                      onPressed: () {
                        ref
                            .read(appointmentDetailsNotifier.notifier)
                            .deleteAppointment(appointmentId);
                      },
                    );
                  },
                ));
      },
    );
  }
}
