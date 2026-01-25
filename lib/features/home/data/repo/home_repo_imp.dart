import 'dart:developer';

import 'package:tabibak/core/networking/api_error_handler.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/data_source/home_remote_data.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/doctor_summary.dart';
import 'package:tabibak/features/home/data/model/specialty_model.dart';
import 'package:tabibak/features/home/data/repo/home_repo.dart';

class HomeRepoImp extends HomeRepo {
  final HomeRemoteData homeRemoteData;

  HomeRepoImp({required this.homeRemoteData});

  @override
  Future<ApiResult<UserModel>> getUserData() async {
    try {
      final result = await homeRemoteData.fetchUserById();

      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<SpecialtyModel>>> fetchSpecialties() async {
    try {
      final result = await homeRemoteData.fetchSpecialties();

      return ApiResult.sucess(result);
    } catch (error) {
      log("-----$error");
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<DoctorModel>>> fetchAllDoctors() async {
    try {
      final result = await homeRemoteData.fetchAllDoctors();
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<DoctorSummary>>> searchDoctor(search) async {
    try {
      final result = await homeRemoteData.searchDoctor(search);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<DoctorSummary>>> getAllDoctorsSummary() async {
    try {
      final result = await homeRemoteData.getAllDoctorsSummary();
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<DoctorModel>> getDoctorId(int id) async {
    try {
      final result = await homeRemoteData.getDoctorById(id);
      return ApiResult.sucess(result);
    } catch (error) {
      log("Error fetching doctor by ID: $id - $error");
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<DoctorSummary>>> getAllDoctorsSpecialties(
      int specialtyId) async {
    try {
      final result = await homeRemoteData.getDoctorSpecialist(specialtyId);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<Comment>>> getDoctorComments(int doctorid) async {
    try {
      final result = await homeRemoteData.getDoctorComments(doctorid);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<void>> addComment(
      {required String comment, required int doctorId}) async {
    try {
      final result =
          await homeRemoteData.addComment(comment: comment, doctorId: doctorId);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<void>> addRate(
      {required double rate, required int doctorId}) async {
    try {
      final result =
          await homeRemoteData.addRate(rate: rate, doctorId: doctorId);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
