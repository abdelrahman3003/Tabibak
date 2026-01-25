// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      id: (json['id'] as num?)?.toInt(),
      comment: json['comment'] as String?,
      userId: json['user_id'] as String?,
      doctorId: json['doctor_id'] as String?,
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'user_id': instance.userId,
      'doctor_id': instance.doctorId,
    };
