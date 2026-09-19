import 'package:tabibak/features/notification/data/model/notification_model.dart';

class NotificationStates {
  final List<NotificationModel>? notifications;
  final bool isLoading;
  final String? errorMessage;

  final Map<String, dynamic>? appointment;
  final bool isAppointmentLoading;

  NotificationStates({
    this.notifications,
    this.isLoading = false,
    this.errorMessage,
    this.appointment,
    this.isAppointmentLoading = false,
  });

  NotificationStates copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? errorMessage,
    Map<String, dynamic>? appointment,
    bool? isAppointmentLoading,
  }) {
    return NotificationStates(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? false,
      errorMessage: errorMessage,
      appointment: appointment ?? this.appointment,
      isAppointmentLoading: isAppointmentLoading ?? false,
    );
  }
}
