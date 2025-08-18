import 'package:image_picker/image_picker.dart';
import 'package:tabibak/core/networking/api_error_handler.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/profile/data/profile_remote_data_source.dart';
import 'package:tabibak/features/profile/domain/repo/profile_repo.dart';

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

  @override
  Future<ApiResult<void>> updateProfileImage(String imageUrl) async {
    try {
      final result = await profileRemoteDataSource.updateProfileImage(imageUrl);

      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<String>> uploadProfileImage(XFile file) async {
    try {
      final result = await profileRemoteDataSource.uploadProfileImage(file);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
