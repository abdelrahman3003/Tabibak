import 'package:tabibak/features/home/data/model/day_shift_model.dart';

class AppointmentBookingStates {
  final bool isLoading;
  final String? errorMessage;
  final DayShiftsModel? dayShiftsModel;
  final bool isSuccess;
  AppointmentBookingStates({
    this.isLoading = false,
    this.errorMessage,
    this.dayShiftsModel,
    this.isSuccess = false,
  });

  AppointmentBookingStates copyWith({
    bool? isLoading,
    bool? isShiftLoading,
    String? errorMessage,
    DayShiftsModel? dayShiftsModel,
    bool? isSuccess,
  }) {
    return AppointmentBookingStates(
      isLoading: isLoading ?? false,
      dayShiftsModel: dayShiftsModel,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? false,
    );
  }
}
