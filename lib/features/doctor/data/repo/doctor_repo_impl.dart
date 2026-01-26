import 'package:tabibak/core/networking/api_error_handler.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/doctor/data/remote_data/doctor_remote_data.dart';
import 'package:tabibak/features/doctor/data/repo/doctor_repo.dart';
import 'package:tabibak/features/home/data/model/comment_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

class DoctorRepoImpl implements DoctorRepo {
  final DoctorRemoteData doctorRemoteData;

  DoctorRepoImpl({required this.doctorRemoteData});

  @override
  Future<ApiResult<DoctorModel>> getDoctor(String doctorId) async {
    try {
      final result = await doctorRemoteData.getDoctor(doctorId);

      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<CommentModel>>> addComment(
      CommentModel commentModel) async {
    try {
      final result =
          await doctorRemoteData.addComment(commentModel: commentModel);

      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
