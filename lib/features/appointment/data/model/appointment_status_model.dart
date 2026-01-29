import 'package:json_annotation/json_annotation.dart';

part 'appointment_status_model.g.dart';

@JsonSerializable()
class AppointmentStatusModel {
  final int id;
  @JsonKey(name: 'status_ar')
  final String? statusAr;
  @JsonKey(name: 'status_en')
  final String? statusEn;
  @JsonKey(name: 'created_at')
  final String createdAt;

  AppointmentStatusModel({
    required this.id,
    required this.statusAr,
    required this.statusEn,
    required this.createdAt,
  });

  factory AppointmentStatusModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentStatusModelToJson(this);
}
