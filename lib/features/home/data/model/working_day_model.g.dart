// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'working_day_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkingDay _$WorkingDayFromJson(Map<String, dynamic> json) => WorkingDay(
      id: (json['id'] as num).toInt(),
      day: DayModel.fromJson(json['days'] as Map<String, dynamic>),
      dayId: (json['day_id'] as num?)?.toInt(),
      shiftMorning: json['shifts_morning'] == null
          ? null
          : ShiftModel.fromJson(json['shifts_morning'] as Map<String, dynamic>),
      shiftEvening: json['shift_evening'] == null
          ? null
          : ShiftModel.fromJson(json['shift_evening'] as Map<String, dynamic>),
      shiftId: (json['shift_id'] as num?)?.toInt(),
      clinicId: (json['clinic_id'] as num?)?.toInt(),
      isSelected: json['is_selected'] as bool?,
    );

Map<String, dynamic> _$WorkingDayToJson(WorkingDay instance) =>
    <String, dynamic>{
      'id': instance.id,
      'days': instance.day.toJson(),
      'day_id': instance.dayId,
      'shifts_morning': instance.shiftMorning?.toJson(),
      'shift_evening': instance.shiftEvening?.toJson(),
      'clinic_id': instance.clinicId,
      'shift_id': instance.shiftId,
      'is_selected': instance.isSelected,
    };
