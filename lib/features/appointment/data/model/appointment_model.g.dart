// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
      userId: json['user_id'] as String,
      appointmentTime: json['appointment_time'] as String,
      appointmentDate: json['appointment_date'] as String,
      doctor: DoctorModel.fromJson(json['doctors'] as Map<String, dynamic>),
      appointmentStatus: AppointmentStatus.fromJson(
          json['appointments_status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'appointment_time': instance.appointmentTime,
      'appointment_date': instance.appointmentDate,
      'doctors': instance.doctor.toJson(),
      'appointments_status': instance.appointmentStatus.toJson(),
    };

AppointmentStatus _$AppointmentStatusFromJson(Map<String, dynamic> json) =>
    AppointmentStatus(
      status: json['status'] as String,
    );

Map<String, dynamic> _$AppointmentStatusToJson(AppointmentStatus instance) =>
    <String, dynamic>{
      'status': instance.status,
    };
