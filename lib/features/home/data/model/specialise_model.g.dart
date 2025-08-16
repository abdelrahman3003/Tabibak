// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialiseModel _$SpecialiseModelFromJson(Map<String, dynamic> json) =>
    SpecialiseModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$SpecialiseModelToJson(SpecialiseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
    };
