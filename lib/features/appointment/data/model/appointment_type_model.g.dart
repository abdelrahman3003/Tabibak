// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentTypeModel _$AppointmentTypeModelFromJson(
        Map<String, dynamic> json) =>
    AppointmentTypeModel(
      id: (json['id'] as num).toInt(),
      appointmentTypeAr: json['appointment_type_ar'] as String?,
      appointmentTypeEn: json['appointment_type_en'] as String?,
    );

Map<String, dynamic> _$AppointmentTypeModelToJson(
        AppointmentTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appointment_type_ar': instance.appointmentTypeAr,
      'appointment_type_en': instance.appointmentTypeEn,
    };
