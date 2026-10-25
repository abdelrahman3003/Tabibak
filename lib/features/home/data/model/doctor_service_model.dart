import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'doctor_service_model.g.dart';

@JsonSerializable()
class DoctorServiceModel {
  final int? id;

  @JsonKey(name: 'doctor_id')
  final String? doctorId;

  @JsonKey(name: 'clinic_id')
  final int? clinicId;

  final String? name;

  @JsonKey(name: 'name_ar')
  final String? nameAr;

  @JsonKey(name: 'name_en')
  final String? nameEn;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  DoctorServiceModel({
    this.id,
    this.doctorId,
    this.clinicId,
    this.name,
    this.nameAr,
    this.nameEn,
    this.createdAt,
    this.updatedAt,
  });

  String getLocalizedName(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    if (isAr) {
      if (nameAr != null && nameAr!.trim().isNotEmpty) return nameAr!.trim();
    } else {
      if (nameEn != null && nameEn!.trim().isNotEmpty) return nameEn!.trim();
    }
    return name?.trim() ?? '';
  }

  factory DoctorServiceModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorServiceModelToJson(this);
}
