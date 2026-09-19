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
      appointmentTime: json['appointment_time'] as String?,
      doctor: json['doctors'] == null
          ? null
          : DoctorModel.fromJson(json['doctors'] as Map<String, dynamic>),
      clinic: json['clinic_data'] == null
          ? null
          : ClinicModel.fromJson(json['clinic_data'] as Map<String, dynamic>),
      doctorId: json['doctor_id'] as String?,
      userId: json['user_id'] as String?,
      status: (json['status'] as num?)?.toInt(),
      shiftMorningId: (json['appointment_morning_shift_id'] as num?)?.toInt(),
      shiftEveningId: (json['appointment_evening_shift_id'] as num?)?.toInt(),
      shiftMorning: json['shifts_morning'] == null
          ? null
          : ShiftModel.fromJson(json['shifts_morning'] as Map<String, dynamic>),
      shiftEvening: json['shift_evening'] == null
          ? null
          : ShiftModel.fromJson(json['shift_evening'] as Map<String, dynamic>),
      phone: json['phone'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      fcmToken: json['fcm_token'] as String?,
      users: json['users'] == null
          ? null
          : UserModel.fromJson(json['users'] as Map<String, dynamic>),
      appointmentTypeId: (json['appointment_type'] as num?)?.toInt(),
      appointmentTypeModel: json['appointment_types'] == null
          ? null
          : AppointmentTypeModel.fromJson(
              json['appointment_types'] as Map<String, dynamic>),
      appointmentsStatus: json['appointments_status'] == null
          ? null
          : AppointmentStatusModel.fromJson(
              json['appointments_status'] as Map<String, dynamic>),
      followUpDate: json['follow_up_date'] == null
          ? null
          : DateTime.parse(json['follow_up_date'] as String),
      queueNumber: (json['queue_number'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'appointment_date': instance.appointmentDate,
      'appointment_time': instance.appointmentTime,
      'doctors': instance.doctor?.toJson(),
      'clinic_data': instance.clinic?.toJson(),
      'doctor_id': instance.doctorId,
      'user_id': instance.userId,
      'status': instance.status,
      'appointment_morning_shift_id': instance.shiftMorningId,
      'appointment_evening_shift_id': instance.shiftEveningId,
      'shifts_morning': instance.shiftMorning?.toJson(),
      'shift_evening': instance.shiftEvening?.toJson(),
      'phone': instance.phone,
      'name': instance.name,
      'description': instance.description,
      'fcm_token': instance.fcmToken,
      'users': instance.users?.toJson(),
      'appointment_type': instance.appointmentTypeId,
      'appointment_types': instance.appointmentTypeModel?.toJson(),
      'appointments_status': instance.appointmentsStatus?.toJson(),
      'follow_up_date': instance.followUpDate?.toIso8601String(),
      'queue_number': instance.queueNumber,
    };
