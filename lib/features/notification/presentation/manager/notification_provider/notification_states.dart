import 'package:tabibak/features/notification/data/model/notification_model.dart';

class NotificationStates {
  final List<NotificationModel>? notifications;
  final bool isLoading;
  final String? errorMessage;

  final Map<String, dynamic>? appointment;
  final bool isAppointmentLoading;
  final bool badgeSeen;

  NotificationStates({
    this.notifications,
    this.isLoading = false,
    this.errorMessage,
    this.appointment,
    this.isAppointmentLoading = false,
    this.badgeSeen = false,
  });

  /// The badge number shown on the notification bell icon.
  /// If the user has opened/seen the notification list, badge is 0 (like Facebook),
  /// but each notification item still retains its [isRead] status.
  int get badgeCount =>
      badgeSeen ? 0 : (notifications?.where((n) => !n.isRead).length ?? 0);

  int get unreadCount =>
      notifications?.where((n) => !n.isRead).length ?? 0;

  NotificationStates copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? errorMessage,
    Map<String, dynamic>? appointment,
    bool? isAppointmentLoading,
    bool? badgeSeen,
  }) {
    return NotificationStates(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? false,
      errorMessage: errorMessage,
      appointment: appointment ?? this.appointment,
      isAppointmentLoading: isAppointmentLoading ?? false,
      badgeSeen: badgeSeen ?? this.badgeSeen,
    );
  }
}
