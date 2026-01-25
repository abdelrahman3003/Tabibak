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
      specialty: json['specialties'] == null
          ? null
          : SpecialtyModel.fromJson(
              json['specialties'] as Map<String, dynamic>),
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
      'clinic_data': instance.clinicData,
      'specialties': instance.specialty,
    };

ClinicDataSummary _$ClinicDataSummaryFromJson(Map<String, dynamic> json) =>
    ClinicDataSummary(
      clinicAddress: json['clinic_address'] == null
          ? null
          : ClinicAddressModel.fromJson(
              json['clinic_address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClinicDataSummaryToJson(ClinicDataSummary instance) =>
    <String, dynamic>{
      'clinic_address': instance.clinicAddress,
    };

ClinicAddressModel _$ClinicAddressModelFromJson(Map<String, dynamic> json) =>
    ClinicAddressModel(
      address: json['address'] as String?,
    );

Map<String, dynamic> _$ClinicAddressModelToJson(ClinicAddressModel instance) =>
    <String, dynamic>{
      'address': instance.address,
    };
