enum AppNotificationType {
  appointment,
  reminder,
  cancellation,
  result,
  promotion,
  general;

  static AppNotificationType fromString(String? value) {
    switch (value) {
      case 'appointment':
        return AppNotificationType.appointment;
      case 'reminder':
        return AppNotificationType.reminder;
      case 'cancellation':
        return AppNotificationType.cancellation;
      case 'result':
        return AppNotificationType.result;
      case 'promotion':
        return AppNotificationType.promotion;
      default:
        return AppNotificationType.general;
    }
  }

  String get value => name;
}

class NotificationModel {
  final int id;
  final String userId;
  final String title;
  final String body;
  final AppNotificationType type;
  final Map<String, dynamic> data;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.data,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: (json['id'] as num).toInt(),
      userId: json['user_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      type: AppNotificationType.fromString(json['type'] as String?),
      data: (json['data'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), v),
          ) ??
          const {},
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'body': body,
      'type': type.value,
      'data': data,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      userId: userId,
      title: title,
      body: body,
      type: type,
      data: data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}
