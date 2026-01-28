import 'package:tabibak/features/home/data/model/shift_model.dart';

class DayShiftsModel {
  final ShiftModel? morning;
  final ShiftModel? evening;

  DayShiftsModel({
    this.morning,
    this.evening,
  });

  factory DayShiftsModel.fromJson(Map<String, dynamic> json) {
    return DayShiftsModel(
      morning: json['shifts_morning'] != null
          ? ShiftModel.fromJson(json['shifts_morning'])
          : null,
      evening: json['shift_evening'] != null
          ? ShiftModel.fromJson(json['shift_evening'])
          : null,
    );
  }
}
