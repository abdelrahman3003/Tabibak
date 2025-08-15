import 'package:json_annotation/json_annotation.dart';

part 'doctor_model.g.dart';

@JsonSerializable()
class DoctorModel {
  final String? name;
  final String? image;
  final String? specialty;
  final String? bio;
  final double? rate;
  final University? universityData;
  @JsonKey(name: "clinic_data")
  final Clinic? clinicData;

  DoctorModel({
    required this.name,
    this.image,
    this.specialty,
    this.bio,
    required this.rate,
    required this.universityData,
    required this.clinicData,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
}

@JsonSerializable()
class University {
  final String? name;
  final String? faculty;
  final int? graduationYear;

  University({
    required this.name,
    required this.faculty,
    required this.graduationYear,
  });

  factory University.fromJson(Map<String, dynamic> json) =>
      _$UniversityFromJson(json);

  Map<String, dynamic> toJson() => _$UniversityToJson(this);
}

@JsonSerializable()
class Clinic {
  final String? address;
  final String? clinicName;
  final PhoneNumber? phoneNumber;
  final int? consultationFee;
  final WorkingDay? workingDay;

  Clinic({
    required this.address,
    required this.clinicName,
    required this.phoneNumber,
    required this.consultationFee,
    required this.workingDay,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) => _$ClinicFromJson(json);

  Map<String, dynamic> toJson() => _$ClinicToJson(this);
}

@JsonSerializable()
class PhoneNumber {
  final int? number;

  PhoneNumber({required this.number});

  factory PhoneNumber.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneNumberToJson(this);
}

@JsonSerializable()
class WorkingDay {
  final String? day;
  final int? time;
  final TimeSlot? times;

  WorkingDay({
    required this.day,
    required this.time,
    required this.times,
  });

  factory WorkingDay.fromJson(Map<String, dynamic> json) =>
      _$WorkingDayFromJson(json);

  Map<String, dynamic> toJson() => _$WorkingDayToJson(this);
}

@JsonSerializable()
class TimeSlot {
  final String? start;
  final String? end;

  TimeSlot({
    required this.start,
    required this.end,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);

  Map<String, dynamic> toJson() => _$TimeSlotToJson(this);
}
