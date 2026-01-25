// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialty_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialtyModel _$SpecialtyModelFromJson(Map<String, dynamic> json) =>
    SpecialtyModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$SpecialtyModelToJson(SpecialtyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
    };
