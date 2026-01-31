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
