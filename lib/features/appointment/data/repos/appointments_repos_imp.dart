import 'dart:developer';

import 'package:tabibak/core/networking/api_error_handler.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/appointment/data/remote_data/appointments_remote_data.dart';
import 'package:tabibak/features/appointment/data/repos/appointments_repos.dart';
import 'package:tabibak/features/home/data/model/shift_model.dart';

class AppointmentsReposImp implements AppointmentsRepos {
  final AppointmentsRemoteData appointmentsRemoteData;

  AppointmentsReposImp({required this.appointmentsRemoteData});
  @override
  Future<ApiResult<void>> addAppointment(AppointmentModel appointment) async {
    try {
      final result = await appointmentsRemoteData.addAppointment(appointment);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<ShiftModel?>> getShift(
      {required String dayEn, required int clinicId}) async {
    try {
      final result = await appointmentsRemoteData.getShift(
          dayEn: dayEn, clinicId: clinicId);
      return ApiResult.sucess(result);
    } catch (error) {
      log("-------$error");
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
