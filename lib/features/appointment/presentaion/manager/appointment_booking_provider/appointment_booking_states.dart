import 'package:tabibak/features/home/data/model/doctor_model.dart';

class AppointmentBookingStates {
  final bool isLoading;
  final bool isDialogLoading;
  final DateTime? selectedDate;
  final TimeSlot? selectedTime;
  final WorkingDay? workingDay;
  final bool isAdded;

  AppointmentBookingStates({
    this.isLoading = false,
    this.isDialogLoading = false,
    this.selectedDate,
    this.selectedTime,
    this.workingDay,
    this.isAdded = false,
  });

  AppointmentBookingStates copyWith(
      {bool? isLoading,
      bool? isDialogLoading,
      DateTime? selectedDate,
      TimeSlot? selectedTime,
      WorkingDay? workingDay,
      bool? isAdded}) {
    return AppointmentBookingStates(
        isLoading: isLoading ?? this.isLoading,
        isDialogLoading: isDialogLoading ?? this.isDialogLoading,
        selectedDate: selectedDate ?? this.selectedDate,
        selectedTime: selectedTime ?? this.selectedTime,
        workingDay: workingDay ?? this.workingDay,
        isAdded: isAdded ?? this.isAdded);
  }
}
