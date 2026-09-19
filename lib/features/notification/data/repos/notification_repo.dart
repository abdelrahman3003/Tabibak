import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/notification/data/model/notification_model.dart';

abstract class NotificationRepo {
  Future<ApiResult<List<NotificationModel>>> getNotifications();

  Future<ApiResult<Map<String, dynamic>?>> getAppointmentDetails(
    int appointmentId,
  );

  Future<ApiResult<void>> markAsRead(int notificationId);

  Future<ApiResult<void>> markAllAsRead();
}
