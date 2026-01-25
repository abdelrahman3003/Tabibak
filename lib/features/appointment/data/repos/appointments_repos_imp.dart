import 'dart:developer';

import 'package:tabibak/core/networking/api_error_handler.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/appointment/data/model/appointment_body.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/appointment/data/remote_data/appointments_remote_data.dart';
import 'package:tabibak/features/appointment/data/repos/appointments_repos.dart';
import 'package:tabibak/features/home/data/model/working_day_model.dart';

class AppointmentsReposImp implements AppointmentsRepos {
  final appointmentsRemoteData = AppointmentsRemoteData();
  @override
  Future<ApiResult<List<Appointment>>> getAllAppoinments(String userId) async {
    try {
      final result =
          await appointmentsRemoteData.getAllAppoinments("eq.$userId");
      return ApiResult.sucess(result);
    } catch (error) {
      log("Error adding appointment: $error");

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

  @override
  Future<ApiResult<WorkingDay?>> getTimeSlots(
      int doctorId, String workingDay) async {
    try {
      final result =
          await appointmentsRemoteData.getTimeSlots(doctorId, workingDay);
      if (result.isEmpty) {
        return ApiResult.sucess(null);
      }
      return ApiResult.sucess(result.first);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<void>> addAppointment(
      AppointmentBody appointmentBody) async {
    try {
      final result =
          await appointmentsRemoteData.addAppointment(appointmentBody);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<void>> deleteAppointment(int id) async {
    try {
      final result = await appointmentsRemoteData.deleteAppointment(id);
      return ApiResult.sucess(result);
    } catch (error) {
      log("=============== err $error");

      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
