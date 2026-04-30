import 'package:json_annotation/json_annotation.dart';

part 'appointment_type_model.g.dart';

@JsonSerializable()
class AppointmentTypeModel {
  final int id;

  @JsonKey(name: 'appointment_type_ar')
  final String? appointmentTypeAr;

  @JsonKey(name: 'appointment_type_en')
  final String? appointmentTypeEn;

  AppointmentTypeModel({
    required this.id,
    this.appointmentTypeAr,
    this.appointmentTypeEn,
  });

  factory AppointmentTypeModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentTypeModelToJson(this);
}
