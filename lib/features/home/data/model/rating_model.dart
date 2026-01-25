import 'package:json_annotation/json_annotation.dart';

part 'rating_model.g.dart';

@JsonSerializable()
class RatingModel {
  final int? id;
  final int? rate;
  final String? user_id;
  final String? doctor_id;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  RatingModel(
      {this.id, this.rate, this.user_id, this.doctor_id, this.createdAt});

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);
  Map<String, dynamic> toJson() => _$RatingModelToJson(this);
}
