import 'package:json_annotation/json_annotation.dart';

part 'specialise_model.g.dart';

@JsonSerializable()
class SpecialiseModel {
  final String name;
  final String icon;
  SpecialiseModel({
    required this.name,
    required this.icon,
  });

  factory SpecialiseModel.fromJson(Map<String, dynamic> json) =>
      _$SpecialiseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialiseModelToJson(this);
}
