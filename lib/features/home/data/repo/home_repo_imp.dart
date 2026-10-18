import 'package:tabibak/core/networking/api_error_handler.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/data_source/home_remote_data.dart';
import 'package:tabibak/features/home/data/model/clinic_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/specialty_model.dart';
import 'package:tabibak/features/home/data/repo/home_repo.dart';
import 'package:tabibak/features/pharamcy/data/models/pharmacy_offer_model.dart';

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
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<DoctorModel>> getDoctorId(String id) async {
    try {
      final result = await homeRemoteData.getDoctorById(id);

      return ApiResult.sucess(result);
    } catch (error) {
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
  Future<ApiResult<List<DoctorModel>>> searchDoctor(String search,
      {int? specialtyId}) async {
    try {
      final result =
          await homeRemoteData.searchDoctor(search, specialtyId: specialtyId);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<DoctorModel>>> searchDoctorFiltered(String search,
      {int? specialtyId,
      int? governorateId,
      int? markazId,
      int? villageId}) async {
    try {
      return ApiResult.sucess(await homeRemoteData.searchDoctor(
        search,
        specialtyId: specialtyId,
        governorateId: governorateId,
        markazId: markazId,
        villageId: villageId,
      ));
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<DoctorModel>>> getDoctorSpecialist({
    int? specialtyId,
    String? sortBy,
    int? markazId,
    int? governorateId,
    int? villageId,
  }) async {
    try {
      final result = await homeRemoteData.getSpecialtyDoctors(
        sortBy: sortBy,
        specialtyId: specialtyId,
        markazId: markazId,
        governorateId: governorateId,
        villageId: villageId,
      );

      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<CityModel>>> getGovernorates({int? specialtyId}) async {
    try {
      final result =
          await homeRemoteData.getGovernorates(specialtyId: specialtyId);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<CityModel>>> getMarkazes(
      {int? governorateId, int? specialtyId}) async {
    try {
      final result = await homeRemoteData.getMarkazes(
        governorateId: governorateId,
        specialtyId: specialtyId,
      );
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<CityModel>>> getVillages(
      {int? markazId, int? specialtyId}) async {
    try {
      final result = await homeRemoteData.getVillages(
          markazId: markazId, specialtyId: specialtyId);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<PharmacyOfferModel>>> getOffers(
      {int? specialtyId, String? sortBy}) async {
    try {
      final result = await homeRemoteData.getAllOffers();
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
