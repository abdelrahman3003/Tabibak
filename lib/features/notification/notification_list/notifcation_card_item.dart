import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotifcationCardItem extends StatelessWidget {
  const NotifcationCardItem(
      {super.key,
      required this.title,
      required this.message,
      required this.time});
  final String title;
  final String message;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      margin: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // خلفية فاتحة للإشعار
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.notifications, color: Color(0xFF7B61FF)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        subtitle: Text(
          message,
          style: TextStyle(fontSize: 14.sp),
        ),
        trailing: Text(
          time,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
      ),
    );
  }
}
