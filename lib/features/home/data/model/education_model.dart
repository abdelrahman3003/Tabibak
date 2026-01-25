import 'package:json_annotation/json_annotation.dart';

part 'education_model.g.dart';

@JsonSerializable()
class EducationModel {
  final int? id;
  final int? year;
  final String? degree;
  final String? country;
  @JsonKey(name: 'doctor_id')
  final String? doctorId;
  final String? university;
  final String? certificate;

  EducationModel({
    this.id,
    this.doctorId,
    this.year,
    this.degree,
    this.country,
    this.university,
    this.certificate,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) =>
      _$EducationModelFromJson(json);
  Map<String, dynamic> toJson() => _$EducationModelToJson(this);
}
