// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetDoctorResponseModel _$GetDoctorResponseModelFromJson(
        Map<String, dynamic> json) =>
    GetDoctorResponseModel(
      name: json['name'] as String,
      image: json['image'] as String?,
      specialty: json['specialty'] as String?,
      bio: json['bio'] as String?,
      rate: (json['rate'] as num).toDouble(),
      universityData:
          University.fromJson(json['universityData'] as Map<String, dynamic>),
      clinicData: Clinic.fromJson(json['clinicData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetDoctorResponseModelToJson(
        GetDoctorResponseModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'specialty': instance.specialty,
      'bio': instance.bio,
      'rate': instance.rate,
      'universityData': instance.universityData,
      'clinicData': instance.clinicData,
    };

University _$UniversityFromJson(Map<String, dynamic> json) => University(
      name: json['name'] as String,
      faculty: json['faculty'] as String,
      graduationYear: (json['graduationYear'] as num).toInt(),
    );

Map<String, dynamic> _$UniversityToJson(University instance) =>
    <String, dynamic>{
      'name': instance.name,
      'faculty': instance.faculty,
      'graduationYear': instance.graduationYear,
    };

Clinic _$ClinicFromJson(Map<String, dynamic> json) => Clinic(
      address: json['address'] as String,
      clinicName: json['clinicName'] as String,
      phoneNumber:
          PhoneNumber.fromJson(json['phoneNumber'] as Map<String, dynamic>),
      consultationFee: (json['consultationFee'] as num).toInt(),
      workingDay:
          WorkingDay.fromJson(json['workingDay'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClinicToJson(Clinic instance) => <String, dynamic>{
      'address': instance.address,
      'clinicName': instance.clinicName,
      'phoneNumber': instance.phoneNumber,
      'consultationFee': instance.consultationFee,
      'workingDay': instance.workingDay,
    };

PhoneNumber _$PhoneNumberFromJson(Map<String, dynamic> json) => PhoneNumber(
      number: (json['number'] as num).toInt(),
    );

Map<String, dynamic> _$PhoneNumberToJson(PhoneNumber instance) =>
    <String, dynamic>{
      'number': instance.number,
    };

WorkingDay _$WorkingDayFromJson(Map<String, dynamic> json) => WorkingDay(
      day: json['day'] as String,
      time: (json['time'] as num).toInt(),
      times: TimeSlot.fromJson(json['times'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkingDayToJson(WorkingDay instance) =>
    <String, dynamic>{
      'day': instance.day,
      'time': instance.time,
      'times': instance.times,
    };

TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) => TimeSlot(
      start: json['start'] as String,
      end: json['end'] as String,
    );

Map<String, dynamic> _$TimeSlotToJson(TimeSlot instance) => <String, dynamic>{
      'start': instance.start,
      'end': instance.end,
    };
