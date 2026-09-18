import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/notification/data/model/notification_model.dart';

abstract class NotificationRepo {
  Future<ApiResult<List<NotificationModel>>> getNotifications();
  Future<ApiResult<int>> getUnreadCount();
  Future<ApiResult<void>> markAsRead(int id);
  Future<ApiResult<void>> markAllAsRead();
  Future<ApiResult<void>> deleteNotification(int id);
  RealtimeChannel subscribeToNotifications(
    void Function(NotificationModel) onInsert,
  );
}
