import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int id;
  final String? name;
  final String? email;
  final String? image;

  @JsonKey(name: 'user_id')
  final String? userId;

  @JsonKey(name: 'fcm_token')
  final String? fcmToken;

  @JsonKey(name: 'is_doctor')
  final bool? isDoctor;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.userId,
    this.fcmToken,
    required this.isDoctor,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
