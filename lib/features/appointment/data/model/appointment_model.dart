import 'package:json_annotation/json_annotation.dart';
import 'package:tabibak/features/appointment/data/model/appointment_status_model.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

part 'appointment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AppointmentModel {
  final int? id;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'appointment_date')
  final String? appointmentDate;
  @JsonKey(name: 'doctors')
  final DoctorModel? doctor;
  @JsonKey(name: 'doctor_id')
  final DoctorModel? doctorId;
  @JsonKey(name: 'user_id')
  final String? userId;
  final int? status;
  @JsonKey(name: 'appointment_shift')
  final int? appointmentShift;
  final String? phone;
  final String? name;
  final String? description;

  final UserModel? users;

  @JsonKey(name: 'appointments_status')
  final AppointmentStatusModel? appointmentsStatus;

  AppointmentModel({
    this.id,
    this.createdAt,
    this.appointmentDate,
    this.appointmentShift,
    this.doctorId,
    this.userId,
    this.status,
    this.phone,
    this.name,
    this.description,
    this.users,
    this.appointmentsStatus,
    this.doctor,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);
}
