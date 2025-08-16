import 'package:tabibak/core/networking/api_error_handler.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/data_source/home_remote_data.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/doctor_summary.dart';
import 'package:tabibak/features/home/data/model/specialise_model.dart';
import 'package:tabibak/features/home/domain/repo/home_repo.dart';

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
  Future<ApiResult<List<SpecialiseModel>>> fetchSpecialties() async {
    try {
      final result = await homeRemoteData.fetchSpecialties();

      return ApiResult.sucess(result);
    } catch (error) {
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
}
