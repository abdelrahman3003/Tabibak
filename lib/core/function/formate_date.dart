import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

String formatTime(String? time) {
  if (time == null || time.isEmpty) return "";

  final parts = time.split(':');
  if (parts.length < 2) return "";

  final hour = parts[0].padLeft(2, '0');
  final minute = parts[1].padLeft(2, '0');

  return "$hour:$minute";
}

TimeOfDay? parseTime(String? time) {
  if (time == null) return null;
  final parts = time.split(':');
  return TimeOfDay(
    hour: int.parse(parts[0]),
    minute: int.parse(parts[1]),
  );
}

String formatDayMonth(String date) {
  final dateTime = DateTime.parse(date);
  return DateFormat('dd/MM').format(dateTime);
}

String timeAgo(String? isoTime) {
  if (isoTime == null || isoTime.isEmpty) return "";

  final dateTime = DateTime.parse(isoTime).toLocal();
  final now = DateTime.now();

  final diff = now.difference(dateTime);

  if (diff.inSeconds < 60) {
    return "منذ ثوانٍ";
  } else if (diff.inMinutes < 60) {
    return "منذ ${diff.inMinutes} دقيقة";
  } else if (diff.inHours < 24) {
    return "منذ ${diff.inHours} ساعة";
  } else if (diff.inDays == 1) {
    return "منذ يوم";
  } else if (diff.inDays == 2) {
    return "منذ يومين";
  } else if (diff.inDays < 7) {
    return "منذ ${diff.inDays} أيام";
  } else if (diff.inDays < 30) {
    final weeks = (diff.inDays / 7).floor();
    return "منذ $weeks أسبوع";
  } else if (diff.inDays < 365) {
    final months = (diff.inDays / 30).floor();
    return "منذ $months شهر";
  } else {
    final years = (diff.inDays / 365).floor();
    return "منذ $years سنة";
  }
}
