import 'package:json_annotation/json_annotation.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

part 'appointment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Appointment {
  final int id;
  @JsonKey(name: 'created_at')
  final DateTime? createDate;
  @JsonKey(name: 'appointment_time')
  final String? appointmentTime;
  @JsonKey(name: 'appointment_date')
  final DateTime? appointmentDate;
  @JsonKey(name: 'doctors')
  final DoctorModel? doctor;
  @JsonKey(name: 'appointments_status')
  final AppointmentStatus? appointmentStatus;

  Appointment({
    required this.id,
    required this.appointmentTime,
    required this.appointmentDate,
    required this.doctor,
    required this.appointmentStatus,
    required this.createDate,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}

@JsonSerializable()
class AppointmentStatus {
  final String status;

  AppointmentStatus({required this.status});

  factory AppointmentStatus.fromJson(Map<String, dynamic> json) =>
      _$AppointmentStatusFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentStatusToJson(this);
}
