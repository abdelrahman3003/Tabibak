import 'package:json_annotation/json_annotation.dart';
import 'package:tabibak/features/home/data/model/day_model.dart';
import 'package:tabibak/features/home/data/model/shift_model.dart';

part 'working_day_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkingDay {
  final int id;
  @JsonKey(name: 'days')
  final DayModel day;
  @JsonKey(name: 'day_id')
  final int? dayId;
  @JsonKey(name: 'shifts_morning')
  final ShiftModel? shiftMorning;
  @JsonKey(name: 'shift_evening')
  final ShiftModel? shiftEvening;
  @JsonKey(name: 'clinic_id')
  final int? clinicId;
  @JsonKey(name: 'shift_id')
  final int? shiftId;

  @JsonKey(name: 'is_selected')
  final bool? isSelected;

  WorkingDay({
    required this.id,
    required this.day,
    this.dayId,
    this.shiftMorning,
    this.shiftEvening,
    this.shiftId,
    this.clinicId,
    this.isSelected,
  });

  factory WorkingDay.fromJson(Map<String, dynamic> json) =>
      _$WorkingDayFromJson(json);
  Map<String, dynamic> toJson() => _$WorkingDayToJson(this);
}
