import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';

abstract class AppointmentsRepos {
  Future<ApiResult<List<Appointment>>> getAllAppoinments(String userId);
  Future<ApiResult<List<AppointmentStatus>>> getAllAppoinmentsStatus();
}
