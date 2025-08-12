import 'package:tabibak/core/networking/api_result.dart';

abstract class ProfileRepo {
  Future<ApiResult<void>> signOut();
}
