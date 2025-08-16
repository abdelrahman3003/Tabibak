// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorCommentModel _$DoctorCommentModelFromJson(Map<String, dynamic> json) =>
    DoctorCommentModel(
      comment: json['comment'] as String?,
      users: json['users'] == null
          ? null
          : User.fromJson(json['users'] as Map<String, dynamic>),
      doctors: json['doctors'] == null
          ? null
          : Doctor.fromJson(json['doctors'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DoctorCommentModelToJson(DoctorCommentModel instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'users': instance.users,
      'doctors': instance.doctors,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
    };

Doctor _$DoctorFromJson(Map<String, dynamic> json) => Doctor(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$DoctorToJson(Doctor instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
