import 'package:json_annotation/json_annotation.dart';
import 'package:tabibak/features/appointment/data/model/appointment_status_model.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

part 'appointment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AppointmentModel {
  final int id;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'appointment_date')
  final String appointmentDate;

  @JsonKey(name: 'doctors')
  final DoctorModel doctor;

  @JsonKey(name: 'appointment_shift')
  final int appointmentShift;

  final String phone;
  final String name;
  final String description;

  final UserModel users;

  @JsonKey(name: 'appointments_status')
  final AppointmentStatusModel appointmentsStatus;

  AppointmentModel({
    required this.id,
    required this.createdAt,
    required this.appointmentDate,
    required this.appointmentShift,
    required this.phone,
    required this.name,
    required this.description,
    required this.users,
    required this.appointmentsStatus,
    required this.doctor,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);
}
