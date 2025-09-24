import 'package:tabibak/features/home/data/model/doctor_model.dart';

class AppointmentBookingStates {
  final bool isLoading;
  final DateTime? selectedDate;
  final TimeSlot? selectedTime;
  final WorkingDay? workingDay;

  AppointmentBookingStates(
      {this.isLoading = false,
      this.selectedDate,
      this.selectedTime,
      this.workingDay});

  AppointmentBookingStates copyWith(
      {bool? isLoading,
      DateTime? selectedDate,
      TimeSlot? selectedTime,
      WorkingDay? workingDay}) {
    return AppointmentBookingStates(
        isLoading: isLoading ?? this.isLoading,
        selectedDate: selectedDate ?? this.selectedDate,
        selectedTime: selectedTime ?? this.selectedTime,
        workingDay: workingDay ?? this.workingDay);
  }
}
