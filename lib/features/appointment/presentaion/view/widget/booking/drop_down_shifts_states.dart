import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/function/formate_date.dart';
import 'package:tabibak/core/widgets/app_drop_dowm.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_provider.dart';
import 'package:tabibak/features/home/data/model/day_shift_model.dart';

class DropDownShiftsStates extends ConsumerWidget {
  final Function({int? shiftMorningId, int? shiftEveningId})? onSelected;

  const DropDownShiftsStates({super.key, this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appointmentBookingNotifierProvider);
    final dayShiftsModel = state.dayShiftsModel;
    final shiftMap = _getShiftMap(dayShiftsModel)!;

    String? selectedShiftKey;
    if (dayShiftsModel?.morning?.id != null) {
      selectedShiftKey = shiftMap.entries
          .firstWhere((e) => e.value == dayShiftsModel!.morning!.id,
              orElse: () => const MapEntry('', 0))
          .key;
    } else if (dayShiftsModel?.evening?.id != null) {
      selectedShiftKey = shiftMap.entries
          .firstWhere((e) => e.value == dayShiftsModel!.evening!.id,
              orElse: () => const MapEntry('', 0))
          .key;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDropdown<String>(
          hint: "Select Shift",
          items: shiftMap.keys.toList(),
          value: selectedShiftKey != '' ? selectedShiftKey : null,
          labelBuilder: (item) => item,
          validator: (item) =>
              item == null || item.isEmpty ? "Please select a shift" : null,
          onChanged: (value) {
            final id = shiftMap[value];
            if (id != null) {
              final isMorning = value!.startsWith('Morning');
              onSelected?.call(
                shiftMorningId: isMorning ? id : null,
                shiftEveningId: isMorning ? null : id,
              );
              debugPrint('Selected Shift ID: $id, isMorning: $isMorning');
            }
          },
        ),
      ],
    );
  }
}

Map<String, int>? _getShiftMap(DayShiftsModel? dayShiftsModel) {
  final map = <String, int>{};

  if (dayShiftsModel?.morning?.start != null &&
      dayShiftsModel?.morning?.end != null) {
    map['Morning ${formatTime(dayShiftsModel!.morning!.start!)} - ${formatTime(dayShiftsModel.morning!.end!)}'] =
        dayShiftsModel.morning!.id;
  }

  if (dayShiftsModel?.evening?.start != null &&
      dayShiftsModel?.evening?.end != null) {
    map['Evening ${formatTime(dayShiftsModel!.evening!.start!)} - ${formatTime(dayShiftsModel.evening!.end!)}'] =
        dayShiftsModel.evening!.id;
  }

  return map;
}
