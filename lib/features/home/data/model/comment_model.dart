import 'package:json_annotation/json_annotation.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final int? id;
  final String? comment;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'doctor_id')
  final String? doctorId;
  @JsonKey(name: 'users')
  final UserModel? userModel;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  CommentModel({
    this.id,
    this.userModel,
    this.comment,
    this.createdAt,
    this.userId,
    this.doctorId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
