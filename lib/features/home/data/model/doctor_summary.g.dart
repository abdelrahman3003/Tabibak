// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorSummary _$DoctorSummaryFromJson(Map<String, dynamic> json) =>
    DoctorSummary(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      image: json['image'] as String?,
      specialty: json['specialty'] as String?,
      clinicData: json['clinic_data'] == null
          ? null
          : ClinicDataSummary.fromJson(
              json['clinic_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DoctorSummaryToJson(DoctorSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'specialty': instance.specialty,
      'clinic_data': instance.clinicData,
    };

ClinicDataSummary _$ClinicDataSummaryFromJson(Map<String, dynamic> json) =>
    ClinicDataSummary(
      address: json['address'] as String?,
    );

Map<String, dynamic> _$ClinicDataSummaryToJson(ClinicDataSummary instance) =>
    <String, dynamic>{
      'address': instance.address,
    };
