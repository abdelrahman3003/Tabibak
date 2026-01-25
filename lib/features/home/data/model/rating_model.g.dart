// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingModel _$RatingModelFromJson(Map<String, dynamic> json) => RatingModel(
      id: (json['id'] as num?)?.toInt(),
      rate: (json['rate'] as num?)?.toInt(),
      user_id: json['user_id'] as String?,
      doctor_id: json['doctor_id'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$RatingModelToJson(RatingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rate': instance.rate,
      'user_id': instance.user_id,
      'doctor_id': instance.doctor_id,
      'created_at': instance.createdAt,
    };
