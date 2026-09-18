import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_error_handler.dart';
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
      final result = await remoteData.getNotifications();
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<int>> getUnreadCount() async {
    try {
      final result = await remoteData.getUnreadCount();
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<void>> markAsRead(int id) async {
    try {
      final result = await remoteData.markAsRead(id);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<void>> markAllAsRead() async {
    try {
      final result = await remoteData.markAllAsRead();
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<void>> deleteNotification(int id) async {
    try {
      final result = await remoteData.deleteNotification(id);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  RealtimeChannel subscribeToNotifications(
    void Function(NotificationModel) onInsert,
  ) {
    return remoteData.subscribeToNotifications(onInsert);
  }
}
