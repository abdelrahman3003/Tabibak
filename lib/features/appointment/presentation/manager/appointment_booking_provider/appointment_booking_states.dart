import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/home/data/model/day_shift_model.dart';

class AppointmentBookingStates {
  final bool isLoading;
  final String? errorMessage;
  final DayShiftsModel? dayShiftsModel;
  final String? emptyShift;
  final bool isSuccess;
  final AppointmentModel? appointmentModel;
  AppointmentBookingStates({
    this.isLoading = false,
    this.errorMessage,
    this.emptyShift,
    this.dayShiftsModel,
    this.isSuccess = false,
    this.appointmentModel,
  });

  AppointmentBookingStates copyWith({
    bool? isLoading,
    bool? isShiftLoading,
    String? errorMessage,
    String? emptyShift,
    DayShiftsModel? dayShiftsModel,
    bool? isSuccess,
    AppointmentModel? appointmentModel,
  }) {
    return AppointmentBookingStates(
      isLoading: isLoading ?? false,
      dayShiftsModel: dayShiftsModel ?? this.dayShiftsModel,
      emptyShift: emptyShift ?? this.emptyShift,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? false,
      appointmentModel: appointmentModel ?? this.appointmentModel,
    );
  }
}
