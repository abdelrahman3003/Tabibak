import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/specialty_model.dart';

abstract class HomeRepo {
  Future<ApiResult<UserModel>> getUserData();

  Future<ApiResult<List<SpecialtyModel>>> getSpecialties();
  Future<ApiResult<List<DoctorModel>>> geTopDoctors();
  Future<ApiResult<List<DoctorModel>>> getSpecialtiesDoctors(int specialtyId);
  Future<ApiResult<List<DoctorModel>>> fetchAllDoctors();
  Future<ApiResult<DoctorModel>> getDoctorId(String id);
  Future<ApiResult<List<DoctorModel>>> searchDoctor(String search);

  Future<ApiResult<List<DoctorModel>>> getDoctorSpecialist(int specialtyId);
}
