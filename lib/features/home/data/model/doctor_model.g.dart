// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      image: json['image'] as String?,
      bio: json['bio'] as String?,
      rate: (json['rate'] as num?)?.toDouble(),
      universityData: json['university_data'] == null
          ? null
          : University.fromJson(
              json['university_data'] as Map<String, dynamic>),
      clinicData: json['clinic_data'] == null
          ? null
          : Clinic.fromJson(json['clinic_data'] as Map<String, dynamic>),
      specialties: json['specialties'] == null
          ? null
          : Specialties.fromJson(json['specialties'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'bio': instance.bio,
      'rate': instance.rate,
      'university_data': instance.universityData,
      'clinic_data': instance.clinicData,
      'specialties': instance.specialties,
    };

University _$UniversityFromJson(Map<String, dynamic> json) => University(
      name: json['name'] as String?,
      faculty: json['faculty'] as String?,
      graduationYear: (json['graduation_year'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UniversityToJson(University instance) =>
    <String, dynamic>{
      'name': instance.name,
      'faculty': instance.faculty,
      'graduation_year': instance.graduationYear,
    };

Clinic _$ClinicFromJson(Map<String, dynamic> json) => Clinic(
      address: json['address'] as String?,
      clinicName: json['clinic_name'] as String?,
      phoneNumber: (json['phone_number'] as num?)?.toInt(),
      consultationFee: (json['consultation_fee'] as num?)?.toInt(),
      clinicWorkingDay: (json['clinic_working_day'] as List<dynamic>?)
          ?.map((e) => ClinicWorkingDay.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ClinicToJson(Clinic instance) => <String, dynamic>{
      'address': instance.address,
      'clinic_name': instance.clinicName,
      'phone_number': instance.phoneNumber,
      'consultation_fee': instance.consultationFee,
      'clinic_working_day': instance.clinicWorkingDay,
    };

ClinicWorkingDay _$ClinicWorkingDayFromJson(Map<String, dynamic> json) =>
    ClinicWorkingDay(
      workingDay: json['working_day'] == null
          ? null
          : WorkingDay.fromJson(json['working_day'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClinicWorkingDayToJson(ClinicWorkingDay instance) =>
    <String, dynamic>{
      'working_day': instance.workingDay,
    };

WorkingDay _$WorkingDayFromJson(Map<String, dynamic> json) => WorkingDay(
      days: json['days'] == null
          ? null
          : Days.fromJson(json['days'] as Map<String, dynamic>),
      times: json['times'] == null
          ? null
          : TimeSlot.fromJson(json['times'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkingDayToJson(WorkingDay instance) =>
    <String, dynamic>{
      'days': instance.days,
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

Days _$DaysFromJson(Map<String, dynamic> json) => Days(
      day: json['day'] as String?,
    );

Map<String, dynamic> _$DaysToJson(Days instance) => <String, dynamic>{
      'day': instance.day,
    };

Specialties _$SpecialtiesFromJson(Map<String, dynamic> json) => Specialties(
      name: json['name'] as String?,
    );

Map<String, dynamic> _$SpecialtiesToJson(Specialties instance) =>
    <String, dynamic>{
      'name': instance.name,
    };
