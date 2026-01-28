import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/core/widgets/dialogs.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_provider.dart';
import 'package:tabibak/features/home/presentation/views/screens/layout_screen.dart';

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
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LayoutScreen(),
            ),
            (route) => true);
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
