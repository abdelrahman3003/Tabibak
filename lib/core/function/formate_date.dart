import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

String? formatTime(String? time) {
  if (time == null || time.isEmpty) return null;

  final parts = time.split(':');
  if (parts.length < 2) return null;

  final hour24 = int.parse(parts[0]);
  final minute = int.parse(parts[1]);

  final period = hour24 >= 12 ? "PM" : "AM";
  final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;

  return "${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
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
