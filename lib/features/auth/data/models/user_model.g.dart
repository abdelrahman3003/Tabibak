// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      userId: json['user_id'] as String?,
      fcmToken: json['fcm_token'] as String?,
      isDoctor: json['is_doctor'] as bool?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'image': instance.image,
      'user_id': instance.userId,
      'fcm_token': instance.fcmToken,
      'is_doctor': instance.isDoctor,
      'created_at': instance.createdAt,
    };
