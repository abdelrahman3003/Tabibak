// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialty_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialtyModel _$SpecialtyModelFromJson(Map<String, dynamic> json) =>
    SpecialtyModel(
      id: (json['id'] as num?)?.toInt(),
      nameAr: json['name_ar'] as String?,
      nameEn: json['name_en'] as String?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$SpecialtyModelToJson(SpecialtyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_ar': instance.nameAr,
      'name_en': instance.nameEn,
      'icon': instance.icon,
    };
