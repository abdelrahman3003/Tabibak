import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagrion.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/core/widgets/dialogs.dart' show Dialogs;
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_provider.dart';

class BookingButtonStates extends ConsumerWidget {
  const BookingButtonStates({
    this.onPressed,
    super.key,
  });
  final Function()? onPressed;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appointmentBookingNotifierProvider);
    if (state.isSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pushReplacementNamed(Routes.bookingSuccessScreen);
      });
    }
    if (state.errorMessage != null) {
      Dialogs.errorDialog(context, state.errorMessage!);
    }
    return AppButton(
        isDisabled: state.isLoading,
        isLoading: state.isLoading,
        title: AppStrings.book,
        onPressed: onPressed);
  }
}
