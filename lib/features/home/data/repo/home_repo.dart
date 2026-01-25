import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/model/comment_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/specialty_model.dart';

abstract class HomeRepo {
  Future<ApiResult<List<SpecialtyModel>>> fetchSpecialties();
  Future<ApiResult<UserModel>> getUserData();
  Future<ApiResult<List<DoctorModel>>> fetchAllDoctors();
  Future<ApiResult<List<DoctorModel>>> geTopDoctors();
  Future<ApiResult<DoctorModel>> getDoctorId(String id);
  Future<ApiResult<List<DoctorModel>>> searchDoctor(String search);

  Future<ApiResult<List<DoctorModel>>> getDoctorSpecialist(int specialtyId);
  Future<ApiResult<List<CommentModel>>> getDoctorComments(int doctorid);
  Future<ApiResult<void>> addComment(
      {required String comment, required int doctorId});
  Future<ApiResult<void>> addRate(
      {required double rate, required int doctorId});
}
