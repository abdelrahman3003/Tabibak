import 'package:json_annotation/json_annotation.dart';

part 'specialty_model.g.dart';

@JsonSerializable()
class SpecialtyModel {
  final int? id;
  @JsonKey(name: "name_ar")
  final String? nameAr;
  @JsonKey(name: "name_en")
  final String? nameEn;
  final String? icon;
  SpecialtyModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.icon,
  });

  String getName(String locale) {
    if (locale == 'ar') {
      return (nameAr != null && nameAr!.isNotEmpty)
          ? nameAr!
          : (nameEn ?? '');
    }
    return (nameEn != null && nameEn!.isNotEmpty)
        ? nameEn!
        : (nameAr ?? '');
  }

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) =>
      _$SpecialtyModelFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialtyModelToJson(this);
}
