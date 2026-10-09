// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferModel _$OfferModelFromJson(Map<String, dynamic> json) => OfferModel(
      id: (json['id'] as num?)?.toInt(),
      titleEn: json['title_en'] as String?,
      titleAr: json['title_ar'] as String?,
      detailsEn: json['details_en'] as String?,
      detailsAr: json['details_ar'] as String?,
      discount: (json['discount'] as num?)?.toDouble(),
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      doctorId: json['doctor_id'] as String?,
      clinicId: (json['clinic_id'] as num?)?.toInt(),
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$OfferModelToJson(OfferModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title_en': instance.titleEn,
      'title_ar': instance.titleAr,
      'details_en': instance.detailsEn,
      'details_ar': instance.detailsAr,
      'discount': instance.discount,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'doctor_id': instance.doctorId,
      'clinic_id': instance.clinicId,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
    };
