import 'package:json_annotation/json_annotation.dart';
import 'package:tabibak/features/appointment/data/model/appointment_status_model.dart';
import 'package:tabibak/features/appointment/data/model/appointment_type_model.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/model/clinic_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/shift_model.dart';

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
  @JsonKey(name: 'clinic_data')
  final ClinicModel? clinic;
  @JsonKey(name: 'doctor_id')
  final String? doctorId;
  @JsonKey(name: 'user_id')
  final String? userId;
  final int? status;
  @JsonKey(name: 'shift_morning_id')
  final int? shiftMorningId;
  @JsonKey(name: 'shift_evening_id')
  final int? shiftEveningId;
  @JsonKey(name: 'shifts_morning')
  final ShiftModel? shiftMorning;
  @JsonKey(name: 'shift_evening')
  final ShiftModel? shiftEvening;
  final String? phone;
  final String? name;
  final String? description;
  final String? fcmToken;
  @JsonKey(name: 'appointment_time')
  final String? appointmentTime;
  final UserModel? users;
  @JsonKey(name: 'appointment_types')
  final AppointmentTypeModel? appointmentTypeModel;
  @JsonKey(name: 'appointments_status')
  final AppointmentStatusModel? appointmentsStatus;
  @JsonKey(name: 'follow_up_date')
  final DateTime? followUpDate;

  AppointmentModel(
      {this.id,
      this.createdAt,
      this.appointmentDate,
      this.appointmentTime,
      this.shiftMorningId,
      this.shiftEveningId,
      this.shiftEvening,
      this.shiftMorning,
      this.doctorId,
      this.clinic,
      this.userId,
      this.status,
      this.phone,
      this.name,
      this.description,
      this.users,
      this.appointmentsStatus,
      this.doctor,
      this.fcmToken,
      this.appointmentTypeModel,
      this.followUpDate});

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);
  Map<String, dynamic> toJsonForInsert() {
    final json = _$AppointmentModelToJson(this);
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
