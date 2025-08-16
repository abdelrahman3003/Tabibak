import 'package:json_annotation/json_annotation.dart';

part 'doctor_comment_model.g.dart';

@JsonSerializable()
class DoctorCommentModel {
  final String? comment;
  final User? users;
  final Doctor? doctors;

  DoctorCommentModel({
    required this.comment,
    required this.users,
    required this.doctors,
  });

  factory DoctorCommentModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorCommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorCommentModelToJson(this);
}

@JsonSerializable()
class User {
  final String? name;

  User({required this.name});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Doctor {
  final int? id;
  final String? name;

  Doctor({required this.id, required this.name});

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorToJson(this);
}
