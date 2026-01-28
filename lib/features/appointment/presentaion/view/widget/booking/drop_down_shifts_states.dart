import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/function/formate_date.dart';
import 'package:tabibak/core/widgets/app_drop_dowm.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_provider.dart';
import 'package:tabibak/features/home/data/model/day_shift_model.dart';
import 'package:tabibak/features/home/data/model/shift_model.dart';

final dateStateController =
    StateProvider<TextEditingController>((ref) => TextEditingController());

class DropDownShiftsStates extends ConsumerWidget {
  final Function({int? shiftMorningId, int? shiftEveningId})? onSelected;

  const DropDownShiftsStates({super.key, this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayShiftsModel = ref.watch(
      appointmentBookingNotifierProvider
          .select((state) => state.dayShiftsModel),
    );
    final dateController = ref.watch(dateStateController.notifier).state;

    final shiftMap = _buildShiftMap(dayShiftsModel);
    final selectedShiftKey = _resolveSelectedKey(shiftMap, dayShiftsModel);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDropdown<String>(
          hint: "Select Shift",
          items: shiftMap.keys.toList(),
          value: selectedShiftKey,
          labelBuilder: (item) => item,
          validator: (item) =>
              item == null || item.isEmpty ? "Please select a shift" : null,
          onChanged: (value) {
            if (value == null) return;

            final id = shiftMap[value];
            if (id == null) return;

            final isMorning = value.startsWith('Morning');

            onSelected?.call(
              shiftMorningId: isMorning ? id : null,
              shiftEveningId: isMorning ? null : id,
            );
          },
        ),
        10.hBox,
        if (dateController.text.isNotEmpty &&
            dayShiftsModel?.morning == null &&
            dayShiftsModel?.morning == null)
          Text("Note: Available shifts depend on the selected date",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.red)),
      ],
    );
  }
}

Map<String, int> _buildShiftMap(DayShiftsModel? model) {
  final map = <String, int>{};

  final morning = model?.morning;
  if (morning?.start != null && morning?.end != null) {
    map[_shiftLabel('Morning', morning!)] = morning.id;
  }

  final evening = model?.evening;
  if (evening?.start != null && evening?.end != null) {
    map[_shiftLabel('Evening', evening!)] = evening.id;
  }

  return map;
}

String _shiftLabel(String title, ShiftModel shift) {
  return '$title ${formatTime(shift.start!)} - ${formatTime(shift.end!)}';
}

String? _resolveSelectedKey(
  Map<String, int> shiftMap,
  DayShiftsModel? model,
) {
  final selectedId = model?.morning?.id ?? model?.evening?.id;
  if (selectedId == null) return null;

  return shiftMap.entries
      .firstWhere(
        (e) => e.value == selectedId,
        orElse: () => const MapEntry('', 0),
      )
      .key;
}
