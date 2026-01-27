import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/function/formate_date.dart';
import 'package:tabibak/core/widgets/app_drop_dowm.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_provider.dart';
import 'package:tabibak/features/home/data/model/shift_model.dart';

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
          items: state.shiftModel == null
              ? []
              : _getShiftMap(state.shiftModel!)!.keys.toList(),
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

Map<String, int>? _getShiftMap(ShiftModel shift) {
  final map = <String, int>{};

  if (shift.morningStart != null && shift.morningEnd != null) {
    map['Morning ${formatTime(shift.morningStart!)} - ${formatTime(shift.morningEnd!)}'] =
        shift.id;
  }

  if (shift.eveningStart != null && shift.eveningEnd != null) {
    map['Evening ${formatTime(shift.eveningStart!)} - ${formatTime(shift.eveningEnd!)}'] =
        shift.id;
  }

  return map;
}
