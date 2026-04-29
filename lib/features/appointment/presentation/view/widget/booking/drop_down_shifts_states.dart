import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/widgets/app_drop_dowm.dart';
import 'package:tabibak/features/appointment/presentation/manager/appointment_booking_provider/appointment_booking_provider.dart';
import 'package:tabibak/features/home/data/model/day_shift_model.dart';

class DropDownShiftsStates extends ConsumerStatefulWidget {
  final Function({int? shiftMorningId, int? shiftEveningId})? onSelected;

  const DropDownShiftsStates({super.key, this.onSelected});

  @override
  ConsumerState<DropDownShiftsStates> createState() =>
      _DropDownShiftsStatesState();
}

class _DropDownShiftsStatesState extends ConsumerState<DropDownShiftsStates> {
  String? _selectedValue; // only field needed

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentBookingNotifierProvider);
    final shiftMap = _buildShiftMap(state.dayShiftsModel);

    ref.listen(
      appointmentBookingNotifierProvider.select((s) => s.dayShiftsModel),
      (previous, next) {
        // ✅ fires correctly now because dayShiftsModel is truly null when cleared
        setState(() => _selectedValue = null);
        widget.onSelected?.call(shiftMorningId: null, shiftEveningId: null);
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDropdown<String>(
          hint: AppStrings.selectPeriod,
          items: shiftMap.keys.toList(),
          value: shiftMap.containsKey(_selectedValue) ? _selectedValue : null,
          labelBuilder: (item) => item == 'morning'
              ? AppStrings.morningShift
              : AppStrings.eveningShift,
          onChanged: (value) {
            if (value == null) return;
            final id = shiftMap[value];
            if (id == null) return;
            setState(() => _selectedValue = value);
            final isMorning = value == 'morning';
            widget.onSelected?.call(
              shiftMorningId: isMorning ? id : null,
              shiftEveningId: isMorning ? null : id,
            );
          },
        ),
        if (state.emptyShift != null)
          Text(
            state.emptyShift!,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Colors.red),
          ),
      ],
    );
  }
}

Map<String, int> _buildShiftMap(DayShiftsModel? model) {
  final map = <String, int>{};

  final morning = model?.morning;
  if (morning?.start != null && morning?.end != null) {
    map['morning'] = morning!.id;
  }

  final evening = model?.evening;
  if (evening?.start != null && evening?.end != null) {
    map['evening'] = evening!.id;
  }

  return map;
}
