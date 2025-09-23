import 'package:tabibak/core/networking/api_error_handler.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/appointment/data/remote_data/appointments_remote_data.dart';
import 'package:tabibak/features/appointment/data/repos/appointments_repos.dart';

class AppointmentsReposImp implements AppointmentsRepos {
  final appointmentsRemoteData = AppointmentsRemoteData();
  @override
  Future<ApiResult<List<Appointment>>> getAllAppoinments(String userId) async {
    try {
      final result =
          await appointmentsRemoteData.getAllAppoinments("eq.$userId");
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<AppointmentStatus>>> getAllAppoinmentsStatus() async {
    try {
      final result = await appointmentsRemoteData.getAllAppoinmentsStatus();
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
