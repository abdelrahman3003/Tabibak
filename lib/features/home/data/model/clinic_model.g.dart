// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClinicModel _$ClinicModelFromJson(Map<String, dynamic> json) => ClinicModel(
      id: (json['id'] as num?)?.toInt(),
      doctorId: json['doctorId'] as String?,
      isBooking: json['doctor_id'] as bool?,
      clinicName: json['clinic_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      consultationFee: (json['consultation_fee'] as num?)?.toInt(),
      clinicAddressModel: json['clinic_address'] == null
          ? null
          : ClinicAddressModel.fromJson(
              json['clinic_address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClinicModelToJson(ClinicModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'doctorId': instance.doctorId,
      'doctor_id': instance.isBooking,
      'clinic_name': instance.clinicName,
      'phone_number': instance.phoneNumber,
      'consultation_fee': instance.consultationFee,
      'clinic_address': instance.clinicAddressModel,
    };

ClinicAddressModel _$ClinicAddressModelFromJson(Map<String, dynamic> json) =>
    ClinicAddressModel(
      id: (json['id'] as num?)?.toInt(),
      clinicId: (json['clinic_id'] as num?)?.toInt(),
      address: json['address'] as String?,
    );

Map<String, dynamic> _$ClinicAddressModelToJson(ClinicAddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clinic_id': instance.clinicId,
      'address': instance.address,
    };
