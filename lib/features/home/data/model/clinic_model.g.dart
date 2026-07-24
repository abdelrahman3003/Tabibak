// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClinicModel _$ClinicModelFromJson(Map<String, dynamic> json) => ClinicModel(
      id: (json['id'] as num?)?.toInt(),
      doctorId: json['doctor_id'] as String?,
      isBooking: json['is_booking'] as bool?,
      isAvailable: json['is_available'] as bool?,
      clinicName: json['clinic_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      consultationFee: (json['consultation_fee'] as num?)?.toInt(),
      clinicAddresses: (json['clinic_address'] as List<dynamic>?)
          ?.map((e) => ClinicAddressModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      workingDays: (json['working_day'] as List<dynamic>?)
          ?.map((e) => WorkingDay.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ClinicModelToJson(ClinicModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'doctor_id': instance.doctorId,
      'is_booking': instance.isBooking,
      'is_available': instance.isAvailable,
      'clinic_name': instance.clinicName,
      'phone_number': instance.phoneNumber,
      'consultation_fee': instance.consultationFee,
      'clinic_address': instance.clinicAddresses,
      'working_day': instance.workingDays,
    };

ClinicAddressModel _$ClinicAddressModelFromJson(Map<String, dynamic> json) =>
    ClinicAddressModel(
      id: (json['id'] as num?)?.toInt(),
      clinicId: (json['clinic_id'] as num?)?.toInt(),
      cityId: (json['city_id'] as num?)?.toInt(),
      city: json['city'] == null
          ? null
          : CityModel.fromJson(json['city'] as Map<String, dynamic>),
      floor: json['floor'] as String?,
      street: json['street'] as String?,
      department: json['department'] as String?,
    );

Map<String, dynamic> _$ClinicAddressModelToJson(ClinicAddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clinic_id': instance.clinicId,
      'city_id': instance.cityId,
      'city': instance.city,
      'floor': instance.floor,
      'street': instance.street,
      'department': instance.department,
    };

CityModel _$CityModelFromJson(Map<String, dynamic> json) => CityModel(
      id: (json['id'] as num?)?.toInt(),
      nameAr: json['name_ar'] as String?,
      nameEn: json['name_en'] as String?,
    );

Map<String, dynamic> _$CityModelToJson(CityModel instance) => <String, dynamic>{
      'id': instance.id,
      'name_ar': instance.nameAr,
      'name_en': instance.nameEn,
    };
