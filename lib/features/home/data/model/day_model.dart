import 'package:json_annotation/json_annotation.dart';

part 'day_model.g.dart';

@JsonSerializable()
class DayModel {
  final int id;
  @JsonKey(name: 'day_ar')
  final String? dayAr;
  @JsonKey(name: 'day_en')
  final String? dayEn;

  DayModel({required this.id, this.dayAr, this.dayEn});

  factory DayModel.fromJson(Map<String, dynamic> json) =>
      _$DayModelFromJson(json);
  Map<String, dynamic> toJson() => _$DayModelToJson(this);
}
