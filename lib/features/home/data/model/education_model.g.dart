// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EducationModel _$EducationModelFromJson(Map<String, dynamic> json) =>
    EducationModel(
      id: (json['id'] as num?)?.toInt(),
      doctorId: json['doctor_id'] as String?,
      year: (json['year'] as num?)?.toInt(),
      degree: json['degree'] as String?,
      country: json['country'] as String?,
      university: json['university'] as String?,
      certificate: json['certificate'] as String?,
    );

Map<String, dynamic> _$EducationModelToJson(EducationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'year': instance.year,
      'degree': instance.degree,
      'country': instance.country,
      'doctor_id': instance.doctorId,
      'university': instance.university,
      'certificate': instance.certificate,
    };
