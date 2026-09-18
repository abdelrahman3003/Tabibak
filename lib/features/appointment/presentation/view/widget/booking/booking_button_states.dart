import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/appointment/presentation/manager/appointment_booking_provider/appointment_booking_provider.dart';
import 'package:tabibak/features/appointment/presentation/view/widget/booking/appointment_success_arg.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

class BookingButtonStates extends ConsumerWidget {
  const BookingButtonStates({
    super.key,
    this.onPressed,
    required this.doctorModel,
  });
  final Function()? onPressed;
  final DoctorModel doctorModel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appointmentBookingNotifierProvider);
    ref.listen(appointmentBookingNotifierProvider, (prev, next) {
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
        ref
            .read(appointmentBookingNotifierProvider.notifier)
            .clearError();
      }
      if (next.isSuccess && next.appointmentModel != null) {
        final model = next.dayShiftsModel;
        final isMorning = next.appointmentModel!.shiftMorningId != null;
        final timeString = isMorning
            ? "${model?.morning?.start ?? ''} - ${model?.morning?.end ?? ''}"
            : "${model?.evening?.start ?? ''} - ${model?.evening?.end ?? ''}";
        final arg = AppointmentSuccessArg(
          doctorModel: doctorModel,
          appointmentDate: next.appointmentModel!.appointmentDate ?? '',
          timeString: timeString,
        );
        // Consume before navigating so rebuilds don't re-navigate.
        ref.read(appointmentBookingNotifierProvider.notifier).consumeSuccess();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.pushReplacementNamed(
            Routes.bookingSuccessScreen,
            arguments: arg,
          );
        });
      }
    });
    return AppButton(
      isDisabled: state.isLoading,
      isLoading: state.isLoading,
      title: AppStrings.book,
      onPressed: onPressed,
    );
  }
}
