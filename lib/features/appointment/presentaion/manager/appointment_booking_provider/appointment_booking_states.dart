import 'package:tabibak/features/home/data/model/day_shift_model.dart';

class AppointmentBookingStates {
  final bool isLoading;
  final String? errorMessage;
  final DayShiftsModel? dayShiftsModel;
  final String? emptyShift;
  final bool isSuccess;
  AppointmentBookingStates({
    this.isLoading = false,
    this.errorMessage,
    this.emptyShift,
    this.dayShiftsModel,
    this.isSuccess = false,
  });

  AppointmentBookingStates copyWith({
    bool? isLoading,
    bool? isShiftLoading,
    String? errorMessage,
    String? emptyShift,
    DayShiftsModel? dayShiftsModel,
    bool? isSuccess,
  }) {
    return AppointmentBookingStates(
      isLoading: isLoading ?? false,
      dayShiftsModel: dayShiftsModel,
      emptyShift: emptyShift,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? false,
    );
  }
}
