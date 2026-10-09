// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
      doctorId: json['doctor_id'] as String,
      name: json['name'] as String?,
      image: json['image'] as String?,
      bioAr: json['bio_ar'] as String?,
      bioEn: json['bio_en'] as String?,
      avrRating: (json['avg_rating'] as num?)?.toDouble(),
      ratingsCount: (json['ratings_count'] as num?)?.toInt(),
      visitsCount: (json['visits_count'] as num?)?.toInt(),
      specialty: json['specialties'] == null
          ? null
          : SpecialtyModel.fromJson(
              json['specialties'] as Map<String, dynamic>),
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      clinic: _readClinic(json, 'clinic') == null
          ? null
          : ClinicModel.fromJson(
              _readClinic(json, 'clinic') as Map<String, dynamic>),
      clinicList: (_readClinicList(json, 'clinicList') as List<dynamic>?)
          ?.map((e) => ClinicModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      education: json['education'] == null
          ? null
          : EducationModel.fromJson(json['education'] as Map<String, dynamic>),
      ratings: (json['ratings'] as List<dynamic>?)
          ?.map((e) => RatingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      offers: (json['offers'] as List<dynamic>?)
          ?.map((e) => OfferModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'doctor_id': instance.doctorId,
      'name': instance.name,
      'image': instance.image,
      'avg_rating': instance.avrRating,
      'ratings_count': instance.ratingsCount,
      'visits_count': instance.visitsCount,
      'bio_ar': instance.bioAr,
      'bio_en': instance.bioEn,
      'phone': instance.phone,
      'email': instance.email,
      'specialties': instance.specialty?.toJson(),
      'education': instance.education?.toJson(),
      'clinic': instance.clinic?.toJson(),
      'clinicList': instance.clinicList?.map((e) => e.toJson()).toList(),
      'comments': instance.comments?.map((e) => e.toJson()).toList(),
      'ratings': instance.ratings?.map((e) => e.toJson()).toList(),
      'offers': instance.offers?.map((e) => e.toJson()).toList(),
    };
