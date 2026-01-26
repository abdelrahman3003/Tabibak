import 'package:json_annotation/json_annotation.dart';

part 'appointment_status_model.g.dart';

@JsonSerializable()
class AppointmentStatusModel {
  final int id;
  final String status;

  @JsonKey(name: 'created_at')
  final String createdAt;

  AppointmentStatusModel({
    required this.id,
    required this.status,
    required this.createdAt,
  });

  factory AppointmentStatusModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentStatusModelToJson(this);
}
