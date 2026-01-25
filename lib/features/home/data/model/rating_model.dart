import 'package:json_annotation/json_annotation.dart';

part 'rating_model.g.dart';

@JsonSerializable()
class RatingModel {
  final int? id;
  final int? rate;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'doctor_id')
  final String? doctorId;

  RatingModel({
    this.id,
    this.rate,
    this.userId,
    this.doctorId,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);
  Map<String, dynamic> toJson() => _$RatingModelToJson(this);
}
