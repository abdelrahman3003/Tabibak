import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/doctor_summary.dart';
import 'package:tabibak/features/home/data/model/specialise_model.dart';

abstract class HomeRepo {
  Future<ApiResult<List<SpecialiseModel>>> fetchSpecialties();
  Future<ApiResult<UserModel>> getUserData();
  Future<ApiResult<List<DoctorModel>>> fetchAllDoctors();
  Future<ApiResult<List<DoctorSummary>>> getAllDoctorsSummary();
  Future<ApiResult<DoctorModel>> getDoctorId(int id);
  Future<ApiResult<List<DoctorSummary>>> getAllDoctorsSpecialties(
      int specialtyId);
  Future<ApiResult<List<Comment>>> getDoctorComments(int doctorid);
  Future<ApiResult<void>> addComment(
      {required String comment, required int doctorId});
  Future<ApiResult<void>> addRate(
      {required double rate, required int doctorId});
}
