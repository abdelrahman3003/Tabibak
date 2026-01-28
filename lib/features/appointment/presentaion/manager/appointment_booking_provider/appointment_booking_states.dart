import 'package:tabibak/features/home/data/model/day_shift_model.dart';

class AppointmentBookingStates {
  final bool isLoading;
  final bool isShiftLoading;
  final String? errorMessage;
  final DayShiftsModel? dayShiftsModel;

  AppointmentBookingStates({
    this.isLoading = false,
    this.errorMessage,
    this.isShiftLoading = false,
    this.dayShiftsModel,
  });

  AppointmentBookingStates copyWith({
    bool? isLoading,
    bool? isShiftLoading,
    String? errorMessage,
    DayShiftsModel? dayShiftsModel,
  }) {
    return AppointmentBookingStates(
      isLoading: isLoading ?? false,
      isShiftLoading: isShiftLoading ?? false,
      dayShiftsModel: dayShiftsModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
