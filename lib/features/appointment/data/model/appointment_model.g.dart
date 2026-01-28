// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) =>
    AppointmentModel(
      id: (json['id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      appointmentDate: json['appointment_date'] as String?,
      shiftMorningId: (json['shift_morning_id'] as num?)?.toInt(),
      shiftEveningId: (json['shift_evening_id'] as num?)?.toInt(),
      doctorId: json['doctor_id'] as String?,
      userId: json['user_id'] as String?,
      status: (json['status'] as num?)?.toInt(),
      phone: json['phone'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      users: json['users'] == null
          ? null
          : UserModel.fromJson(json['users'] as Map<String, dynamic>),
      appointmentsStatus: json['appointments_status'] == null
          ? null
          : AppointmentStatusModel.fromJson(
              json['appointments_status'] as Map<String, dynamic>),
      doctor: json['doctors'] == null
          ? null
          : DoctorModel.fromJson(json['doctors'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'appointment_date': instance.appointmentDate,
      'doctors': instance.doctor?.toJson(),
      'doctor_id': instance.doctorId,
      'user_id': instance.userId,
      'status': instance.status,
      'shift_morning_id': instance.shiftMorningId,
      'shift_evening_id': instance.shiftEveningId,
      'phone': instance.phone,
      'name': instance.name,
      'description': instance.description,
      'users': instance.users?.toJson(),
      'appointments_status': instance.appointmentsStatus?.toJson(),
    };
