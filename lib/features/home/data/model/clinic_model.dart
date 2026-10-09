import 'package:json_annotation/json_annotation.dart';
import 'package:tabibak/features/home/data/model/working_day_model.dart';

part 'clinic_model.g.dart';

@JsonSerializable()
class ClinicModel {
  final int? id;
  @JsonKey(name: 'doctor_id')
  final String? doctorId;
  @JsonKey(name: 'is_booking')
  final bool? isBooking;
  @JsonKey(name: 'is_available')
  final bool? isAvailable;
  @JsonKey(name: 'clinic_name')
  final String? clinicName;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'consultation_fee')
  final int? consultationFee;
  @JsonKey(name: 'clinic_address')
  final List<ClinicAddressModel>? clinicAddresses;
  @JsonKey(name: 'working_day')
  final List<WorkingDay>? workingDays;
  @JsonKey(name: 'offer')
  final String? offer;
  ClinicModel({
    this.id,
    this.doctorId,
    this.isBooking,
    this.isAvailable,
    this.clinicName,
    this.phoneNumber,
    this.consultationFee,
    this.clinicAddresses,
    this.workingDays,
    this.offer,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicModelFromJson(json);
  Map<String, dynamic> toJson() => _$ClinicModelToJson(this);
}

@JsonSerializable()
class ClinicAddressModel {
  final int? id;

  @JsonKey(name: 'clinic_id')
  final int? clinicId;

  @JsonKey(name: 'city_id')
  final int? cityId;

  // The main city/neighbourhood record (FK: clinic_address_city_id_fkey)
  final CityModel? city;

  // Markaz (district) – FK: clinic_address_markaz_id_fkey
  @JsonKey(name: 'markaz_id')
  final int? markazId;
  final CityModel? markaz;

  // Village – FK: clinic_address_village_id_fkey
  @JsonKey(name: 'village_id')
  final int? villageId;
  final CityModel? village;

  // Governorate raw ID (no FK relationship in Supabase schema)
  @JsonKey(name: 'governorate_id')
  final int? governorateId;
  final CityModel? governorate;

  final String? floor;
  final String? street;
  final String? department;

  ClinicAddressModel({
    this.id,
    this.clinicId,
    this.cityId,
    this.city,
    this.markazId,
    this.markaz,
    this.villageId,
    this.village,
    this.governorateId,
    this.governorate,
    this.floor,
    this.street,
    this.department,
  });

  factory ClinicAddressModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClinicAddressModelToJson(this);
}

@JsonSerializable()
class CityModel {
  final int? id;

  @JsonKey(name: 'name_ar')
  final String? nameAr;

  @JsonKey(name: 'name_en')
  final String? nameEn;

  final String? type;

  @JsonKey(name: 'parent_id')
  final int? parentId;

  final CityModel? parent;

  CityModel({
    this.id,
    this.nameAr,
    this.nameEn,
    this.type,
    this.parentId,
    this.parent,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityModelToJson(this);
}
