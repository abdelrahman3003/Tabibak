import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/theme/app_colors.dart';

// ─────────────────────────────────────────────
// Data Models
// ─────────────────────────────────────────────

enum NotificationType { appointment, reminder, cancellation, result, promotion }

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final String time;
  final String? doctorName;
  final String? doctorSpecialty;
  final String? avatarInitials;
  final Color? avatarColor;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    this.doctorName,
    this.doctorSpecialty,
    this.avatarInitials,
    this.avatarColor,
    this.isRead = false,
  });
}

// ─────────────────────────────────────────────
// Notification Screen
// ─────────────────────────────────────────────

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<NotificationItem> _allNotifications = [
    NotificationItem(
      id: '1',
      type: NotificationType.reminder,
      title: 'تذكير بموعدك',
      body: 'لديك موعد مع د. أحمد السيد غداً الساعة 10:00 صباحاً',
      time: 'منذ 5 دقائق',
      doctorName: 'د. أحمد السيد',
      doctorSpecialty: 'طب القلب',
      avatarInitials: 'أس',
      avatarColor: AppColors.primary,
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      type: NotificationType.appointment,
      title: 'تأكيد الحجز',
      body: 'تم تأكيد حجزك في عيادة النور للأسنان بنجاح',
      time: 'منذ ساعة',
      doctorName: 'د. سارة محمود',
      doctorSpecialty: 'طب الأسنان',
      avatarInitials: 'سم',
      avatarColor: AppColors.green,
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      type: NotificationType.cancellation,
      title: 'إلغاء الموعد',
      body:
          'تم إلغاء موعدك مع د. خالد عمر بسبب ظرف طارئ. يمكنك إعادة الحجز الآن',
      time: 'منذ 3 ساعات',
      doctorName: 'د. خالد عمر',
      doctorSpecialty: 'الجراحة العامة',
      avatarInitials: 'خع',
      avatarColor: AppColors.orange,
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      type: NotificationType.result,
      title: 'نتائج التحاليل جاهزة',
      body: 'نتائج تحاليل الدم الخاصة بك أصبحت متاحة. اضغط لعرضها',
      time: 'أمس',
      avatarInitials: '🧪',
      avatarColor: AppColors.primaryLight30,
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      type: NotificationType.promotion,
      title: 'عرض خاص لك',
      body: 'احصل على خصم 20% على أول استشارة عبر الإنترنت مع أي طبيب',
      time: 'منذ يومين',
      avatarInitials: '🎁',
      avatarColor: AppColors.lightGreen,
      isRead: true,
    ),
    NotificationItem(
      id: '6',
      type: NotificationType.appointment,
      title: 'موعد جديد مضاف',
      body: 'تم إضافة موعد جديد مع د. منى حسن في عيادة الأطفال',
      time: 'منذ 3 أيام',
      doctorName: 'د. منى حسن',
      doctorSpecialty: 'طب الأطفال',
      avatarInitials: 'مح',
      avatarColor: Color(0xFF7B61FF),
      isRead: true,
    ),
  ];

  List<NotificationItem> get _unreadNotifications =>
      _allNotifications.where((n) => !n.isRead).toList();

  int get _unreadCount => _unreadNotifications.length;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _allNotifications) {
        n.isRead = true;
      }
    });
  }

  void _markAsRead(String id) {
    setState(() {
      _allNotifications.firstWhere((n) => n.id == id).isRead = true;
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      _allNotifications.removeWhere((n) => n.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBG,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildNotificationList(_allNotifications),
                  _buildNotificationList(_unreadNotifications),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
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
        'الإشعارات',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
          fontFamily: 'Tajawal',
        ),
      ),
      actions: [
        if (_unreadCount > 0)
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(
              'قراءة الكل',
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

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.second,
        borderRadius: AppRadius.radius12,
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: AppRadius.radius8,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.subtextColor,
        dividerColor: Colors.transparent,
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'Tajawal',
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          fontFamily: 'Tajawal',
        ),
        tabs: [
          Tab(text: 'الكل'),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('غير مقروءة'),
                if (_unreadCount > 0) ...[
                  SizedBox(width: 6.w),
                  _UnreadBadge(count: _unreadCount),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationItem> notifications) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    // Group by date label
    final today = <NotificationItem>[];
    final earlier = <NotificationItem>[];

    for (final n in notifications) {
      if (n.time.contains('دقيقة') ||
          n.time.contains('ساعة') ||
          n.time.contains('ساعات')) {
        today.add(n);
      } else {
        earlier.add(n);
      }
    }

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      children: [
        if (today.isNotEmpty) ...[
          _SectionHeader(title: 'اليوم'),
          ...today.map((n) => _buildDismissibleTile(n)),
        ],
        if (earlier.isNotEmpty) ...[
          _SectionHeader(title: 'سابقاً'),
          ...earlier.map((n) => _buildDismissibleTile(n)),
        ],
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildDismissibleTile(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.startToEnd,
      background: _buildDismissBackground(),
      onDismissed: (_) => _deleteNotification(notification.id),
      child: _NotificationTile(
        notification: notification,
        onTap: () => _markAsRead(notification.id),
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
      child: Icon(Icons.delete_outline_rounded, color: Colors.white, size: 26),
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
            decoration: BoxDecoration(
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
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
              fontFamily: 'Tajawal',
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'ستظهر هنا جميع الإشعارات المتعلقة\nبمواعيدك وعياداتك',
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
  final NotificationItem notification;
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
              color: Colors.black.withOpacity(0.04),
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
            _buildRightSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final bool isEmoji = notification.avatarInitials != null &&
        notification.avatarInitials!.length <= 2 &&
        !RegExp(r'^[\u0600-\u06FF]+$').hasMatch(notification.avatarInitials!);

    return Stack(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: (notification.avatarColor ?? AppColors.primary)
                .withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isEmoji
                ? Text(
                    notification.avatarInitials ?? '',
                    style: TextStyle(fontSize: 22.sp),
                  )
                : Text(
                    notification.avatarInitials ?? '',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: notification.avatarColor ?? AppColors.primary,
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
              color: _typeColor(),
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

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notification.title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
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
        if (notification.doctorName != null) ...[
          SizedBox(height: 8.h),
          _DoctorChip(
            name: notification.doctorName!,
            specialty: notification.doctorSpecialty!,
          ),
        ],
      ],
    );
  }

  Widget _buildRightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          notification.time,
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

  Color _typeColor() {
    switch (notification.type) {
      case NotificationType.appointment:
        return AppColors.primary;
      case NotificationType.reminder:
        return AppColors.orange;
      case NotificationType.cancellation:
        return AppColors.red;
      case NotificationType.result:
        return AppColors.green;
      case NotificationType.promotion:
        return AppColors.primaryLight30;
    }
  }

  IconData _typeIcon() {
    switch (notification.type) {
      case NotificationType.appointment:
        return Icons.calendar_today_rounded;
      case NotificationType.reminder:
        return Icons.access_time_rounded;
      case NotificationType.cancellation:
        return Icons.cancel_outlined;
      case NotificationType.result:
        return Icons.science_outlined;
      case NotificationType.promotion:
        return Icons.local_offer_outlined;
    }
  }
}

// ─────────────────────────────────────────────
// Supporting Widgets
// ─────────────────────────────────────────────

class _DoctorChip extends StatelessWidget {
  final String name;
  final String specialty;

  const _DoctorChip({required this.name, required this.specialty});

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
          Text(
            '$name • $specialty',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.primary,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 10.h, right: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.subtextColor,
          fontFamily: 'Tajawal',
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  final int count;

  const _UnreadBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        count.toString(),
        style: TextStyle(
          fontSize: 10.sp,
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }
}
