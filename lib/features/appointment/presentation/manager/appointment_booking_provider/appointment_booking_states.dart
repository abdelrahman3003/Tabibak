import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/home/data/model/day_shift_model.dart';

class AppointmentBookingStates {
  final bool isLoading;
  final bool isShiftLoading;
  final String? errorMessage;
  final DayShiftsModel? dayShiftsModel;
  final String? emptyShift;
  final bool isSuccess;
  final AppointmentModel? appointmentModel;
  AppointmentBookingStates({
    this.isLoading = false,
    this.isShiftLoading = false,
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
    bool clearError = false,
    String? emptyShift,
    bool clearEmptyShift = false,
    DayShiftsModel? dayShiftsModel,
    bool clearDayShifts = false,
    bool? isSuccess,
    AppointmentModel? appointmentModel,
    bool clearAppointment = false,
  }) {
    return AppointmentBookingStates(
      isLoading: isLoading ?? false,
      isShiftLoading: isShiftLoading ?? false,
      dayShiftsModel:
          clearDayShifts ? null : dayShiftsModel ?? this.dayShiftsModel,
      emptyShift: clearEmptyShift ? null : emptyShift ?? this.emptyShift,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? false,
      appointmentModel:
          clearAppointment ? null : appointmentModel ?? this.appointmentModel,
    );
  }
}
