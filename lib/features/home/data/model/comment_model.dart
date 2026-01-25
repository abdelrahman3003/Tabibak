import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final int? id;
  final String? comment;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'doctor_id')
  final String? doctorId;

  CommentModel({
    this.id,
    this.comment,
    this.userId,
    this.doctorId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
