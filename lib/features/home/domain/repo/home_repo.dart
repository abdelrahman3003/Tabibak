import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/model/get_specialite_response.dart';

abstract class HomeRepo {
  Future<ApiResult<GetSpecialiteResponse>> fetchSpecialties();
  Future<ApiResult<UserModel>> getUserData();
}
