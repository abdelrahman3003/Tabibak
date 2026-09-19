import 'package:tabibak/core/networking/api_error_model.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/notification/data/model/notification_model.dart';
import 'package:tabibak/features/notification/data/remote_data/notification_remote_data.dart';
import 'package:tabibak/features/notification/data/repos/notification_repo.dart';

class NotificationRepoImp implements NotificationRepo {
  NotificationRepoImp({required this.remoteData});

  final NotificationRemoteData remoteData;

  @override
  Future<ApiResult<List<NotificationModel>>> getNotifications() async {
    try {
      final notifications = await remoteData.getNotifications();

      return ApiResult.sucess(notifications);
    } catch (e) {
      return ApiResult.failure(
        ApiErrorModel(message: e.toString()),
      );
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>?>> getAppointmentDetails(
    int appointmentId,
  ) async {
    try {
      final appointment = await remoteData.getAppointmentDetails(
        appointmentId,
      );

      return ApiResult.sucess(appointment);
    } catch (e) {
      return ApiResult.failure(
        ApiErrorModel(message: e.toString()),
      );
    }
  }
}
