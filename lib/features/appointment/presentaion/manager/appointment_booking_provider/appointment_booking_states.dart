import 'package:tabibak/features/home/data/model/shift_model.dart';

class AppointmentBookingStates {
  final bool isLoading;
  final bool isShiftLoading;
  final String? errorMessage;
  final ShiftModel? shiftModel;
  AppointmentBookingStates({
    this.isLoading = false,
    this.errorMessage,
    this.isShiftLoading = false,
    this.shiftModel,
  });

  AppointmentBookingStates copyWith({
    bool? isLoading,
    bool? isShiftLoading,
    String? errorMessage,
    ShiftModel? shiftModel,
  }) {
    return AppointmentBookingStates(
      isLoading: isLoading ?? false,
      isShiftLoading: isShiftLoading ?? false,
      shiftModel: shiftModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
