import 'package:json_annotation/json_annotation.dart';

part 'doctor_summary.g.dart';

@JsonSerializable()
class DoctorSummary {
  final String name;
  final String? image;
  final String specialty;
  @JsonKey(name: 'clinic_data')
  final ClinicData clinicData;

  DoctorSummary({
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
class ClinicData {
  final String address;

  ClinicData({required this.address});

  factory ClinicData.fromJson(Map<String, dynamic> json) =>
      _$ClinicDataFromJson(json);

  Map<String, dynamic> toJson() => _$ClinicDataToJson(this);
}
