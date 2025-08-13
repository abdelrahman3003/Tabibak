import 'package:tabibak/core/networking/api_error_handler.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/data_source/home_remote_data.dart';
import 'package:tabibak/features/home/data/model/get_specialite_response.dart';
import 'package:tabibak/features/home/domain/repo/home_repo.dart';

class HomeRepoImp extends HomeRepo {
  final HomeRemoteData homeRemoteData;

  HomeRepoImp({required this.homeRemoteData});
  @override
  Future<ApiResult<GetSpecialiteResponse>> fetchSpecialties() async {
    try {
      final result = await homeRemoteData.fetchSpecialties();
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<UserModel>> getUserData() async {
    try {
      final result = await homeRemoteData.fetchUserById();

      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
