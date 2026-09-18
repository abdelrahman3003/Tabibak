import 'package:tabibak/features/notification/data/model/notification_model.dart';

class NotificationStates {
  final List<NotificationModel>? notifications;
  final bool isLoading;
  final String? errorMessage;
  final int unreadCount;

  NotificationStates({
    this.notifications,
    this.isLoading = false,
    this.errorMessage,
    this.unreadCount = 0,
  });

  List<NotificationModel> get unread =>
      (notifications ?? []).where((n) => !n.isRead).toList();

  NotificationStates copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? errorMessage,
    int? unreadCount,
  }) {
    return NotificationStates(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? false,
      errorMessage: errorMessage ?? this.errorMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
