// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentStatusModel _$AppointmentStatusModelFromJson(
        Map<String, dynamic> json) =>
    AppointmentStatusModel(
      id: (json['id'] as num).toInt(),
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$AppointmentStatusModelToJson(
        AppointmentStatusModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'created_at': instance.createdAt,
    };
