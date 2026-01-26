import 'dart:developer';

import 'package:tabibak/core/networking/api_error_handler.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/data_source/home_remote_data.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/specialty_model.dart';
import 'package:tabibak/features/home/data/repo/home_repo.dart';

class HomeRepoImp extends HomeRepo {
  final HomeRemoteData homeRemoteData;

  HomeRepoImp({required this.homeRemoteData});

  @override
  Future<ApiResult<UserModel>> getUserData() async {
    try {
      final result = await homeRemoteData.getUserData();

      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<SpecialtyModel>>> getSpecialties() async {
    try {
      final result = await homeRemoteData.getSpecialties();

      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<DoctorModel>>> geTopDoctors() async {
    try {
      final result = await homeRemoteData.getTopDoctors();
      return ApiResult.sucess(result);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<List<DoctorModel>>> getSpecialtiesDoctors(
      int specialtyId) async {
    try {
      final result = await homeRemoteData.getSpecialtiesDoctors(specialtyId);
      return ApiResult.sucess(result);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<DoctorModel>> getDoctorId(String id) async {
    try {
      final result = await homeRemoteData.getDoctorById(id);
      return ApiResult.sucess(result);
    } catch (error) {
      log("Error fetching doctor by ID: $id - $error");
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<DoctorModel>>> fetchAllDoctors() async {
    try {
      final result = await homeRemoteData.getTopDoctors();
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<DoctorModel>>> searchDoctor(search) async {
    try {
      final result = await homeRemoteData.searchDoctor(search);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<DoctorModel>>> getDoctorSpecialist(
      int specialtyId) async {
    try {
      final result = await homeRemoteData.getSpecialtiesDoctors(specialtyId);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
