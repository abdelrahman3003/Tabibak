import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(includeToJson: false)
  final int? id;

  final String? name;
  final String? email;

  @JsonKey(includeToJson: false)
  final String? password;

  @JsonKey(includeToJson: false)
  final String? image;

  @JsonKey(name: 'user_id')
  final String? userId;

  @JsonKey(name: 'fcm_token', includeToJson: false)
  final String? fcmToken;

  @JsonKey(name: 'is_doctor', includeToJson: false)
  final bool? isDoctor;

  @JsonKey(name: 'created_at', includeToJson: false)
  final String? createdAt;

  UserModel({
    this.id,
    this.name,
    this.password,
    this.email,
    this.image,
    this.userId,
    this.fcmToken,
    this.isDoctor,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
