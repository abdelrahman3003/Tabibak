import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_error_handler.dart';
import 'package:tabibak/core/networking/api_error_model.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:tabibak/features/profile/data/repo/profile_repo.dart';

class ProfileRepoImp extends ProfileRepo {
  final ProfileRemoteDataSource profileRemoteDataSource;

  ProfileRepoImp({required this.profileRemoteDataSource});

  @override
  Future<ApiResult<void>> updateProfileImage(String imageUrl) async {
    try {
      await profileRemoteDataSource.updateProfileImage(imageUrl);
      return ApiResult.sucess(null);
    } catch (error) {
      if (error is PostgrestException) {
        return ApiResult.failure(ApiErrorModel(message: error.message));
      }
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

  @override
  Future<ApiResult<void>> submitProblemReport({
    required String reportType,
    required String message,
  }) async {
    try {
      await profileRemoteDataSource.submitProblemReport(
        reportType: reportType,
        message: message,
      );
      return ApiResult.sucess(null);
    } catch (error) {
      if (error is PostgrestException) {
        return ApiResult.failure(ApiErrorModel(message: error.message));
      }
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
