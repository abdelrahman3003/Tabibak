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

  @JsonKey(name: 'appointment_time')
  final String? appointmentTime;

  @JsonKey(name: 'doctors')
  final DoctorModel? doctor;

  @JsonKey(name: 'clinic_data')
  final ClinicModel? clinic;

  @JsonKey(name: 'doctor_id')
  final String? doctorId;

  @JsonKey(name: 'user_id')
  final String? userId;

  final int? status;

  @JsonKey(name: 'appointment_morning_shift_id')
  final int? shiftMorningId;

  @JsonKey(name: 'appointment_evening_shift_id')
  final int? shiftEveningId;

  @JsonKey(name: 'shifts_morning')
  final ShiftModel? shiftMorning;

  @JsonKey(name: 'shift_evening')
  final ShiftModel? shiftEvening;

  final String? phone;
  final String? name;
  final String? description;

  @JsonKey(name: 'fcm_token')
  final String? fcmToken;

  final UserModel? users;

  @JsonKey(name: 'appointment_type')
  final int? appointmentTypeId;

  @JsonKey(name: 'appointment_types')
  final AppointmentTypeModel? appointmentTypeModel;

  @JsonKey(name: 'appointments_status')
  final AppointmentStatusModel? appointmentsStatus;

  @JsonKey(name: 'follow_up_date')
  final DateTime? followUpDate;

  @JsonKey(name: 'queue_number')
  final int? queueNumber;

  AppointmentModel({
    this.id,
    this.createdAt,
    this.appointmentDate,
    this.appointmentTime,
    this.doctor,
    this.clinic,
    this.doctorId,
    this.userId,
    this.status,
    this.shiftMorningId,
    this.shiftEveningId,
    this.shiftMorning,
    this.shiftEvening,
    this.phone,
    this.name,
    this.description,
    this.fcmToken,
    this.users,
    this.appointmentTypeId,
    this.appointmentTypeModel,
    this.appointmentsStatus,
    this.followUpDate,
    this.queueNumber,
  });

  factory AppointmentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final normalized = Map<String, dynamic>.from(json);

    normalized['appointment_morning_shift_id'] ??= json['shift_morning_id'];

    normalized['appointment_evening_shift_id'] ??= json['shift_evening_id'];

    return _$AppointmentModelFromJson(normalized);
  }

  Map<String, dynamic> toJson() {
    return _$AppointmentModelToJson(this);
  }

  Map<String, dynamic> toJsonForInsert() {
    return {
      'appointment_date': appointmentDate,
      'doctor_id': doctorId,
      'user_id': userId,
      'status': status ?? 1,
      'phone': phone,
      'name': name,
      'description': description,
      'shift_morning_id': shiftMorningId,
      'shift_evening_id': shiftEveningId,
      'appointment_type': appointmentTypeId ?? 1,
    }..removeWhere(
        (key, value) => value == null,
      );
  }
}
