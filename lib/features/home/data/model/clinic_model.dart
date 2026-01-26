import 'package:json_annotation/json_annotation.dart';
import 'package:tabibak/features/home/data/model/working_day_model.dart';

part 'clinic_model.g.dart';

@JsonSerializable()
class ClinicModel {
  final int? id;
  @JsonKey(name: 'doctor_id')
  final String? doctorId;
  @JsonKey(name: 'is_booking')
  final bool? isBooking;
  @JsonKey(name: 'clinic_name')
  final String? clinicName;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'consultation_fee')
  final int? consultationFee;
  @JsonKey(name: 'clinic_address')
  final ClinicAddressModel? clinicAddressModel;
  @JsonKey(name: 'working_day')
  final List<WorkingDay>? workingDays;
  ClinicModel({
    this.id,
    this.doctorId,
    this.isBooking,
    this.clinicName,
    this.phoneNumber,
    this.consultationFee,
    this.clinicAddressModel,
    this.workingDays,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicModelFromJson(json);
  Map<String, dynamic> toJson() => _$ClinicModelToJson(this);
}

@JsonSerializable()
class ClinicAddressModel {
  final int? id;
  @JsonKey(name: 'clinic_id')
  final int? clinicId;
  final String? address;

  ClinicAddressModel({
    this.id,
    this.clinicId,
    this.address,
  });

  factory ClinicAddressModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicAddressModelFromJson(json);
  Map<String, dynamic> toJson() => _$ClinicAddressModelToJson(this);
}
