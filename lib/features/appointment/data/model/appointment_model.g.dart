// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
      id: (json['id'] as num).toInt(),
      appointmentTime: json['appointment_time'] as String?,
      appointmentDate: json['appointment_date'] == null
          ? null
          : DateTime.parse(json['appointment_date'] as String),
      doctor: json['doctors'] == null
          ? null
          : DoctorModel.fromJson(json['doctors'] as Map<String, dynamic>),
      appointmentStatus: json['appointments_status'] == null
          ? null
          : AppointmentStatus.fromJson(
              json['appointments_status'] as Map<String, dynamic>),
      createDate: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createDate?.toIso8601String(),
      'appointment_time': instance.appointmentTime,
      'appointment_date': instance.appointmentDate?.toIso8601String(),
      'doctors': instance.doctor?.toJson(),
      'appointments_status': instance.appointmentStatus?.toJson(),
    };

AppointmentStatus _$AppointmentStatusFromJson(Map<String, dynamic> json) =>
    AppointmentStatus(
      status: json['status'] as String,
    );

Map<String, dynamic> _$AppointmentStatusToJson(AppointmentStatus instance) =>
    <String, dynamic>{
      'status': instance.status,
    };
