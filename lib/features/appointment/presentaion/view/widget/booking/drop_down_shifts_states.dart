import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/function/formate_date.dart';
import 'package:tabibak/core/widgets/app_drop_dowm.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_provider.dart';
import 'package:tabibak/features/home/data/model/day_shift_model.dart';

class DropDownShiftsStates extends StatelessWidget {
  const DropDownShiftsStates({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(appointmentBookingNotifierProvider);
        String? selectedShift;
        return AppDropdown<String>(
          hint: "Select Doctor",
          items: state.dayShiftsModel == null
              ? []
              : _getShiftMap(state.dayShiftsModel!)!.keys.toList(),
          value: selectedShift,
          labelBuilder: (item) => item,
          validator: (item) => item == null ? "Please select a shift" : null,
          onChanged: (value) {
            selectedShift = value;
          },
        );
      },
    );
  }
}

Map<String, int>? _getShiftMap(DayShiftsModel dayShiftsModel) {
  final map = <String, int>{};

  if (dayShiftsModel.morning?.start != null &&
      dayShiftsModel.morning?.end != null) {
    map['Morning ${formatTime(dayShiftsModel.morning!.start!)} - ${formatTime(dayShiftsModel.morning!.end!)}'] =
        dayShiftsModel.morning!.id;
  }

  if (dayShiftsModel.evening?.start != null &&
      dayShiftsModel.evening?.end != null) {
    map['Evening ${formatTime(dayShiftsModel.evening!.start!)} - ${formatTime(dayShiftsModel.evening!.end!)}'] =
        dayShiftsModel.evening!.id;
  }

  return map;
}
