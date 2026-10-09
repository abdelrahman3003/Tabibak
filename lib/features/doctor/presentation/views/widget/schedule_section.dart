import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/function/formate_date.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/clinic_work_day_card.dart';
import 'package:tabibak/features/home/data/model/working_day_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/title_text.dart';

class ScheduleSection extends StatelessWidget {
  const ScheduleSection({super.key, this.workingDayList});
  final List<WorkingDay>? workingDayList;
  @override
  Widget build(BuildContext context) {
    final workingDays = _getCleanList(workingDayList);
    if (workingDays.isEmpty) return const SizedBox();

    final summary = _tryBuildSummary(workingDays, context);

    if (summary != null) {
      return Column(
        children: [
          30.hBox,
          TitleText(title: AppStrings.workingHours),
          10.hBox,
          summary,
        ],
      );
    }

    return Column(
      children: [
        30.hBox,
        TitleText(title: AppStrings.workingHours),
        10.hBox,
        Column(
            children: List.generate(
          workingDays.length,
          (index) => ClinicWorkDayCard(workingDay: workingDays[index]),
        )),
      ],
    );
  }
}

List<WorkingDay> _getCleanList(List<WorkingDay>? workingDayList) {
  List<WorkingDay> list = [];
  if (workingDayList == null) return [];
  for (var workday in workingDayList) {
    if (workday.isSelected!) {
      list.add(workday);
    }
  }
  return list;
}

/// Returns a formatted hours string for one WorkingDay, e.g. "09:00 AM - 05:00 PM".
/// Returns empty string if no shifts are present.
String _formatDayHours(WorkingDay day) {
  final parts = <String>[];

  final ms = day.shiftMorning;
  if (ms != null && _hasTime(ms.start) && _hasTime(ms.end)) {
    parts.add('${formatTime(ms.start)} - ${formatTime(ms.end)}');
  }

  final es = day.shiftEvening;
  if (es != null && _hasTime(es.start) && _hasTime(es.end)) {
    parts.add('${formatTime(es.start)} - ${formatTime(es.end)}');
  }

  return parts.join(' · ');
}

bool _hasTime(String? t) => t != null && t.trim().isNotEmpty;

/// Tries to build a single summary widget if all working days share the same
/// hours. Returns null when the fallback (individual cards) should be used.
Widget? _tryBuildSummary(List<WorkingDay> workingDays, BuildContext context) {
  // All 7 canonical day keys in calendar order.
  const allDayKeys = [
    'saturday',
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
  ];

  // Deduplicate by day name, keeping the first entry with non-empty hours.
  final dayHours = <String, String>{};
  for (final day in workingDays) {
    final key = (day.day.dayEn ?? '').trim().toLowerCase();
    if (key.isEmpty) continue;

    final hours = _formatDayHours(day);
    if (!dayHours.containsKey(key) || dayHours[key]!.isEmpty) {
      dayHours[key] = hours;
    }
  }

  // Only consider days that actually have hours.
  final openDays = Map.fromEntries(
    dayHours.entries.where((e) => e.value.isNotEmpty),
  );

  // Group open days by their hours string.
  final hoursToDays = <String, List<String>>{};
  for (final entry in openDays.entries) {
    hoursToDays.putIfAbsent(entry.value, () => []).add(entry.key);
  }

  // All open days must share the SAME hours to qualify for a summary.
  if (hoursToDays.length != 1) return null;

  final commonHours = hoursToDays.keys.first;
  final openDayKeys = hoursToDays.values.first.toSet();
  final missingDays =
      allDayKeys.where((d) => !openDayKeys.contains(d)).toList();

  // Rule 1: all 7 days open → "Open every day from X to Y"
  // Rule 2: 1 day off       → "Open every day except [Day] from X to Y"
  // Rule 3: 2 days off      → "Open every day except [D1] and [D2] from X to Y"
  // Otherwise (3+ days off) → return null to fall back to individual cards.
  if (missingDays.length > 2) return null;

  final locale = context.locale.languageCode;

  String localizedDay(String enKey) {
    if (locale == 'ar') {
      const map = {
        'saturday': 'السبت',
        'sunday': 'الأحد',
        'monday': 'الاثنين',
        'tuesday': 'الثلاثاء',
        'wednesday': 'الأربعاء',
        'thursday': 'الخميس',
        'friday': 'الجمعة',
      };
      return map[enKey] ?? enKey;
    }
    return '${enKey[0].toUpperCase()}${enKey.substring(1)}';
  }

  String text;
  if (missingDays.isEmpty) {
    text = '${'Open every day from'.tr()} $commonHours';
  } else if (missingDays.length == 1) {
    final off = localizedDay(missingDays[0]);
    text = '${'Open every day except'.tr()} $off ${'from'.tr()} $commonHours';
  } else {
    final off1 = localizedDay(missingDays[0]);
    final off2 = localizedDay(missingDays[1]);
    text =
        '${'Open every day except'.tr()} $off1 ${'and'.tr()} $off2 ${'from'.tr()} $commonHours';
  }

  final theme = Theme.of(context);
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: theme.brightness == Brightness.dark
          ? theme.cardColor.withAlpha(5)
          : const Color(0xffEDF2F7),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: theme.brightness == Brightness.dark
            ? Colors.white.withAlpha(1)
            : const Color(0xffE2E8F0),
        width: 1,
      ),
    ),
    child: Row(
      children: [
        Icon(Icons.schedule, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
