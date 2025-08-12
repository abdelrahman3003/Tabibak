import 'package:tabibak/core/networking/api_error_handler.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/profile/data/profile_remote_data_source.dart';
import 'package:tabibak/features/profile/domain/profile_repo.dart';

class ProfileRepoImp extends ProfileRepo {
  final ProfileRemoteDataSource profileRemoteDataSource;

  ProfileRepoImp({required this.profileRemoteDataSource});
  @override
  Future<ApiResult<void>> signOut() async {
    try {
      final result = await profileRemoteDataSource.signOut();
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
