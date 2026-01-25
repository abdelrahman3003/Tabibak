import 'package:json_annotation/json_annotation.dart';
import 'package:tabibak/features/home/data/model/specialty_model.dart';

part 'doctor_summary.g.dart';

@JsonSerializable()
class DoctorSummary {
  final int id;
  final String? name;
  final String? image;
  @JsonKey(name: 'clinic_data')
  final ClinicDataSummary? clinicData;
  @JsonKey(name: "specialties")
  final SpecialtyModel? specialty;
  DoctorSummary({
    required this.id,
    required this.name,
    this.image,
    required this.specialty,
    required this.clinicData,
  });

  factory DoctorSummary.fromJson(Map<String, dynamic> json) =>
      _$DoctorSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorSummaryToJson(this);
}

@JsonSerializable()
class ClinicDataSummary {
  @JsonKey(name: 'clinic_address')
  final ClinicAddressModel? clinicAddress;

  ClinicDataSummary({required this.clinicAddress});

  factory ClinicDataSummary.fromJson(Map<String, dynamic> json) =>
      _$ClinicDataSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$ClinicDataSummaryToJson(this);
}

@JsonSerializable()
class ClinicAddressModel {
  final String? address;

  ClinicAddressModel({this.address});

  factory ClinicAddressModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClinicAddressModelToJson(this);
}
