// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorServiceModel _$DoctorServiceModelFromJson(Map<String, dynamic> json) =>
    DoctorServiceModel(
      id: (json['id'] as num?)?.toInt(),
      doctorId: json['doctor_id'] as String?,
      clinicId: (json['clinic_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      nameAr: json['name_ar'] as String?,
      nameEn: json['name_en'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$DoctorServiceModelToJson(DoctorServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'doctor_id': instance.doctorId,
      'clinic_id': instance.clinicId,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'name_en': instance.nameEn,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
