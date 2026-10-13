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

  /// Always returns the Arabic name in both Arabic and English app languages.
  /// Falls back to English only if Arabic is not available.
  String get arabicName {
    if (nameAr != null && nameAr!.trim().isNotEmpty) {
      return nameAr!.trim();
    }
    return nameEn?.trim() ?? '';
  }

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityModelToJson(this);
}

extension ClinicAddressFormatting on ClinicAddressModel {
  /// Returns only one location according to hierarchy:
  /// 1. village if available
  /// 2. district/markaz (or city) if available
  /// 3. governorate if available
  /// Never returns full address or street.
  /// Always returns in Arabic in both Arabic and English app languages.
  String getLocation([String? locale]) {
    String getCityName(CityModel? c) {
      if (c == null) return '';
      return c.arabicName;
    }

    final vlg = getCityName(village);
    if (vlg.isNotEmpty) return vlg;

    final mrk = getCityName(markaz);
    if (mrk.isNotEmpty) return mrk;

    final cty = getCityName(city);
    if (cty.isNotEmpty) return cty;

    final gov = getCityName(governorate);
    if (gov.isNotEmpty) return gov;

    return '';
  }

  String formatAddress(String locale) {
    String getCityName(CityModel? c) {
      if (c == null) return '';
      return c.arabicName;
    }

    final parts = <String>[];
    final gov = getCityName(governorate);
    final mrk = getCityName(markaz);
    final vlg = getCityName(village);
    final cty = getCityName(city);
    final str = street?.trim() ?? '';

    if (gov.isNotEmpty) parts.add(gov);
    if (mrk.isNotEmpty && !parts.contains(mrk)) parts.add(mrk);
    if (vlg.isNotEmpty && !parts.contains(vlg)) parts.add(vlg);
    if (cty.isNotEmpty && !parts.contains(cty)) parts.add(cty);
    if (str.isNotEmpty && !parts.contains(str)) parts.add(str);

    return parts.join(locale == 'ar' ? '، ' : ', ');
  }
}

extension ClinicFormatting on ClinicModel {
  List<String> getLocations(String locale) {
    final list = <String>[];
    if (clinicAddresses != null && clinicAddresses!.isNotEmpty) {
      for (final addr in clinicAddresses!) {
        final loc = addr.getLocation(locale);
        if (loc.isNotEmpty && !list.contains(loc)) {
          list.add(loc);
        }
      }
    }
    return list;
  }

  String getLocation(String locale) {
    final list = getLocations(locale);
    return list.isNotEmpty ? list.first : '';
  }

  String getFormattedAddress(String locale) {
    if (clinicAddresses != null && clinicAddresses!.isNotEmpty) {
      final addr = clinicAddresses!.first.formatAddress(locale);
      if (addr.isNotEmpty) return addr;
    }
    return clinicName?.trim() ?? '';
  }
}
