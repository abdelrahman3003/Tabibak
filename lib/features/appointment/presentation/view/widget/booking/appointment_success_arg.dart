import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

class AppointmentSuccessArg {
  final AppointmentModel appointmentModel;
  final DoctorModel doctorModel;
  final String timeString;

  AppointmentSuccessArg({
    required this.appointmentModel,
    required this.doctorModel,
    required this.timeString,
  });
}
