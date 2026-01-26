import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/home/data/model/shift_model.dart';

abstract class AppointmentsRepos {
  Future<ApiResult<void>> addAppointment(AppointmentModel appointment);
  Future<ApiResult<ShiftModel?>> getShift(
      {required String dayEn, required int clinicId});
}
