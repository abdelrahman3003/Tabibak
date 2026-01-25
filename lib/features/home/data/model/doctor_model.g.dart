// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
      doctorId: json['doctor_id'] as String,
      name: json['name'] as String?,
      image: json['image'] as String?,
      bio: json['bio'] as String?,
      specialty: json['specialties'] == null
          ? null
          : SpecialtyModel.fromJson(
              json['specialties'] as Map<String, dynamic>),
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      clinic: json['clinic_data'] == null
          ? null
          : ClinicModel.fromJson(json['clinic_data'] as Map<String, dynamic>),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      education: json['education'] == null
          ? null
          : EducationModel.fromJson(json['education'] as Map<String, dynamic>),
      ratings: (json['ratings'] as List<dynamic>?)
          ?.map((e) => RatingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'doctor_id': instance.doctorId,
      'name': instance.name,
      'image': instance.image,
      'bio': instance.bio,
      'phone': instance.phone,
      'email': instance.email,
      'specialties': instance.specialty?.toJson(),
      'education': instance.education?.toJson(),
      'clinic_data': instance.clinic?.toJson(),
      'comments': instance.comments?.map((e) => e.toJson()).toList(),
      'ratings': instance.ratings?.map((e) => e.toJson()).toList(),
    };
