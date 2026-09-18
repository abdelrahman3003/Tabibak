import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/notification/data/model/notification_model.dart';
import 'package:tabibak/features/notification/presentation/manager/notification_provider/notification_provider.dart';

// ─────────────────────────────────────────────
// Notification Screen (real data via Supabase)
// ─────────────────────────────────────────────

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  bool _handledInitialArgs = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_handledInitialArgs) return;
    _handledInitialArgs = true;
    // Only when opened from a push/local notification tap (notification_id
    // present) mark THAT specific notification as read. Opening the screen
    // normally never changes unread state.
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['notification_id'] != null) {
      final id = int.tryParse(args['notification_id'].toString());
      if (id != null) {
        Future.microtask(
          () => ref
              .read(notificationProviderNotifier.notifier)
              .markAsRead(id),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationProviderNotifier);
    final notifier = ref.read(notificationProviderNotifier.notifier);
    final all = state.notifications ?? [];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBG,
      appBar: _buildAppBar(
        unreadCount: state.unreadCount,
        onMarkAll: all.isEmpty ? null : notifier.markAllAsRead,
      ),
      body: _buildBody(
        isLoading: state.isLoading && all.isEmpty,
        error: state.errorMessage,
        notifications: all,
        onRetry: notifier.fetchNotifications,
        onRefresh: notifier.fetchNotifications,
        onTap: (n) => notifier.markAsRead(n.id),
        onDelete: (n) => notifier.deleteNotification(n.id),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar({
    required int unreadCount,
    required VoidCallback? onMarkAll,
  }) {
    return AppBar(
      backgroundColor: AppColors.scaffoldBG,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded,
            color: AppColors.textDark, size: 20),
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
      actions: [
        if (unreadCount > 0)
          TextButton(
            onPressed: onMarkAll,
            child: Text(
              'Mark all read'.tr(),
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.primary,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody({
    required bool isLoading,
    required String? error,
    required List<NotificationModel> notifications,
    required VoidCallback onRetry,
    required Future<void> Function() onRefresh,
    required void Function(NotificationModel) onTap,
    required void Function(NotificationModel) onDelete,
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
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        children: _buildNotificationTiles(notifications, onTap, onDelete),
      ),
    );
  }

  List<Widget> _buildNotificationTiles(
      List<NotificationModel> notifications,
      void Function(NotificationModel) onTap,
      void Function(NotificationModel) onDelete,
      ) {
    final tiles = <Widget>[];

    for (final n in notifications) {
      tiles.add(_buildDismissibleTile(n, onTap, onDelete));
    }

    return tiles;
  }

  Dismissible _buildDismissibleTile(
      NotificationModel notification,
      void Function(NotificationModel) onTap,
      void Function(NotificationModel) onDelete,
      ) {
    return Dismissible(
      key: ValueKey('notif-${notification.id}'),
      direction: DismissDirection.startToEnd,
      background: _buildDismissBackground(),
      onDismissed: (_) => onDelete(notification),
      child: _NotificationTile(
        notification: notification,
        onTap: () => onTap(notification),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: AppColors.red,
        borderRadius: AppRadius.radius16,
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20.w),
      child: const Icon(Icons.delete_outline_rounded,
          color: Colors.white, size: 26),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      itemCount: 6,
      itemBuilder: (_, __) => const _NotificationShimmer(),
    );
  }

  Widget _buildErrorState(String error, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error, textAlign: TextAlign.center),
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

// ─────────────────────────────────────────────
// Notification Tile
// ─────────────────────────────────────────────

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : AppColors.primaryLight,
          borderRadius: AppRadius.radius16,
          border: Border.all(
            color: notification.isRead
                ? AppColors.borderLight
                : AppColors.primaryLight30,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(),
            SizedBox(width: 12.w),
            Expanded(child: _buildContent()),
            SizedBox(width: 8.w),
            _buildRightSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final initials = _initials(notification.title);
    final color = _typeColor();
    return Stack(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: color,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            width: 18.w,
            height: 18.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(
              _typeIcon(),
              size: 9.sp,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  String _initials(String title) {
    final words =
        title.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '•';
    if (words.length == 1) {
      final w = words.first;
      return w.length >= 2 ? w.substring(0, 2) : w;
    }
    return '${words[0].substring(0, 1)}${words[1].substring(0, 1)}';
  }

  Widget _buildContent() {
    final doctorName = notification.data['doctor_name']?.toString();
    final appointmentId = notification.data['appointment_id']?.toString();
    final subtitle = doctorName ??
        (appointmentId != null
            ? '${'Appointment'.tr()} #$appointmentId'
            : null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notification.title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight:
                notification.isRead ? FontWeight.w500 : FontWeight.w700,
            color: AppColors.textDark,
            fontFamily: 'Tajawal',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          notification.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.subtextColor,
            fontFamily: 'Tajawal',
            height: 1.5,
          ),
        ),
        if (subtitle != null)...[
          SizedBox(height: 8.h),
          _MetaChip(text: subtitle),
        ],
      ],
    );
  }

  Widget _buildRightSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _relativeTime(context, notification.createdAt),
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.subtextColor,
            fontFamily: 'Tajawal',
          ),
        ),
        SizedBox(height: 6.h),
        if (!notification.isRead)
          Container(
            width: 8.w,
            height: 8.w,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  String _relativeTime(BuildContext context, DateTime date) {
    final locale = context.locale.languageCode;
    final diff = DateTime.now().difference(date);
    final ar = locale == 'ar';
    if (diff.inMinutes < 1) return ar ? 'الآن' : 'now';
    if (diff.inMinutes < 60) {
      return ar ? 'منذ ${diff.inMinutes} د' : '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return ar ? 'منذ ${diff.inHours} س' : '${diff.inHours}h ago';
    }
    if (diff.inDays < 7) {
      return ar ? 'منذ ${diff.inDays} يوم' : '${diff.inDays}d ago';
    }
    return DateFormat('dd/MM/yyyy', locale).format(date);
  }

  Color _typeColor() {
    switch (notification.type) {
      case AppNotificationType.appointment:
        return AppColors.primary;
      case AppNotificationType.reminder:
        return AppColors.orange;
      case AppNotificationType.cancellation:
        return AppColors.red;
      case AppNotificationType.result:
        return AppColors.green;
      case AppNotificationType.promotion:
        return AppColors.primaryLight30;
      case AppNotificationType.general:
        return AppColors.primary;
    }
  }

  IconData _typeIcon() {
    switch (notification.type) {
      case AppNotificationType.appointment:
        return Icons.calendar_today_rounded;
      case AppNotificationType.reminder:
        return Icons.access_time_rounded;
      case AppNotificationType.cancellation:
        return Icons.cancel_outlined;
      case AppNotificationType.result:
        return Icons.science_outlined;
      case AppNotificationType.promotion:
        return Icons.local_offer_outlined;
      case AppNotificationType.general:
        return Icons.notifications_outlined;
    }
  }
}

// ─────────────────────────────────────────────
// Supporting Widgets
// ─────────────────────────────────────────────

class _MetaChip extends StatelessWidget {
  final String text;

  const _MetaChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBG,
        borderRadius: AppRadius.radius8,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_outline_rounded,
              size: 13.sp, color: AppColors.primary),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.primary,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
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
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
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