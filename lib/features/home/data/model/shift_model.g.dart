// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftModel _$ShiftModelFromJson(Map<String, dynamic> json) => ShiftModel(
      id: (json['id'] as num).toInt(),
      morningStart: json['morning_start'] as String?,
      morningEnd: json['morning_end'] as String?,
      eveningStart: json['evening_start'] as String?,
      eveningEnd: json['evening_end'] as String?,
    );

Map<String, dynamic> _$ShiftModelToJson(ShiftModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'morning_start': instance.morningStart,
      'morning_end': instance.morningEnd,
      'evening_start': instance.eveningStart,
      'evening_end': instance.eveningEnd,
    };
