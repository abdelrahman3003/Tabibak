// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentStatusModel _$AppointmentStatusModelFromJson(
        Map<String, dynamic> json) =>
    AppointmentStatusModel(
      id: (json['id'] as num).toInt(),
      statusAr: json['status_ar'] as String?,
      statusEn: json['status_en'] as String?,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$AppointmentStatusModelToJson(
        AppointmentStatusModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status_ar': instance.statusAr,
      'status_en': instance.statusEn,
      'created_at': instance.createdAt,
    };
