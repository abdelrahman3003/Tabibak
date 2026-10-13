import 'package:json_annotation/json_annotation.dart';
import 'package:tabibak/features/home/data/model/clinic_model.dart';
import 'package:tabibak/features/home/data/model/comment_model.dart';
import 'package:tabibak/features/home/data/model/education_model.dart';
import 'package:tabibak/features/home/data/model/rating_model.dart';
import 'package:tabibak/features/home/data/model/specialty_model.dart';
import 'package:tabibak/features/home/data/model/offer_model.dart';

part 'doctor_model.g.dart';

Object? _readClinic(Map json, String key) {
  if (json['clinic_data'] is Map) return json['clinic_data'];
  if (json['clinic_data'] is List && (json['clinic_data'] as List).isNotEmpty) {
    return (json['clinic_data'] as List).first;
  }
  return null;
}

Object? _readClinicList(Map json, String key) {
  if (json['clinic_data'] is List) return json['clinic_data'];
  if (json['clinic_data'] is Map) return [json['clinic_data']];
  return null;
}

@JsonSerializable(explicitToJson: true)
class DoctorModel {
  @JsonKey(name: 'doctor_id')
  final String doctorId;
  final String? name;
  final String? image;
  @JsonKey(name: 'avg_rating')
  final double? avrRating;
  @JsonKey(name: 'ratings_count')
  final int? ratingsCount;
  @JsonKey(name: 'visits_count')
  final int? visitsCount;
  @JsonKey(name: 'bio_ar')
  final String? bioAr;
  @JsonKey(name: 'bio_en')
  final String? bioEn;
  final String? phone;
  final String? email;
  @JsonKey(name: 'specialties')
  final SpecialtyModel? specialty;
  final EducationModel? education;

  @JsonKey(name: 'clinic', readValue: _readClinic)
  final ClinicModel? clinic;

  @JsonKey(name: 'clinicList', readValue: _readClinicList)
  final List<ClinicModel>? clinicList;
  final List<CommentModel>? comments;
  final List<RatingModel>? ratings;
  final List<OfferModel>? offers;
  DoctorModel({
    required this.doctorId,
    this.name,
    this.image,
    this.bioAr,
    this.bioEn,
    this.avrRating,
    this.ratingsCount,
    this.visitsCount,
    this.specialty,
    this.phone,
    this.email,
    this.clinic,
    this.clinicList,
    this.comments,
    this.education,
    this.ratings,
    this.offers,
  });

  /// Returns only offers that are currently active and haven't expired.
  List<OfferModel> get activeOffers =>
      offers?.where((o) => o.isValid).toList() ?? [];

  /// Returns true if the doctor has any valid ratings or reviews.
  bool get hasRating {
    if (ratings != null && ratings!.isNotEmpty) return true;
    if (ratingsCount != null && ratingsCount! > 0) return true;
    if (avrRating != null && avrRating! > 0) return true;
    return false;
  }

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
}

extension DoctorAddressFormatting on DoctorModel {
  /// Returns a list of all unique clinic locations for this doctor.
  /// Each location follows the hierarchy:
  /// 1. village if available
  /// 2. district/markaz (or city) if available
  /// 3. governorate if available
  /// Never returns full address or street.
  List<String> getClinicLocations(String locale) {
    final clinics = clinicList?.isNotEmpty == true
        ? clinicList!
        : (clinic != null ? [clinic!] : <ClinicModel>[]);

    final locations = <String>[];
    for (final c in clinics) {
      for (final loc in c.getLocations(locale)) {
        if (loc.isNotEmpty && !locations.contains(loc)) {
          locations.add(loc);
        }
      }
    }
    return locations;
  }

  /// Formatted single or multi-clinic location string (e.g. "Dishna • Qena").
  String getClinicLocation(String locale) {
    final locations = getClinicLocations(locale);
    if (locations.isEmpty) return '';
    return locations.join(' • ');
  }

  String getClinicAddress(String locale) {
    final c = clinic ??
        (clinicList?.isNotEmpty == true ? clinicList!.first : null);
    if (c == null) return '';
    return c.getFormattedAddress(locale);
  }
}
