// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) =>
    AppointmentModel(
      id: (json['id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      appointmentDate: json['appointment_date'] as String,
      appointmentShift: (json['appointment_shift'] as num).toInt(),
      phone: json['phone'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      users: UserModel.fromJson(json['users'] as Map<String, dynamic>),
      appointmentsStatus: AppointmentStatusModel.fromJson(
          json['appointments_status'] as Map<String, dynamic>),
      doctor: DoctorModel.fromJson(json['doctors'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'appointment_date': instance.appointmentDate,
      'doctors': instance.doctor.toJson(),
      'appointment_shift': instance.appointmentShift,
      'phone': instance.phone,
      'name': instance.name,
      'description': instance.description,
      'users': instance.users.toJson(),
      'appointments_status': instance.appointmentsStatus.toJson(),
    };
