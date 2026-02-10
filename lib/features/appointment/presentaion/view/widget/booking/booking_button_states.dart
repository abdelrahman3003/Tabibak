import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagrion.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/core/widgets/dialogs.dart' show Dialogs;
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_provider.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/booking/appointment_success_arg.dart';

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
    if (state.isSuccess && state.appointmentModel != null) {
      final arg = AppointmentSuccessArg(
        appointmentModel: state.appointmentModel!,
        doctorModel: doctorModel,
      );
      context.pushReplacementNamed(
        Routes.bookingSuccessScreen,
        arguments: arg,
      );
    }
    if (state.errorMessage != null) {
      Dialogs.errorDialog(context, state.errorMessage!);
    }
    return AppButton(
      isDisabled: state.isLoading,
      isLoading: state.isLoading,
      title: AppStrings.book,
      onPressed: onPressed,
    );
  }
}
