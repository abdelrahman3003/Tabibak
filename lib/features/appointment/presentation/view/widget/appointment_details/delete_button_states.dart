import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/alert_widget.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/appointment/presentation/manager/appointment_details_provider/appointment_details_provider.dart';
import 'package:tabibak/features/appointment/presentation/manager/appointment_provider/appointment_provider.dart';

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
                    final messenger = ScaffoldMessenger.of(context);
                    ref.listen(appointmentDetailsNotifier, (prev, next) async {
                      if (next.isDeleted) {
                        ref
                            .read(appointmentDetailsNotifier.notifier)
                            .consumeDeleted();
                        await ref
                            .read(appointsProviderNotifier.notifier)
                            .getAppointments();
                        if (context.mounted) {
                          context.pushReplacementNamed(Routes.layoutScreen);
                          messenger.showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Appointment cancelled successfully")),
                          );
                        }
                      }
                      if (next.errorMessage != null &&
                          next.errorMessage != prev?.errorMessage) {
                        final msg = next.errorMessage!;
                        ref
                            .read(appointmentDetailsNotifier.notifier)
                            .consumeDeleted();
                        if (context.mounted) {
                          Navigator.of(context, rootNavigator: true).maybePop();
                          messenger.showSnackBar(
                            SnackBar(content: Text(msg)),
                          );
                        }
                      }
                    });
                    final state = ref.watch(appointmentDetailsNotifier);
                    return AlertWidget(
                      context: context,
                      isLoading: state.isDeleting,
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
