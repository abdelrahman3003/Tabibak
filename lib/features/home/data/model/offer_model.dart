import 'package:json_annotation/json_annotation.dart';

part 'offer_model.g.dart';

@JsonSerializable()
class OfferModel {
  final int? id;
  @JsonKey(name: 'title_en')
  final String? titleEn;
  @JsonKey(name: 'title_ar')
  final String? titleAr;
  @JsonKey(name: 'details_en')
  final String? detailsEn;
  @JsonKey(name: 'details_ar')
  final String? detailsAr;
  final double? discount;
  @JsonKey(name: 'start_date')
  final String? startDate;
  @JsonKey(name: 'end_date')
  final String? endDate;
  @JsonKey(name: 'doctor_id')
  final String? doctorId;
  @JsonKey(name: 'clinic_id')
  final int? clinicId;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  OfferModel({
    this.id,
    this.titleEn,
    this.titleAr,
    this.detailsEn,
    this.detailsAr,
    this.discount,
    this.startDate,
    this.endDate,
    this.doctorId,
    this.clinicId,
    this.isActive,
    this.createdAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) =>
      _$OfferModelFromJson(json);
  Map<String, dynamic> toJson() => _$OfferModelToJson(this);
}
