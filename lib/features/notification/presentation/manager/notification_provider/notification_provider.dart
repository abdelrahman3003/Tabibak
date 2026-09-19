import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
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
  }

  final NotificationRepo _repo;

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
}
