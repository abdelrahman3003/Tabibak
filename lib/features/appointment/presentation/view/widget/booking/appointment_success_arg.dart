import 'package:tabibak/features/home/data/model/doctor_model.dart';

class AppointmentSuccessArg {
  final DoctorModel doctorModel;
  final String appointmentDate;
  final String timeString;

  AppointmentSuccessArg({
    required this.doctorModel,
    required this.appointmentDate,
    required this.timeString,
  });
}
