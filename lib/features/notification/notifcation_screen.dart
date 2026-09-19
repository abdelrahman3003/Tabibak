import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/appointment/presentation/view/screens/appointment_details_screen.dart';
import 'package:tabibak/features/notification/data/model/notification_model.dart';
import 'package:tabibak/features/notification/presentation/manager/notification_provider/notification_provider.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationProviderNotifier);
    final notifier = ref.read(notificationProviderNotifier.notifier);
    final all = state.notifications ?? [];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBG,
      appBar: _buildAppBar(context),
      body: _buildBody(
        context: context,
        isLoading: state.isLoading && all.isEmpty,
        error: state.errorMessage,
        notifications: all,
        onRetry: notifier.fetchNotifications,
        onRefresh: notifier.fetchNotifications,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.scaffoldBG,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.textDark,
          size: 20,
        ),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(
        'Notifications'.tr(),
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required bool isLoading,
    required String? error,
    required List<NotificationModel> notifications,
    required VoidCallback onRetry,
    required Future<void> Function() onRefresh,
  }) {
    if (isLoading) {
      return _buildShimmer();
    }

    if (error != null && notifications.isEmpty) {
      return _buildErrorState(error, onRetry);
    }

    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 4.h,
        ),
        itemCount: notifications.length,
        itemBuilder: (_, i) {
          final notification = notifications[i];

          return _NotificationTile(
            notification: notification,
            onTap: () => _handleNotificationTap(
              context,
              notification,
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleNotificationTap(
    BuildContext context,
    NotificationModel notification,
  ) async {
    if (notification.type != AppNotificationType.appointment) {
      return;
    }

    final appointmentId = int.tryParse(
      '${notification.data['appointment_id']}',
    );

    if (appointmentId == null) {
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final response =
          await Supabase.instance.client.from('appointments').select('''
            *,
            doctors(*, clinic_data(*)),
            shifts_morning(*),
            shift_evening(*),
            appointment_types(*),
            appointments_status(*)
          ''').eq('id', appointmentId).maybeSingle();

      if (!context.mounted) return;

      Navigator.of(context).pop();

      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Appointment not found'.tr(),
              style: const TextStyle(
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        );
        return;
      }

      final appointment = AppointmentModel.fromJson(
        Map<String, dynamic>.from(response),
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AppointmentDetailsScreen(
            appointmentId: appointment.id!,
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Something went wrong'.tr(),
            style: const TextStyle(
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      );
    }
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 4.h,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const _NotificationShimmer(),
    );
  }

  Widget _buildErrorState(
    String error,
    VoidCallback onRetry,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              error,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: onRetry,
            child: Text('Retry'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 48.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'No notifications'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
              fontFamily: 'Tajawal',
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Empty notifications message'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.subtextColor,
              fontFamily: 'Tajawal',
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: notification.isRead
            ? Colors.white
            : AppColors.primary.withValues(alpha: 0.05),
        borderRadius: AppRadius.radius16,
        border: Border.all(
          color: notification.isRead
              ? AppColors.borderLight
              : AppColors.primary.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.radius16,
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildContent(),
                ),
                SizedBox(width: 8.w),
                Text(
                  _relativeTime(
                    context,
                    notification.createdAt,
                  ),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.subtextColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final initials = _initials(notification.title);

    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
    );
  }

  String _initials(String title) {
    final words =
        title.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

    if (words.isEmpty) return '•';

    if (words.length == 1) {
      final word = words.first;
      return word.length >= 2 ? word.substring(0, 2) : word;
    }

    return '${words[0].substring(0, 1)}${words[1].substring(0, 1)}';
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notification.title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
            fontFamily: 'Tajawal',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          notification.message,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.subtextColor,
            fontFamily: 'Tajawal',
            height: 1.5,
          ),
        ),
      ],
    );
  }

  String _relativeTime(
    BuildContext context,
    DateTime date,
  ) {
    final locale = context.locale.languageCode;
    final diff = DateTime.now().toUtc().difference(
          date.toUtc(),
        );

    final ar = locale == 'ar';

    if (diff.inMinutes < 1) {
      return ar ? 'الآن' : 'now';
    }

    if (diff.inMinutes < 60) {
      return ar ? 'منذ ${diff.inMinutes} د' : '${diff.inMinutes}m ago';
    }

    if (diff.inHours < 24) {
      return ar ? 'منذ ${diff.inHours} س' : '${diff.inHours}h ago';
    }

    if (diff.inDays < 7) {
      return ar ? 'منذ ${diff.inDays} يوم' : '${diff.inDays}d ago';
    }

    return DateFormat(
      'dd/MM/yyyy',
      locale,
    ).format(date);
  }
}

class _NotificationShimmer extends StatelessWidget {
  const _NotificationShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.radius16,
        border: Border.all(
          color: AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.scaffoldBG,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBG,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBG,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
