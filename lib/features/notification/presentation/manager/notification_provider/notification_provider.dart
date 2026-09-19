import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/core/services/push_notification_service.dart';
import 'package:tabibak/features/notification/data/model/notification_model.dart';
import 'package:tabibak/features/notification/data/remote_data/notification_remote_data.dart';
import 'package:tabibak/features/notification/data/repos/notification_repo.dart';
import 'package:tabibak/features/notification/data/repos/notification_repo_imp.dart';
import 'package:tabibak/features/notification/presentation/manager/notification_provider/notification_states.dart';

final notificationRepoProvider = Provider<NotificationRepo>((ref) {
  try {
    return getIt<NotificationRepo>();
  } catch (_) {
    return NotificationRepoImp(
      remoteData: NotificationRemoteData(
        supabase: Supabase.instance,
      ),
    );
  }
});

final notificationProviderNotifier =
    StateNotifierProvider.autoDispose<NotificationProvider, NotificationStates>(
  (ref) => NotificationProvider(
    ref.watch(notificationRepoProvider),
  ),
);

final class NotificationProvider extends StateNotifier<NotificationStates> {
  NotificationProvider(this._repo) : super(NotificationStates()) {
    fetchNotifications();
    _setupRealtime();
    _setupForegroundMessageListener();
  }

  final NotificationRepo _repo;
  RealtimeChannel? _realtimeChannel;
  StreamSubscription? _fgSubscription;

  void _setupForegroundMessageListener() {
    _fgSubscription = PushNotificationService.foregroundMessages.stream.listen((_) {
      fetchNotifications();
    });
  }

  void _setupRealtime() {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      _realtimeChannel = Supabase.instance.client
          .channel('public:notifications:${user.id}')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'notifications',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'user_id',
              value: user.id,
            ),
            callback: (payload) {
              final eventType = payload.eventType;
              final newRecord = payload.newRecord;
              final oldRecord = payload.oldRecord;

              final currentList = List<NotificationModel>.from(state.notifications ?? []);

              if (eventType == PostgresChangeEvent.insert) {
                if (newRecord.isNotEmpty) {
                  final newNotif = NotificationModel.fromJson(newRecord);
                  currentList.removeWhere((n) => n.id == newNotif.id);
                  currentList.insert(0, newNotif);
                  // New notification arrived -> reset badgeSeen so badge increases
                  state = state.copyWith(
                    notifications: currentList,
                    badgeSeen: false,
                  );
                }
              } else if (eventType == PostgresChangeEvent.update) {
                if (newRecord.isNotEmpty) {
                  final updatedNotif = NotificationModel.fromJson(newRecord);
                  final index = currentList.indexWhere((n) => n.id == updatedNotif.id);
                  if (index != -1) {
                    currentList[index] = updatedNotif;
                  } else {
                    currentList.insert(0, updatedNotif);
                  }
                  state = state.copyWith(notifications: currentList);
                }
              } else if (eventType == PostgresChangeEvent.delete) {
                final oldId = oldRecord['id'];
                if (oldId != null) {
                  currentList.removeWhere((n) => n.id.toString() == oldId.toString());
                  state = state.copyWith(notifications: currentList);
                }
              }
            },
          )
          .subscribe();
    } catch (_) {}
  }

  Future<void> fetchNotifications() async {
    state = state.copyWith(isLoading: true);

    final result = await _repo.getNotifications();

    result.when(
      sucess: (notifications) {
        state = state.copyWith(
          notifications: notifications,
          isLoading: false,
          errorMessage: null,
        );
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.message,
        );
      },
    );
  }

  Future<void> markAsRead(int notificationId) async {
    final currentList = List<NotificationModel>.from(state.notifications ?? []);
    final index = currentList.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      currentList[index] = currentList[index].copyWith(isRead: true);
      state = state.copyWith(notifications: currentList);
    }

    await _repo.markAsRead(notificationId);
  }

  void clearBadge() {
    state = state.copyWith(badgeSeen: true);
  }

  Future<void> markAllAsRead() async {
    final currentList = (state.notifications ?? [])
        .map((n) => n.copyWith(isRead: true))
        .toList();
    state = state.copyWith(notifications: currentList);

    await _repo.markAllAsRead();
  }

  Future<void> getAppointmentDetails(
    int appointmentId,
  ) async {
    state = state.copyWith(
      isAppointmentLoading: true,
      errorMessage: null,
    );

    final result = await _repo.getAppointmentDetails(
      appointmentId,
    );

    result.when(
      sucess: (appointment) {
        state = state.copyWith(
          appointment: appointment,
          isAppointmentLoading: false,
        );
      },
      failure: (error) {
        state = state.copyWith(
          isAppointmentLoading: false,
          errorMessage: error.message,
        );
      },
    );
  }

  @override
  void dispose() {
    _fgSubscription?.cancel();
    _realtimeChannel?.unsubscribe();
    super.dispose();
  }
}
