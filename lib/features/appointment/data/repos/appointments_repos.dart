import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/appointment/data/model/appointment_body.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/home/data/model/working_day_model.dart';

abstract class AppointmentsRepos {
  Future<ApiResult<List<Appointment>>> getAllAppoinments(String userId);
  Future<ApiResult<List<AppointmentStatus>>> getAllAppoinmentsStatus();
  Future<ApiResult<WorkingDay?>> getTimeSlots(int doctorId, String workingDay);
  Future<ApiResult<void>> addAppointment(AppointmentBody appointmentBody);
  Future<ApiResult<void>> deleteAppointment(int id);
}
