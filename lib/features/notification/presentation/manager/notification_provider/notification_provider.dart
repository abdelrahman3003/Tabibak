import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/features/notification/data/model/notification_model.dart';
import 'package:tabibak/features/notification/data/remote_data/notification_remote_data.dart';
import 'package:tabibak/features/notification/data/repos/notification_repo.dart';
import 'package:tabibak/features/notification/data/repos/notification_repo_imp.dart';
import 'package:tabibak/features/notification/presentation/manager/notification_provider/notification_states.dart';

final notificationRepoProvider = Provider<NotificationRepo>((ref) {
  // Prefer the service locator when available, fall back to a direct instance
  // so the provider works even before DI is initialized (e.g. in tests).
  try {
    return getIt<NotificationRepo>();
  } catch (_) {
    return NotificationRepoImp(
      remoteData: NotificationRemoteData(supabase: Supabase.instance),
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
    _subscribe();
  }

  final NotificationRepo _repo;
  RealtimeChannel? _channel;

  Future<void> fetchNotifications() async {
    state = state.copyWith(isLoading: true);
    final result = await _repo.getNotifications();
    result.when(
      sucess: (notifications) {
        final unread = notifications.where((n) => !n.isRead).length;
        state = state.copyWith(
          notifications: notifications,
          unreadCount: unread,
          isLoading: false,
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

  Future<void> refreshUnreadCount() async {
    final result = await _repo.getUnreadCount();
    result.when(
      sucess: (count) => state = state.copyWith(unreadCount: count),
      failure: (_) {},
    );
  }

  void _subscribe() {
    try {
      _channel = _repo.subscribeToNotifications((incoming) {
        final current = [...?state.notifications];
        // Avoid duplicates when the same insert arrives twice.
        if (current.any((n) => n.id == incoming.id)) return;
        current.insert(0, incoming);
        state = state.copyWith(
          notifications: current,
          unreadCount: state.unreadCount + (incoming.isRead ? 0 : 1),
        );
      });
    } catch (_) {
      // Realtime is best-effort; list still works via fetch.
    }
  }

  /// Called from FCM foreground handler as a fallback when realtime is
  /// momentarily disconnected.
  void handleRemoteInsert(NotificationModel incoming) {
    final current = [...?state.notifications];
    if (current.any((n) => n.id == incoming.id)) return;
    current.insert(0, incoming);
    state = state.copyWith(
      notifications: current,
      unreadCount: state.unreadCount + (incoming.isRead ? 0 : 1),
    );
  }

  Future<void> markAsRead(int id) async {
    // Optimistic update.
    final current = [...?state.notifications];
    final index = current.indexWhere((n) => n.id == id);
    bool wasUnread = false;
    if (index != -1 && !current[index].isRead) {
      wasUnread = true;
      current[index] = current[index].copyWith(isRead: true);
      state = state.copyWith(
        notifications: current,
        unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
      );
    }
    final result = await _repo.markAsRead(id);
    result.when(
      sucess: (_) {},
      failure: (_) {
        // Roll back on failure.
        if (wasUnread && index != -1) {
          final rolledBack = [...?state.notifications];
          rolledBack[index] =
              rolledBack[index].copyWith(isRead: false);
          state = state.copyWith(
            notifications: rolledBack,
            unreadCount: state.unreadCount + 1,
          );
        }
      },
    );
  }

  Future<void> markAllAsRead() async {
    final previous = [...?state.notifications];
    state = state.copyWith(
      notifications: previous.map((n) => n.copyWith(isRead: true)).toList(),
      unreadCount: 0,
    );
    final result = await _repo.markAllAsRead();
    result.when(
      sucess: (_) {},
      failure: (_) {
        state = state.copyWith(notifications: previous);
        refreshUnreadCount();
      },
    );
  }

  Future<void> deleteNotification(int id) async {
    final previous = [...?state.notifications];
    final removed = previous.where((n) => n.id == id).toList();
    final wasUnread = removed.isNotEmpty && !removed.first.isRead;
    state = state.copyWith(
      notifications: previous.where((n) => n.id != id).toList(),
      unreadCount:
          wasUnread && state.unreadCount > 0 ? state.unreadCount - 1 : state.unreadCount,
    );
    final result = await _repo.deleteNotification(id);
    result.when(
      sucess: (_) {},
      failure: (_) => state = state.copyWith(notifications: previous),
    );
  }

  @override
  void dispose() {
    try {
      _channel?.unsubscribe();
    } catch (_) {}
    super.dispose();
  }
}
