// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
      name: json['name'] as String?,
      image: json['image'] as String?,
      specialty: json['specialty'] as String?,
      bio: json['bio'] as String?,
      rate: (json['rate'] as num?)?.toDouble(),
      universityData: json['universityData'] == null
          ? null
          : University.fromJson(json['universityData'] as Map<String, dynamic>),
      clinicData: json['clinic_data'] == null
          ? null
          : Clinic.fromJson(json['clinic_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'specialty': instance.specialty,
      'bio': instance.bio,
      'rate': instance.rate,
      'universityData': instance.universityData,
      'clinic_data': instance.clinicData,
    };

University _$UniversityFromJson(Map<String, dynamic> json) => University(
      name: json['name'] as String?,
      faculty: json['faculty'] as String?,
      graduationYear: (json['graduationYear'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UniversityToJson(University instance) =>
    <String, dynamic>{
      'name': instance.name,
      'faculty': instance.faculty,
      'graduationYear': instance.graduationYear,
    };

Clinic _$ClinicFromJson(Map<String, dynamic> json) => Clinic(
      address: json['address'] as String?,
      clinicName: json['clinicName'] as String?,
      phoneNumber: json['phoneNumber'] == null
          ? null
          : PhoneNumber.fromJson(json['phoneNumber'] as Map<String, dynamic>),
      consultationFee: (json['consultationFee'] as num?)?.toInt(),
      workingDay: json['workingDay'] == null
          ? null
          : WorkingDay.fromJson(json['workingDay'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClinicToJson(Clinic instance) => <String, dynamic>{
      'address': instance.address,
      'clinicName': instance.clinicName,
      'phoneNumber': instance.phoneNumber,
      'consultationFee': instance.consultationFee,
      'workingDay': instance.workingDay,
    };

PhoneNumber _$PhoneNumberFromJson(Map<String, dynamic> json) => PhoneNumber(
      number: (json['number'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PhoneNumberToJson(PhoneNumber instance) =>
    <String, dynamic>{
      'number': instance.number,
    };

WorkingDay _$WorkingDayFromJson(Map<String, dynamic> json) => WorkingDay(
      day: json['day'] as String?,
      time: (json['time'] as num?)?.toInt(),
      times: json['times'] == null
          ? null
          : TimeSlot.fromJson(json['times'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkingDayToJson(WorkingDay instance) =>
    <String, dynamic>{
      'day': instance.day,
      'time': instance.time,
      'times': instance.times,
    };

TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) => TimeSlot(
      start: json['start'] as String?,
      end: json['end'] as String?,
    );

Map<String, dynamic> _$TimeSlotToJson(TimeSlot instance) => <String, dynamic>{
      'start': instance.start,
      'end': instance.end,
    };
