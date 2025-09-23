import 'package:flutter/material.dart';
import 'package:tabibak/core/theme/app_colors.dart';

enum AppointmentStatusEnum { pending, accepted, completed, cancelled, unknown }

extension AppointmentStatusX on AppointmentStatusEnum {
  static AppointmentStatusEnum fromString(String? status) {
    switch (status?.toLowerCase()) {
      case "pending":
        return AppointmentStatusEnum.pending;
      case "accepted":
        return AppointmentStatusEnum.accepted;
      case "completed":
        return AppointmentStatusEnum.completed;
      case "cancelled":
        return AppointmentStatusEnum.cancelled;
      default:
        return AppointmentStatusEnum.unknown;
    }
  }

  String get label {
    switch (this) {
      case AppointmentStatusEnum.pending:
        return "Pending";
      case AppointmentStatusEnum.accepted:
        return "Accepted";
      case AppointmentStatusEnum.completed:
        return "Completed";
      case AppointmentStatusEnum.cancelled:
        return "Cancelled";
      case AppointmentStatusEnum.unknown:
        return "Unknown";
    }
  }

  Color get color {
    switch (this) {
      case AppointmentStatusEnum.pending:
        return AppColors.primary;
      case AppointmentStatusEnum.accepted:
        return Colors.green;
      case AppointmentStatusEnum.completed:
        return Colors.orange;
      case AppointmentStatusEnum.cancelled:
        return Colors.red;
      case AppointmentStatusEnum.unknown:
        return Colors.grey;
    }
  }
}
