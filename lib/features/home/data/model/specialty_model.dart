import 'package:json_annotation/json_annotation.dart';

part 'specialty_model.g.dart';

@JsonSerializable()
class SpecialtyModel {
  final int? id;
  final String? name;
  final String? icon;
  SpecialtyModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) =>
      _$SpecialtyModelFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialtyModelToJson(this);
}
