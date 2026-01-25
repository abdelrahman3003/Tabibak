import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

abstract class DoctorRepo {
  Future<ApiResult<DoctorModel>> getDoctor(String doctorId);
}
