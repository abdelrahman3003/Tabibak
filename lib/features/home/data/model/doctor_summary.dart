import 'package:json_annotation/json_annotation.dart';

part 'doctor_summary.g.dart';

@JsonSerializable()
class DoctorSummary {
  final int id;
  final String? name;
  final String? image;
  final String? specialty;
  @JsonKey(name: 'clinic_data')
  final ClinicDataSummary? clinicData;

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
  final String? address;

  ClinicDataSummary({required this.address});

  factory ClinicDataSummary.fromJson(Map<String, dynamic> json) =>
      _$ClinicDataSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$ClinicDataSummaryToJson(this);
}
