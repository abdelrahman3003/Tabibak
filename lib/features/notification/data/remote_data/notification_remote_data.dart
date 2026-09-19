import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/features/notification/data/model/notification_model.dart';

class NotificationRemoteData {
  NotificationRemoteData({required this.supabase});

  final Supabase supabase;

  String get _userId {
    final user = supabase.client.auth.currentUser;
    if (user == null) {
      throw const AuthException('User not logged in');
    }
    return user.id;
  }

  Future<List<NotificationModel>> getNotifications({
    int limit = 100,
  }) async {
    final response = await supabase.client
        .from('notifications')
        .select()
        .eq('user_id', _userId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map(
          (e) => NotificationModel.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<Map<String, dynamic>?> getAppointmentDetails(
    int appointmentId,
  ) async {
    final response = await supabase.client
        .from('appointments')
        .select()
        .eq('id', appointmentId)
        .maybeSingle();

    return response;
  }

  Future<void> markAsRead(int notificationId) async {
    await supabase.client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId)
        .eq('user_id', _userId);
  }

  Future<void> markAllAsRead() async {
    await supabase.client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', _userId);
  }
}
