import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/features/notification/notification_list/notifcation_card_item.dart';

class NotificationListView extends StatelessWidget {
  const NotificationListView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NotificationItem> notifications = [
      NotificationItem(
        title: "موعد جديد",
        message: "لديك موعد مع الدكتور أحمد الساعة 5 مساءً",
        time: "12:30 م",
      ),
      NotificationItem(
        title: "تذكير دواء",
        message: "لا تنس تناول دوائك الساعة 8 صباحًا",
        time: "8:00 ص",
      ),
      NotificationItem(
        title: "تنبيه متابعة",
        message: "نتائج تحاليلك جاهزة للعرض",
        time: "10:15 ص",
      ),
    ];
    return ListView.builder(
      padding: EdgeInsets.all(12.w),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final item = notifications[index];
        return NotifcationCardItem(
            title: item.title, message: item.message, time: item.time);
      },
    );
  }
}

class NotificationItem {
  final String title;
  final String message;
  final String time;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
  });
}
