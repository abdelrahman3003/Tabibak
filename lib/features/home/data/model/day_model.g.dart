// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayModel _$DayModelFromJson(Map<String, dynamic> json) => DayModel(
      id: (json['id'] as num).toInt(),
      dayAr: json['day_ar'] as String?,
      dayEn: json['day_en'] as String?,
    );

Map<String, dynamic> _$DayModelToJson(DayModel instance) => <String, dynamic>{
      'id': instance.id,
      'day_ar': instance.dayAr,
      'day_en': instance.dayEn,
    };
