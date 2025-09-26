// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentBody _$AppointmentBodyFromJson(Map<String, dynamic> json) =>
    AppointmentBody(
      doctorId: (json['doctor_id'] as num).toInt(),
      userId: json['user_id'] as String,
      appointmentTime: json['appointment_time'] as String,
      appointmentDate: DateTime.parse(json['appointment_date'] as String),
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$AppointmentBodyToJson(AppointmentBody instance) =>
    <String, dynamic>{
      'doctor_id': instance.doctorId,
      'user_id': instance.userId,
      'appointment_time': instance.appointmentTime,
      'appointment_date': instance.appointmentDate.toIso8601String(),
      'status': instance.status,
    };
