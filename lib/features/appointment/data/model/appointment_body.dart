import 'package:json_annotation/json_annotation.dart';

part 'appointment_body.g.dart';

@JsonSerializable()
class AppointmentBody {
  @JsonKey(name: 'doctor_id')
  final int doctorId;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'appointment_time')
  final String appointmentTime;
  @JsonKey(name: 'appointment_date')
  final DateTime appointmentDate;
  final int status;

  AppointmentBody({
    required this.doctorId,
    required this.userId,
    required this.appointmentTime,
    required this.appointmentDate,
    required this.status,
  });

  factory AppointmentBody.fromJson(Map<String, dynamic> json) =>
      _$AppointmentBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentBodyToJson(this);
}
