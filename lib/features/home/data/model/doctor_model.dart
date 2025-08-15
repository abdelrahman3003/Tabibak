import 'package:json_annotation/json_annotation.dart';

part 'doctor_model.g.dart';

@JsonSerializable()
class DoctorModel {
  final String? name;
  final String? image;
  final String? specialty;
  final String? bio;
  final double? rate;
  @JsonKey(name: "university_data")
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
  @JsonKey(name: "graduation_year")
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
  @JsonKey(name: "clinic_name")
  final String? clinicName;
  @JsonKey(name: "phone_number")
  final int? phoneNumber;
  @JsonKey(name: "consultation_fee")
  final int? consultationFee;
  @JsonKey(name: "clinic_working_day")
  final List<ClinicWorkingDay>? clinicWorkingDay;

  Clinic({
    required this.address,
    required this.clinicName,
    required this.phoneNumber,
    required this.consultationFee,
    required this.clinicWorkingDay,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) => _$ClinicFromJson(json);

  Map<String, dynamic> toJson() => _$ClinicToJson(this);
}

@JsonSerializable()
class ClinicWorkingDay {
  @JsonKey(name: "working_day")
  final WorkingDay? workingDay;

  ClinicWorkingDay({
    required this.workingDay,
  });

  factory ClinicWorkingDay.fromJson(Map<String, dynamic> json) =>
      _$ClinicWorkingDayFromJson(json);

  Map<String, dynamic> toJson() => _$ClinicWorkingDayToJson(this);
}

@JsonSerializable()
class WorkingDay {
  final Days? days;
  final TimeSlot? times;

  WorkingDay({
    required this.days,
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

@JsonSerializable()
class Days {
  final String? day;

  Days({required this.day});

  factory Days.fromJson(Map<String, dynamic> json) => _$DaysFromJson(json);

  Map<String, dynamic> toJson() => _$DaysToJson(this);
}
